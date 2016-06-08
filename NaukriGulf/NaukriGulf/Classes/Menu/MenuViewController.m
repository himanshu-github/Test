
#import "MenuViewController.h"
#import "NGCustomCell.h"
#import "NGShortlistedJobsViewController.h"
#import "NGFeedbackViewController.h"
#import "NGJobAnalyticsViewController.h"
#import "NGResmanLoginDetailsViewController.h"

@interface MenuViewController()
{
    NSDictionary* pushCountDict;    /// Contains the information related to push notification count.
    UITapGestureRecognizer *tapGesture; /// For recording tap event on visit desktop site label.
    NGLoader* loader;   /// to display data is fetched from the server.
    
    NSMutableArray* menuListArray;  /// List of all the menu items to be displayed.
    int jobAnalyticsViewTabIndex;
}

@property (weak, nonatomic) IBOutlet UILabel *visitDesktopSiteLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightReservedLabel;

@end

@implementation MenuViewController

#pragma mark ViewController Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTable.separatorColor=UIColorFromRGB(0X202020);
    
    [self updateMenu];
    NSString *yearString = [NGDateManager stringFromDate:[NSDate date] WithDateFormat:@"yyyy"];
    
    NSString *copyRightstr = [NSString stringWithFormat:@"All rights reserved © %@ Info Edge (India) Ltd",yearString];;
    self.rightReservedLabel.text = copyRightstr;
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_USER_PHOTO object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_UPDATE_MENU_ITEMS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUserPhoto:) name:NOTIFICATION_USER_PHOTO object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMenuListItems:) name:NOTIFICATION_UPDATE_MENU_ITEMS object:nil];
    self.menuTable.tableFooterView = [[UIView alloc] init];
    NSString *appVersionString = [@"Version " stringByAppendingString:[NSString getAppVersion]];
    
    self.visitDesktopSiteLabel.text = appVersionString;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([loader isLoaderAvail]) {
        [loader hideAnimatior:self.view];
    }
}

#pragma mark Memory Management

- (void)dealloc
{
    [self releaseMemory];
}

-(void)releaseMemory{
    self.view.backgroundColor =     nil;
    self.menuTable.backgroundColor =    nil;
    self.menuTable.separatorColor = nil;
    [_visitDesktopSiteLabel removeGestureRecognizer:tapGesture];
    self.menuTable.delegate = nil;
    self.menuTable.dataSource = nil;
    self.menuTable  =   nil;
    self.visitDesktopSiteLabel  =   nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_USER_PHOTO object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_UPDATE_MENU_ITEMS object:nil];
}

#pragma mark Notification Methods

/**
 *  Refresh the user's profile photo when new photo is downloaded.
 *
 *  @param notification The NSNotification object.
 */
-(void)refreshUserPhoto:(NSNotification *)notification{
    if ([NGHelper sharedInstance].isUserLoggedIn) {
        [self updateMenu];
    }
}

/**
 *  Refresh the menu items when user loggedin or logout from the app.
 *
 *  @param notf The NSNotification object.
 */

