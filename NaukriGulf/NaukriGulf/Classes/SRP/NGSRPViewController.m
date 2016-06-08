//
//  NGSRPViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 05/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
// 

#import "NGSRPViewController.h"
#import "NGShortlistedJobsViewController.h"


@interface NGSRPViewController (){

    NSDate *searchStartTime;
    NSDate *searchEndTime;
    
    BOOL filterFlag;       //Checks if filetering is ON
    BOOL isJobsLoading;    //Checks if any Job is being Download
    NSInteger jobIndex;
    
    NGHelper *helperObj;
    
    __weak IBOutlet NSLayoutConstraint *uiTableViewBottomConstraint;
    __weak IBOutlet UIButton *addSSAButton;
    
    NSArray *serviceArr;
 
    NSMutableArray *cachedHeightArr;
    
}

@property (weak, nonatomic) IBOutlet NGButton *modifySearchBtn;
@property (weak, nonatomic) IBOutlet NGButton *createAlertBtn;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIView *noJobsView;
@property (weak, nonatomic) IBOutlet UILabel *noMatchingJobLable;

- (IBAction)modfiySearchTapped:(id)sender;
- (IBAction)createAlertTapped:(id)sender;

@end

@implementation NGSRPViewController

static NSString *cellIdentifier = @"NGJobTupleCustomCell";

#pragma mark -
#pragma mark UIViewController Methods

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
   [AppTracer traceStartTime:TRACER_ID_SRP];
    [super viewDidLoad];
    cachedHeightArr = [NSMutableArray array];
    [UIAutomationHelper setAccessibiltyLabel:@"modifySearch_btn" forUIElement:_modifySearchBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"createAlert_btn" forUIElement:_createAlertBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"addSSA_btn" forUIElement:addSSAButton];
    
    [self addNavigationBarForSRPWithTitle:@""];
    
    [NGSavedData saveLastSearch:self.paramsDict];
    
    self.noJobsView.hidden = YES;
    _contentTableView.hidden = YES;
    self.jobDownloadOffset = 0;
    filterFlag = FALSE;
    
    isJobsLoading = NO;
    self.allJobsArr = [[NSMutableArray alloc]init];
    self.selectedClusterDict = [[NSMutableDictionary alloc]init];
    [self fetchJobsFromServer];
   
    [[DataManagerFactory getStaticContentManager] deleteAllJD];
    searchStartTime = [NSDate date];
    
    [addSSAButton setHidden:YES];
    
    UINib *jobTuppleNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [_contentTableView registerNib:jobTuppleNib forCellReuseIdentifier:cellIdentifier];
    
    [_contentTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_contentTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
   
    [UIAutomationHelper setAccessibiltyLabel:@"srpTableView" forUIElement:_contentTableView withAccessibilityEnabled:NO];
    
    serviceArr = @[[NSNumber numberWithInt:SERVICE_TYPE_ALL_JOBS]];
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
  
    
}
-(void)fetchJobsFromServer{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.paramsDict];
    [dict setCustomObject:@"ios" forKey:@"requestsource"];
    
    [self showAnimator];
    [self downloadJobsWithParams:dict];
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    [super viewWillAppear:animated];
    helperObj = [NGHelper sharedInstance];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppTracer clearLoadTime:TRACER_ID_SRP];
    
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    [NGHelper sharedInstance].appState = APP_STATE_SRP;
    [super viewDidAppear:YES];
    [NGGoogleAnalytics sendScreenReport:K_GA_SEARCH_RESULT_PAGE];

    _ssaView.needToListenKeyboardEvent = YES;
    [self refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self hideAnimator];
    _ssaView.needToListenKeyboardEvent = NO;
    [APPDELEGATE.container setRightMenuViewController:nil];
}


#pragma mark -
#pragma mark handling Memory

-(void)viewDidUnload{    
    [super viewDidUnload];
}

