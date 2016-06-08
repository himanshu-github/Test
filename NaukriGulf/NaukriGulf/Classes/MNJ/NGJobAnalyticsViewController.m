//
//  NGJobAnalyticsViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 21/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJobAnalyticsViewController.h"
#import "NGAppliedJobDetailModel.h"
#import "NGRecommendedJobDetailModel.h"

#define TAB_SAVED_INDEX 1
#define TAB_RECOMMENDED_INDEX 2
#define TAB_APPLIED_INDEX 3
#define SHORTLISTED 11
#define UNSHORTLISTED 10

@interface NGJobAnalyticsViewController ()
{
    NSInteger totalSavedJobs;   // totalJobs available
    NSInteger totalJobsCount;   // totalJobs available
    int appliedJobsOffset;   // conatin the number till which the data is present
    BOOL isJobsLoading;      // BOOL for checking if job is present
    BOOL isRecommendedJobsLoded;  // BOOl for checking if recommended jobs are loaded
    BOOL isAppliedJobsLoaded;     // to check  if applied Jobs are Loaded
    
    NSInteger newRecommendedJobsCount;  // Denotes the number of new recommended jobs
}

/**
 *   a Muatble Array for storing the data of recommendedjobs
 */
@property (strong, nonatomic) NSMutableArray *recomendedJobsArr;
/**
 *   view appears if number of savedjobs are Zero
 */
@property (weak, nonatomic) IBOutlet UIView *noSavedJobsView;
/**
 *   view appears if number of Recommendedjobs are Zero
 */
@property (weak, nonatomic) IBOutlet UIView *noRecommendedJobsView;
/**
 *   view appears if number of AppliedJobs are Zero
 */
@property (weak, nonatomic) IBOutlet UIView *noAppliedJobsView;
/**
 *   Button used to navigate to NGSearchJobsViewController if no  jobs are applied
 */
@property (weak, nonatomic) IBOutlet UIButton *gotoSearchPageBtn;
//@property (weak, nonatomic) IBOutlet UIButton *gotoSearchPageBtnForAppliedJobs;

/**
 *  TableView for displaying the Applied Jobs
 */
@property (weak, nonatomic) IBOutlet UITableView *tableViewAppliedJobsView;
/**
 *  Table View for displaying the RecommendedJobs
 */
@property (weak, nonatomic) IBOutlet UITableView *tableViewRecommendedJobsView;
/**
 *  Table View for displaying The SavedJobs
 */
@property (weak, nonatomic) IBOutlet UITableView *tableViewSavedJobsView;

/**
 *  Custom Loader animates on service Request
 */
@property (strong, nonatomic) NGLoader* loader;

@end

@implementation NGJobAnalyticsViewController

#pragma mark - ViewController LifeCycle
- (void)viewDidLoad {

    [self setPageLoading];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _isAPIHitFromiWatch = NO;
    
    [self addNavigationBarWithBackBtnWithTitle:@"Jobs for You"];
    
    [self showOptionBar];
    
    appliedJobsOffset=0;
    self.appliedJobsArr = [[NSMutableArray alloc]init];
    isJobsLoading=FALSE;
    isRecommendedJobsLoded=FALSE;
    isAppliedJobsLoaded=FALSE;
    
    
    
    self.noAppliedJobsView.hidden=YES;
    self.noRecommendedJobsView.hidden=YES;
    self.noSavedJobsView.hidden=YES;

    
    NSDictionary *dict = [NGSavedData getBadgeInfo];
    newRecommendedJobsCount = [[dict objectForKey:KEY_BADGE_TYPE_JA]integerValue];
    
    if (newRecommendedJobsCount>0) {
        [[NGNotificationWebHandler sharedInstance] resetNotifications:KEY_BADGE_TYPE_JA];
    }
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
 }

-(void) viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    
        [self changeContentOnSelectionAtTabIndex:self.selectedTabIndex];
        if([NGSavedData getIfSimJobsExistsForTheJob])
        {
            
            [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"You have successfully applied to the job" animationTime:5 showAnimationDuration:0];
            
            [NGSavedData setIfSimJobsExistsForTheJob:FALSE];
            
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:KEY_DUPLICATE_APPLY])
        {
            
            
            [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"You have previously applied to this job" animationTime:5 showAnimationDuration:0];
            [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:KEY_DUPLICATE_APPLY];
            
        }
        [NGDecisionUtility checkNetworkStatus];
}