-(void)refreshMenuListItems:(NSNotification*)notification
{
    if ([NGHelper sharedInstance].isUserLoggedIn)
    {
        [self updateMenu];
    }
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    pushCountDict=[NGSavedData getBadgeInfo];
    
    return [menuListArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if((![NGHelper sharedInstance].isUserLoggedIn && indexPath.row == 0)){
        
        static NSString *cellIdentifier = @"ProfileHeaderNotLogged";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            //            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:225/255.0 green:223/255.0 blue:224/255.0 alpha:1]];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 35, 200, 35)];
            [cell.contentView addSubview:imgView];
            [imgView setImage:[UIImage imageNamed:@"naukrigulf"]];
        }
        return cell;
    }
    
    
    
    if ([NGHelper sharedInstance].isUserLoggedIn && indexPath.row == 0)
    {
        static NSString *cellIdentifier = @"ProfileHeader";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        
        NSInteger profileUpdateViewCount=[[pushCountDict valueForKey:KEY_BADGE_TYPE_PU] integerValue];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            UIView *v = [[UIView alloc] init] ;
            v.backgroundColor = UIColorFromRGB(0x0071bc);
            cell.selectedBackgroundView = v;
            
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:64/255.0 green:63/255.0 blue:63/255.0 alpha:1]];
            
            NSMutableDictionary* dictProfileImg=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_IMAGEVIEW],KEY_VIEW_TYPE,
                                                 [NSValue valueWithCGRect:CGRectMake(15,30.0,60,60) ],KEY_FRAME,
                                                 [NSNumber numberWithInt:10],KEY_TAG,
                                                 nil];
            
            NGImageView *profileImg=  (NGImageView*)[NGViewBuilder createView:dictProfileImg];
            [cell.contentView addSubview:profileImg];
            
            NSMutableDictionary* dictionaryForTitleLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                        [NSNumber numberWithInt:0],KEY_TAG,
                                                        [NSValue valueWithCGRect:CGRectMake(84, 40, 170, 20)],KEY_FRAME,
                                                        [NSNumber numberWithInt:20],KEY_TAG,
                                                        nil];
            
            NGLabel* titleLbl= (NGLabel*)[NGViewBuilder createView:dictionaryForTitleLbl];
            
            NSMutableDictionary* dictionaryForTitleStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor clearColor],KEY_BACKGROUND_COLOR,
                                                          [NSString stringWithFormat:@"%@",@"name"],KEY_LABEL_TEXT,
                                                          [NSNumber numberWithInteger:NSTextAlignmentLeft],kEY_LABEL_ALIGNMNET,
                                                          [UIColor whiteColor],KEY_TEXT_COLOR,
                                                          FONT_STYLE_HELVITCA_NEUE,KEY_FONT_FAMILY,FONT_SIZE_16,KEY_FONT_SIZE,nil];
            
            [titleLbl setLabelStyle:dictionaryForTitleStyle];
            [cell.contentView addSubview:titleLbl];
            
            NSMutableDictionary* dictionaryForDesignLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                         [NSNumber numberWithInt:0],KEY_TAG,
                                                         [NSValue valueWithCGRect:CGRectMake(84, 60, 170, 35)],KEY_FRAME,
                                                         [NSNumber numberWithInt:30],KEY_TAG,
                                                         nil];
            
            NGLabel* designLbl=(NGLabel*)   [NGViewBuilder createView:dictionaryForDesignLbl];
            
            NSMutableDictionary* dictionaryForDesignStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor clearColor],KEY_BACKGROUND_COLOR,
                                                           [NSString stringWithFormat:@"%@",@"designation"],KEY_LABEL_TEXT,
                                                           [NSNumber numberWithInteger:NSTextAlignmentLeft],kEY_LABEL_ALIGNMNET,
                                                           [UIColor whiteColor],KEY_TEXT_COLOR,
                                                           FONT_STYLE_HELVITCA_NEUE_LIGHT,KEY_FONT_FAMILY,@"13.0",KEY_FONT_SIZE,nil];
            
            [designLbl setLabelStyle:dictionaryForDesignStyle];
            designLbl.numberOfLines = 2;
            [cell.contentView addSubview:designLbl];
            
            
            /* Update Profile Button Added    */
            UIButton *updateBtn =  [UIButton buttonWithType:UIButtonTypeCustom];      [UIAutomationHelper setAccessibiltyLabel:@"updatePtofile_btn" forUIElement:updateBtn];
            [updateBtn  addTarget:self action:@selector(updateProfileButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [updateBtn setFrame:(CGRect){ SCREEN_WIDTH - 70, 63, 55, 20}];
            updateBtn.layer.borderWidth = 5.0;
            [updateBtn setBackgroundColor:[UIColor clearColor]];
            updateBtn.layer.borderWidth = .5;
            updateBtn.layer.borderColor=[[UIColor whiteColor] CGColor];
            [updateBtn setTitleColor:[UIColor colorWithRed:167/255.0 green:165/255.0 blue:166/255.0 alpha:1] forState:UIControlStateNormal];
            [updateBtn setTitle:@"Update" forState:UIControlStateNormal];
            updateBtn.titleLabel.font = [UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:13.0];
            [cell.contentView addSubview:updateBtn];
            //Label for Push
            
            NSMutableDictionary* dictionaryForCountLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                        [NSValue valueWithCGRect:CGRectMake(262, 38, 24, 20)],KEY_FRAME,
                                                        [NSNumber numberWithInt:200],KEY_TAG,
                                                        nil];
            
            NGLabel* countLbl=(NGLabel*)   [NGViewBuilder createView:dictionaryForCountLbl];
            countLbl.layer.cornerRadius = 9.0;
            countLbl.layer.masksToBounds = YES;
            
            NSMutableDictionary* dictionaryForCountLblStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor redColor],KEY_BACKGROUND_COLOR,[NSNumber numberWithInt:1],KEY_LABEL_NO_OF_LINES,
                                                             [NSNumber numberWithInteger:NSTextAlignmentCenter],kEY_LABEL_ALIGNMNET,
                                                             [NSString stringWithFormat:@"%ld",(long)profileUpdateViewCount],KEY_LABEL_TEXT,
                                                             [UIColor blackColor],KEY_TEXT_COLOR,
                                                             FONT_STYLE_HELVITCA_NEUE_LIGHT,KEY_FONT_FAMILY,FONT_SIZE_16,KEY_FONT_SIZE,nil];
            
            [countLbl setLabelStyle:dictionaryForCountLblStyle];
            [cell.contentView addSubview:countLbl];
            
            if (profileUpdateViewCount==0)
            {
                countLbl.hidden = YES;
            }
            else
                countLbl.hidden=NO;
            
            
        }
        
        NSDictionary *dict = [NGSavedData getUserDetails];
        NSString *imageURL = [NSString getProfilePhotoPath];
        
        NGImageView *profileImg = (NGImageView *)[cell.contentView viewWithTag:10];
        [profileImg setImageWithLocalURL:imageURL];
        
        [profileImg cropImageCircularWithBorderWidth:5 borderColor:[UIColor whiteColor]];
        
        NGLabel *name = (NGLabel *)[cell.contentView viewWithTag:20];
        name.text = [dict objectForKey:@"name"];
        
        if(name.text.length >= kSupportedNamelength){
            
            name.text = [NSString stringWithFormat:@"%@..",[name.text substringToIndex:KTrimNameLength]];
        }
        
        NGLabel *designation = (NGLabel *)[cell.contentView viewWithTag:30];
        designation.text = [dict objectForKey:@"currentDesignation"];
        
        
        NGLabel *count = (NGLabel *)[cell.contentView viewWithTag:200];
        count.text = [NSString stringWithFormat:@"%ld",(long)profileUpdateViewCount];
        if (profileUpdateViewCount==0)
        {
            count.hidden = YES;
        }
        else
            count.hidden=NO;
        cell.backgroundColor = [UIColor clearColor];
        [UIAutomationHelper setAccessibiltyLabel:@"name_lbl" value:name.text forUIElement:name];
        [UIAutomationHelper setAccessibiltyLabel:@"designation_lbl" value:designation.text forUIElement:designation];
        return cell;
    }
    
    NGMenuCustomCell *cell = [self configureCellForIndexPath:indexPath];
    
    [self updateNotificationCount:indexPath withCell:cell];
    
    return cell;
    
    
}

