//
//  NGApplyConfirmationViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 19/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGApplyConfirmationViewController.h"
#import "NGApplyConfirmationMessageCell.h"
#import "NGJobTupleCustomCell.h"
#import "NGSimJobSectionCell.h"

#define SHORTLISTED 11
#define UNSHORTLISTED 10


@interface NGApplyConfirmationViewController ()
{
    int simJobsOffset;
    BOOL isJobsLoading;
    NSInteger totalJobsCount;
    
    NGApplyConfirmationMessageCell* applyConfirmationCell;
    
    NSInteger selectedJobIndex;
    

}

@end

@implementation NGApplyConfirmationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.hidden = YES;
    [NGSavedData setIfSimJobsExistsForTheJob:FALSE];
    [self addNavigationBarWithBackBtnWithTitle:@"Apply Confirmation"];
    totalJobsCount=[NGSavedData getTotalSimJobsCount];
    
    self.isSwipePopGestureEnabled = NO;
    self.isSwipePopDuringTransition = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    _tableView.hidden = NO;
    [_tableView reloadData];
    if (_bScrollTableToTop)
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];//scroll to top
 }

-(void)viewDidAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    selectedJobIndex = -1;
    
    [NGHelper sharedInstance].appState = APP_STATE_APPLY_CONFIRMATION;
    [super viewDidAppear:animated];
    
    [NGGoogleAnalytics sendScreenReport:K_GA_APPLY_CONFIRMATION_SCREEN];
    
    [NGUIUtility removeAllViewControllersTillJobTupleSourceView];
    [AppTracer traceEndTime:TRACER_ACP];    
    [UIAutomationHelper setAccessibiltyLabel:@"acpTableView" forUIElement:self.tableView withAccessibilityEnabled:NO];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    _bScrollTableToTop = NO;
    [AppTracer clearLoadTime:TRACER_ACP];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 return 3;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;
    }else{
        return _simJobs.count;
    }
    
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return [self configureCellForApplyConfirmationSection:indexPath];
    }else if(indexPath.section==1){
        return [self configureCellForStaticSection:indexPath];
    }else{
        return [self configureCellJobTouple:indexPath];
    }
}
-(NGSimJobSectionCell*)configureCellForStaticSection:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"SimJobSection";
    NGSimJobSectionCell *cell = (NGSimJobSectionCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[NGSimJobSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.userInteractionEnabled=NO;
    
    return cell;
}

 
-(NGApplyConfirmationMessageCell*)configureCellForApplyConfirmationSection:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"ApplyConfirmation";
   
    applyConfirmationCell=(NGApplyConfirmationMessageCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (applyConfirmationCell == nil)
    {
        applyConfirmationCell = [[NGApplyConfirmationMessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                      reuseIdentifier:cellIdentifier];
    }
   
    //applyConfirmationCell.designLbl.text = [NSString stringWithFormat:@"\"%@\"",self.jobObj.designation];
    [applyConfirmationCell configureACMessageCell:[NSString stringWithFormat:@"\"%@\"",self.jobObj.designation]];
    
    return applyConfirmationCell;
}

-(NGJobTupleCustomCell*)configureCellJobTouple:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"NGJobTupleCustomCell";
    
    NGJobTupleCustomCell *cell = (NGJobTupleCustomCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (NGJobTupleCustomCell *)[nib fetchObjectAtIndex:0];
    }
    
    NSInteger jobIndex = indexPath.row;
    
    NGJobDetails *jobObj = [_simJobs fetchObjectAtIndex:jobIndex];
    
    [cell displayData:jobObj atIndex:jobIndex];
    
   return cell;

}
 
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self cachedHeightForIndexPath:indexPath];
    // Not cached ?
    if (height <= 0)
        height = [self heightForIndexPath:indexPath];
    
    return height;
}
-(CGFloat)heightForIndexPath:(NSIndexPath*)indexPath{
    float height = 120.0f;
    if (indexPath.section==0)
    {
        height = [UITableViewCell getCellHeight:[self configureCellForApplyConfirmationSection:indexPath]];
    }else if(indexPath.section==1){
         height = 45;
    }else{
        height = [UITableViewCell getCellHeight:[self configureCellJobTouple:indexPath]];
        NGJobDetails *jobObj = [_simJobs fetchObjectAtIndex:indexPath.row];
        jobObj.cellHeight = height;
    }

    return height;
    
}
-(CGFloat)cachedHeightForIndexPath:(NSIndexPath*)indexPath{
    float height = 120.0f;
    if (indexPath.section==0)
    {
        height = [UITableViewCell getCellHeight:[self configureCellForApplyConfirmationSection:indexPath]];
    }
    else if(indexPath.section==1)
    {
        height = 45;
    }
    else
    {
        NGJobDetails *jobObj = [_simJobs fetchObjectAtIndex:indexPath.row];
        height = jobObj.cellHeight;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedJobIndex = [indexPath row];
    
    [[NGAppStateHandler sharedInstance]setDelegate:self];
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JD usingNavigationController:self.navigationController animated:YES ];
}
#pragma mark - AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc{
    if([vc isMemberOfClass:[NGJDParentViewController class]])
    {
        NGJDParentViewController* navgationController_ = (NGJDParentViewController*)vc;
        if (navgationController_.allJobsArr) {
            [navgationController_.allJobsArr removeAllObjects];
        }else{
            navgationController_.allJobsArr = [NSMutableArray new];
        }
        [navgationController_.allJobsArr addObjectsFromArray:_simJobs];
        navgationController_.selectedIndex = selectedJobIndex;
        navgationController_.totalJobsCount = [_simJobs count];
        navgationController_.openJDLocation = JD_FROM_ACP_SIM_JOB_PAGE;
        navgationController_.xzMIS = @"30_0_34";
        navgationController_.jobDownloadOffset = 0;
        navgationController_.viewLoadingStartTime = [NSDate date];

    }
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deallocAllElements{


    self.tableView.backgroundColor  =   nil;
    if([_simJobs count]){
    
        [_simJobs removeAllObjects];
    }
    self.jobObj     =   nil;
    self.jobId      =   nil;
    self.designLbl = nil;
    self.tableView.delegate =   nil;
    self.tableView.dataSource    =   nil;
    
    [super releaseMemory];
}
-(void)paginationForSimJobs
{
    [self showAnimator];
    
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInt:simJobsOffset] forKey:@"offset"];
    [params setValue:[NSNumber numberWithInteger:SIMJOBS_PAGINATION_LIMIT] forKey:@"limit"];
    
    //K_RESOURCE_PARAMS
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SIM_JOBS_PAGINATION];
    __weak NGApplyConfirmationViewController *mySelfWeak = self;
    __block NSInteger totalJobsCountWeak = totalJobsCount;
    __block NSMutableArray* simJobsWeak = _simJobs;
    __block BOOL isJobsLoadingWeak = isJobsLoading;

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSMutableDictionary *)@{@"jobId": self.jobObj.jobID},K_RESOURCE_PARAMS,params,K_ATTRIBUTE_PARAMS, nil];
    
    [obj getDataWithParams:paramDict handler:^(NGAPIResponseModal *responseData) {
        if (responseData.isSuccess) {
            totalJobsCountWeak=[[responseData.parsedResponseData objectForKey:@"TotalJobsCount"] integerValue];
            if(responseData.serviceType == SERVICE_TYPE_SIM_JOBS_PAGINATION){
                NSArray *jobsArr = [responseData.parsedResponseData objectForKey:@"Sim Jobs"];
                [simJobsWeak addObjectsFromArray:jobsArr];
                isJobsLoadingWeak = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mySelfWeak.tableView reloadData];
                    [mySelfWeak hideAnimator];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[ERROR_RESPONSE] withButtonsTitle:@"Ok" withDelegate:nil];
                [mySelfWeak hideAnimator];
            });
        }
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 15;
    
    if(y > h + reload_distance)
    {
        
        if (!isJobsLoading)
        {
            
            isJobsLoading = YES;
            simJobsOffset+=SIMJOBS_PAGINATION_LIMIT;
            
            NSInteger maxOffset = totalJobsCount;
            if (simJobsOffset<maxOffset)
            {
                [self paginationForSimJobs];
                
            }
            else
            {
                isJobsLoading = NO;
                simJobsOffset-=SIMJOBS_PAGINATION_LIMIT;
            }
        }
    }
}

#pragma mark Helper Methods
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)dealloc
{
  [self deallocAllElements];
}
@end