-(void)viewDidAppear:(BOOL)animated {
    
    if(self.isSwipePopDuringTransition)
        return;

    [NGHelper sharedInstance].appState = APP_STATE_MNJ_ANALYTICS;
    
    [super viewDidAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self hideAnimator];
    
    switch (self.selectedTabIndex) {
        
        case TAB_APPLIED_INDEX:
            [AppTracer clearLoadTime:TRACER_ID_APPLIED_JOBS];
            break;
        case TAB_RECOMMENDED_INDEX:
            [AppTracer clearLoadTime:TRACER_ID_RECOMMENDED_JOBS];
            break;
        case  TAB_SAVED_INDEX:
            [AppTracer clearLoadTime:TRACER_ID_SHORTLISTED_JOBS];
            break;
        
        default:
            break;
    }


    NSArray* serviceArr = @[[NSNumber numberWithInt:SERVICE_TYPE_APPLIED_JOBS],
                            [NSNumber numberWithInt:SERVICE_TYPE_RECOMMENDED_JOBS]];
    
    [[NGOperationQueueManager sharedManager] cancelOperation:serviceArr];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Memory Management

- (void)viewDidUnload {
    
    [self.recomendedJobsArr removeAllObjects];
    self.recomendedJobsArr=nil;
    [self.appliedJobsArr removeAllObjects];
    self.appliedJobsArr=nil;
    [self.savedJobsArr removeAllObjects];
    self.savedJobsArr=nil;
    
    [self setNoSavedJobsView:nil];
    [self setNoRecommendedJobsView:nil];
    [self setNoAppliedJobsView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
}

-(void) setPageLoading{
    
    switch (self.selectedTabIndex) {
        case TAB_APPLIED_INDEX:
            [AppTracer traceStartTime:TRACER_ID_APPLIED_JOBS];
            break;
        case TAB_RECOMMENDED_INDEX:
            [AppTracer traceStartTime:TRACER_ID_RECOMMENDED_JOBS];
            break;
        case  TAB_SAVED_INDEX:
            [AppTracer traceStartTime:TRACER_ID_SHORTLISTED_JOBS];
            break;
        default:
            break;
    }
}
#pragma mark - IBActions

- (IBAction)gotoSearchJobs:(id)sender {
    
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JOB_SEARCH usingNavigationController:((UINavigationController *)[NGAppDelegate appDelegate].container.centerViewController) animated:YES];
}

#pragma mark UITapgestureRecognizer methods

-(void)tabItemsTapped:(UITapGestureRecognizer *)tapR{
    self.selectedTabIndex = tapR.view.tag;
    [self changeContentOnSelectionAtTabIndex:self.selectedTabIndex];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.tableViewSavedJobsView)
    {
        
        totalSavedJobs=self.savedJobsArr.count;
        
        return self.savedJobsArr.count;
    }
    
    if (tableView==self.tableViewRecommendedJobsView)
    {
        return self.recomendedJobsArr.count;
    }
    
    else
    {
        return self.appliedJobsArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configureCellForJobTouple:tableView withIndexPath:indexPath];
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = [self cachedHeightForIndexPath:indexPath ofTable:tableView];
    // Not cached ?
    if (height <= 0)
        height = [self heightForIndexPath:indexPath ofTable:tableView];
    
    return height;

}