-(void)updateNotificationCount:(NSIndexPath *)indexPath withCell:(NGMenuCustomCell *)cell{
    
    //// Product updates
    
    if (([NGHelper sharedInstance].isUserLoggedIn && indexPath.row==8)||(![NGHelper sharedInstance].isUserLoggedIn && indexPath.row==6)){
        NSInteger count = [[pushCountDict valueForKey:KEY_BADGE_TYPE_PROD] integerValue];
        //count = 7;
        if (count==0) {
            cell.menuCountLbl.hidden = YES;
        }
        else{
            cell.menuCountLbl.hidden = NO;
            cell.menuCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
        }
    }
    
    //// recommended jobs
    
    if ([NGHelper sharedInstance].isUserLoggedIn && indexPath.row==5){
        NSInteger count = [[pushCountDict valueForKey:KEY_BADGE_TYPE_JA] integerValue];
        if (count==0) {
            cell.menuCountLbl.hidden = YES;
        }
        else{
            cell.menuCountLbl.hidden = NO;
            cell.menuCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
        }
    }
    
    //// who viewed my cv
    
    if ([NGHelper sharedInstance].isUserLoggedIn && indexPath.row==3){
        NSInteger count = [[pushCountDict valueForKey:KEY_BADGE_TYPE_PV] integerValue];
        if (count==0) {
            cell.menuCountLbl.hidden = YES;
        }
        else{
            cell.menuCountLbl.hidden = NO;
            cell.menuCountLbl.text = [NSString stringWithFormat:@"%ld",(long)count];
        }
    }
    [UIAutomationHelper setAccessibiltyLabel:@"profileUpdateViewCount_lbl" value:cell.menuCountLbl.text forUIElement:cell.menuCountLbl];
    
}


