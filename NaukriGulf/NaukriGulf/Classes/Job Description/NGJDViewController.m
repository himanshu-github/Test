//
//  NGJDViewController.m
//  NaukriGulf

//  Created by Arun Kumar on 05/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.


#import "NGJDViewController.h"
#import "NGJobDescriptionCell.h"
#import "NGDesiredCandidateCell.h"
#import "NGEmployerDetailsCell.h"
#import "NGContactDetailsCell.h"
#import "NGJobSummaryCell.h"
#import "NGWebJobCell.h"
#import "AsyncImageView.h"
#import "NGJDdataFetcher.h"
#import "NGJobTupleCustomCell.h"
#import "NGSimJobViewMoreSectionCell.h"
#import "NGViewMoreSimJobsViewController.h"
#import "NGLogoCell.h"


#define K_JD_FOOTER_HEIGHT 60
#define K_SIM_JOB_HEADER_HEIGHT 50
#define K_APPLY_VIEW_SECTION_FOOTER_TAG 9999

typedef enum{
   
    LogoCell=0,
    JobSummaryCell,
    JDCell,
    DesiredCandidateCell,
    EDCell,
    ContactDetailsCell
}CellIndex;




@interface NGJDViewController ()
{
    
    BOOL isheightCached;
    
    
}
- (IBAction)viewOriginalTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *expiredJobView;

@end

@implementation NGJDViewController{
    
    
    int isNameNotPresent;
    int isEmailNotPresent;
    int isWebsiteNotPresent;
    int hideContactSection;
    
    int hideEmployerDetailsSection;
    
    // Read more Flags
    NSInteger isEDReadMoreTapped;
    NSInteger isJDReadMoreTapped;
    NSInteger isDCReadMoreTapped;
    
    NSMutableDictionary *heightsArray;   // For caching heights
    BOOL hideLogo;
    NSMutableArray *readMoreSections;    // Array containing row indexes of sections where "Read More" has been tapped
    
    
    BOOL isScrollingUp;
    int prevValue;
    int simJobsOffset;
    BOOL isSimJobsLoading;
    NSInteger totalJobsCount;
    NSInteger selectedJobIndex;
    NSInteger jobIndex;
    BOOL isDisplayingSimJobs;
    UIView *simJobHeaderView;
    
    BOOL isShowApplyFooter;
    
    
}

@synthesize managedObjectContext;
@synthesize jdTableView = _jdTableView;

#pragma mark -
#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [AppTracer traceStartTime:[NSString stringWithFormat:@"JD_%ld",(long)self.selectedIndex]];    
    [super viewDidLoad];
    [self showAnimator];
    heightsArray = [[NSMutableDictionary alloc] init];
    readMoreSections = [[NSMutableArray alloc] init];
    
    self.jdTableView.hidden = YES;
    [self.jdTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.jdTableView setBackgroundColor:[UIColor clearColor]];
    
    _simJobs = [NSMutableArray array];
    isShowApplyFooter = YES;
    
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.jobID,@"jobId", nil];
    
    [params setCustomObject:@"ios" forKey:@"requestsource"];
    if (self.openJDLocation == JD_FROM_SRP_PAGE||self.openJDLocation == JD_FROM_VIEWMORE_OR_JD_SIM_JOB) {
        [params setCustomObject:self.xzMIS forKey:@"xz"];
        [params setCustomObject:self.srchIDMIS forKey:@"srchId"];
    }else if (JD_FROM_RECOMMENDED_JOBS_PAGE == self.openJDLocation ||self.openJDLocation == JD_FROM_ACP_SIM_JOB_PAGE){
            [params setCustomObject:self.xzMIS forKey:@"xz"];
        
    }else{
        //dummy
    }
    
    [self fetchJDForJob:self.jobID requestParameters:params];

    if (self.jobObj.isWebjob) {
        [NGGoogleAnalytics sendScreenReport:K_GA_JD_WEB_JOB];
    }else{
        [NGGoogleAnalytics sendScreenReport:K_GA_JD_POSTED_JOB];
    }
    [NGDecisionUtility checkNetworkStatus];
    
    
    if(self.openJDLocation == JD_FROM_VIEWMORE_OR_JD_SIM_JOB)
        [NGGoogleAnalytics sendScreenReport:K_GA_JD_SIM_JOB];

}

