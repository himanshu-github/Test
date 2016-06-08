//
//  NGMNJViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 18/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJViewController.h"
#import "NGJobAnalyticsViewController.h"
#import "NGWhoViewedMyCVViewController.h"
#import "NGSearchJobsViewController.h"
#import "NIDashboardCell.h"
#import "NGProfileInfoCell.h"
#import "NGProfileCompletionView.h"
#import "NGCriticalSectionCell.h"
#import "NGUpdateProfileCell.h"
#import "NGCriticalSectionHelper.h"
#import "NGRecommendedJobDetailModel.h"
#import "NGProfileViewController.h"
#import "NGUserDetails.h"


#define kSectionHeaderHeight 90
#define kdarkViewTag 9000 //make static
#define kProgressViewTag 9001

@interface NGMNJViewController () <UITableViewDataSource,UpdateProfileCellDelegate,UIGestureRecognizerDelegate,
UITableViewDelegate,NIDashboardCellDelegate>{
    
    NSString *profileLastUpdateDate;    // modified date of user's profile
    int expandedCellIndex;
    IBOutlet UIView *dashBoardView;
    __weak IBOutlet UITableView *mnjTableView;
    
    IBOutlet UIView* rightMenuView;
    IBOutlet UITableView* csTableView;
    NGProfileInfoCell* profileInfoCell;
    
    NSMutableArray *profileSectionsArr;
    int panDirection;
    NSInteger scrollToIndex;
    UIRefreshControl *refreshControl;
    BOOL bIsProfileSixMonthOld;
    
    __strong IBOutlet NSLayoutConstraint *csLeftConstraint;
    __block NSLayoutConstraint *animateConstraint;
    
    CGFloat offsetY;

    BOOL isPullingTable;
   
}


/**
 *  Maintains all the shortlisted jobs.
 */
@property (nonatomic,assign) NSInteger savedJobsCount;
@property (nonatomic,assign) NSInteger appliedJobsCount;
@property (nonatomic,assign) NSInteger totalRecoJobsCount;
@property (nonatomic,assign) NSInteger newRecoJobsCount;
@property (nonatomic,assign) NSInteger totalProfileViewCount;
@property(nonatomic, assign) NSInteger newProfileViewsCount;
@property (nonatomic,assign) BOOL isDefaultOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mnjTopPos;

@end

@implementation NGMNJViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self removeLoginScreen];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self addNavigationBarWithTitleAndHamBurger:@"My Naukri"];
    
    [self setNavtitleView:[self createViewForNavTitle]];
    
    [self expandCellAtIndex:DashBoardRowRecommendedJobs];
    
    [mnjTableView setBackgroundColor:[UIColor clearColor]];
    
    profileSectionsArr =[NSMutableArray array];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleRightPan:)];
	[recognizer setMaximumNumberOfTouches:1];
    [recognizer setDelegate:self];
    [rightMenuView addGestureRecognizer:recognizer];
    
    profileSectionsArr = [[NGCriticalSectionHelper sharedInstance] configureSectionsArr];

    [self getUserBasicDetails];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_USER_PHOTO object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUserPhoto:) name:NOTIFICATION_USER_PHOTO object:nil];
    
   
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_MNJ_NAV_TITLE_VIEW object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNavView) name:NOTIFICATION_MNJ_NAV_TITLE_VIEW object:nil];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [mnjTableView addSubview:refreshControl];

}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:rightMenuView];
    [self getAllParametersCount];
    [self getProfileIncompeleteSections];
    [csTableView reloadData];
   
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [NGHelper sharedInstance].appState = APP_STATE_MNJ;
    [NGGoogleAnalytics sendScreenReport:K_GA_MNJ_SCREEN];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_WITH_DOCUMENT_TYPE_HANDLER object:nil];
    
    [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_MNJ withModel:nil]];

}

#pragma mark - nav bar methods