-(CGFloat)heightForIndexPath:(NSIndexPath*)indexPath ofTable:(UITableView*)tableView{
    CGFloat height = 0.0f;
    NGJobTupleCustomCell* cell= [self configureCellForJobTouple:tableView withIndexPath:indexPath];
    height = [UITableViewCell getCellHeight:cell];
    
    if (tableView==self.tableViewSavedJobsView){
        NGJobDetails *jobObj = [self.savedJobsArr fetchObjectAtIndex:indexPath.row];
        jobObj.cellHeight = height;
    }
    
    else if(tableView==self.tableViewRecommendedJobsView){
        NGJobDetails *jobObj = [self.recomendedJobsArr fetchObjectAtIndex:indexPath.row];
        jobObj.cellHeight = height;
    }
    else if(tableView==self.tableViewAppliedJobsView)
    {
        NGJobDetails *jobObj = [self.appliedJobsArr fetchObjectAtIndex:indexPath.row];
        jobObj.cellHeight = height;
    }
    return height;
}
-(CGFloat)cachedHeightForIndexPath:(NSIndexPath*)indexPath ofTable:(UITableView*)tableView{
    float height = 0.0f;
    if (tableView==self.tableViewSavedJobsView){
        NGJobDetails *jobObj = [self.savedJobsArr fetchObjectAtIndex:indexPath.row];
        height = jobObj.cellHeight;
    }
    
    else if(tableView==self.tableViewRecommendedJobsView){
        NGJobDetails *jobObj = [self.recomendedJobsArr fetchObjectAtIndex:indexPath.row];
        height = jobObj.cellHeight;
    }
    else if(tableView==self.tableViewAppliedJobsView)
    {
        NGJobDetails *jobObj = [self.appliedJobsArr fetchObjectAtIndex:indexPath.row];
        height = jobObj.cellHeight;
    }
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger jobIndex = indexPath.row;
    
    NGJDParentViewController *jdVC = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JDView"];

    if (tableView==self.tableViewSavedJobsView)
    {
        jdVC.allJobsArr = (NSMutableArray*)self.savedJobsArr;
        jdVC.totalJobsCount = [self.savedJobsArr count];
        jdVC.openJDLocation=JD_FROM_SAVED_OR_SHORTLISTED_JOBS_PAGE;

    }
    
    else if(tableView==self.tableViewRecommendedJobsView)
    {
        jdVC.allJobsArr = (NSMutableArray*)self.recomendedJobsArr;
        jdVC.totalJobsCount = [self.recomendedJobsArr count];
        jdVC.openJDLocation = JD_FROM_RECOMMENDED_JOBS_PAGE;//NGIA-554 story
        jdVC.xzMIS = @"2_0_41";//NGIA-554 story
    }
    else
    {
        jdVC.allJobsArr = (NSMutableArray*)self.appliedJobsArr;
        jdVC.totalJobsCount = [self.appliedJobsArr count];
        jdVC.openJDLocation=JD_FROM_SAVED_OR_SHORTLISTED_JOBS_PAGE;

    }
    
    jdVC.selectedIndex = jobIndex;
    [(IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController pushActionViewController:jdVC Animated:YES];
     
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark UIScrollview Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.selectedTabIndex==TAB_APPLIED_INDEX)
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
                appliedJobsOffset+=APPLIED_PAGINATION_LIMIT;
                
                NSInteger maxOffset = totalJobsCount;
                
                if (appliedJobsOffset<maxOffset)
                {
                    [self getAppliedJobs];
                    
                }
                else
                {
                    isJobsLoading = NO;
                    appliedJobsOffset-=APPLIED_PAGINATION_LIMIT;
                }
            }
        }
    }
}
-(void)setTotalJobsCountWithNum:(NSInteger)paramNum{
    totalJobsCount = paramNum;
}
-(void)setIsJobsLoadingWithFlag:(BOOL)paramFlag{
    isJobsLoading = paramFlag;
}
#pragma mark - Private Methods
/**
 *  @name Private Methods
 */
/**
 *    create request for applied jobs
 */