#pragma mark-ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint currentOffset = _jdTableView.contentOffset;
    isScrollingUp = currentOffset.y > prevValue;
    prevValue = currentOffset.y;

    //sim job api check
    CGFloat tableContentHeight =_jdTableView.contentSize.height;
    CGFloat sixtyPercentHeightForService = tableContentHeight*0.6;
    CGFloat yOffsetOfTable = _jdTableView.contentOffset.y+_jdTableView.bounds.size.height;
   
    if(yOffsetOfTable>sixtyPercentHeightForService)
    {
       if(!isSimJobsLoading&&!isDisplayingSimJobs)
       {
           dispatch_async(dispatch_get_main_queue(), ^{
               isSimJobsLoading = YES;
               [self.jdTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
               [self getSimJobsFromApi];
           });
       }
    }

    if(_simJobs.count>0)
    {
    
        UIView *cell = simJobHeaderView;
        if(cell.center.y == 0)
            return;
        CGFloat offset = cell.center.y-cell.frame.size.height/2.0;
        if(yOffsetOfTable>offset)
        {
        if(isShowApplyFooter)
        {
            isShowApplyFooter = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_jdTableView reloadData];
            });
        }
        }
        else if (yOffsetOfTable<offset)
        {
            if(isShowApplyFooter== NO)
            {
                isShowApplyFooter = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_jdTableView reloadData];

                });
            }
        
        }
    }
    
    
}
-(void)changeNavTitle:(NSString*)title{

    [self.simJobDelegate changeTitleTo:title];
    
}
-(void)getSimJobsFromApi{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInt:simJobsOffset] forKey:@"offset"];
    [params setValue:[NSNumber numberWithInteger:3] forKey:@"limit"];
    //K_RESOURCE_PARAMS
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SIM_JOBS_PAGINATION];
    __weak NGJDViewController *mySelfWeak = self;
    NSString *jdID = self.jobID;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSMutableDictionary *)@{@"jobId": jdID},K_RESOURCE_PARAMS,params,K_ATTRIBUTE_PARAMS, nil];
    [obj getDataWithParams:paramDict handler:^(NGAPIResponseModal *responseData) {
        [mySelfWeak receivedServerResponse:responseData];
        
    }];
}

- (IBAction)viewMoreSimJobAction:(id)sender{
    NGViewMoreSimJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"VMJView"];
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInt:0] forKey:@"offset"];
    [params setValue:[NSNumber numberWithInteger:SIMJOBS_PAGINATION_LIMIT] forKey:@"limit"];
    NSString *jdID = self.jobID;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSMutableDictionary *)@{@"jobId": jdID},K_RESOURCE_PARAMS,params,K_ATTRIBUTE_PARAMS, nil];
    navgationController_.paramsDict = paramDict;
    navgationController_.startTime = [NSDate date];
    [(IENavigationController*)self.navigationController  pushActionViewController:navgationController_ Animated:YES ];
    params = nil;
}


-(void)fetchJDForJob:(NSString*)jobID requestParameters:(NSMutableDictionary *)params
{
//#warning testing
//    [self downloadJDWithParams:params];
//
//    return;
    
    NGJDdataFetcher *dataFetcher = [[NGJDdataFetcher alloc] init];
    NGJDJobDetails *jdObj = [dataFetcher getJobFromLocal:[params objectForKey:@"jobId"]];
    
    if (jdObj) {

        NGAPIResponseModal *obj = [[NGAPIResponseModal alloc]init];
        obj.statusMessage = @"success";
        obj.parsedResponseData = jdObj;
        obj.serviceType = SERVICE_TYPE_JD;
        [self receivedSuccessFromServer:obj];
    }else{
        [self downloadJDWithParams:params];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideAnimator];
    [AppTracer clearLoadTime:[NSString stringWithFormat:@"JD_%ld",(long)self.selectedIndex]];
}