-(void)getUserBasicDetails{
    
    NSDictionary *dict = [NGSavedData getUserDetails];
    NSString *name = [dict objectForKey:@"name"];
    NSString *currentDesignation = [dict objectForKey:@"currentDesignation"];
    NSString *photoURL = [NSString getProfilePhotoPath];
    NSString *modDate = [dict objectForKey:@"modifiedDate"];
    
    [NGHelper sharedInstance].usrObj = [[NGUserDetails alloc]init];
    [NGHelper sharedInstance].usrObj.name = name;
    [NGHelper sharedInstance].usrObj.designation = currentDesignation;
    [NGHelper sharedInstance].usrObj.photoURL = photoURL;
    [NGHelper sharedInstance].usrObj.lastModifiedDate = modDate;
}


-(UIView*) createViewForNavTitle {
    
    NSString *name = [[NGSavedData getUserDetails]objectForKey:@"name"];
    if(!name)
        name = K_NOT_MENTIONED;
    if(name.length > kSupportedNamelength){
        name = [NSString stringWithFormat:@"%@..",[name substringToIndex:KTrimNameLength]];
    }
   
    NSString *designation = [[NGSavedData getUserDetails]objectForKey:@"currentDesignation"];
    if(!designation)
        designation = K_NOT_MENTIONED;
    
    float fWidth = 220;
    if (IS_IPHONE6)
        fWidth += 20;
    else if(IS_IPHONE6_PLUS)
        fWidth += 35;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fWidth, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    titleLabel.numberOfLines=2;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:titleLabel];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    NSMutableAttributedString *string ;
    
    string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",name,designation]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,name.length)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(name.length,string.length-name.length)];
    
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                   range:NSMakeRange(0,name.length)];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]
                   range:NSMakeRange(name.length,string.length-name.length)];
    
    [titleLabel setAttributedText:string];
    
    [UIAutomationHelper setAccessibiltyLabel:@"name_designation_lbl" value:[NSString stringWithFormat:@"%@<automation_seperator>%@",name,designation] forUIElement:titleLabel];
    
    return view;
    
}

-(void) updateNavView {
    
    self.navigationItem.titleView = nil;
    [self setNavtitleView:[self createViewForNavTitle]];
    
}


-(void) setNavtitleView : (UIView*) view {
    
    self.navigationItem.titleView = view;
}

#pragma mark - refresh UI

- (void)handleRefresh:(UIRefreshControl*)sender
{
    [self fetchProfileIncompeleteSections];
}

-(void)refreshUserPhoto:(NSNotification *)notification{
    
    if(!profileInfoCell)
        profileInfoCell = (NGProfileInfoCell*)[csTableView dequeueReusableCellWithIdentifier:@"profileDetailsCell"];
    NGProfileCompletionView*customProgressView  = (NGProfileCompletionView*)[profileInfoCell.contentView viewWithTag:kProgressViewTag ];
    [customProgressView refreshPhoto];}


- (void)getProfileIncompeleteSections{
   
    NSDictionary *dict = [NGSavedData getMNJHomePageData];

    if (dict) {
    
        [self displayData:dict];
        [self fetchProfileIncompeleteSections];
    
    }else{

        [self fetchProfileIncompeleteSections];
    }
}

/**
 *  Fetches data like incomplete tabs, jobs count and profile count from the server.
 */