-(NGMenuCustomCell *)configureCellForIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MenuCustumcell";
    
    NGMenuCustomCell *cell = [self.menuTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (NGMenuCustomCell *)[nib fetchObjectAtIndex:0];
        
        UIView *v = [[UIView alloc] init] ;
        v.backgroundColor = UIColorFromRGB(0x0071bc);
        cell.selectedBackgroundView = v;
    }
    
    cell.menuTitle.text = [[menuListArray fetchObjectAtIndex:indexPath.row] valueForKey:@"MenuLabel"];
    [cell.menuTitle sizeToFit];
    
    cell.menuImg.image = [UIImage imageNamed:[[menuListArray fetchObjectAtIndex:indexPath.row] valueForKey:@"MenuIcon"]];
    cell.menuCountLbl.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.menuCountLbl.layer.cornerRadius = 7;
    cell.menuCountLbl.layer.masksToBounds = YES;
    [UIAutomationHelper setAccessibiltyLabel:@"name_lbl" value:cell.menuTitle.text forUIElement:cell.menuTitle];
    [UIAutomationHelper setAccessibiltyLabel:@"menuCount_lbl" value:cell.menuCountLbl.text forUIElement:cell.menuCountLbl];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([NGHelper sharedInstance].isUserLoggedIn && indexPath.row == 0){
        
        [self.menuTable deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        NGDeepLinkingHelper *deeplinkingHelper = [NGDeepLinkingHelper sharedInstance];
        if (deeplinkingHelper.deeplinkingPage == NGDeeplinkingPageProfile) {
            [deeplinkingHelper setDeeplinkingPage:NGDeeplinkingPageNone];
        }
    }
    
    NSInteger index = indexPath.row;
    
    if(![NGHelper sharedInstance].isUserLoggedIn && indexPath.row == 0){
        
        index = 3;
    }
    
    [self handleAllMenuButtonActionsOnLoggedInAtIndex:index];
    
    
    [self performSelector:@selector(scrollTotop) withObject:nil afterDelay:1.0];
}

-(void) scrollTotop {
    
    [self.menuTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 105;
    }
    
    return 50;
    
    
}

#pragma mark Private Methods

/**
 *  Perform action when menu item is tapped in case of loggedin user.
 *
 *  @param index Denotes the index of menu item which is tapped.
 */
