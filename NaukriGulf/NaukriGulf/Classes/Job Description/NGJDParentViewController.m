//
//  NGJDParentViewController.m
//  NaukriGulf
//
//  Created by Minni Arora on 11/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCustomScrollView.h"
#import "NGJDParentViewController.h"
#import "NGJobAnalyticsViewController.h"
#import "NGViewMoreSimJobsViewController.h"

@interface NGJDParentViewController ()
{
    NSDate *searchStartTime;
    NSDate *searchEndTime;
    NGLoader* loader;
    NSMutableArray *jdViewsArray;
}

@property (weak, nonatomic) IBOutlet NGCustomScrollView *tableScrollView;

@end

@implementation NGJDParentViewController

#pragma mark -
#pragma mark UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetup];
}

- (void)initSetup{
    searchStartTime = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"ApplyUnsuccessfullMsg"];
    
    jdViewsArray = [[NSMutableArray alloc] init];
    [self setArrayWithNullValue:jdViewsArray FromIndex:0 toIndex:_allJobsArr.count];
    [self addNavigationBarWithBackBtnWithTitle:@"Job Details"];
    
    
    self.tableScrollView.delegate = self;
    [self.tableScrollView setShowsHorizontalScrollIndicator:NO];
    
    //congigurable width
    self.tableScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*[_allJobsArr count], SCREEN_HEIGHT - JD_SCROLLVIEWCONTENT_OFFSET);
    
    //self.tableScrollView.backgroundColor = [UIColor blueColor];
    self.tableScrollView.pagingEnabled = YES;
    [self.tableScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.selectedIndex, 0) animated:NO];
    self.tableScrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    
    NGJobDetails *jobObj = [_allJobsArr fetchObjectAtIndex:_selectedIndex];
    
    if (!jobObj.isAlreadyRead)
    {
        jobObj.isAlreadyRead = YES;
        [NGSavedData saveReadJobWithID:jobObj.jobID];
    }
    
    self.pagesArr = [[NSMutableArray alloc]init];
    [self setArrayWithNullValue:self.pagesArr FromIndex:0 toIndex:_allJobsArr.count];
    [NGAppDelegate appDelegate].container.leftMenuPanEnabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    dispatch_async(dispatch_get_main_queue(), ^{
        NGJobDetails *jobObj = [_allJobsArr fetchObjectAtIndex:_selectedIndex];
        [self sendMISWithJobID:jobObj.jobID];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        [self createChildTableViewsWithIndex:self.selectedIndex];
        [NGDecisionUtility checkNetworkStatus];
    });

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([loader isLoaderAvail]) {
        [loader hideAnimatior:self.view];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [NGHelper sharedInstance].appState = APP_STATE_JD;
    
   for (NSInteger i = self.selectedIndex - JD_DOWNLOAD_OFFSET; i <= self.selectedIndex + JD_DOWNLOAD_OFFSET; i++) {
        if (i >= JD_MIN_BOUND && i < _allJobsArr.count && i!=self.selectedIndex) {
            [self createChildTableViewsWithIndex:i];
        }
    }
    
}




#pragma mark -
#pragma mark handling Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private methods

-(void)setArrayWithNullValue:(NSMutableArray *)array FromIndex:(NSInteger)from toIndex:(NSInteger)limit {
    
    for (NSInteger i = from ; i < limit ; i++) {
        
        if(array){
            
            [array addObject:[NSNull null]];
        }
    }
}


- (void) applyClicked:(NGJobDetails*)jobDetailObj {
    
    
    
    NGJobsHandlerObject *obj =  [[NGJobsHandlerObject alloc]init];
    obj.jobObj =  jobDetailObj;
    
    obj.jobObj.xzMIS = self.xzMIS;//required to make it dynamic in nature, via coming from diff viewcontrollers
    
    obj.openJDLocation =  self.openJDLocation;
    obj.Controller =  self;
    obj.viewLoadingStartTime =  [NSDate date];
    
    [[NGApplyJobHandler sharedManager] jobHandlerWithJobDescriptionPageApply:obj];
}