-(void)dealloc{

    [[NGOperationQueueManager sharedManager] cancelOperation:serviceArr];

    [self.allJobsArr removeAllObjects];
    self.allJobsArr = nil;
    
    _contentTableView = nil;
    self.noJobsView = nil;
    self.topView = nil;
    self.paramsDict = nil;
    self.clusterDict = nil;
    self.selectedClusterDict = nil;
    _ssaView = nil;
    self.modifySearchBtn = nil;
    self.createAlertBtn = nil;
    filterBtnForSRP = nil;
    helperObj = nil;//    loader = nil;
}


#pragma mark Private Methods


/**
 *  Adds the SSA View at the bottom of the page
 */

-(void)addSSAView{
    
    NSString *keywords = [self.paramsDict objectForKey:@"Keywords"];
    
    if (![keywords isEqualToString:@""])
    {
        [addSSAButton setHidden:NO];
        [uiTableViewBottomConstraint setConstant:55];
    }
    else
    {
        [uiTableViewBottomConstraint setConstant:0];
        [addSSAButton setHidden:YES];
    }
    [_contentTableView updateConstraints];
    [[self view] setNeedsLayout];
}
- (IBAction)addSSAButtonTapped:(UIButton*)sender{
    if (nil==_ssaView) {
        
        _ssaView = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"SSAView"];
        
        
        float yOfSSAView = CGRectGetMaxY(self.view.frame);
        
        _ssaView.view.frame = CGRectMake(0, yOfSSAView, SCREEN_WIDTH, 240);
        _ssaView.needToListenKeyboardEvent = YES;
        _ssaView.paramsDict = self.paramsDict;
        [self addChildViewController:_ssaView];
        [self.view addSubview:_ssaView.view];
    }
    [_ssaView ssaTapped:_ssaView.ssaBtn];
}
- (void)addAutoLayoutConstraintForSSAView{
    if (_ssaView) {
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:_ssaView.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:_ssaView.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_ssaView.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:_ssaView.view.frame.origin.y];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_ssaView.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_ssaView.view.frame.size.height];

        
        
        [self.view addConstraint:leadingConstraint];
        [self.view addConstraint:trailingConstraint];
        [self.view addConstraint:topConstraint];
        [self.view addConstraint:heightConstraint];
    }
}
/**
 *  Removes the SSA view
 */