-(void)handleAllMenuButtonActionsOnLoggedInAtIndex:(NSInteger)index{
    
    NGAppDelegate* delegate=[NGAppDelegate appDelegate];
    __weak NGAppDelegate* delegateWeak = delegate;
    __weak MenuViewController *selfWeak = self;
    
    NSInteger actionIdentifier = [[[menuListArray fetchObjectAtIndex:index] objectForKey:@"MenuAction"] integerValue];
    
    switch (actionIdentifier) {
            
        case K_NAUKRI_PROFILE:{
            
            if ([[NGHelper sharedInstance] isUserLoggedIn]) {
                
                [delegate.container toggleLeftSideMenuCompletion:^{
                    
                    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE usingNavigationController:delegateWeak.container.centerViewController animated:YES];
                    
                }];
                
            }
            break;
        }
            
        case K_NAUKRI_HOME_HAMBURGER_ID: {
            
            [delegate.container toggleLeftSideMenuCompletion:^{
                
                
                [NGAppStateHandler sharedInstance].delegate = selfWeak;
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ usingNavigationController:delegateWeak.container.centerViewController animated:YES];
                
                
            }];
            
            break;
        }
            
        case K_SEARCH_JOBS_HAMBURGER_ID: {
            [delegate.container toggleLeftSideMenuCompletion:^{

                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JOB_SEARCH usingNavigationController:delegateWeak.container.centerViewController animated:YES];
            }];
            
            break;
            
        }
            
        case K_WHO_VIEWED_MY_CV_HAMBURGER_ID:{
            [delegate.container toggleLeftSideMenuCompletion:^{
                
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE_VIEWER usingNavigationController:delegateWeak.container.centerViewController animated:YES];
            }];
            
            
            break;
        }
            
        case K_SHORTLISTED_JOBS_HAMBURGER_ID:{
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_SHORT_LISTED_JOB withEventLabel:K_GA_EVENT_SHORT_LISTED_JOB withEventValue:nil];
            
            [delegate.container toggleLeftSideMenuCompletion:^{
                
                if ([NGHelper sharedInstance].isUserLoggedIn) {
                    jobAnalyticsViewTabIndex = 1;
                    [[NGAppStateHandler sharedInstance]setDelegate:selfWeak];
                    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ_ANALYTICS usingNavigationController:((IENavigationController*)delegateWeak.container.centerViewController) animated:YES];
                }else{
                    NGShortlistedJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"ShortlistedJobsView"];
                    
                    [((IENavigationController*)delegateWeak.container.centerViewController) pushActionViewController:navgationController_ Animated:YES];
                }
                
                
            }];
            
            break;
        }
            
        case K_RECOMMENDED_JOBS_HAMBURGER_ID:{
            
            [delegate.container toggleLeftSideMenuCompletion:^{
                jobAnalyticsViewTabIndex = 2;
                [[NGAppStateHandler sharedInstance]setDelegate:selfWeak];
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ_ANALYTICS usingNavigationController:((IENavigationController*)delegateWeak.container.centerViewController) animated:YES];
                
            }];
            break;
        }
            
        case K_APPLY_HISTORY_HAMBURGER_ID:{
            
            [delegate.container toggleLeftSideMenuCompletion:^{
                jobAnalyticsViewTabIndex = 3;
                [[NGAppStateHandler sharedInstance]setDelegate:selfWeak];
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ_ANALYTICS usingNavigationController:((IENavigationController*)delegateWeak.container.centerViewController) animated:YES];
                
                
            }];
            
            
            break;
        }
            
        case K_CAREER_CAFE_HAMBURGER_ID:{
            
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_WATS_NEW withEventLabel:K_GA_EVENT_CAREER_CAFE withEventValue:nil];
            [delegate.container toggleLeftSideMenuCompletion:^{
                
                NGWebViewController *webView = (NGWebViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"webView"];
                webView.isCloseBtnHidden = NO;
                [webView setNavigationTitle:@"Career Cafe" withUrl:CAREER_CARE_URL];
                
                IENavigationController *cntrllr = delegateWeak.container.centerViewController;
                [cntrllr pushActionViewController:webView Animated:YES];
                
            }];
            
            
            break;
        }
            
        case K_WHATS_NEW_HAMBURGER_ID:{
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_WATS_NEW withEventLabel:K_GA_EVENT_WATS_NEW withEventValue:nil];
            [NGGoogleAnalytics sendScreenReport:K_GA_WHATS_NEW_SCREEN];
            [delegate.container toggleLeftSideMenuCompletion:^{
                [[NGNotificationWebHandler sharedInstance] resetNotifications:KEY_BADGE_TYPE_PROD];
                [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_PROD withBadgeNumber:0];
                
                
                NGWebViewController *webView = (NGWebViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"webView"];
                webView.isCloseBtnHidden = NO;
                [webView setNavigationTitle:@"Whats New" withUrl:[NGSavedData getProductURL]];
                IENavigationController *cntrllr = delegateWeak.container.centerViewController;
                [cntrllr pushActionViewController:webView Animated:YES];
            }];
            
            break;
        }
            
        case K_FEEDBACK_HAMBURGER_ID:{
            
            [delegate.container toggleLeftSideMenuCompletion:^{
                
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_FEEDBACK usingNavigationController:delegateWeak.container.centerViewController animated:YES];
                
            }];
            
            break;
        }
            
        case K_LOGOUT_HAMBURGER_ID:{
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_LOGOUT withEventLabel:K_GA_EVENT_LOGOUT withEventValue:nil];
            
            loader = [[NGLoader alloc] initWithFrame:self.view.frame];
            [loader showAnimation:self.view];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_LOGOUT];
            
            __weak MenuViewController *weakVC = self;
            __weak NGLoader *weakLoader = loader;
            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
                
                if(responseData.isSuccess){
                    
                    [[WatchOSAndiOSCommunicationLayer sharedInstance] sendLoginStatusToWatch:NO];
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [delegateWeak.container toggleLeftSideMenuCompletion:nil];
                        [weakLoader hideAnimatior:weakVC.view];
                        [NGUIUtility makeUserLoggedOutOnSessionExpired:NO];
                        NSString *deviceToken = [NGSavedData getDeviceToken];
                        [[NGNotificationWebHandler sharedInstance]registerDevice:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",deviceToken,@"tokenId",[NSNumber numberWithBool:NO],@"loginStatus" ,nil]];
                        
                    });
                
                }else{
                    
                    [[WatchOSAndiOSCommunicationLayer sharedInstance] sendLoginStatusToWatch:YES];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakLoader hideAnimatior:weakVC.view];
                        
                        [NGUIUtility showAlertWithTitle:@"Error" message:@"Connection could not be established" delegate:nil];
                        
                        
                    });
                }
            }];
            
            break;
            
        }
            
        case K_LOGIN_HAMBURGER_ID:{
            
            [delegate.container toggleLeftSideMenuCompletion:^{
                
                NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
                [appStateHandler setDelegate:selfWeak];
                
                [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:delegateWeak.container.centerViewController animated:YES];
                
                appStateHandler = nil;
            }];
            break;
            
        }
            
        case K_REGISTER_HAMBURGER_ID:{
            
            [delegate.container toggleLeftSideMenuCompletion:^{
                
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_REGISTER_WITH_NG withEventLabel:K_GA_EVENT_REGISTER_WITH_NG withEventValue:nil];
                
                NGResmanLoginDetailsViewController *resmanVc = [[NGResmanLoginDetailsViewController alloc] initWithNibName:nil bundle:nil];
                [delegate.container.centerViewController pushActionViewController:resmanVc Animated:YES];
                
            }];
            break;
            
        }
        default:
            break;
    }
    
}