- (void)getAppliedJobs{
    
    
    self.noAppliedJobsView.hidden = YES;
    
    [self showAnimator];
    
    __weak NGJobAnalyticsViewController *weakVC = self;
    __block NSInteger weakTotalJobsCount = totalJobsCount;
    __block BOOL weakIsJobsLoading = isJobsLoading;
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_APPLIED_JOBS];
    
    [obj getDataWithParams:(NSMutableDictionary*)[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",[NSNumber numberWithInt:appliedJobsOffset],@"offset",[NSNumber numberWithInt:APPLIED_PAGINATION_LIMIT],@"limit", nil] handler:^(NGAPIResponseModal *responseData){
        
            if(responseData.isSuccess){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakVC hideAnimator];
                });
                
                
                NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
                NGAppliedJobDetailModel *objModel = [responseDataDict objectForKey:KEY_JOBS_INFO];
                
                
                weakTotalJobsCount=objModel.totoalJobsCount;
                
                NSArray *jobsArr = objModel.jobList;
                
                [weakVC.appliedJobsArr addObjectsFromArray:jobsArr];
                
                weakIsJobsLoading = NO;
                [self setDataOnSpotlight:TAB_APPLIED_INDEX];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakVC setTotalJobsCountWithNum:weakTotalJobsCount];
                    [weakVC setIsJobsLoadingWithFlag:weakIsJobsLoading];
                    [weakVC loadAllData];
                    [AppTracer traceEndTime:TRACER_ID_APPLIED_JOBS];

                });
                
            }else{
                
                isAppliedJobsLoaded = false;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                [weakVC hideAnimator];
               
                    if (!responseData.isNetworFailed) {
             
                        [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
                    }
                    else
                    {
                    [NGDecisionUtility checkNetworkStatus];
                        if(weakVC.appliedJobsArr.count>0)
                            _noAppliedJobsView.hidden = YES;
                        else
                            _noAppliedJobsView.hidden = NO;
 
                    UIImageView *midImgV = (UIImageView*)[_noAppliedJobsView viewWithTag:100];
                    UILabel *midTextLbl = (UILabel*)[_noAppliedJobsView viewWithTag:101];
                    if(!([NGHelper sharedInstance].isNetworkAvailable))
                    {
                        midImgV.image = [UIImage imageNamed:@"error_blue"];
                        midTextLbl.text = @"Network Error";
                    }
                    else
                    {
                        midImgV.image = [UIImage imageNamed:@"emptyalreadyapplied"];
                        midTextLbl.text = @"You have not applied to any Job";
                    }
                    }
                    [AppTracer traceEndTime:TRACER_ID_APPLIED_JOBS];

                });
            }
    }];
}
/**
 *   Provide the icons and title for optionBar
 */
- (void)showOptionBar{
    NSArray *iconArr = [NSArray arrayWithObjects:@"saved_gray",@"reco_gray",@"alreadyapplied", nil];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"Saved",@"Recommended",@"Applied", nil];
    
    for (NSInteger i = 0; i<3; i++) {
        [self createOptionWithIcon:[iconArr fetchObjectAtIndex:i] title:[titleArr fetchObjectAtIndex:i] frame:CGRectMake(0+SCREEN_WIDTH/3*i, 0, SCREEN_WIDTH/3, 70) inView:self.view tag:i+1];
    }
}
/**
 *  Method used for creating for displaying icons of Recommended Jobs, Saved Jobs , Applied Jobs
 *
 *  @param icon       icon description
 *  @param title      title description
 *  @param frame      frame description
 *  @param parentView parentView where added as subview
 *  @param tag        tag description
 */