-(void)fetchProfileIncompeleteSections{
    
    __weak UIRefreshControl *weakRefreshControl = refreshControl;
    __weak NGMNJViewController *weakVc= self;
    __weak UITableView *weakMnjTableView = mnjTableView;
    __block int weakExpandedCellIndex = expandedCellIndex;
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_MNJ_INCOMPLETE_SECTION];
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseData){
        
        if(responseData.isSuccess){
            
            dispatch_async(dispatch_get_main_queue(), ^{
              
                [weakRefreshControl endRefreshing];
            });
            
            NSDictionary* responseDataDict = responseData.parsedResponseData;
            
            [NGSavedData saveMNJHomePageData:responseDataDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakVc displayData:responseDataDict];
                
                [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_JA withBadgeNumber:weakVc.newRecoJobsCount];
                
                [self setLeftHamBurgerCount];
               
                [weakMnjTableView reloadData];
                
                if(weakVc.newRecoJobsCount)
                    weakExpandedCellIndex = DashBoardRowRecommendedJobs;
                else  if(weakVc.newProfileViewsCount)
                    weakExpandedCellIndex = DashBoardRowPV;
                else
                    weakExpandedCellIndex = DashBoardRowRecommendedJobs;
                
                [weakVc expandCellAtIndex:expandedCellIndex];
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //issue: connection could not be established popup coming from here.
                [weakRefreshControl endRefreshing];
                if (!responseData.isNetworFailed) {
                   
                    [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
                }
                
            });
            
        }
        
        [AppTracer traceEndTime:TRACER_ID_MNJ_DASHBOARD];
     
    }];
}



-(void)displayData:(NSDictionary *)responseData{
    NSString *statusStr = [responseData objectForKey:KEY_MNJ_INCOMPLETE_SECTION_STATUS];
    if ([statusStr isEqualToString:@"success"]) {
        NSArray *arr = [responseData objectForKey:KEY_MNJ_INCOMPLETE_SECTION_DATA];
        [self updateProfileSectionsOrder:arr];

    }
    NSInteger count = [[responseData objectForKey:KEY_MNJ_VIEW_DETAIL_COUNT_DATA]integerValue];
    self.totalProfileViewCount = count;
    
    NSInteger appliedCount = [[responseData objectForKey:KEY_MNJ_APPLY_HISTORY_COUNT_DATA]integerValue];
    self.appliedJobsCount = appliedCount;
    
    
    statusStr = [responseData objectForKey:KEY_MNJ_RECOMMENDED_JOBS_COUNT_STATUS];
    if ([statusStr isEqualToString:@"success"]) {
        NSInteger count = [[responseData objectForKey:KEY_MNJ_RECOMMENDED_JOBS_COUNT_DATA]integerValue];
        self.totalRecoJobsCount = count;
        self.newRecoJobsCount = [[responseData objectForKey:KEY_MNJ_RECOMMENDED_NEW_JOBS_COUNT_DATA]integerValue];
    }else{
        self.totalRecoJobsCount = 0;
        self.newRecoJobsCount = 0;
    }
}




#pragma data for table view

-(void)getAllParametersCount{
    
    NSMutableArray *savedJobsArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]getAllSavedJobs]];
    
    self.savedJobsCount = savedJobsArr.count;
    
    [self updateAllCount];
    
}

-(void)updateAllCount{
    
    [self setLeftHamBurgerCount ];
    
    NSDictionary *dict = [NGSavedData getBadgeInfo];
    
    self.newProfileViewsCount = [[dict objectForKey:KEY_BADGE_TYPE_PV]integerValue];
    
    NSArray *localRecommendedJobsArr = [[DataManagerFactory getStaticContentManager] getAllRecommendedJobs];
    
    self.totalRecoJobsCount = localRecommendedJobsArr.count;
   
}


#pragma mark - table view methods