-(void)removeSSAView{
    if (_ssaView) {
        [_ssaView.view removeFromSuperview];
         _ssaView = nil;
    }
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
            
            static NSString *cellIdentifier = @"JobVacancyCell";
            
            NGVacancyCustomCell *cell = (NGVacancyCustomCell*)[_contentTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                cell = [[NGVacancyCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            [cell displayDataWithTotalJobs:self.totalJobsCount Vacancies:self.totalVacanciesCount];
            cell.userInteractionEnabled = YES;
            [cell.modifySearchBtn addTarget:self action:@selector(modfiySearchTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
            break;
        }
            
        case 1:{
            NGJobTupleCustomCell *cell = (NGJobTupleCustomCell*)[_contentTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                cell = (NGJobTupleCustomCell *)[nib fetchObjectAtIndex:0];
                
            }
            
            NSInteger jobIndexTmp = indexPath.row;
            
            NGJobDetails *jobObj = [self.allJobsArr fetchObjectAtIndex:jobIndexTmp];
            [cell displayData:jobObj atIndex:jobIndexTmp];
            
            cell.delegate = self;
            
            return cell;
            
            
            break;
        }
        default:
            break;
    }
    
    return nil;
}

#pragma mark Notification Methods

/**
 *  When JD is closed the class will be notified by invoking this method
 *
 *  @param notification The notification
 */

-(void)jobCloseBtnTapped:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"jdCloseTapped" object:nil];
    
    NSMutableArray *arr = [notification.userInfo objectForKey:@"alljobsarr"];
    
    [self.allJobsArr removeAllObjects];
    
    [self.allJobsArr addObjectsFromArray:arr];
    
    
    NSInteger j = [self.allJobsArr count]/[NGConfigUtility getJobDownloadLimit];
    NSInteger k = [self.allJobsArr count]%[NGConfigUtility getJobDownloadLimit];
    if (k==0) {
        self.jobDownloadOffset = [NGConfigUtility getJobDownloadLimit]*(j-1);
    }else{
        self.jobDownloadOffset = [NGConfigUtility getJobDownloadLimit]*j;
    }
    
    [_contentTableView reloadData];
}

#pragma mark IBAction Methods

- (IBAction)modfiySearchTapped:(id)sender {
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
}

- (IBAction)createAlertTapped:(id)sender {
    if (_ssaView) {
        [_ssaView.view removeFromSuperview];
        [_ssaView removeFromParentViewController];
        _ssaView = nil;
    }
    

    [self addSSAButtonTapped:nil];
}


#pragma mark Filter Delegate

/**
 *  Filters searched results based on selected clusters
 *
 *  @param resultDict  Search results list
 *  @param slectedDict Selected clusters list
 */

-(void) doneFiltering:(NSMutableDictionary *) resultDict withRowsSelected:(NSMutableDictionary *)slectedDict{
    
    if([resultDict isEqualToDictionary:self.selectedClusterDict]){
        return;
    }
    
     [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_REFINE_SRP withEventLabel:K_GA_EVENT_REFINE_SRP withEventValue:nil];
    
    
    [self.selectedClusterDict setDictionary:resultDict];
    
    NSArray *totalKeys=[resultDict allKeys];
    NSInteger countItemsInKey=0;
    
    if(totalKeys!=nil)
    {
        for (NSInteger i=0; i<totalKeys.count;i++)
        {
            countItemsInKey=[[resultDict valueForKey:[totalKeys fetchObjectAtIndex:i]] count];
            if (countItemsInKey>0)
                break;
        }
    }
    
    if (countItemsInKey==0)
    {
        [filterBtnForSRP setImage:[UIImage imageNamed:@"refineSRPIcon"] forState:UIControlStateNormal];
    }
    else
    {
        [filterBtnForSRP setImage:[UIImage imageNamed:@"refineAppliedSRPIcon"] forState:UIControlStateNormal];
    }
    
    
    filterFlag = TRUE;
    self.jobDownloadOffset = 0;    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setDictionary:resultDict];    
    [params setCustomObject:[NSNumber numberWithInteger:self.jobDownloadOffset] forKey:@"Offset"];
    [params setCustomObject:[NSNumber numberWithInteger:[NGConfigUtility getJobDownloadLimit]] forKey:@"Limit"];
    [params setCustomObject:[self.paramsDict objectForKey:@"Keywords"] forKey:@"Keywords"];
    [params setCustomObject:[self.paramsDict objectForKey:@"Location"] forKey:@"Location"];
    [params setCustomObject:[self.paramsDict objectForKey:@"Experience"] forKey:@"Experience"];
    
    self.paramsDict = params;
    _ssaView.paramsDict = params;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchJobsFromServer];
    });
    
    
}