- (void)createOptionWithIcon:(NSString *)icon title:(NSString *)title frame:(CGRect)frame inView:(UIView *)parentView tag:(NSInteger)tag{
    
    NSMutableDictionary* dictionaryForShadowView=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",@"View"],@"viewtype_key",
                                                  [NSValue valueWithCGRect:frame ],KEY_FRAME,
                                                  [NSNumber numberWithInteger:tag],KEY_TAG,
                                                  nil];
    
    NGView* shadowView=  (NGView*)[NGViewBuilder createView:dictionaryForShadowView];
    
    
    NSMutableDictionary* dictionaryForShadowStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_jean_dark.png"]],KEY_BACKGROUND_COLOR,
                                                   [UIColor clearColor],KEY_SHADOW_COLOR,
                                                   [NSNumber numberWithFloat:0.8 ],KEY_OPACITY,
                                                   [NSValue valueWithCGSize:CGSizeMake(2.2, 0.0)],kEY_SHADOW_OFFSET,
                                                   nil];
    
    [shadowView setViewStyle:dictionaryForShadowStyle];
    [parentView addSubview:shadowView];
    
    
    UIImageView *iconImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon]];
    iconImgView.frame = CGRectMake((frame.size.width-24)/2, 13, 24, 24);
    iconImgView.tag = 20+tag;
    [shadowView addSubview:iconImgView];
    
    NSMutableDictionary* dictionaryForTitleLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],@"viewtype_key",
                                                [NSNumber numberWithInt:10],KEY_TAG,
                                                [NSValue valueWithCGRect:CGRectMake(0, 40, SCREEN_WIDTH/3, 24)],KEY_FRAME,
                                                nil];
    
    NGLabel* titleLbl=(NGLabel*)   [NGViewBuilder createView:dictionaryForTitleLbl];
    
    NSMutableDictionary* dictionaryForTitleStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor clearColor],KEY_BACKGROUND_COLOR,
                                                  [NSString stringWithFormat:@"%@",title],KEY_LABEL_TEXT,
                                                  [NSNumber numberWithInteger:NSTextAlignmentCenter],kEY_LABEL_ALIGNMNET,
                                                  [UIColor whiteColor],KEY_TEXT_COLOR,
                                                  FONT_STYLE_HELVITCA_LIGHT,KEY_FONT_FAMILY,FONT_SIZE_13,KEY_FONT_SIZE,nil];
    
    [titleLbl setLabelStyle:dictionaryForTitleStyle];
    
    [shadowView addSubview:titleLbl];
    
    
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabItemsTapped:)];
    [shadowView addGestureRecognizer:tapR];
}
/**
 *  Triggers when the users tap on the view (Recommended Jobs, Saved Jobs, Applied Jobs) from the option bar.
 *
 *  @param tabIndex display the view according to the index
 */
- (void)changeContentOnSelectionAtTabIndex:(NSInteger)tabIndex{
    
    switch (tabIndex) {
        case TAB_SAVED_INDEX:{
            self.navigationItem.title = @"Shortlisted Jobs";
            
            [NGGoogleAnalytics sendScreenReport:K_GA_MNJ_SHORTLIST_SCREEN];
            
            self.tableViewSavedJobsView.hidden= YES;
            self.noSavedJobsView.hidden = YES;
            
            NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]getAllSavedJobs]];
            self.savedJobsArr = (NSMutableArray*)[[tempArr reverseObjectEnumerator] allObjects];
            
            [self loadShortlistedData];
            
            [self.tableViewSavedJobsView reloadData];
   
            [AppTracer traceEndTime:TRACER_ID_SHORTLISTED_JOBS];
            [self setDataOnSpotlight:TAB_SAVED_INDEX];

            break;
        }
        case TAB_RECOMMENDED_INDEX:
        {
            self.navigationItem.title = @"Recommended Jobs";
            [NGGoogleAnalytics sendScreenReport:K_GA_MNJ_RECOMMENDED_JOB_SCREEN];
            
            
            self.noSavedJobsView.hidden = YES;
            UIImageView *midImgV = (UIImageView*)[_noRecommendedJobsView viewWithTag:100];
            UILabel *midTextLbl = (UILabel*)[_noRecommendedJobsView viewWithTag:101];
            if(!([NGHelper sharedInstance].isNetworkAvailable)){
                midImgV.image = [UIImage imageNamed:@"error_blue"];
                midTextLbl.text = @"Network Error";
            }
            else{
                midImgV.image = [UIImage imageNamed:@"noreco"];
                midTextLbl.text = @"Today there are no Recommended jobs for you";
            }

            
            
            if(!isRecommendedJobsLoded)
            {
                self.recomendedJobsArr = [[NSMutableArray alloc]init];
                
                [self getRecommendedJobs];
                
                isRecommendedJobsLoded=TRUE;
            }
            else {
                [self loadRecommendedJobs];
            }
            
            break;
        }
        case TAB_APPLIED_INDEX:
        {
            self.navigationItem.title = @"Applied Jobs";
            [NGGoogleAnalytics sendScreenReport:K_GA_MNJ_APPLIED_JOB_SCREEN];
            
            self.tableViewAppliedJobsView.hidden =  YES;
            self.tableViewRecommendedJobsView.hidden =  YES;
            self.tableViewSavedJobsView.hidden= YES;
            self.gotoSearchPageBtn.hidden= YES;
            self.noSavedJobsView.hidden =  YES;
            self.noRecommendedJobsView.hidden =  YES;
            self.noAppliedJobsView.hidden =  YES;
            
            
            UIImageView *midImgV = (UIImageView*)[_noAppliedJobsView viewWithTag:100];
            UILabel *midTextLbl = (UILabel*)[_noAppliedJobsView viewWithTag:101];
            if(!([NGHelper sharedInstance].isNetworkAvailable))
            {
                midImgV.image = [UIImage imageNamed:@"error_blue"];
                midTextLbl.text = @"Network Error";
            }
            else
            {
                midImgV.image = [UIImage imageNamed:@"emptyalreadyapplied"];
                midTextLbl.text = @"You have not applied to any Job";
            }

            
            
            if(!isAppliedJobsLoaded)
            {
                [self.appliedJobsArr removeAllObjects];
                [self getAppliedJobs];
                isAppliedJobsLoaded=TRUE;
            }
            else
                [self loadAllData];
            
            
            
            break;
        }
            
        default:
            break;
    }
    
    
    
    NSArray *iconArr = [NSArray arrayWithObjects:@"saved_gray",@"reco_gray",@"alreadyapplied", nil];
    NSArray *selectedIconArr = [NSArray arrayWithObjects:@"saved_white",@"reco_white",@"alreadyapplied_white", nil];
    
    for (UIView *view in self.view.subviews) {
        if (view.tag>=1 && view.tag<=3) {
            NGLabel *lbl = (NGLabel*)[view viewWithTag:10];
            if (view.tag==tabIndex) {
                view.backgroundColor = Clr_Profile_Blue;
                lbl.textColor = [UIColor whiteColor];
                UIImageView *icon = [view viewWithTag:20+tabIndex];
                if([icon isKindOfClass:[UIImageView class]])
                    icon.image = [UIImage imageNamed:[selectedIconArr fetchObjectAtIndex:tabIndex-1]];
                
            }else{
                view.backgroundColor = Clr_Grey_SearchJob;
                lbl.textColor = [UIColor darkGrayColor];
                UIImageView *icon = [view viewWithTag:20+view.tag];
                if([icon isKindOfClass:[UIImageView class]])
                    icon.image = [UIImage imageNamed:[iconArr fetchObjectAtIndex:view.tag-1]];
            }
        }
    }

}