#pragma mark - Tableview delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == csTableView) {
  
        if (bIsProfileSixMonthOld)
            return profileSectionsArr.count +1;
        else
            return profileSectionsArr.count;
        
    }else{
        
        return CellTypePV+1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return (tableView == csTableView)?kSectionHeaderHeight:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == mnjTableView){
        
        float expandedCellHeight = 0;
        float searchCellHeight = 0;
        float unexpandedCellHeight = 0;

        if(IS_IPHONE4)
        {
            expandedCellHeight = 163;
            searchCellHeight = 65;
            unexpandedCellHeight = 63;
            
        }
        else if (IS_IPHONE5)
        {
            expandedCellHeight = 172;
            searchCellHeight = 83;
            unexpandedCellHeight = 84;
            
        }
        else if (IS_IPHONE6)
        {
            expandedCellHeight = 243;
            searchCellHeight = 90;
            unexpandedCellHeight = 90;

        }
        else if (IS_IPHONE6_PLUS)
        {
            expandedCellHeight = 282;
            searchCellHeight = 90;
            unexpandedCellHeight = 100;
        
        }
        
        if(indexPath.row == expandedCellIndex)
            return expandedCellHeight;
        
        float cellHeight;
        switch (indexPath.row) {
                
            case DashBoardRowSearch:
                cellHeight = searchCellHeight;
                break;
                
            case CellTypeRecommendedJobs:
            case CellTypeAppliedJobs:
            case CellTypeSavedJobs:
            case CellTypePV:
                cellHeight = unexpandedCellHeight;
                break;
                
            default: cellHeight = (IS_IPHONE5?102:84);
                break;
        }

        
        
        
        
        
        
//        if(indexPath.row == expandedCellIndex)
//            return IS_IPHONE5?172:163;
//        
//        float cellHeight;
//        switch (indexPath.row) {
//                
//            case DashBoardRowSearch:
//                cellHeight = IS_IPHONE5?83:65;
//                break;
//                
//            case CellTypeRecommendedJobs:
//            case CellTypeAppliedJobs:
//            case CellTypeSavedJobs:
//            case CellTypePV:
//                cellHeight = (IS_IPHONE5?84:63);
//                break;
//                
//            default: cellHeight = (IS_IPHONE5?102:84);
//                break;
//        }
        
        return cellHeight;
        
    }else if (tableView == csTableView){
        
        if(tableView == csTableView){
            
            if (bIsProfileSixMonthOld && indexPath.row == 0)
                return 145;
            else
                return 66;
        }

        
    }
    return 0;
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(tableView == mnjTableView) {
        
        return nil;
    }
    else if (tableView == csTableView) {
        
        
        UIView* viewToReturn = nil;
        viewToReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, csTableView.frame.size.width, kSectionHeaderHeight)];
        viewToReturn.clipsToBounds= YES;
        if(!profileInfoCell)
            profileInfoCell = (NGProfileInfoCell*)[csTableView dequeueReusableCellWithIdentifier:@"profileDetailsCell"];
        
        [self configureProfileDetailsCell:profileInfoCell];
        [profileInfoCell configureCell];
        [viewToReturn addSubview:profileInfoCell];
        [viewToReturn setBackgroundColor:[UIColor clearColor]];
        
        [profileInfoCell.showHideDataLabel setHidden:FALSE];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, viewToReturn.frame.size.height-1, viewToReturn.frame.size.width, 1)];
        line.backgroundColor = [csTableView separatorColor];
        [viewToReturn addSubview:line];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openRightSectionBar)];
        [viewToReturn addGestureRecognizer:tapGesture];
        
        return viewToReturn;
        
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(tableView == mnjTableView) {
        
        NSInteger displayCount;
        switch (indexPath.row)
        {
            case DashBoardRowSearch:
            {
                UITableViewCell* cell = [mnjTableView dequeueReusableCellWithIdentifier:@"searchCell"];
                [UIAutomationHelper setAccessibiltyLabel:@"search_cell" forUIElement:cell withAccessibilityEnabled:NO];
                
                return cell;
            }
                
            case DashBoardRowRecommendedJobs:
                displayCount = self.totalRecoJobsCount;
                break;
            case DashBoardRowSavedJobs:
                displayCount = self.savedJobsCount;
                break;
            case DashBoardRowAppliedJobs:
                displayCount = self.appliedJobsCount;
                break;
            case DashBoardRowPV:
                displayCount = self.totalProfileViewCount;
                break;
            default:
                displayCount =0;
                break;
        }
        
        NIDashboardCell* cell = [mnjTableView dequeueReusableCellWithIdentifier:@"dashboardCell"];
        cell.displayCount = displayCount;
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
        cell.delegate = self;
        if(indexPath.row == expandedCellIndex){
            cell.isExpanded = YES;
        }
        else{
            
            cell.isExpanded = NO;
            
        }
        cell.tileCount = (indexPath.row == DashBoardRowRecommendedJobs)?self.newRecoJobsCount:self.newProfileViewsCount;
        
        [cell configureCellWithType:indexPath.row];
        return cell;
        
    }
    
    if(tableView == csTableView){
        
        if (bIsProfileSixMonthOld) {
            
                if (indexPath.row == 0) {
                    
                    NGUpdateProfileCell* cell = [csTableView dequeueReusableCellWithIdentifier:@"profileUpdateCell"];
                    cell.delegate = self;
                    [UIAutomationHelper setAccessibiltyLabel:@"profileUpdateCell" forUIElement:cell withAccessibilityEnabled:NO];
                    return cell;
                    
                }else{
                    
                    NGCriticalSectionCell* cell = (NGCriticalSectionCell*)[csTableView dequeueReusableCellWithIdentifier:@"criticalSectionCell"];
                    [cell configureCell:[profileSectionsArr fetchObjectAtIndex:indexPath.row]];
                    return cell;
                }
                
            }
        
        else {
        
            NGCriticalSectionCell* cell = (NGCriticalSectionCell*)[csTableView dequeueReusableCellWithIdentifier:@"criticalSectionCell"];
        
            [cell configureCell:[profileSectionsArr fetchObjectAtIndex:indexPath.row]];
        
            return cell;
        }
    }
    return nil;
}
-(void) openRightSectionBar{
    
    if(![self isRightMenuOpen])
    {
        [self pullOver];
        return;
    }else[self goToMenuWithoutIndex:nil];

}

