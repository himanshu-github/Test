//
//  NGViewController.m
//  NaukriGulf
//
//  Created by Iphone Developer on 21/05/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGViewController.h"
#import "NGSearchJobsViewController.h"
#import "NGResmanLoginDetailsViewController.h"

@interface NGViewController ()<AppStateHandlerDelegate>
{
    UIToolbar* headerToolbar;
    UIBarButtonItem* menuButton;
    IBOutlet UIButton *registerBtn;
    UIBarButtonItem* headerTitle;
    NSMutableArray *animAlphaArr;
    /**
     *  Time duration for displaying animation
     */
    NSTimer *loadingTimer;

    /**
     *  No of times animation is repeated
     */
    
    NSInteger loadingRepeatCount;
    
    __weak IBOutlet NSLayoutConstraint *topCOnstraintOfLogo;
    
}
@property (weak, nonatomic) IBOutlet UIButton *searchJobsBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NGImageView *homeImg;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIButton *myNaukrigulfBtn;



- (IBAction)gotoSearchJobs:(id)sender;
- (IBAction)gotoLogin:(id)sender;
- (IBAction)registerWithNG:(id)sender;

@end



@implementation NGViewController

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
    [super viewDidLoad];
 
    //Setting Background image
    [self setHomeImage];
    self.myNaukrigulfBtn.hidden = YES;
    [self showHomeScreen:NO];
    
    [self createLoadingAnimation];
    if(IS_IPHONE4)
    topCOnstraintOfLogo.constant = topCOnstraintOfLogo.constant-35;

    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Hiding the NavigationBar
    self.navigationController.navigationBarHidden=TRUE;

    [APPDELEGATE.container setLeftMenuViewController:nil];
	[NGGoogleAnalytics sendScreenReport:K_GA_HOME_SCREEN];
    
    if (!loadingTimer) {
        [self configureViewBasedOnLoggedInState];
    }
    [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_HOME withModel:nil]];
    [self setHomeImage];
    
}



-(void)configureViewBasedOnLoggedInState{
    
    if ([NGHelper sharedInstance].isUserLoggedIn) {
        self.loginBtn.hidden = YES;
        registerBtn.hidden = YES;
        self.myNaukrigulfBtn.hidden = NO;
        
    }else{
        self.loginBtn.hidden = NO;
        registerBtn.hidden = NO;
        self.myNaukrigulfBtn.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];

}

-(void)viewDidAppear:(BOOL)animated{

    [NGHelper sharedInstance].appState = APP_STATE_HOME;
    [super viewDidAppear:animated];
}

#pragma mark Private Methods

/**
 *  The method hide & unhide other controls on the page
 *   based on the animation flag.
 *
 *  @param  flag for showing the animation
 */

-(void)showHomeScreen:(BOOL)showFlag
{
    
    NGHelper *ngHelper = [NGHelper sharedInstance];
    self.searchJobsBtn.hidden = !showFlag;
    self.loginBtn.hidden = !showFlag;
    registerBtn.hidden = !showFlag;

    
    headerToolbar.hidden = YES;
    [UIAutomationHelper setAccessibiltyLabel:@"login_btn" value:[[NGHelper sharedInstance]isUserLoggedIn]?@"Logged In":@"Logged Out" forUIElement:_loginBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"search_btn" forUIElement:self.searchJobsBtn];
    
    [UIAutomationHelper setAccessibiltyLabel:@"register_btn" forUIElement:registerBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"myNaukrigulfBtn" forUIElement:self.myNaukrigulfBtn];

    //play animation called
    if (showFlag) {
        
        
        if ([[NGSpotlightSearchHelper sharedInstance] spotlightAppState] == NGSpotlightAppStateLaunch)
            [[NGSpotlightSearchHelper sharedInstance] handleSpotlightItemClick];
        
        else if (NGDeepLinkingAppStateLaunch == [[NGDeepLinkingHelper sharedInstance] deeplinkingAppState])
                [[NGDeepLinkingHelper sharedInstance] handleDeeplinkingNotification];
    
        else if(NGLocalNotificationLaunchingFromStateLaunch == [[NGLocalNotificationHelper sharedInstance] launchingFromState]){
            
            [[NGLocalNotificationHelper sharedInstance] handleLocalNotification];
            
        }else if(NGPushNotificationAppStateLaunch == [[NGNotificationAppHandler sharedInstance] pushNotificationAppState]){
            
            [[NGNotificationAppHandler sharedInstance] handlePushNotification];
            
        }else if (ngHelper.isUserLoggedIn) {
            
                NGAppDelegate *appDelegate = [NGAppDelegate appDelegate];
                [[NGAppStateHandler sharedInstance] setAppState:APP_STATE_MNJ usingNavigationController:appDelegate.container.centerViewController animated:NO];
        }else{
            //dummy
        }
    }
}