-(void)setDataOnSpotlight:(NSInteger)index{
    
    if (SYSTEM_VERSION_LESS_THAN(@"9.0"))
        return;
    switch (index) {
            
        case TAB_SAVED_INDEX :
            
            [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_SHORTLISTED_JOBS_AT_JOB_ANALYTICS withModel:_savedJobsArr]];

            break;
        case TAB_RECOMMENDED_INDEX :
            
            [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_RECOMMENDED_JOBS withModel:_recomendedJobsArr]];

            break;
        case TAB_APPLIED_INDEX :
            
            [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_APPLIED_JOBS withModel:_appliedJobsArr]];
            break;
    }

}

/**
 *  create the request for recommended jobs and send to the server
 */
- (void)getRecommendedJobs {
    
    [self showAnimator];
    NGStaticContentManager *jobMgrObj = [DataManagerFactory getStaticContentManager];
    NSArray *jobsArr = [jobMgrObj getAllRecommendedJobs];
    
    if (jobsArr.count > 0) {
        [self.recomendedJobsArr addObjectsFromArray:jobsArr];
        [self loadRecommendedJobs];
        [self.tableViewRecommendedJobsView reloadData];
        [self performSelector:@selector(hideAnimatorWithDelay) withObject:nil afterDelay:1.0];
    }
    
    
    __weak NGJobAnalyticsViewController *weakVC = self;
    
    
    [self myRecoJobs:^(NGAPIResponseModal *modal) {
        
        if(modal.isSuccess){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakVC hideAnimator];
                
            });
            
            [NGSavedData saveBadgeConsumedInfoWithType:KEY_BADGE_TYPE_JA isConsumed:TRUE];
            
            NSDictionary *responseDataDict = (NSDictionary *)modal.parsedResponseData;
            
            NGRecommendedJobDetailModel *objModel = [responseDataDict objectForKey:KEY_JOBS_INFO];
            NSArray *jobsArr = objModel.jobList;
            
            NGStaticContentManager *jobMgrObj = [DataManagerFactory getStaticContentManager];
            [weakVC.recomendedJobsArr removeAllObjects];
            [weakVC.recomendedJobsArr addObjectsFromArray:jobsArr];
            [jobMgrObj deleteAllRecommendedJobs];
            [jobMgrObj saveRecommendedJobs:jobsArr];
            [self setDataOnSpotlight:TAB_RECOMMENDED_INDEX];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakVC loadRecommendedJobs];
                [AppTracer traceEndTime:TRACER_ID_RECOMMENDED_JOBS];

            });
            
            
        }else{
            
            isRecommendedJobsLoded = false;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakVC hideAnimator];
                
                if (!modal.isNetworFailed) {
                    
                    [NGDecisionUtility checkForSessionExpire:modal.responseCode];
                }
                else
                {
                    
                    [NGDecisionUtility checkNetworkStatus];
                    UIImageView *midImgV = (UIImageView*)[_noRecommendedJobsView viewWithTag:100];
                    UILabel *midTextLbl = (UILabel*)[_noRecommendedJobsView viewWithTag:101];
                    if(!([NGHelper sharedInstance].isNetworkAvailable))
                    {
                        midImgV.image = [UIImage imageNamed:@"error_blue"];
                        midTextLbl.text = @"Network Error";
                    }
                    else
                    {
                        midImgV.image = [UIImage imageNamed:@"noreco"];
                        midTextLbl.text = @"Today there are no Recommended jobs for you";
                    }
                    
                }
                
                [weakVC loadRecommendedJobs];
                [AppTracer traceEndTime:TRACER_ID_RECOMMENDED_JOBS];

            });
        }
    }];
}