/**
 *  Perform action when update profile button is tapped.
 *
 *  @param sender UIButton object.
 */
- (void)updateProfileButtonPress:(id)sender {
    
    [APPDELEGATE.container toggleLeftSideMenuCompletion:^{
        
        if ([NGHelper sharedInstance].appState != APP_STATE_PROFILE ){
            [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE usingNavigationController:APPDELEGATE.container.centerViewController animated:YES];
        }
        
    }];
}


#pragma mark - AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc{
    if([vc isKindOfClass:[NGJobAnalyticsViewController class]])
    {
        NGJobAnalyticsViewController* jaVC = (NGJobAnalyticsViewController*)vc;
        jaVC.selectedTabIndex = jobAnalyticsViewTabIndex;
        if(jaVC.selectedTabIndex == 1)
        {
            NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]getAllSavedJobs]];
            jaVC.savedJobsArr = (NSMutableArray*)[[tempArr reverseObjectEnumerator] allObjects];//coolban
        }
    }else if([vc isKindOfClass:[NGLoginViewController class]])
    {
        NGLoginViewController* viewC = (NGLoginViewController*)vc;
        
        [viewC showViewWithType:LOGINVIEWTYPE_REGISTER_VIEW];
        [viewC setTitleForLoginView:@"Job Seeker Login"];
    }else{
        //dummy
    }
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
}
#pragma mark Public Methods

-(void)updateMenu
{
    NSString *filePath = [NGConfigUtility getAppConfigFilePath];
    
    if (filePath)
    {
        NSMutableDictionary *root=[[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        if ([NGHelper sharedInstance].isUserLoggedIn){
            menuListArray=[[NSMutableArray alloc] initWithArray:[[root valueForKey:@"MenuListItemsForLogedIn"]valueForKey:@"MenuList"]];
            
        }
        else
        {
            
            menuListArray=[[NSMutableArray alloc] initWithArray:[[root valueForKey:@"MenuListForNotLogedIn"]valueForKey:@"MenuList"]];
            
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"MenuIcon",@"",@"MenuLabel",@"0",@"MenuAction", nil];
        [menuListArray insertObject:dict atIndex:0];
        
    }
    
    __weak MenuViewController *selfWeak = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.menuTable reloadData];
    });
}



@end