/**
 *  Loads the custom animation
 */

-(void)createLoadingAnimation{
    
    animAlphaArr = [[NSMutableArray alloc]init];
    [animAlphaArr addObject:[NSNumber numberWithFloat:0.2]];
    [animAlphaArr addObject:[NSNumber numberWithFloat:0.2]];
    [animAlphaArr addObject:[NSNumber numberWithFloat:0.4]];
    [animAlphaArr addObject:[NSNumber numberWithFloat:0.4]];
    [animAlphaArr addObject:[NSNumber numberWithFloat:0.6]];
    [animAlphaArr addObject:[NSNumber numberWithFloat:0.8]];
    [animAlphaArr addObject:[NSNumber numberWithFloat:1.0]];
    
    NSInteger yPos = SCREEN_HEIGHT - 40;
    
    float xFactor = 0;
    
    if(IS_IPHONE4||IS_IPHONE5)
        xFactor = 20;
    else if(IS_IPHONE6)
        xFactor = 29;
    else if(IS_IPHONE6_PLUS)
        xFactor = 36;
    
    
    
    
    
    for (NSInteger i = 0; i<animAlphaArr.count; i++) {
        NSMutableDictionary* imgDict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_IMAGEVIEW],KEY_VIEW_TYPE,
                                             [NSValue valueWithCGRect:CGRectMake(16+(24+xFactor)*i,yPos,24,24)],KEY_FRAME,
                                             [NSNumber numberWithInteger:i],KEY_TAG,
                                             nil];
        
        NGImageView *img=  (NGImageView*)[NGViewBuilder createView:imgDict];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"spicon%ld",((long)i+1)]];
        [self.homeImg addSubview:img];
        
        img.alpha = [[animAlphaArr fetchObjectAtIndex:i]floatValue];
    }
    
    loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(playLoadingAnimation:) userInfo:nil repeats:YES];
    loadingRepeatCount = 0;
}

/**
 *  Display the custom animation
 *
 *  @param timer Time duration for which you want to show the animation
 */

-(void)playLoadingAnimation:(NSTimer *)timer{
    NSNumber *lastObj = [animAlphaArr lastObject];
    if(lastObj)
    [animAlphaArr insertObject:lastObj atIndex:0];
    [animAlphaArr removeLastObject];
    
    for (NSInteger i = 0; i<animAlphaArr.count; i++) {
        NGImageView *img=  (NGImageView*)[self.homeImg viewWithTag:i];
        img.alpha = [[animAlphaArr fetchObjectAtIndex:i]floatValue];
    }
    
    loadingRepeatCount++;
    
    
    if (loadingRepeatCount>=LOADING_REPEAT) {
        [loadingTimer invalidate];
        loadingTimer = nil;
        
        for (NSInteger i = 0; i<animAlphaArr.count; i++) {
            NGImageView *img=  (NGImageView*)[self.homeImg viewWithTag:i];
            img.hidden = YES;
        }
        
        [self setHomeImage];
        
        [self configureViewBasedOnLoggedInState];
        
        [self showHomeScreen:YES];
        
        [[NGAnimator sharedInstance]fadeInView:self.loginBtn duration:0.5f delay:0.0f];
        
        [[NGAnimator sharedInstance]fadeInView:registerBtn duration:0.5f delay:0.0f];
        
        [[NGAnimator sharedInstance]fadeInView:self.searchJobsBtn duration:0.5f delay:0.0f];
        [[NGAnimator sharedInstance]fadeInView:self.myNaukrigulfBtn duration:0.5f delay:0.0f];

        if ([NGOpenWithResumeHandler sharedInstance].isRegisteredByLocalObserver) {
            if (NO == [[NGHelper sharedInstance] isUserLoggedIn]) {
                [NGUIUtility showAlertWithTitle:@"Error" withMessage:[NSArray arrayWithObjects:@"Please login to attach a CV.", nil] withButtonsTitle:@"OK" withDelegate:nil];
                
                [NGOpenWithResumeHandler sharedInstance].isRegisteredByLocalObserver = NO;
            }
        }
        if(!(IS_IPHONE4))
        [self performSelector:@selector(setLogoImage) withObject:nil afterDelay:0.0];
    }
}