#pragma mark Table View Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_simJobs.count>0)
    {
        if(totalJobsCount>3)
        return 3;
        else
        return 2;
        
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
    if ([self.jobObj.isWebjob isEqualToString:@"true"]) {
        return 5;
    }
    return 6;
    }
    else if(section==1)
    {
        if(isSimJobsLoading)
        return _simJobs.count+1;
        else
            return _simJobs.count;
    }
    else if(section==2)
    {
        return 1;
    }
    else
        return 0;
    
}
-(BOOL)isValidLogo{
    if(![NGDecisionUtility isValidString:[self.jobObj getLogoUrl]])
    {
        return NO;
    }
    if(hideLogo)
    return NO;

    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return [self configureCellForJobDetailSection:indexPath];
    }
    else if(indexPath.section==1){
        if(isSimJobsLoading&&indexPath.row == 0)
        return [self configureCellJobForSpinner:indexPath];
        else
        return [self configureCellJobTouple:indexPath];
    }
    else if(indexPath.section==2){
        return [self configureCellForViewMore:indexPath];
    }
    else
        return nil;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0||indexPath.section == 1){
        CGFloat height = 0;
        if(isheightCached)
        height = [self cachedHeightForIndexPath:indexPath];
        // Not cached ?
        if (height <= 0)
            height = [self heightForIndexPath:indexPath];
        return height;
    }
    else if(indexPath.section == 2){
        return 55;//view more button section
    }
    else{
        return 0;
    }
}

