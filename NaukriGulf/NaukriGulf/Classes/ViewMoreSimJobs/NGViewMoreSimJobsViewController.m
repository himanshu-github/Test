//
//  NGViewMoreSimJobsViewController.m
//  NaukriGulf
//
//  Created by Himanshu on 9/30/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGViewMoreSimJobsViewController.h"
#import "NGSRPViewController.h"

@interface NGViewMoreSimJobsViewController ()
{
        NSDate *searchStartTime;
        NSDate *searchEndTime;
        NSInteger jobIndex;
        BOOL isJobsLoading;    //Checks if any Job is being Download

        NGHelper *helperObj;

}
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIView *noJobsView;
@property (weak, nonatomic) IBOutlet UILabel *noMatchingJobLable;

@end
static NSString *cellIdentifier = @"NGJobTupleCustomCell";

@implementation NGViewMoreSimJobsViewController

- (void)viewDidLoad {
    [AppTracer traceStartTime:TRACER_ID_VIEW_MORE_SIM_JOBS];
    [super viewDidLoad];
    [self addNavigationBarWithBackBtnWithTitle:@"Similar Jobs"];
    self.noJobsView.hidden = YES;
    _contentTableView.hidden = YES;
    self.jobDownloadOffset = 0;
    isJobsLoading = NO;
    self.allJobsArr = [[NSMutableArray alloc]init];
    [self fetchJobsFromServer];
    searchStartTime = [NSDate date];
    
    UINib *jobTuppleNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_contentTableView registerNib:jobTuppleNib forCellReuseIdentifier:cellIdentifier];
    [_contentTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_contentTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
   
}
-(void)fetchJobsFromServer{
    
    [self showAnimator];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SIM_JOBS_PAGINATION];
    __weak NGViewMoreSimJobsViewController *mySelfWeak = self;
    [obj getDataWithParams:self.paramsDict handler:^(NGAPIResponseModal *responseData) {
        [mySelfWeak receivedServerResponse:responseData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    helperObj = [NGHelper sharedInstance];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppTracer clearLoadTime:TRACER_ID_VIEW_MORE_SIM_JOBS];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [NGHelper sharedInstance].appState = APP_STATE_VIEW_MORE_JOB;
    [super viewDidAppear:YES];
    [NGGoogleAnalytics sendScreenReport:K_GA_VIEW_MORE_SIM_JOBS_RESULT_PAGE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self hideAnimator];
}
- (void)backButtonClicked:(UIButton*)sender{
    NSArray *navArr = self.navigationController.viewControllers;
    id viewControllerToPop = nil;
    for (NSUInteger i = navArr.count-1; i>0; i--) {
        
        id vc = [navArr objectAtIndex:i];
        if([vc isKindOfClass:[NGJDParentViewController class]]||[vc isKindOfClass:[NGViewMoreSimJobsViewController class]])
        {
            
        }
        else{
            
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
 *  Refresh/update all JD's.
 Clears cache for all JD stored locally.
 */

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

/**
 *  Configuring Custom cells based on the IndexPath
 *
 *  @param indexPath indexPath
 *
 *  @return UITableViewCell
 */

-(UITableViewCell *)configureCell:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
            
        case 0:{
            NGJobTupleCustomCell *cell = (NGJobTupleCustomCell*)[_contentTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                cell = (NGJobTupleCustomCell *)[nib fetchObjectAtIndex:0];
                
            }
            
            NSInteger jobIndexTmp = indexPath.row;
            
            NGJobDetails *jobObj = [self.allJobsArr fetchObjectAtIndex:jobIndexTmp];
            [cell displayData:jobObj atIndex:jobIndexTmp];
            
            //cell.delegate = self;
            
            return cell;
            
            
            break;
        }
        default:
            break;
    }
    
    return nil;
}

#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    
    searchEndTime = [NSDate date];
    NSTimeInterval timeDifference = [searchEndTime timeIntervalSinceDate:self.startTime];
    
    NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
    NSInteger totalJobs =[[responseDataDict objectForKey:@"TotalJobsCount"] integerValue];
    NSArray *jobsArr = [responseDataDict objectForKey:@"Sim Jobs"];
//    self.xzMIS = objModel.xzMIS;
//    self.srchIDMIS = objModel.srchID_MIS;
    self.totalJobsCount = totalJobs;
    
    dispatch_async(dispatch_get_main_queue(), ^{
            if (totalJobs==0)
            {
                self.noJobsView.hidden = NO;
                _contentTableView.hidden = YES;
                [self setCustomTitle:@"No Jobs Found"];
                [self setCustomFontForSRPPageNavigationBar:NO];
                [self removeAllRightSideItemsOfNavigationBar];
                
            }
            else{
                self.noJobsView.hidden = YES;
                _contentTableView.hidden = NO;
                [self.allJobsArr addObjectsFromArray:jobsArr];
                [_contentTableView reloadData];
            }
        [self hideLoader];
        [AppTracer traceEndTime:TRACER_ID_VIEW_MORE_SIM_JOBS];
        [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"View More Sim Jobs Loding Time" withTimngLabel:@"success"];
    });
    
}

-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    searchEndTime = [NSDate date];
    NSTimeInterval timeDifference = [searchEndTime timeIntervalSinceDate:self.startTime];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if (!responseData.isNetworFailed) {
            [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
            if(_allJobsArr.count == 0)
            {
                [self setCustomTitle:@"Network Error"];
                _noMatchingJobLable.text = @"Network Error";
            }
        }
        else{
            //no network condition case
            [NGDecisionUtility checkNetworkStatus];
            [self setCustomTitle:@"Network Error"];
            _noMatchingJobLable.text = @"Network Error";
        }
        self.noJobsView.hidden = NO;
        _contentTableView.hidden = YES;
        [self removeAllRightSideItemsOfNavigationBar];
        [self setCustomFontForSRPPageNavigationBar:NO];
        [self hideLoader];
        [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"View More Sim Jobs Loding Time" withTimngLabel:@"Failure"];
        [AppTracer traceEndTime:nil];
    });
    
    
}
-(void)hideLoader{
    isJobsLoading = NO;
    [self hideAnimator];
}
#pragma mark - AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc{
    if([vc isKindOfClass:[NGJDParentViewController class]])
    {
    }
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
}