-(void) goToMenuWithoutIndex:(UITapGestureRecognizer*) tap {
    
    scrollToIndex = 0;
    [self goToMenu:tap];
}

-(void)goToMenu:(UITapGestureRecognizer*)tap
{
    [[NGAppStateHandler sharedInstance]setDelegate:self];
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE usingNavigationController:self.navigationController animated:YES];
}

#pragma mark - Other Private Methods


-(void)changeCellState:(CellType)type isExpanded:(BOOL)isExpanded{
    if(isExpanded)
        [self expandCellAtIndex:type];
}

-(void)expandCellAtIndex:(int)index
{
    expandedCellIndex = index;
    
    [mnjTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:expandedCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    for (int i= 1; i<=DashBoardRowPV; i++)
    {
        if(i!=expandedCellIndex)
        {
            NIDashboardCell* cell  = ( NIDashboardCell*)[mnjTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.isExpanded = NO;
            [cell configureCellWithType:i];
        }
        
    }
    mnjTableView.backgroundColor = [UIColor clearColor];
}


#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [NGSavedData setProfileStatusForCheck:@"false"];
    
    IENavigationController *navVC = (IENavigationController *)APPDELEGATE.container.centerViewController;
    
    if(tableView == mnjTableView) {
    
    switch (indexPath.row)
    {
        case DashBoardRowSearch:{
            NGSearchJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JobSearch"];
            [navgationController_ setComingVia:K_GA_MNJ_SCREEN];
            [navVC  pushActionViewController:navgationController_ Animated:YES ];
        }
            break;
        case DashBoardRowRecommendedJobs:
        {
            
            NGJobAnalyticsViewController *vc = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"JobAnalyticsView"];
            
            vc.selectedTabIndex = RECOMMENDED_JOBS;
            
            [navVC  pushActionViewController:vc Animated:YES ];
            
        }
            break;
        case DashBoardRowSavedJobs:
        {
            
            
            NGJobAnalyticsViewController *vc = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"JobAnalyticsView"];
            
            vc.selectedTabIndex = SAVED_JOBS;
            
            [navVC  pushActionViewController:vc Animated:YES ];
            
        }
            break;
            
        case DashBoardRowAppliedJobs:
        {
            NGJobAnalyticsViewController *vc = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"JobAnalyticsView"];
            
            vc.selectedTabIndex = APPLIED_JOBS;
            
            [navVC  pushActionViewController:vc Animated:YES ];
        }
            
            break;
        case DashBoardRowPV:
            {
                NGWhoViewedMyCVViewController *whoViewedMyCV = [[NGHelper sharedInstance].mNJStoryboard instantiateViewControllerWithIdentifier:@"WhoViewedMyCV"];
                
                [navVC  pushActionViewController:whoViewedMyCV Animated:YES ];
            }
            break;
        default:
            break;
        }
            
    }else if(tableView == csTableView){
        
            if(![self isRightMenuOpen])
            {
                [self pullOver];
                return;
            }
            
            [NGSavedData setProfileStatusForCheck:@"false"];
        
            NGProfileSectionModalClass* sectionTapped = nil;
            if (bIsProfileSixMonthOld)
                sectionTapped   = [profileSectionsArr fetchObjectAtIndex:indexPath.row-1];
            else
                sectionTapped   = [profileSectionsArr fetchObjectAtIndex:indexPath.row];
            
            scrollToIndex = 0;
            if(sectionTapped == nil)
                scrollToIndex = 0;
            else{
                scrollToIndex = sectionTapped.profileSectionType;
                [[NGAppStateHandler sharedInstance]setDelegate:self];
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE usingNavigationController:self.navigationController animated:YES];
              
            }
            if(scrollToIndex != 0)
            {
                [self goToMenu:nil];
            }
            return;
        
    }
}