-(CGFloat)heightForIndexPath:(NSIndexPath*)indexPath{
    
    
    NSInteger row = indexPath.row;
    CGFloat cellHeight = 0;
    switch (indexPath.section) {
        case 0:
        {
            switch (row) {
                    
                case LogoCell:{
                    
                    NSString * CellIdentifier =@"LogoCell";
                    NGLogoCell *cell =[self.jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (![self isValidLogo])
                    {
                        cell.logoImgV.frame = CGRectZero;
                        cellHeight = 0.01;//making non zero to avoid calling again
                    }
                    else
                        cellHeight = 70;
                    
                    [heightsArray setCustomObject:[NSNumber numberWithFloat:cellHeight] forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                    break;
                    
                }
                    
                case JobSummaryCell:
                {
                    
                    NSString * CellIdentifier = @"JobSummary";
                    NGJobSummaryCell *cell = [_jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        
                        cell = [[NGJobSummaryCell alloc]
                                initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier];
                    }
                    [cell configureCell:self.jobObj];
                    cellHeight = [UITableViewCell getCellHeight:cell];
                    [heightsArray setCustomObject:[NSNumber numberWithFloat:cellHeight] forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                    break;
                }
                case JDCell:
                {
                    NSString *CellIdentifier = @"JobDescription";
                    NGJobDescriptionCell *cell = [_jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil) {
                        cell = [[NGJobDescriptionCell alloc]
                                initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier];
                    }
                    cell.isJDReadMoreTapped = isJDReadMoreTapped;
                    [cell configureJobDescCell:self.jobObj];
                    cellHeight = [UITableViewCell getCellHeight:cell];
                    [heightsArray setCustomObject:[NSNumber numberWithFloat:cellHeight] forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                    break;
                }
                case DesiredCandidateCell:{
                    
                    NSString *CellIdentifier = @"DesiredCandidate";
                    NGDesiredCandidateCell *cell = [_jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell.isDCReadMoreTapped = isDCReadMoreTapped;
                    [cell configureDesiredCandidateCell:self.jobObj];
                    cellHeight = [UITableViewCell getCellHeight:cell];
                    [heightsArray setCustomObject:[NSNumber numberWithFloat:cellHeight] forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                    break;
                    
                }
                case EDCell:
                {
                    if (hideEmployerDetailsSection == 1) {
                        cellHeight = 0;
                        [heightsArray setCustomObject:[NSNumber numberWithFloat:cellHeight] forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                        break;
                    }
                    NSString * CellIdentifier = @"EmployerDetails";
                    
                    NGEmployerDetailsCell *cell = [_jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell.isEDReadMoreTapped = isEDReadMoreTapped;
                    [cell configureEDCell:self.jobObj];
                    cellHeight = [UITableViewCell getCellHeight:cell];
                    [heightsArray setCustomObject:[NSNumber numberWithFloat:cellHeight] forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                    break;
                    
                }
                case ContactDetailsCell:{
                    
                    if(hideContactSection == 1){
                        cellHeight = 0;
                        [heightsArray setCustomObject:[NSNumber numberWithFloat:cellHeight] forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                        break;
                        
                    }
                    
                    if ([self.jobObj.isWebjob isEqualToString:@"true"]) {
                        cellHeight = 140;
                        NSNumber *num = [NSNumber numberWithFloat:cellHeight];
                        [heightsArray setCustomObject:num forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                        break;
                    }
                    
                    NSString * CellIdentifier = @"ContactDetails";
                    NGContactDetailsCell *cell = [_jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    [cell configureContactDetailsCell:self.jobObj];
                    cellHeight = [UITableViewCell getCellHeight:cell];
                    [heightsArray setCustomObject:[NSNumber numberWithFloat:cellHeight] forKey:[NSString stringWithFormat:@"%ld", (long)row]];
                    break;
                }
                default:
                    cellHeight = 55;
                    break;
            }
        }
            break;
        case 1:
        {
            if(isSimJobsLoading&&indexPath.row == 0)
            {
                cellHeight = 30;
            }
            else
            {
                NGJobTupleCustomCell *cell = (NGJobTupleCustomCell*)[self configureCellJobTouple:indexPath];
                cellHeight = [UITableViewCell getCellHeight:cell];
                NGJobDetails *jobObj = [self.simJobs fetchObjectAtIndex:indexPath.row];
                jobObj.cellHeight = cellHeight;
            }
        }
            break;
        default:
             cellHeight = 0;
            break;
    }

    return cellHeight;


}
-(CGFloat)cachedHeightForIndexPath:(NSIndexPath*)indexPath{

    float height = 0.0f;
    switch (indexPath.section) {
        case 0:
        {
            if([heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]])
            {
                NSNumber *num = [heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                height = num.floatValue;
            }
        }
            break;
            case 1:
        {
            if(isSimJobsLoading&&indexPath.row == 0)
            {
                height = 30;
            }
            else
            {
            NGJobDetails *jobObj = [self.simJobs fetchObjectAtIndex:indexPath.row];
            height = jobObj.cellHeight;
            }
        }
            break;
        default:
            height = 0;
            break;
    }

        return height;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if(indexPath.section == 1)
    {
        
        //open jd page again from sim jobs
        if(isSimJobsLoading&&indexPath.row == 0)
            return;
        [self refreshAllJDs];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        jobIndex = indexPath.row;

        [NGAppStateHandler sharedInstance].appState = APP_STATE_JD;
        NGJDParentViewController* jdParentViewController=[[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JDView"];
        jdParentViewController.selectedIndex = jobIndex;
        NGJobDetails* job = [_simJobs fetchObjectAtIndex:indexPath.row];
        jdParentViewController.jobID=job.jobID;
        jdParentViewController.openJDLocation = JD_FROM_VIEWMORE_OR_JD_SIM_JOB;
        jdParentViewController.selectedIndex=indexPath.row;
        jdParentViewController.allJobsArr=_simJobs;
        jdParentViewController.totalJobsCount=totalJobsCount;
        jdParentViewController.jobDownloadOffset = 0;
        jdParentViewController.xzMIS = self.xzMIS;
        jdParentViewController.srchIDMIS = self.srchIDMIS;
        jdParentViewController.viewLoadingStartTime = [NSDate date];
        [self.navigationController pushViewController:jdParentViewController animated:YES];
  
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0)
    {
        if(isShowApplyFooter)
    {
       return K_JD_FOOTER_HEIGHT;
    }else
        return 0;
    }
    else
        return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(isShowApplyFooter)
        {
                UIView* viewToReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, K_JD_FOOTER_HEIGHT)];
                [viewToReturn addSubview:_applyView.view];
                viewToReturn.tag = K_APPLY_VIEW_SECTION_FOOTER_TAG;
                return viewToReturn;
            
           }else
            return nil;
    }else
        return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1)
    {
        UIView* viewToReturn = nil;
        
        viewToReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, K_SIM_JOB_HEADER_HEIGHT)];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, K_SIM_JOB_HEADER_HEIGHT)];
        if(isDisplayingSimJobs)
        {
            if(_simJobs.count==0)
            lbl.text = @"No Similar Jobs";
            else
            lbl.text = @"Similar Jobs";
        }
        else{
        lbl.text = @"Similar Jobs";
        }
        lbl.tag = 999;
        [lbl setBackgroundColor:[UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255 alpha:1.0]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:17]];
        [lbl setTextColor:[UIColor colorWithRed:109.0/255 green:109.0/255 blue:109.0/255 alpha:1.0]];

        [viewToReturn addSubview:lbl];
        simJobHeaderView = viewToReturn;
        return viewToReturn;
        
    }else
        return nil;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1)
    {
        return K_SIM_JOB_HEADER_HEIGHT;
 
    }else
        return 0;
    

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    
    
    if((indexPath.section == 1&&indexPath.row == 0)||(indexPath.section == 2&&indexPath.row == 0))
    {
        if(_simJobs.count>0)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeNavTitle:K_SIM_JOB_NAV_TITLE];
            });
            
        }
        else{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeNavTitle:K_JOB_DETAIL_NAV_TITLE];
            });

        }
    }

}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{

        if(indexPath.section == 1)
        {
            if(_simJobs.count>0&&indexPath.row == 0&&isScrollingUp == NO)
            {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeNavTitle:K_JOB_DETAIL_NAV_TITLE];
            });
            }
        }
    
}