#pragma mark UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
            
        case 0:
            if (_allJobsArr && 0 <[_allJobsArr count]) {
                return [_allJobsArr count];
            }
            break;
            
        default:
            break;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self configureCell:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = [self cachedHeightForIndexPath:indexPath];
    // Not cached ?
    if (height <= 0)
        height = [self heightForIndexPath:indexPath];
    
    return height;
    
}
-(CGFloat)heightForIndexPath:(NSIndexPath*)indexPath{
    
    float height = 120.0f;
    switch (indexPath.section) {
            
        case 0:{
            NGJobTupleCustomCell *cell = (NGJobTupleCustomCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            NGJobDetails *jobObj = [self.allJobsArr fetchObjectAtIndex:indexPath.row];
            jobObj.cellHeight = height;
            break;
        }
        default:
            break;
    }
    
    return height;
    
}
-(CGFloat)cachedHeightForIndexPath:(NSIndexPath*)indexPath{
    
    float height = 0.0f;
    switch (indexPath.section) {
        case 0:{
            NGJobDetails *jobObj = [self.allJobsArr fetchObjectAtIndex:indexPath.row];
            height = jobObj.cellHeight;
            break;
        }
        default:
            break;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0)
    {
        [self refreshAllJDs];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        jobIndex = indexPath.row;
        NGJDParentViewController* navgationController_=[[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JDView"];

        navgationController_.allJobsArr = self.allJobsArr;
        navgationController_.selectedIndex = jobIndex;
        navgationController_.jobDownloadOffset = self.jobDownloadOffset;
        navgationController_.totalJobsCount = self.totalJobsCount;
        navgationController_.paramsDict = self.paramsDict;
        navgationController_.openJDLocation = JD_FROM_VIEWMORE_OR_JD_SIM_JOB;
        navgationController_.xzMIS = self.xzMIS;
        navgationController_.srchIDMIS = self.srchIDMIS;
        navgationController_.viewLoadingStartTime = [NSDate date];
        [self.navigationController pushViewController:navgationController_ animated:YES];
        
    }
    
}

#pragma mark- ScrollView delegates
/**
 *  Loads new(more) jobs on Scrolling
 *
 *  @param scrollView scrollView
 */

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
        if (!isJobsLoading) {
            isJobsLoading = YES;
            self.jobDownloadOffset+=[NGConfigUtility getJobDownloadLimit];
            NSInteger maxOffset = self.totalJobsCount;
            if (self.jobDownloadOffset<maxOffset) {
                [[self.paramsDict objectForKey:K_ATTRIBUTE_PARAMS] setCustomObject:[NSNumber numberWithInteger:self.jobDownloadOffset] forKey:@"offset"];
                [self fetchJobsFromServer];

            }else{
                isJobsLoading = NO;
                self.jobDownloadOffset-=[NGConfigUtility getJobDownloadLimit];
            }
        }
        
    }
}
- (void)receivedServerResponse:(NGAPIResponseModal*)responseData{
    if (responseData.isSuccess) {
        [self receivedSuccessFromServer:responseData];
    }else{
        [self receivedErrorFromServer:responseData];
    }
}
@end