-(void)setLogoImage{
    
    topCOnstraintOfLogo.constant = topCOnstraintOfLogo.constant-35;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)setHomeImage{

    NSNumber *willShowCelebrationImg = [NGSavedData willShowCelebrationImageKeyValue];
    if(willShowCelebrationImg.intValue == 1)
    {
        self.logoImg.hidden = YES;
        if (IS_IPHONE5)
        {
            UIImage *image = [UIImage imageNamed:@"iCeleb55s6"];
            self.homeImg.image = image;
        }
        else if (IS_IPHONE6)
        {
            UIImage *image = [UIImage imageNamed:@"iCeleb55s6"];
            self.homeImg.image = image;
            
        }
        else if (IS_IPHONE6_PLUS)
        {
            UIImage *image = [UIImage imageNamed:@"iCeleb6plus"];
            self.homeImg.image = image;
            
        }
        else{
            UIImage *image = [UIImage imageNamed:@"iCeleb4s"];
            self.homeImg.image = image;
        }
        
    }
    else{
       
    self.logoImg.hidden = NO;

    if (IS_IPHONE5)
    {
        UIImage *image = [UIImage imageNamed:@"LaunchImage-700-568h"];
        self.homeImg.image = image;
    }
    else if (IS_IPHONE6)
    {
        UIImage *image = [UIImage imageNamed:@"LaunchImage-800-667h"];
        self.homeImg.image = image;
        
    }
    else if (IS_IPHONE6_PLUS)
    {
        UIImage *image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
        self.homeImg.image = image;
        
    }
    else{
        UIImage *image = [UIImage imageNamed:@"LaunchImage-700"];
        self.homeImg.image = image;
    }
    }
}
#pragma mark -
#pragma mark Event Listeners

- (IBAction)gotoSearchJobs:(id)sender
{
    NGSearchJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JobSearch"];
    
    IENavigationController *navVC = (IENavigationController *)APPDELEGATE.container.centerViewController;
    [navVC  pushActionViewController:navgationController_ Animated:YES ];
}

- (IBAction)gotoLogin:(id)sender {
   
    
    NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
    [appStateHandler setDelegate:self];
    
    NGAppDelegate *appDelegate = [NGAppDelegate appDelegate];

    if ([NGHelper sharedInstance].isUserLoggedIn) {
        [appStateHandler setAppState:APP_STATE_MNJ usingNavigationController:appDelegate.container.centerViewController animated:YES];
        
    }else{
        [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:appDelegate.container.centerViewController animated:YES];
    }
    appStateHandler = nil;
    appDelegate = nil;
    
}
-(void)setPropertiesOfVC:(id)vc{
    
    if([vc isKindOfClass:[NGLoginViewController class]])
    {
        NGLoginViewController* viewC = (NGLoginViewController*)vc;
        
        [viewC showViewWithType:LOGINVIEWTYPE_REGISTER_VIEW];
        [viewC setTitleForLoginView:@"Job Seeker Login"];
    }
    
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
    
}

- (IBAction)registerWithNG:(id)sender{
   
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_REGISTER_WITH_NG withEventLabel:K_GA_EVENT_REGISTER_WITH_NG withEventValue:nil];
    
     NGResmanLoginDetailsViewController *resmanVc = [[NGResmanLoginDetailsViewController alloc] initWithNibName:nil bundle:nil];
    [(IENavigationController*)APPDELEGATE.container.centerViewController pushActionViewController:resmanVc Animated:YES];
    

}

#pragma mark -
#pragma mark handling memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end