#pragma mark - AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc{
    if([vc isKindOfClass:[NGJDParentViewController class]])
    {
    }
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
}

#pragma mark- Configure cell methods
-(UITableViewCell*)configureCellForViewMore:(NSIndexPath*)indexPath{
    static NSString *cellIdentifier = @"ViewMoreSection";
    NGSimJobViewMoreSectionCell *cell = (NGSimJobViewMoreSectionCell*)[self.jdTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[NGSimJobViewMoreSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

-(UITableViewCell*)configureCellForJobDetailSection:(NSIndexPath*)indexPath{

    //static NSString *CellIdentifier = @"JobSummary";
    
    UITableViewCell *cellNoreturn = [self.jdTableView dequeueReusableCellWithIdentifier:@"JobSummary"];
    NSInteger row = [indexPath row];
    switch (row) {
        case LogoCell:{
            
            NSString * CellIdentifier =@"LogoCell";
            NGLogoCell *cell =[self.jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if ([self isValidLogo])
            {
                [cell.logoImgV setImageURL:[NSURL URLWithString:self.jobObj.getLogoUrl]];
                cell.logoImgV.showActivityIndicator = NO;
                [[AsyncImageLoader sharedLoader] loadImageWithURL:[NSURL URLWithString:self.jobObj.getLogoUrl] target:self success:@selector(successToLoadImage:) failure:@selector(failedToLoadImage:)];
            }
            return cell;
            
        }
            
            
        case JobSummaryCell:
        {
            NSString * CellIdentifier =@"JobSummary";
            NGJobSummaryCell *cell = [self.jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell configureCell:self.jobObj];
            return cell;
            break;
        }
        case JDCell:
        {
            NSString * CellIdentifier =@"JobDescription";
            
            NGJobDescriptionCell *cell = [self.jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.isJDReadMoreTapped = isJDReadMoreTapped;
            [cell configureJobDescCell:self.jobObj];
            cell.descriptionLbl.delegate = self;
            
            return cell;
        }
        case DesiredCandidateCell:
        {
            
            NSString * CellIdentifier =@"DesiredCandidate";
            NGDesiredCandidateCell *cell = [self.jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.isDCReadMoreTapped = isDCReadMoreTapped;
            [cell configureDesiredCandidateCell:self.jobObj];
            cell.dcProfileLbl.delegate = self;
            return cell;
            
        }
        case EDCell:
        {
            NSString * CellIdentifier = @"EmployerDetails";
            NGEmployerDetailsCell *cell = [self.jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.isEDReadMoreTapped = isEDReadMoreTapped;
            
            if (hideEmployerDetailsSection == 1) {
                cell.hidden = YES;
            }
            else{
                [cell configureEDCell:self.jobObj ];
                
            }
            cell.employerDetailsLbl.delegate = self;
            return cell;
        }
            
        case ContactDetailsCell:{
            
            if ([self.jobObj.isWebjob isEqualToString:@"true"]) {
                static NSString *cellIdentifier = @"WebJobCell";
                
                NGWebJobCell *cell = (NGWebJobCell*)[self.jdTableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                [cell.viewOriginalBtn addTarget:self action:@selector(viewOriginalTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:cell.viewOriginalBtn.titleLabel.text];
                
                [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
                
                [cell.viewOriginalBtn setAttributedTitle:commentString forState:UIControlStateNormal];
                
                [UIAutomationHelper setAccessibiltyLabel:@"webJob_cell" forUIElement:cell withAccessibilityEnabled:NO];
                [UIAutomationHelper setAccessibiltyLabel:@"viewOriginal_btn" forUIElement:cell.viewOriginalBtn];
                
                
                return cell;
                
            }
            
            
            NSString * CellIdentifier = @"ContactDetails";
            NGContactDetailsCell *cell = [self.jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell configureContactDetailsCell:self.jobObj];
            if (hideContactSection == 1) {
                cell.hidden = YES;
            }
            
            
            return cell;
            
        }
        default:
            break;
    }
    return cellNoreturn;

}

-(NGJobTupleCustomCell*)configureCellJobTouple:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"NGJobTupleCustomCell";
    
    NGJobTupleCustomCell *cell = (NGJobTupleCustomCell*)[self.jdTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (NGJobTupleCustomCell *)[nib fetchObjectAtIndex:0];
    }
    NSInteger jobIndex1 = indexPath.row;
    NGJobDetails *jobObj = [_simJobs fetchObjectAtIndex:jobIndex1];
    [cell displayData:jobObj atIndex:jobIndex1];
    return cell;
    
}
-(UITableViewCell*)configureCellJobForSpinner:(NSIndexPath*)indexpath{
    
    NSString * CellIdentifier =@"SpinnerCell";
    UITableViewCell *cell = [self.jdTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2,5, 20, 20)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    spinner.tag = 990;
    [spinner hidesWhenStopped];
    [spinner startAnimating];
    [cell.contentView addSubview:spinner];
        
    }
    else{
    
        [(UIActivityIndicatorView*)[cell.contentView viewWithTag:990] startAnimating];
    
    }
    return cell;

}
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    }
    else if (buttonIndex == 1)
    {
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_VIEW_ORINAL_WEB_JOB withEventLabel:K_GA_EVENT_VIEW_ORINAL_WEB_JOB withEventValue:nil];
        
        NSURL *url = [NSURL URLWithString:self.jobObj.contactWebsite];
        
        if (![[UIApplication sharedApplication] openURL:url]){
        }
    }
}


//#pragma mark Button tapped action functions
#pragma mark Private methods
- (void)backButtonClicked:(UIButton*)sender{
    NSArray *navArr = self.navigationController.viewControllers;
    id viewControllerToPop = nil;
    for (NSUInteger i = navArr.count-1; i>0; i--) {
        id vc = [navArr objectAtIndex:i];
        if((![vc isKindOfClass:[NGJDParentViewController class]])||(![vc isKindOfClass:[NGViewMoreSimJobsViewController class]]))
        {
            viewControllerToPop = vc;
            break;
            
        }
    }
    
    if(viewControllerToPop!=nil)
        [self.navigationController popToViewController:viewControllerToPop animated:YES];
    else
        [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
}

/**
 *  Action handler for view original job in case of job is webjob.
 *
 *  @param sender Sender
 */

-(void) viewOriginalTapped:(id) sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You are navigating out of Naukrigulf.com. We recommend you Email this job to yourself and apply later. Click ‘Cancel’ to stay on the page" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
    [alert show];
    
}


/**
 *  Adding Footerview based on the job type.
 */

-(void)addApplyView{
    
    if(_applyView == nil)
    {
    if ([self.jobObj.isArchivedjob isEqualToString:@"true"])
    {
        [self.expiredJobView setHidden:FALSE];
        [self.jdTableView setHidden:FALSE];
        return;
        
    } else{
        
        [self.expiredJobView setHidden:TRUE];
        [self.jdTableView setHidden:FALSE];
    }
    

    BOOL tempWebJobFlag = NO;
    BOOL tempAlreadyAppliedFlag = NO;
    
    
    if ([self.jobObj.isWebjob isEqualToString:@"true"]) {
        tempWebJobFlag = YES;
    }
    
    if ([self.jobObj.isAlreadyApplied isEqualToString:@"true"])
    {
        tempAlreadyAppliedFlag = YES;
    }

    
    NGJDFooterView *applyView = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"ApplyView"];
    applyView.xzMIS = self.xzMIS;
    
    [applyView setParams:tempWebJobFlag isAppliedJob:tempAlreadyAppliedFlag andJobObj:[self getSRPObject] andJD:self.jobObj];
    
    applyView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    
    applyView.delegate=self.viewCtrller;
    
    _applyView = applyView;
    [self displayData];
    }
    else{
    
        //do nothing
        
    
    }

    isheightCached = NO;
    [self.jdTableView reloadData];
    
    isheightCached = YES;
}
-(NGJobDetails*)getSRPObject{
   // if (YES == self.srpJobObj.isInitiatedFromDeeplinking || YES == self.srpJobObj.isInitiatedFromSpotlight) {
     if (YES == self.srpJobObj.isInitiatedFromDeeplinking) {
        self.srpJobObj = [self.srpJobObj fillRequiredFieldsFromJDJobDetailObject:self.jobObj];
    }
    return self.srpJobObj;
}
/**
 *  Displays data on page from different sections.
 */

-(void)displayData{
    if([self.jobObj.formattedContactNameDes isEqualToString:@""] && [self.jobObj.contactEmail isEqualToString:@""] && [self.jobObj.contactWebsite isEqualToString:@""]){
        hideContactSection = 1;
    }
    
    if ([self.jobObj.companyProfile isEqualToString:@""] ) {
        hideEmployerDetailsSection = 1;
    }
    
    //Reload the table and set its hidden property to no
    [self.jdTableView reloadData];

     self.jdTableView.hidden = NO;
    
    [AppTracer traceEndTime:[NSString stringWithFormat:@"JD_%ld",(long)self.selectedIndex]];

}

#pragma  mark Attributed Strings/Labels

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"read-more-ED"]) {
            isEDReadMoreTapped = 1;
            [readMoreSections addObject:[NSNumber numberWithInt:EDCell]];
            [heightsArray removeObjectForKey:[NSNumber numberWithInteger:EDCell]];
            isheightCached = NO;
            [self.jdTableView reloadData];
            isheightCached = YES;
        }
        
        if ([[url host] hasPrefix:@"read-more-JD"]) {
            isJDReadMoreTapped = 1;
            [readMoreSections addObject:[NSNumber numberWithInt:JDCell]];
            [heightsArray removeObjectForKey:[NSNumber numberWithInteger:JDCell]];
            isheightCached = NO;
            [self.jdTableView reloadData];
            isheightCached = YES;

        }
        
        if ([[url host] hasPrefix:@"read-more-DC"]) {
            isDCReadMoreTapped = 1;
            [readMoreSections addObject:[NSNumber numberWithInt:DesiredCandidateCell]];
            [heightsArray removeObjectForKey:[NSNumber numberWithInteger:DesiredCandidateCell]];
            isheightCached = NO;
            [self.jdTableView reloadData];

            isheightCached = YES;
            
        }
        
    }
    
}