-(void) hideAnimatorWithDelay {
    
    [self hideAnimator];
}
/**
 *   Update the hidden state of all the  views with respect to the  appliedJobs count
 */
-(void)loadAllData{
    
    self.tableViewSavedJobsView.hidden=YES;
    
    if (self.appliedJobsArr.count==0)
    {
        self.noAppliedJobsView.hidden=NO;
        self.tableViewAppliedJobsView.hidden=YES;
        self.gotoSearchPageBtn.hidden=NO;
        
    }
    else
    {
        self.noAppliedJobsView.hidden=YES;
        self.tableViewAppliedJobsView.hidden=NO;
        self.gotoSearchPageBtn.hidden=YES;
        [self.tableViewAppliedJobsView reloadData];
        
    }
    
    self.tableViewRecommendedJobsView.hidden=YES;
    
    self.noSavedJobsView.hidden=YES;
    self.noRecommendedJobsView.hidden=YES;
}

/**
 *   Update the hidden state of all the  views with respect to the  recommendJobs count
 */
-(void)loadRecommendedJobs {
    
    self.tableViewSavedJobsView.hidden=YES;
    self.noSavedJobsView.hidden=YES;
    self.tableViewAppliedJobsView.hidden=YES;
    self.noAppliedJobsView.hidden=YES;
    
    if (self.recomendedJobsArr.count==0)
    {
        self.noRecommendedJobsView.hidden=NO;
        self.gotoSearchPageBtn.hidden=NO;
        self.tableViewRecommendedJobsView.hidden=YES;
    }
    else
    {
        self.tableViewRecommendedJobsView.hidden=NO;
        self.noRecommendedJobsView.hidden=YES;
        self.gotoSearchPageBtn.hidden=YES;
        [self.tableViewRecommendedJobsView reloadData];
    }
}
/**
 *   Update the hidden state of all the  views with respect to the  shortlisted count
 */
-(void)loadShortlistedData {
    
    if (self.savedJobsArr.count==0)
    {
        self.noSavedJobsView.hidden=NO;
        self.tableViewSavedJobsView.hidden=YES;
    }
    else
    {
        self.noSavedJobsView.hidden=YES;
        self.tableViewSavedJobsView.hidden=NO;
    }
    self.gotoSearchPageBtn.hidden=YES;
    self.tableViewRecommendedJobsView.hidden=YES;
    self.tableViewAppliedJobsView.hidden=YES;
    self.noRecommendedJobsView.hidden=YES;
    self.noAppliedJobsView.hidden=YES;
}
/**
 *  Pop / Remove the current controller from parent controller
 *
 *  @param sender pop controller using [NGAnimator sharedInstance]
 */