- (void) shareClicked:(NGJobDetails*)jobDetailObj {
     NGJobDetails *jobObj = [_allJobsArr objectAtIndex:self.selectedIndex];
    [NGUIUtility showShareActionSheetWithText:@"" url:jobObj.jdURL image:nil inViewController:self];
}
/**
 *  Send JobDescription information to MIS.
 *
 *  @param jobID the JobID.
 */

-(void)sendMISWithJobID:(NSString *)jobID {
   
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:jobID,@"jobId", nil];
    [params setCustomObject:@"ios" forKey:@"requestsource"];
  
    if (self.openJDLocation == JD_FROM_SRP_PAGE) {
        [params setCustomObject:self.xzMIS forKey:@"xz"];
        [params setCustomObject:self.srchIDMIS forKey:@"srchId"];
    }
    NGWebDataManager *objNew = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_MIS_JD];
    [objNew getDataWithParams:params handler:^(NGAPIResponseModal *responseData) {}];
}

/**
 *  Unloading earlier laoded page(s) when user is navigating to next and previous pages.
 
 *
 *  @param pageNumber PageIndex
 */

-(void)unLoadPage:(NSInteger)pageNumber {
   
    @try {
            NSInteger pageIndex;
            NSInteger limit = [jdViewsArray count];
            for ( pageIndex = 0; pageIndex < limit; pageIndex++){
                
                if (pageIndex == self.selectedIndex-1  ){
                    
                    continue ;
                    
                }
                else if (pageIndex == self.selectedIndex ){
                    
                    continue;
                }
                else if (pageIndex == self.selectedIndex+1 ){
                    
                    continue;
                }
                else{
                    
                    if([NSNull null] != [jdViewsArray fetchObjectAtIndex:pageIndex]){

                        NGJDViewController * tempJD = [jdViewsArray fetchObjectAtIndex:pageIndex];
                        if(tempJD)
                        [tempJD releaseMemory];
                        [tempJD removeFromParentViewController];
                        [tempJD.view removeFromSuperview];
                        tempJD =  nil;
                        [jdViewsArray replaceObjectAtIndex:pageIndex withObject:[NSNull null]];
                        [self.pagesArr replaceObjectAtIndex:pageIndex withObject:[NSNull null]];

                    }
                }
            }
    }
    @catch (NSException *exception) {
        
        [NGGoogleAnalytics sendExceptionWithDescription:@"Exception -- unload page in JD" withIsFatal:NO];
    }
    @finally {
        
    }
}


-(void)closeTapped:(id)sender {
    [self removeExistingJDviews];
 
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jdCloseTapped" object:self userInfo:[NSDictionary dictionaryWithObject:[NSArray arrayWithArray:_allJobsArr] forKey:@"alljobsarr"]];
    
}

-(void) createChildTableViewsWithIndex: (NSInteger) selectedIndex{
    
    BOOL isJobAlreadyCreated = [self.pagesArr containsObject:[NSNumber numberWithInteger:selectedIndex]];
    
    if (!isJobAlreadyCreated) {
        NGJDViewController *navgationController_ = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JDView2"];
        NGJobDetails *obj = (NGJobDetails *)[_allJobsArr fetchObjectAtIndex:selectedIndex];
        navgationController_.jobID = obj.jobID;
        navgationController_.simJobDelegate = self;
        navgationController_.srpJobObj = obj;
        navgationController_.openJDLocation = self.openJDLocation;
        navgationController_.viewCtrller=self;
        navgationController_.xzMIS = self.xzMIS;
        navgationController_.srchIDMIS = self.srchIDMIS;
        navgationController_.selectedIndex = self.selectedIndex;
        navgationController_.view.frame = CGRectMake(SCREEN_WIDTH*selectedIndex, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 );
        navgationController_.jdTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 );
        
        
        [self.tableScrollView addSubview:navgationController_.view];
        [self addChildViewController:navgationController_];
       

        if([self.pagesArr count] > selectedIndex){
            
            
            if([NSNull null] != [jdViewsArray fetchObjectAtIndex:selectedIndex]){
                NGJDViewController * tempJD = [jdViewsArray fetchObjectAtIndex:selectedIndex];
                if(tempJD)
                [tempJD releaseMemory];
                [tempJD removeFromParentViewController];
                [tempJD.view removeFromSuperview];
                tempJD =  nil;
            }
            [self.pagesArr replaceObjectAtIndex:selectedIndex withObject:[NSNumber numberWithInteger:selectedIndex]];
            [jdViewsArray replaceObjectAtIndex:selectedIndex withObject:navgationController_];
        }
    }
}