#pragma mark received jobs delegate
- (void)receivedServerResponse:(NGAPIResponseModal*)responseData{
    if (responseData.isSuccess) {
        [self receivedSuccessFromServer:responseData];
    }else{
        [self receivedErrorFromServer:responseData];
    }
}
-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    
    if(responseData.serviceType == SERVICE_TYPE_SIM_JOBS_PAGINATION)
    {
            totalJobsCount=[[responseData.parsedResponseData objectForKey:@"TotalJobsCount"] integerValue];
            NSArray *jobsArr = [responseData.parsedResponseData objectForKey:@"Sim Jobs"];
            [self.simJobs removeAllObjects];
            [self.simJobs addObjectsFromArray:jobsArr];
            isSimJobsLoading = NO;
            isDisplayingSimJobs = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_jdTableView reloadData];
            [self hideAnimator];
            if(_simJobs.count == 0)
            {
                [(UILabel*)[simJobHeaderView viewWithTag:999] setText:@"No Similar Jobs"];
            }
            else{
                [(UILabel*)[simJobHeaderView viewWithTag:999] setText:@"Similar Jobs"];
            }
        });
        
    }
    else if (responseData.serviceType == SERVICE_TYPE_JD)
    {
        self.jobObj = responseData.parsedResponseData;
        //[self setDataOnSpotlight];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideAnimator];
            [self addApplyView];
        });

    
    }
}