#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    
    searchEndTime = [NSDate date];
    NSTimeInterval timeDifference = [searchEndTime timeIntervalSinceDate:self.startTime];
    
    NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
    NGJobDetailModel *objModel = [responseDataDict objectForKey:KEY_JOBS_INFO];
    
    NSInteger totalJobs = objModel.totoalJobsCount;
    NSInteger totalVacancies = objModel.totoalVacancyCount;
    NSMutableDictionary *clusterDict = objModel.clusters;
    NSArray *jobsArr = objModel.jobList;
    
    self.xzMIS = objModel.xzMIS;
    self.srchIDMIS = objModel.srchID_MIS;
    
    self.totalJobsCount = totalJobs;
    self.totalVacanciesCount = totalVacancies;
    self.clusterDict = clusterDict;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (filterFlag) {
            
            filterFlag = FALSE;
            if (totalJobs==0)
            {
                self.noJobsView.hidden = NO;
                _contentTableView.hidden = YES;
                
                
            }
            else
            {
                [self addSSAView];
                
                [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_SRP withModel:_paramsDict]];

                self.noJobsView.hidden = YES;
                _contentTableView.hidden = NO;
                [self.allJobsArr removeAllObjects];
                [self.allJobsArr addObjectsFromArray:jobsArr];
                
                [_contentTableView reloadData];
            }
            
        }else{
            if (totalJobs==0)
            {
                self.noJobsView.hidden = NO;
                _contentTableView.hidden = YES;
                
                [self setCustomTitle:@"No Jobs Found"];
                [self setCustomFontForSRPPageNavigationBar:NO];
                [self removeAllRightSideItemsOfNavigationBar];
                
            }
            else{
                
                [self addSSAView];
                
                self.noJobsView.hidden = YES;
                _contentTableView.hidden = NO;
                [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_SRP withModel:_paramsDict]];

                [self.allJobsArr addObjectsFromArray:jobsArr];
                
                [_contentTableView reloadData];
            }
            
        }
        
        if (_allJobsArr && 0<[_allJobsArr count]) {
            [self addNavigationBarForSRPWithTitle:nil];
        }
        
        [self hideLoader];
        [AppTracer traceEndTime:TRACER_ID_SRP];
        [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"SRP View Loding Time" withTimngLabel:@"success"];

    });
    
    
}

-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    
    searchEndTime = [NSDate date];
    NSTimeInterval timeDifference = [searchEndTime timeIntervalSinceDate:self.startTime];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeSSAView];
        
        
        if (!responseData.isNetworFailed) {
            //response error from service api case
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
        [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"SRP View Loding Time" withTimngLabel:@"Failure"];
        [AppTracer traceEndTime:nil];

    });
    
    
}
-(void)hideLoader{
    isJobsLoading = NO;
    [self hideAnimator];
}

/**
 *  Hides TopView (Toolbar) based on flag passed
 *
 *  @param flag If YES Toolbar is hidden
 */

-(void)hideToolBarButtons:(BOOL)flag
{
    for (UIView* subview in self.topView.subviews)
    {
        
        if (([subview viewWithTag:1]) || ([subview viewWithTag:42]))
        {
            subview.hidden=flag;
        }
        
    }
}

#pragma mark - AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc{
    if([vc isKindOfClass:[NGJDParentViewController class]])
    {
        NGJDParentViewController* navgationController_ = (NGJDParentViewController*)vc;
        navgationController_.allJobsArr = self.allJobsArr;
        navgationController_.selectedIndex = jobIndex;
        navgationController_.jobDownloadOffset = self.jobDownloadOffset;
        navgationController_.totalJobsCount = self.totalJobsCount;
        navgationController_.paramsDict = self.paramsDict;
        navgationController_.openJDLocation = JD_FROM_SRP_PAGE;
        navgationController_.xzMIS = self.xzMIS;
        navgationController_.srchIDMIS = self.srchIDMIS;
        navgationController_.viewLoadingStartTime = [NSDate date];

    }
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
}

#pragma mark reload method