-(void)removeExistingJDviews{
    
    [jdViewsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([NSNull null]!= obj){
            NGJDViewController * tempJD = (NGJDViewController *)obj;
            
            if(tempJD)
            [tempJD releaseMemory];
            [tempJD removeFromParentViewController];
            [tempJD.view removeFromSuperview];
            tempJD =  nil;
            
            
        }
    }];
}
-(void)changeTitleTo:(NSString*)title{
    
    self.title = title;

}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger pageNum = (int)self.tableScrollView.contentOffset.x/SCREEN_WIDTH;
    
    NGJobDetails *jobObj = [_allJobsArr fetchObjectAtIndex:pageNum];
    
    
    if (!jobObj.isAlreadyRead) {
        jobObj.isAlreadyRead = YES;
        [NGSavedData saveReadJobWithID:jobObj.jobID];
    }
    
    [self sendMISWithJobID:jobObj.jobID];
    
    if (self.selectedIndex < pageNum) {
        [self rightSwipePerformed:pageNum];
    }
    else if (self.selectedIndex > pageNum){
        
        [self leftSwipePerformed:pageNum];
    }
}

#pragma mark Swipe Helper Functions

/**
 *  Loads right/next JD if available.
 *
 *  @param pageNum PageIndex.
 */

-(void) rightSwipePerformed: (NSInteger) pageNum{
    
    self.selectedIndex = pageNum;
    
    if (pageNum == ([_allJobsArr count] - 1)) {
        if (pageNum < self.totalJobsCount-1){
            
            self.jobDownloadOffset+=[NGConfigUtility  getJobDownloadLimit];
            NSInteger maxOffset = self.totalJobsCount;
            
            if (self.jobDownloadOffset<maxOffset) {
                [self.paramsDict setCustomObject:[NSNumber numberWithInteger:self.jobDownloadOffset] forKey:@"Offset"];
                
                loader = [[NGLoader alloc] initWithFrame:self.view.frame];
                [loader showAnimation:self.view];
                [self downloadJobsWithParams:self.paramsDict];
                
            }
            else{
                self.jobDownloadOffset-=[NGConfigUtility getJobDownloadLimit];
            }
        }
        else{
            
            [self createChildTableViewsWithIndex:self.selectedIndex];
        }
    }
    else{
        NSInteger pageIndex = self.selectedIndex;
        if(self.selectedIndex > 0 )
            pageIndex = self.selectedIndex - JD_DOWNLOAD_OFFSET;
        for (NSInteger i = pageIndex ; i<= self.selectedIndex + JD_DOWNLOAD_OFFSET; i++) {
             [self createChildTableViewsWithIndex:i];
        }
    }
    [self unLoadPage:pageNum];
    
    
    //for change in title
    [self setNavTitle];

    
}

/**
 *  Loads left/previous JD if available.
 *
 *  @param pageNum PageIndex
 */

