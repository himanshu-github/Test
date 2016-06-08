//
//  NGWhoViewedMyCVViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 30/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//
#import "NGWhoViewedMyCVViewController.h"
#import "NGWhoViewedToupleCell.h"
#import "NGWhoViewedStatusCell.h"


@interface NGWhoViewedMyCVViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger countForNewProfileViews;
    float totalCellHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString* date;
@property (nonatomic,strong) NSMutableArray* profileViews;
@property (weak, nonatomic) IBOutlet UIView *noProfileViewsView;
@property (strong, nonatomic) NGLoader* loader;

@end
@implementation NGWhoViewedMyCVViewController
#pragma mark - View Controller Cycle
- (void)viewDidLoad
{
    _isAPIHitFromiWatch = NO;
    [AppTracer traceStartTime:TRACER_ID_WHO_VIEWED_MY_CV];
    [super viewDidLoad];
    totalCellHeight = 0.0;
    self.noProfileViewsView.hidden=YES;
    self.tableView.hidden=YES;
    [self addNavigationBarWithBackBtnWithTitle:@"Who viewed your CV"];
    self.profileViews=[[NSMutableArray alloc]init];
    
    NSDictionary *dict = [NGSavedData getBadgeInfo];
    countForNewProfileViews = [[dict objectForKey:KEY_BADGE_TYPE_PV]integerValue];
    [[NGNotificationWebHandler sharedInstance] resetNotifications:KEY_BADGE_TYPE_PV];
    [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_PV withBadgeNumber:0];
    self.profileViews= (NSMutableArray*)[[DataManagerFactory getStaticContentManager] getAllProfileViews];
    self.profileViews=(NSMutableArray*)[[self.profileViews reverseObjectEnumerator]allObjects];
    [self getProfileViews];
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [NGHelper sharedInstance].appState = APP_STATE_PROFILE_VIEWER;
    [super viewDidAppear:animated];
    [NGGoogleAnalytics sendScreenReport:K_GA_MNJ_CV];
    [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_CV_VIEW withModel:_profileViews]];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.loader isLoaderAvail]) {
        [self.loader hideAnimatior:self.view];
    }
    [AppTracer clearLoadTime:TRACER_ID_WHO_VIEWED_MY_CV];
}
#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.profileViews=nil;
    self.networkView=nil;
    self.noProfileViewsView=nil;
    self.tableView=nil;
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section > 0){
        if (self.profileViews.count>0)
        {
            self.noProfileViewsView.hidden=YES;
            self.tableView.hidden=NO;
        }
        return self.profileViews.count;
    }
    else
    {
        return self.profileViews.count?1:0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   return [self configureCell:indexPath];
    
}
-(UITableViewCell*)configureCell:(NSIndexPath*)indexPath{

    if(indexPath.row < self.profileViews.count )
    {
        if(indexPath.section == 0){
            static NSString *cellIdentifier = @"WhoViewedStatusCell";
            NGWhoViewedStatusCell *statusCell = (NGWhoViewedStatusCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (statusCell == nil)
                statusCell = [[NGWhoViewedStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            [statusCell configureCell:self.profileViews.count];
            return statusCell;
        }
        else
        {
            static NSString *cellIdentifier = @"WhoViewedTouple";
            NGWhoViewedToupleCell* cell = (NGWhoViewedToupleCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                cell = [[NGWhoViewedToupleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:cellIdentifier];
            }
            [cell configureCell:[self.profileViews fetchObjectAtIndex:indexPath.row]];
            if (self.date.length>0)
            {
                if (indexPath.row<countForNewProfileViews)
                {
                    cell.contentView.backgroundColor=UIColorFromRGB(0xedfbff);
                }
            }
            
            if (indexPath.row==self.profileViews.count-1)
            {
                if(self.view.frame.size.height - 50> totalCellHeight){
                    CGRect tempRect =  self.tableView.frame;
                    tempRect.size.height=totalCellHeight;
                    self.tableView.frame=tempRect;
                }
            }
            return  cell;
        }
    }
    else{
        return nil;
    }
}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        totalCellHeight += 50;
        return 50.0;
    }
    else {
        float height = [UITableViewCell getCellHeight:[self configureCell:indexPath]];
        totalCellHeight += height;
        return height;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==1)
        return [[UIView alloc]init];
    return nil;
}
#pragma mark - Private Method
/**
 *  @name Private Method
 */


/**
 *  generate the request of WHO_VIEWED_MY_CV  and send it to server
 */
-(void)getProfileViews
{
    self.loader = [[NGLoader alloc] initWithFrame:self.view.frame];
    [self.loader showAnimation:self.view];
    __weak NGWhoViewedMyCVViewController *weakVC = self;
    
    [self getCVViews:^(NGAPIResponseModal *responseData) {
        if (responseData.isSuccess) {
            [weakVC receivedSuccessFromServer:responseData];
        }
        else{
            [weakVC receivedErrorFromServer:responseData];
        }
    }];
   
}
-(void)getCVViews:(void (^)(NGAPIResponseModal* modal))callback{
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_WHO_VIEWED_MY_CV];
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];

    if(_isAPIHitFromiWatch)
        params= [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"1", KEY_IS_API_HIT_FROM_WATCH, nil]];

    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        callback(responseData);
    }];
}
/**
 *  this method  pop the current controller from parent Controller
 *
 *  @param sender NGButton
 */
-(void)closeTapped:(id)sender
{
    //[[NGAnimator sharedInstance]popViewControllerAnimated:YES];
}
#pragma mark - Server Responses
- (void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData {
    [NGSavedData saveBadgeConsumedInfoWithType:KEY_BADGE_TYPE_PV isConsumed:TRUE];
    NSMutableDictionary *responseDict = responseData.parsedResponseData;
    NSArray* arrayFromHttpResponse = nil;
    if ([responseDict objectForKey:@"ViewsDetail"] == [NSNull null]) {
        //empty case
    }else  {
        arrayFromHttpResponse= [NSArray arrayWithArray:[responseDict objectForKey:@"ViewsDetail"]];
        NGStaticContentManager *jobMgrObj = [DataManagerFactory getStaticContentManager];
        [jobMgrObj deleteAllProfileViews];
        [jobMgrObj saveProfileViews:arrayFromHttpResponse];
        [self.profileViews removeAllObjects];
        [self.profileViews addObjectsFromArray:arrayFromHttpResponse];
        
        self.date=[responseDict objectForKey:@"CurrentViewDate"];
        [NGSavedData saveViewedDateForProfile:self.date];
        totalCellHeight=0;
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect tempFrame = self.tableView.frame;
            tempFrame.size.height = self.view.frame.size.height - 44;
            self.tableView.frame = tempFrame;
            [self.tableView reloadData];
        });
        if (self.profileViews.count==0) {
            self.tableView.hidden = YES;
            self.noProfileViewsView.hidden=NO;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loader hideAnimatior:self.view];
        [AppTracer traceEndTime:TRACER_ID_WHO_VIEWED_MY_CV];
    });
}


- (void)receivedErrorFromServer:(NGAPIResponseModal *)responseData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!responseData.isNetworFailed) {
            [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
        }
        [self.loader hideAnimatior:self.view];
        [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
        [self.loader hideAnimatior:self.view];
        [AppTracer traceEndTime:TRACER_ID_WHO_VIEWED_MY_CV];
    });
}

@end