-(void) setPropertiesOfVC:(id)vc{
   
    if([vc isKindOfClass:[NGProfileViewController class]])
    {
        NGProfileViewController* viewC = (NGProfileViewController*)vc;
        viewC.showBackButton = YES;
        viewC.scrollToIndex = scrollToIndex;
        
    }
    
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
    
}

#pragma mark - critical section methods

-(void)configureProfileDetailsCell:(UITableViewCell*)cell{
    
    NGProfileCompletionView *customProgressView  = (NGProfileCompletionView*)[cell.contentView viewWithTag:kProgressViewTag ];
    if(!customProgressView){
        customProgressView = [[NGProfileCompletionView alloc] initWithOriginPoint:CGPointMake(0, 0)];
        customProgressView.delegate = self;
        customProgressView.tag = kProgressViewTag;
        [cell.contentView addSubview:customProgressView];
    }
    else
    {
        [customProgressView refreshPhoto];
    }
}



-(void)updateProfileSectionsOrder: (NSArray *) arr{
   
    profileSectionsArr = [[NGCriticalSectionHelper sharedInstance] orderProfileSectionArray:arr];
   
    [csTableView reloadData];

}


#pragma mark - UI Animations

-(void)pullOver{
    
    UIView* bgView = [[UIView alloc] init];
    bgView.backgroundColor=[UIColor blackColor];
    bgView.alpha = 0.6;
    bgView.frame = mnjTableView.frame;
    bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    bgView.tag = kdarkViewTag;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(restoreToNormal:)];
    
    [bgView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:bgView];
    
    [self.view bringSubviewToFront:rightMenuView];
    [profileInfoCell.showHideDataLabel setHidden:TRUE];

  
    float delta =  rightMenuView.frame.origin.x < [self rightViewOriginXOpenState]?0:25;
    
    [UIView animateWithDuration:0.175 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        animateConstraint = (NSLayoutConstraint*)[NSLayoutConstraint constraintWithItem:rightMenuView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:45];
        
 
        [self.view removeConstraint:csLeftConstraint];
        [self.view addConstraint:animateConstraint];
        
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL completed)
     {
         [UIView animateWithDuration:0.150 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
             
             animateConstraint.constant = animateConstraint.constant+delta;
             [self.view layoutIfNeeded];
            
         }
                          completion:^(BOOL completed)
          {
          }];
     }];
    
    
}
-(void)restoreToNormal:(UITapGestureRecognizer*)tap{
    
    [profileInfoCell.showHideDataLabel setHidden:FALSE];
    
    [NGSavedData setProfileStatusForCheck:@"false"];
     bIsProfileSixMonthOld = NO;
    [UIView animateWithDuration:0.175 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
       
        [self.view viewWithTag:kdarkViewTag].alpha = 0.1;
        
        [self.view removeConstraint:animateConstraint];
       
        [self.view addConstraint:csLeftConstraint];
        
        [self.view layoutIfNeeded];
        
    }
                     completion:^(BOOL completed)
     {
         [csTableView reloadData];
         
         [csTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
         
         [[self.view viewWithTag:kdarkViewTag]removeFromSuperview];
         
     }];
}
-(float)rightViewOriginXOpenState{
    return self.view.frame.size.width-mnjTableView.frame.size.width;
}
-(float)rightViewOriginXClosedState{
    return mnjTableView.frame.size.width;
}