-(void) leftSwipePerformed: (NSInteger) pageNum{
    self.selectedIndex = pageNum;
    NSInteger pageIndex = self.selectedIndex;
    if(self.selectedIndex < [_allJobsArr count]-1 ){
        pageIndex = self.selectedIndex + JD_DOWNLOAD_OFFSET;
    }
    
    for (NSInteger i = pageIndex; i >= self.selectedIndex - JD_DOWNLOAD_OFFSET; i--) {
        
        if (i >= JD_MIN_BOUND) {
            
            [self createChildTableViewsWithIndex:i];
        }
    }
    if(pageNum >= 0){
        
        [self unLoadPage:pageNum];
    }
    //for change in title
    [self setNavTitle];
    
}
-(void)setNavTitle{

    NGJDViewController *jdView = (NGJDViewController*)[jdViewsArray objectAtIndex:self.selectedIndex];
    UITableView *jdTable =jdView.jdTableView;
    
    NSArray* visiblecell = [jdTable visibleCells];
    BOOL isSimJobVisible = NO;
    
    for (UITableViewCell *cell in visiblecell) {
        
        NSIndexPath *index = [jdTable indexPathForCell:cell];
        if(index.section == 1&&jdView.simJobs.count>0)
        {
            isSimJobVisible = YES;
            break;
        }
        else{
        
        }
        
    }
    if(isSimJobVisible)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [jdView.simJobDelegate changeTitleTo:K_SIM_JOB_NAV_TITLE];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [jdView.simJobDelegate changeTitleTo:K_JOB_DETAIL_NAV_TITLE];
        });
    
    }
}

#pragma mark JobManager Delegate
- (void)receivedServerResponse:(NGAPIResponseModal*)responseData{
    if (responseData.isSuccess) {
        [self receivedSuccessFromServer:responseData];
    }else{
        [self receivedErrorFromServer:responseData];
    }
}

-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData {

    dispatch_async(dispatch_get_main_queue(), ^{
        [loader hideAnimatior:self.view];
    });
    
    searchEndTime = [NSDate date];
    NSTimeInterval timeDifference = [searchEndTime timeIntervalSinceDate:self.viewLoadingStartTime];
    [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"Job Description View Loading Time" withTimngLabel:@"Failure"];
}

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData {
    searchEndTime = [NSDate date];
    NSTimeInterval timeDifference = [searchEndTime timeIntervalSinceDate:self.viewLoadingStartTime];
    
    switch (responseData.serviceType)
    {
        case SERVICE_TYPE_ALL_JOBS:
        {
            NGJobDetailModel *objModel = [responseData.parsedResponseData objectForKey:KEY_JOBS_INFO];
            
            NSArray *jobsArr = objModel.jobList;
            
            [self setArrayWithNullValue:self.pagesArr FromIndex:_allJobsArr.count toIndex:_allJobsArr.count+jobsArr.count];
            [self setArrayWithNullValue:jdViewsArray FromIndex:_allJobsArr.count toIndex:_allJobsArr.count+jobsArr.count];
            
            [_allJobsArr addObjectsFromArray:jobsArr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createChildTableViewsWithIndex:self.selectedIndex];
                self.tableScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*[_allJobsArr count], SCREEN_HEIGHT - JD_SCROLLVIEWCONTENT_OFFSET);

                [self unLoadPage:self.selectedIndex];
            });
            
            break;
        }
        default:
            break;
    }
    
    [loader hideAnimatior:self.view];
    [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"Job Description View Loading Time" withTimngLabel:@"Success"];
}

#pragma mark UITouchEvents Delegate

-(void)animatorWillDisappearScreen:(BOOL)flag
{    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ApplyUnsuccessfullMsg"])
    {
         [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Apply Unsuccessful. Your application for this job could not be completed because you have not provided the additional information requested by the Employer" animationTime:8 showAnimationDuration:0.5];
        
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"ApplyUnsuccessfullMsg"];
    }
}
-(IBAction)backButtonClicked:(id)sender{
    
    NSArray* serviceArr = @[[NSNumber numberWithInt:SERVICE_TYPE_ALL_JOBS]];
    [[NGOperationQueueManager sharedManager] cancelOperation:serviceArr];
    
    [self removeExistingJDviews];
    
    {
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
    
    
}

@end