-(void)closeTapped:(id)sender{
   
}
/**
 *  Return customized NGSimJobToupleCell at specific IndexPath
 *
 *  @param  The index path locating the row in the receiver
 *
 *  @return An object representing a cell of the table or nil if the cell is not visible or indexPath is out of range.
 */

-(NGJobTupleCustomCell*)configureCellForJobTouple:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath {
    
    
    static NSString *cellIdentifier = @"NGJobTupleCustomCell";
    
    NGJobTupleCustomCell *cell = (NGJobTupleCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (NGJobTupleCustomCell *)[nib fetchObjectAtIndex:0];
    }
    
    cell.delegate = self;
    
    
    if (tableView==self.tableViewSavedJobsView){
        [cell displayData:[self.savedJobsArr fetchObjectAtIndex:indexPath.row] atIndex:indexPath.row];
    }
    
    else if(tableView==self.tableViewRecommendedJobsView){
        [cell displayData:[self.recomendedJobsArr fetchObjectAtIndex:indexPath.row] atIndex:indexPath.row];
        
        if (indexPath.row<newRecommendedJobsCount)
        {
            cell.contentView.backgroundColor=UIColorFromRGB(0xedfbff);
            
        }
    }
    
    
    else if(tableView==self.tableViewAppliedJobsView)
    {
        [cell displayData:[self.appliedJobsArr fetchObjectAtIndex:indexPath.row] atIndex:indexPath.row];
        cell.shortListBtn.hidden=YES;
        cell.appliedDate.hidden=NO;
    }
    
    return cell;
}

#pragma mark - NGSimJobToupleCell delegate
/**
 *  @name  NGSimJobToupleCell delegate
 */
/**
 *  a delegate used for removing the shortlisted jobs
 *
 *  @param sender   remove the cell from shortlisted tableView
 */

-(void)jobTupleCell:(NGJobTupleCustomCell *)jobTupleObj shortListTappedWithFlag:(BOOL)flag
{
    if(!flag)
    {
        if(self.selectedTabIndex == TAB_SAVED_INDEX)
        {
            
            NSIndexPath *removeIndexPath = [self.tableViewSavedJobsView indexPathForCell:jobTupleObj];
            
            NGJobDetails *jobObj = [self.savedJobsArr fetchObjectAtIndex:removeIndexPath.row];
            [self.savedJobsArr removeObjectAtIndex:removeIndexPath.row];
            [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:jobObj forStoring:NO];
            
            [self.tableViewSavedJobsView reloadData];
            [self loadShortlistedData];
        }
       
    }
    
}
-(void)synchSavedJobHavingIndex:(NSString*)jobId forStoring:(BOOL)store{
    
    NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]
                                                                    getAllRecommendedJobs]];
    NGJobDetails* myJob = nil;
    for (NGJobDetails* job in tempArr){
        
        if ([job.jobID isEqualToString:jobId]) {
            myJob = job;
            break;
        }
    }
    if (!myJob) {
        //Also check from Saved jobs
        NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]
                                                                        getAllSavedJobs]];
        tempArr = (NSMutableArray*)[[tempArr reverseObjectEnumerator] allObjects];
        for (NGJobDetails* job in tempArr){
            
            if ([job.jobID isEqualToString:jobId]) {
                myJob = job;
                break;
            }
        }
    }
    [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:myJob forStoring:store];
    [self changeContentOnSelectionAtTabIndex:TAB_SAVED_INDEX];
    
}


-(void)myRecoJobs:(void (^)(NGAPIResponseModal* modal))callback{
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_RECOMMENDED_JOBS];
    
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if(_isAPIHitFromiWatch)
        dataDict= [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",@"1", KEY_IS_API_HIT_FROM_WATCH, nil]];
    else
        dataDict= [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format", nil]];
    

    [obj getDataWithParams:dataDict handler:^(NGAPIResponseModal *responseData){
        callback(responseData);
        
    }];
}



@end