-(BOOL)isRightMenuOpen{
    if([self.view viewWithTag:kdarkViewTag])
        return YES;
    return NO;
}
#pragma mark - Gesture Recognizers

- (void) handleRightPan:(UIPanGestureRecognizer *)recognizer {
    
    UIView* view = recognizer.view;
    
    
    CGPoint translatedPoint = [recognizer translationInView:view];
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        panDirection = 0;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:self.view];

        [profileInfoCell.showHideDataLabel setHidden:TRUE];
        
        if(fabs(translation.x) > fabs(translation.y))
        {
            
            CGPoint imageViewPosition = recognizer.view.center;
            imageViewPosition.x += translation.x;
            
            float newOrigin = imageViewPosition.x - (rightMenuView.frame.size.width / 2.0);
            if(translation.x>0)
            {
                if(newOrigin >= [self rightViewOriginXClosedState])
                    return;
                else
                {
                    
                    float alpha = [self.view viewWithTag:kdarkViewTag].alpha;
                    alpha -= 0.00355;
                    [self.view viewWithTag:kdarkViewTag].alpha = alpha;
                    
                    
                }
            }
            else
            {
                if(newOrigin <= 0)
                    return;
            }
            recognizer.view.center = imageViewPosition;
            [recognizer setTranslation:CGPointZero inView:self.view];
            panDirection = translation.x<=0?1:2;
            
            
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        if(translatedPoint.x <= 0 && ![self isRightMenuOpen] && panDirection == 1){
            [self pullOver];
     
     
    }
        else
            [self restoreToNormal:nil];
    }
    
    
}

-(void)onUpdateProfile{
    
    [self goToMenu:nil];
}

-(void) viewDidUnload{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_USER_PHOTO object:nil];
    
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self restoreToNormal:nil];
  
     expandedCellIndex = CellTypeRecommendedJobs;
    
    [self expandCellAtIndex:expandedCellIndex];
    
    [self hideAnimator];
    
    NSArray* serviceArr = @[[NSNumber numberWithInt:SERVICE_TYPE_MNJ_INCOMPLETE_SECTION],
];
    
    [[NGOperationQueueManager sharedManager] cancelOperation:serviceArr];

    
}

#pragma mark - Scroll View Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == csTableView)
        return;
    offsetY = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == csTableView)
        return;
    if (scrollView.contentOffset.y > offsetY)
    {
        [scrollView setScrollEnabled:NO];
        [scrollView setContentOffset:CGPointZero animated:NO];
    }
    [scrollView setScrollEnabled:YES];
}

-(void) removeLoginScreen {
    
    [NGUIUtility removeAllViewControllerInstanceFromVCStackOfTypeName:@"NGLoginViewController"];
}
@end