-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    if(responseData.serviceType == SERVICE_TYPE_SIM_JOBS_PAGINATION)
    {
        //sim job rezponse error handle
        dispatch_async(dispatch_get_main_queue(), ^{
            [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[ERROR_RESPONSE] withButtonsTitle:@"Ok" withDelegate:nil];
            isSimJobsLoading = NO;
            isDisplayingSimJobs = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_jdTableView reloadData];

                [self hideAnimator];
                
                
            });
        });
        
    }
    else if (responseData.serviceType == SERVICE_TYPE_JD)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideAnimator];
            if (!responseData.isNetworFailed) {
                [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
                
                if(responseData.responseData==nil)
                {
                
                    [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[ERROR_RESPONSE] withButtonsTitle:@"Ok" withDelegate:nil];
                    [self hideAnimator];
                
                }
                
                
                
            }
            else
                [NGDecisionUtility checkNetworkStatus];
            
        });
        
    }

    
  
}
#pragma mark - Async Image Download
-(void)failedToLoadImage:(UIImage *)image
{
    if(hideLogo == NO)
    {
    
    if([heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)LogoCell]])
    {
        [heightsArray setCustomObject:[NSNumber numberWithFloat:0.0] forKey:[NSString stringWithFormat:@"%ld", (long)LogoCell]];
    }

     hideLogo = YES;
     [self.jdTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:LogoCell inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)successToLoadImage:(UIImage *)image
{
    
}