-(void) refreshView{
    
    [_contentTableView reloadData];
    
    if([NGSavedData getIfSimJobsExistsForTheJob])
    {
        
        [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:nil title:@"" subTitle:@"You have successfully applied to the job" animationTime:5 showAnimationDuration:0.5];
        
        [NGSavedData  setIfSimJobsExistsForTheJob:FALSE];
        
        
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:KEY_DUPLICATE_APPLY])
    {
        
        [_contentTableView setContentOffset:CGPointMake(0, 0)];
        
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:nil title:@"" subTitle:ERROR_MESSAGE_DUPLICATE_APPLY animationTime:5 showAnimationDuration:0];
        
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:KEY_DUPLICATE_APPLY];
        
    }

}
#pragma mark UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    CGFloat height = 0.0f;
    switch (indexPath.section) {
        case 0: {
            NGVacancyCustomCell *cell = (NGVacancyCustomCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
        case 1: {
            height = [self cachedHeightForIndexPath:indexPath];
            // Not cached ?
            if (height <= 0)
                height = [self heightForIndexPath:indexPath];
            break;
        }
        default: {
            break;
        }
    }
    
    return height;
    
}
-(CGFloat)heightForIndexPath:(NSIndexPath*)indexPath{
    float height = 120.0f;
    switch (indexPath.section) {
        case 1:{
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
    switch (indexPath.section)
    {
        case 1:{
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
    
    if (indexPath.section==1)
    {
        [self refreshAllJDs];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        jobIndex = indexPath.row;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jobCloseBtnTapped:) name:@"jdCloseTapped" object:nil];
        [[NGAppStateHandler sharedInstance]setDelegate:self];
        [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JD usingNavigationController:self.navigationController animated:YES ];
    
    }
    
}

#pragma mark JobTupleCell Delegate Methods


-(void)jobTupleCell:(NGJobTupleCustomCell *)jobTupleObj shortListTappedWithFlag:(BOOL)flag{
    if (flag) {
        NSInteger jobIndexTmp = jobTupleObj.jobIndex;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:jobIndexTmp inSection:1];
        
        CGRect rectInTableView = [_contentTableView rectForRowAtIndexPath:indexPath];
        CGRect rectInSuperview = [_contentTableView convertRect:rectInTableView toView:[_contentTableView superview]];
        
        [NGUIUtility showShortlistedAnimationinView:self.view AtPosition:CGPointMake(rectInSuperview.origin.x, rectInSuperview.origin.y-30)];
    }
}

- (void)openShortlistedJobViewController:(id)sender{
    [self.view endEditing:YES];
    [_ssaView hideSSAViewFromSuperView];
    NGShortlistedJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"ShortlistedJobsView"];
    
    [(IENavigationController*)self.navigationController pushActionViewController:navgationController_ Animated:YES];
}
- (void)openRefineSearchViewController:(id)sender{
    
    [self.view endEditing:YES];
    [_ssaView hideSSAViewFromSuperView];
    
    
    NGFilterViewController *filterSideMenuViewController = [[NGFilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    
    filterSideMenuViewController.filterDelegate = self;
    filterSideMenuViewController.clusterDict = self.clusterDict;
    
    [APPDELEGATE.container setRightMenuViewController:filterSideMenuViewController];
    
    filterSideMenuViewController.clusterDict = self.clusterDict;
    
    [filterSideMenuViewController.resultDict setDictionary:self.selectedClusterDict];
    [filterSideMenuViewController.paramsDict setDictionary:self.paramsDict];
    [filterSideMenuViewController updateFiltersList];
    [filterSideMenuViewController resetAll];

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
}
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
                [self.paramsDict setCustomObject:[NSNumber numberWithInteger:self.jobDownloadOffset] forKey:@"Offset"];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.paramsDict];
                [dict setCustomObject:@"ios" forKey:@"requestsource"];
                [self showAnimator];
                [self downloadJobsWithParams:dict];
                
            }else{
                isJobsLoading = NO;
                self.jobDownloadOffset-=[NGConfigUtility getJobDownloadLimit];
            }
        }
        
    }
}
-(void)gotoMenu:(id)sender{
    [self.view endEditing:YES];
    [_ssaView hideSSAViewFromSuperView];
    [super gotoMenu:nil];
}
- (void)receivedServerResponse:(NGAPIResponseModal*)responseData{
    if (responseData.isSuccess) {
        [self receivedSuccessFromServer:responseData];
    }else{
        [self receivedErrorFromServer:responseData];
    }
}
@end