/**
 *  Refresh/update all JD's.
 Clears cache for all JD stored locally.
 */
#pragma mark-
-(void)refreshAllJDs
{
    NSDate* currentTime=[NSDate date];
    
    NSDate* lastSavedTime=[NGSavedData getJDOpenedTime];
    
    NSTimeInterval interval = [currentTime timeIntervalSinceDate:lastSavedTime];
    
    int hours = (int)interval / 3600;             // integer division to get the hours part
    int minutes = (interval - (hours*3600)) / 60; // interval minus hours part (in seconds) divided by 60 yields minutes
    
    if(lastSavedTime)
    {
        
        if (minutes>30)
        {
            [NGSavedData saveJDOpenedTime:currentTime];
            [[DataManagerFactory getStaticContentManager] deleteAllJD];
        }
    }
    else
    {
        [NGSavedData saveJDOpenedTime:currentTime];
    }
    
}
#pragma mark -
#pragma mark handling Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    
}
-(void)releaseMemory
{
    self.jdTableView.backgroundColor = nil;
    [self.applyView removeFromParentViewController];
    [self.applyView.view removeFromSuperview];
    self.applyView.delegate = nil;
    self.applyView = nil;
    self.jobObj = nil;
    self.jdTableView.dataSource = nil;
    self.jdTableView.delegate = nil;
    self.jdTableView =  nil;
    self.viewCtrller = nil;
    self.srpJobObj = nil;
    self.xzMIS  =  nil;
    self.srchIDMIS = nil;
    if([heightsArray allKeys])
        [heightsArray removeAllObjects];
    [self.networkView removeFromSuperview];
    self.networkView = nil;
    readMoreSections = nil;
    _jobID = nil;
    [super releaseMemory];
}


@end
