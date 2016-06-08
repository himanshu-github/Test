//
//  NGBaseViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 05/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//
#import "Reachability.h"
#import "NGNetworkStatusView.h"
#import "WatchConstants.h"


#define kHamBtnTag 300
#define kHamCounterTag 301

@interface NGBaseViewController (){
    NGLoader* loader;
    
}
@property(strong,nonatomic) NGAppDelegate *delegate;
@end

@implementation NGBaseViewController



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
    
    self.delegate = APPDELEGATE;
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdatePush" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMenuPushCount) name:@"UpdatePush" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:MFSideMenuStateNotificationEvent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
    errorCellArr = [[NSMutableArray alloc] init];
      [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];


}
-(void)setBackgroundOfView
{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_jean"]];
    
    
}
-(void)setBackgroundOfTableView:(UITableView*)tableView
{
    tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_jean"]];
    
}

-(void)hideKeyboardOnTapOutsideKeyboard
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                   
                                                                          action:@selector(dismissKeyboardOnTap)];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    
}
-(void)hideKeyboardOnTapAtView:(UIView*)paramView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                   
                                                                          action:@selector(dismissKeyboardOnTap)];
    tap.delegate=self;
    [paramView addGestureRecognizer:tap];
    
}

-(void)dismissKeyboardOnTap
{
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
       return TRUE;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setLeftHamBurgerCount];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self listenForAppNotification:UIApplicationWillEnterForegroundNotification
 WithAction:YES];
    
    [NGDecisionUtility checkNetworkStatus];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [NGMessgeDisplayHandler forceHideAllTopWindowMessages];
    
    [self listenForAppNotification:UIApplicationWillEnterForegroundNotification
                        WithAction:NO];
}


#pragma mark Custom KeyBoard

-(void)initilizaArrayForTextfields:(NSArray*)fieldsArray
{
    self.fieldsArray = [[NSArray alloc] initWithArray:fieldsArray];
}

- (void) dismissKeyboard:(id)sender
{
    for (int i=0;i<self.fieldsArray.count;i++)
    {
        [[self.fieldsArray fetchObjectAtIndex:i] resignFirstResponder];
    }
    
    [NGUIUtility slideView:self.view toXPos:0 toYPos:0 duration:0.25f delay:0.0f];
}

-(void)customTextFieldDidBeginEditing:(UITextField*)textField
{
    [textField setInputAccessoryView:[self customToolBarForKeyBoard]];
}

-(void)customTextViewDidBeginEditing:(UITextView*)textView
{
    [textView setInputAccessoryView:[self customToolBarForKeyBoard]];
    
}

-(UIToolbar*)customToolBarForKeyBoard
{
    
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolBar.frame = CGRectMake(0, 0, 320, 50);
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [toolBar sizeToFit];
    
    prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(previous) ];
    nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(next)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)];
    
    
    NSArray *items  =   [[NSArray alloc] initWithObjects:prevButton,nextButton,flexibleSpace,doneButton,nil];
    [toolBar setItems:items];
    
    
    return toolBar;
}



#pragma mark -
#pragma mark Toolbar

-(UIView *)addToolBarView{
    
    //Shadow View
    NSMutableDictionary* dictionaryForShadowView=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_VIEW],KEY_VIEW_TYPE,
                                                  [NSValue valueWithCGRect:CGRectMake(SHADOW_VIEW_FRAME) ],KEY_FRAME,
                                                  [NSNumber numberWithInt:300],KEY_TAG,
                                                  nil];
    
    NGView* shadowView=  (NGView*)[NGViewBuilder createView:dictionaryForShadowView];
    [shadowView setShadowView];
    [self.view addSubview:shadowView];
    
    [NGUIUtility modifyBadgeOnIcon:[NGUIUtility getAllNotificationsCount]];
    
    //Menu Button
     
    NGButton* menuBtn_=  (NGButton*)[UIButton buttonWithType:UIButtonTypeCustom];
    
    [self setCustomButton:menuBtn_ withImage:[UIImage imageNamed:@"Hamburger.png"] withFrame:CGRectMake(13, 13, 18, 18)];
    [menuBtn_ addTarget:self action:@selector(gotoMenu:) forControlEvents:UIControlEventTouchUpInside];
    [shadowView addSubview:menuBtn_];
        
    
   

    //Label for Push
    
    NSMutableDictionary* dictionaryForCountLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                [NSValue valueWithCGRect:CGRectMake(18, 12, 15, 15)],KEY_FRAME,
                                                [NSNumber numberWithInt:200],KEY_TAG,
                                                nil];
    
    self.countLbl=(NGLabel*) [NGViewBuilder createView:dictionaryForCountLbl];
    self.countLbl.tag = 200;
    self.countLbl.layer.cornerRadius = 5.0;
    self.countLbl.layer.masksToBounds = YES;
    
    NSInteger count = [NGUIUtility getAllNotificationsCount];
    
    NSMutableDictionary* dictionaryForCountLblStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor redColor],KEY_BACKGROUND_COLOR,
                                                     [NSNumber numberWithInt:1],KEY_LABEL_NO_OF_LINES,
                                                     [NSNumber numberWithInteger:NSTextAlignmentCenter],kEY_LABEL_ALIGNMNET,
                                                     [NSString stringWithFormat:@"%ld",(long)count],KEY_LABEL_TEXT,
                                                     [UIColor whiteColor],KEY_TEXT_COLOR,
                                                     FONT_STYLE_HELVITCA_NEUE_LIGHT,KEY_FONT_FAMILY,FONT_SIZE_15,KEY_FONT_SIZE,nil];
    
    [self.countLbl setLabelStyle:dictionaryForCountLblStyle];
    [shadowView addSubview:self.countLbl];
    
    self.countLbl.userInteractionEnabled = NO;
    
    if (count==0 ) {
        self.countLbl.hidden = YES;
    }else{
        self.countLbl.hidden = NO;
    }
    
    //Separator
    NSMutableDictionary* dictionaryForSeparator=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_VIEW],KEY_VIEW_TYPE,
                                                  [NSValue valueWithCGRect:CGRectMake(44, 0, 1, 44) ],KEY_FRAME,
                                                  [NSNumber numberWithInt:0],KEY_TAG,
                                                  nil];

    
    NGView* separatorView=(NGView*)[NGViewBuilder createView:dictionaryForSeparator];
    [separatorView setSeparatorStyle];
    [shadowView addSubview:separatorView];
  
    
    if (!self.delegate.container.leftMenuViewController) {
        MenuViewController *leftSideMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        
        [self.delegate.container setLeftMenuViewController:leftSideMenuViewController];
    }else{
        MenuViewController *leftSideMenuViewController = (MenuViewController*)self.delegate.container.leftMenuViewController;
        [leftSideMenuViewController updateMenu];
    }
    
    
    return shadowView;
   
}



-(void)ClearButtonClicked{

// Need to override the method
}

-(void)setCustomButton:(NGButton*)button withImage:(UIImage*)image withFrame:(CGRect)frame
{
    [button setImage:image forState:UIControlStateNormal];
    [button setFrame:frame];
   
    if (button.tag!=42)
        [button setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    button.showsTouchWhenHighlighted = YES;
}


-(void)disbaleLeftAndRightPanOnPage
{
    self.delegate.container.leftMenuPanEnabled = NO;
    self.delegate.container.rightMenuPanEnabled = NO;
}


-(void)enableLeftAndRightPanOnPage
{
    self.delegate.container.leftMenuPanEnabled = YES;
    self.delegate.container.rightMenuPanEnabled = YES;
    
}

-(void)disableRightPanOnPage
{
    self.delegate.container.rightMenuPanEnabled=NO;
    self.delegate.container.leftMenuPanEnabled=YES;
}

-(void)enableRightPanOnPage
{
    self.delegate.container.rightMenuPanEnabled=YES;
     self.delegate.container.leftMenuPanEnabled=YES;
}

-(void)enableLeftSwipe:(BOOL)isEnabled{
    self.delegate.container.leftMenuPanEnabled = isEnabled;
}

-(void)enableRightSwipe:(BOOL)isEnabled{
    self.delegate.container.rightMenuPanEnabled = isEnabled;
}


-(void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoMenu:(id)sender
{
    MenuViewController *menuViewController = (MenuViewController*)APPDELEGATE.container.leftMenuViewController;
    [menuViewController updateMenu];
    [APPDELEGATE.container toggleLeftSideMenuCompletion:nil];
}


-(void)updateMenuPushCount
{
    MenuViewController *menuViewController = (MenuViewController*)self.delegate.container.leftMenuViewController;
    [menuViewController updateMenu];

    [self setLeftHamBurgerCount];
}

-(void) setLeftHamBurgerCount {
    
    NSInteger count = [NGUIUtility getAllNotificationsCount];
    
    UIBarButtonItem *barButton = self.navigationItem.leftBarButtonItem;
    UILabel *lbl = (UILabel*)[barButton.customView viewWithTag:kHamCounterTag];
    if(count) {
        
        [lbl setHidden:FALSE];
        lbl.text = [NSString stringWithFormat:@"%ld",(long)count];
    }
    else [lbl setHidden:TRUE];
    
}
-(void)closeTapped:(id)sender{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)staticTapped:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadJobsWithParams:(NSDictionary *)requestParams{

    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_ALL_JOBS];
    __weak NGBaseViewController* mySelfWeak = self;
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithDictionary:requestParams] handler:^(NGAPIResponseModal *responseData) {
        [mySelfWeak receivedServerResponse:responseData];
    }];
}
- (void)receivedServerResponse:(NGAPIResponseModal*)responseData{
    
}

-(void)downloadJDWithParams:(NSDictionary *)requestParams{
    
    __weak NGBaseViewController* mySelfWeak = self;
    [self fetchJDFromServer:requestParams withCallback:^(NGAPIResponseModal *modal) {
        [mySelfWeak receivedServerResponse:modal];
    }];
    
}

-(void)fetchJDFromServer:(NSDictionary*)requestParams withCallback:(void (^)(NGAPIResponseModal* modal))callback{
    
    NSDictionary *resourceParams = [NSDictionary dictionaryWithObjectsAndKeys:[requestParams objectForKey:@"jobId"],@"jobId", nil];
    NSMutableDictionary *attributeParams = [NSMutableDictionary  dictionaryWithDictionary:requestParams];
    [attributeParams removeObjectForKey:@"jobId"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    if([requestParams objectForKey:KEY_IS_API_HIT_FROM_WATCH])
        dataDict =  [NSMutableDictionary dictionaryWithObjectsAndKeys:resourceParams,K_RESOURCE_PARAMS,attributeParams,K_ATTRIBUTE_PARAMS,[requestParams objectForKey:KEY_IS_API_HIT_FROM_WATCH],KEY_IS_API_HIT_FROM_WATCH,  nil];
    
    else
        dataDict =  [NSMutableDictionary dictionaryWithObjectsAndKeys:resourceParams,K_RESOURCE_PARAMS,attributeParams,K_ATTRIBUTE_PARAMS,nil];

    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_JD];
    [obj getDataWithParams:dataDict handler:^(NGAPIResponseModal *responseData) {        callback(responseData);
    }];
    
    
    
}

#pragma mark Suggestors

- (AutocompletionTableView *)getSuggestorForDD:(NSString *)ddKey textField:(UITextField *)txtFld
{
    AutocompletionTableView *_autoCompleter;
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
    [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
    [options setValue:nil forKey:ACOUseSourceFont];
        
    _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:txtFld inViewController:self withOptions:options withDefaultStyle:NO];
    _autoCompleter.suggestionsDictionary = [[DataManagerFactory getStaticContentManager]getSuggestedStringsFromKey:ddKey];    
    
    return _autoCompleter;
}

#pragma mark MFSideMenu Delegate

- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
    
    if (event==MFSideMenuStateEventMenuWillOpen) {
        [NGMessgeDisplayHandler forceHideAllTopWindowMessages];
        //commenting the swipe back feature for future
        //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (event==MFSideMenuStateEventMenuDidClose) {
        //commenting the swipe back feature for future
       // self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark Release Memory

-(void)releaseMemory{
    [[NSNotificationCenter defaultCenter] removeObserver:MFSideMenuStateNotificationEvent];
    [[NSNotificationCenter defaultCenter] removeObserver:kReachabilityChangedNotif];
    [[NSNotificationCenter defaultCenter] removeObserver:BLOCK_IP_NOTIFICATION_OBSERVER];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdatePush" object:nil];
    
    self.view.backgroundColor = nil;
    self.countLbl = nil;
    self.delegate = nil;
    self.fieldsArray = nil;
    self.networkView = nil;
    self.delegate = nil;
}

- (void)dealloc
{
    [self releaseMemory];
}
-(void)showSingletonNetworkErrorLayer{
    
    UIView *netView = [NGNetworkStatusView sharedInstance];
    [APPDELEGATE.window addSubview:netView];
    CGPoint fadeInToPoint;
    fadeInToPoint = CGPointMake(netView.center.x, 64.0f);
    [UIView animateWithDuration:0.5 animations:^
     {
         netView.center = fadeInToPoint;
         
     } completion:^(BOOL finished)
     {
     }];
    [self performSelector:@selector(removeSingletonNetworkErrorLayer) withObject:nil afterDelay:3.0];
    

}
-(void)removeSingletonNetworkErrorLayer{
    UIView *netView = [NGNetworkStatusView sharedInstance];
    CGPoint fadeOutToPoint;
    fadeOutToPoint = CGPointMake(netView.center.x, -CGRectGetHeight(netView.frame)/2.f);
    [UIView animateWithDuration:0.5 animations:^
     {
         netView.center = fadeOutToPoint;
         
     } completion:^(BOOL finished)
     {
         [[NGNetworkStatusView sharedInstance] removeFromSuperview];

     }];
    
    
    
}
#pragma mark Validations

-(void)setErrorIndexAs:(float)index{
    if (errorFieldIndex==-1) {
        errorFieldIndex = index;
    }
}


#pragma mark - new nav bar methods
-(void)changeTitle:(NSString *)title{

    self.title = title;
    

}
-(void)addNavigationBarWithTitleOnly:(NSString *)paramTitle{
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.leftBarButtonItems = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    self.navigationItem.hidesBackButton = YES;
    
    [self setCustomTitle:paramTitle];
    [self customizeNavigationTitleFont];
}

-(void) addNavigationBarWithTitle : (NSString *) title{
    
    [self setNavigationBarWithTitle:title];
    
    //[self addHamburgerOnNavBar];
}


-(void)addNavigationBarWithTitleAndClearButton : (NSString *) title {
    
    [self addNavigationBarWithTitle:title];
    
    [self addClearButtonAtRightOfNavigationBar];
}

- (void)addButtonAtRightOfNavigationBarWithTitle:(NSString*)paramTitle{
    //left for future implementation
}
- (void)addClearButtonAtRightOfNavigationBar{
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn addTarget:self
                 action:@selector(ClearButtonClicked)
       forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setTitle:@"Clear" forState:UIControlStateNormal];
    [clearBtn setTitle:@"Clear" forState:UIControlStateHighlighted];
    [clearBtn setTitle:@"Clear" forState:UIControlStateSelected];
    [clearBtn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:BUTTON_TITLE_FONTSIZE]];
    clearBtn.frame = CGRectMake(SCREEN_WIDTH-50,0,58,44);
    clearBtn.backgroundColor = [UIColor clearColor];
    [clearBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [clearBtn setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:186.0f/255.0f blue:255.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [clearBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    self.navigationItem.rightBarButtonItem = [self createBarButtonItemWithButton:clearBtn];
}

- (void)setNavigationBarWithTitle:(NSString *)navigationTitle {
    
    [self addNavigationBarWithTitleOnly:navigationTitle];
    
    [self initialiseLeftMenu];
    
}

-(void) addHamburgerOnNavBar{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
    
    UIButton *hamBtn  = [self createButtonWithFrame:CGRectMake(0, 0, 35, 44) withImage:@"ham"];
    
    hamBtn.tag = kHamBtnTag;
    
    [view addSubview:hamBtn];
    
    [hamBtn addTarget:self action:@selector(gotoMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(hamBtn.frame.origin.x+hamBtn.frame.size.width-18, 5, 20, 18)];
    [lbl setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT  size:13]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor redColor]];
    [lbl setTextColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    lbl.tag = kHamCounterTag;
    lbl.layer.cornerRadius = 9.0;
    lbl.layer.masksToBounds = YES;
    lbl.userInteractionEnabled= FALSE;
    [view addSubview:lbl];
    [lbl setHidden:YES];
    self.navigationItem.leftBarButtonItem = [self createBarButtonItemWithView:view];
    [hamBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    
}


-(void) initialiseLeftMenu {
    
    if (!self.delegate.container.leftMenuViewController) {
        MenuViewController *leftSideMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        
        [self.delegate.container setLeftMenuViewController:leftSideMenuViewController];
    }else{
        MenuViewController *leftSideMenuViewController = (MenuViewController*)self.delegate.container.leftMenuViewController;
        [leftSideMenuViewController updateMenu];
    }
    
    
}


-(UIBarButtonItem *)createBarButtonItemWithView:(UIView *)view{
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    return barBtnItem;
    
}


-(UIBarButtonItem *)createBarButtonItemWithButton:(UIButton *)button{
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barBtnItem;
    
}
-(UIButton *)createButtonWithFrame:(CGRect)btnFrame withImage:(NSString *)imageName{
    
    UIButton* tempButton = [[UIButton alloc] initWithFrame:btnFrame];
    [tempButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    tempButton.exclusiveTouch = YES;
    return tempButton;
}

-(void)customizeNavigationTitleFont{
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
      [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:19.0], NSFontAttributeName,nil]];
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)setCustomFontForSRPPageNavigationBar:(BOOL)paramIsJobsFound{
    
    if (paramIsJobsFound) {
        [self.navigationController.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
          [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:12.0], NSFontAttributeName,nil]];
    }else{
        [self customizeNavigationTitleFont];
    }
    
}
-(void)setCustomTitle:(NSString *)customTitle{
    
    if ( !customTitle || [customTitle isKindOfClass:[NSNull class]]){
    }
    else{
        self.title = customTitle;
    }
}

-(void)addNavigationBarWithCloseBtnWithTitle:(NSString *)navigationTitle{
    
    self.navigationController.navigationBarHidden = FALSE;
    
    [self addNavigationBarWithTitle:navigationTitle];
    
    [self addCloseButtonOnNavigationBar];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.navigationItem.leftBarButtonItem = nil;
}


-(void) addCloseButtonOnNavigationBar{
    
    UIButton* btnClose = [self createButtonWithFrame:CGRectMake(0, 0, 40, 40) withImage:@"cancel"];
    [btnClose setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
    [btnClose addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnClose.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *leftNavBtn = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.rightBarButtonItem = leftNavBtn;
}

-(void)closeButtonClicked:(id)sender{
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
}

-(void)addNavigationBarWithBackBtnWithTitle:(NSString *)navigationTitle{
    
    [self addNavigationBarWithTitle:navigationTitle];
    
    [self addBackButtonWithBackImageOnNavigationBar];
    
    
}
-(void) addBackButtonWithBackImageOnNavigationBar {
    
    if(navigationBarLeftBtn){
        [navigationBarLeftBtn removeFromSuperview];
        navigationBarLeftBtn = nil;
    }
    if(navigationBarRightBtn){
        
        [navigationBarRightBtn removeFromSuperview];
        navigationBarRightBtn = nil;
    }
    self.navigationItem.rightBarButtonItem = nil ;
    self.navigationItem.leftBarButtonItem = nil ;

    navigationBarLeftBtn  = [self createButtonWithFrame:CGRectMake(0, 0, 50, 50) withImage:@"back"];
    [self setNavigationLeftButtonEdgeInset];
    [navigationBarLeftBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [self createBarButtonItemWithButton:navigationBarLeftBtn];
}
-(void)setNavigationLeftButtonEdgeInset{
   
    [navigationBarLeftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [navigationBarLeftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
}
-(void)setNavigationRightButtonEdgeInsect{
   
    [navigationBarRightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        
    
}
-(void) addNavigationBarWithTitleAndHamBurger:(NSString*) navigationTitle {
    
    [self addNavigationBarWithTitle:navigationTitle];
    [self addHamburgerOnNavBar];
    
}

-(void)changeHamburgerToBackButton
{
    [self addBackButtonWithBackImageOnNavigationBar];
}
-(void)addNavigationBarForPreviewControllerWithTitle:(NSString*)paramTitle AndBackButtonTitle:(NSString*)paramBackButtonTitle{
    
}
- (void)addNavigationBarForSRPWithTitle:(NSString*)paramTitle{
    
    if (nil==paramTitle) {
        [self addLogoToNavigationBarWithImageName:@"Fevicon"];
    }else{
        [self addNavigationBarWithTitleAndHamBurger:paramTitle];
    }
    if (nil == filterBtnForSRP) {
        [self addFilterAndShortlistedJobsButtonOnNavigationBar];
    }
}

- (void)addFilterAndShortlistedJobsButtonOnNavigationBar{
    if(navigationBarRightBtn){
        
        [navigationBarRightBtn removeFromSuperview];
        navigationBarRightBtn = nil;
    }
    self.navigationItem.rightBarButtonItem = nil ;
    
    UIButton *btnShortlistedJobs   = [self createButtonWithFrame:CGRectMake(0, 0, 25, 25) withImage:@"shortlistJobsIcon"];
    [btnShortlistedJobs addTarget:self action:@selector(openShortlistedJobViewController:) forControlEvents:UIControlEventTouchUpInside];

    
    filterBtnForSRP = [self createButtonWithFrame:CGRectMake(50, 0, 25, 25) withImage:@"refineSRPIcon"];
    [filterBtnForSRP addTarget:self action:@selector(openRefineSearchViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    //seperator button
    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = 20.0f;
    
    self.navigationItem.rightBarButtonItems = @[[self createBarButtonItemWithButton:filterBtnForSRP],fixedSpaceItem,[self createBarButtonItemWithButton:btnShortlistedJobs]];

    
}
- (void)removeAllRightSideItemsOfNavigationBar{
    if(navigationBarRightBtn){
        
        [navigationBarRightBtn removeFromSuperview];
        navigationBarRightBtn = nil;
    }
    self.navigationItem.rightBarButtonItem = nil ;
    self.navigationItem.rightBarButtonItems = nil;

}
-(void)customizeValidationErrorUIForIndexPath:(NSIndexPath *)indexPath cell:(NGCustomValidationCell *)cell{
    
    if ([errorCellArr containsObject:[NSNumber numberWithInteger:indexPath.row]] ) {
        [cell showValidationError];
    }else{
        [cell hideValidationError];
    }
}
- (void)addLogoToNavigationBarWithImageName:(NSString*)paramImageFilename{
    
    UIView *headerView = [[UIView alloc] init];
    NSInteger xOfImage = (SCREEN_WIDTH-35)/2;
    headerView.frame = CGRectMake(xOfImage, 0, 35, 44);
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:paramImageFilename]];
    imgView.frame = CGRectMake(0, 4, 35, 35);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.userInteractionEnabled=YES;
    
    
    UITapGestureRecognizer *fevicaonTapRecognizer = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(feviconTapped:)];
    [fevicaonTapRecognizer setDelegate:self];
    [imgView addGestureRecognizer:fevicaonTapRecognizer];

    [UIAutomationHelper setAccessibiltyLabel:@"naukriLogo_imgView" forUIElement:imgView];
    
    [headerView addSubview:imgView];
    
    [self.navigationItem setTitleView:headerView];
}

- (void)addLogoToNavigationBarWithUnTappableImageName:(NSString*)paramImageFilename{
    
 
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.leftBarButtonItems = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    self.navigationItem.hidesBackButton = YES;

    
    
    UIView *headerView = [[UIView alloc] init];
    NSInteger xOfImage = (SCREEN_WIDTH-35)/2;
    headerView.frame = CGRectMake(xOfImage, 0, 35, 44);
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:paramImageFilename]];
    imgView.frame = CGRectMake(0, 4, 35, 35);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.userInteractionEnabled=YES;
    
    [UIAutomationHelper setAccessibiltyLabel:@"registerNowLogo_imgView" forUIElement:imgView];
    
    [headerView addSubview:imgView];
    
    [self.navigationItem setTitleView:headerView];
}


-(void)feviconTapped:(id)sender
{
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JOB_SEARCH usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:YES];
}
#pragma mark- Tableview separator layout
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - Animator
-(void)showAnimator{
    //commenting the swipe back feature for future
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if(!loader){
        
        loader = [[NGLoader alloc] initWithFrame:self.view.frame];
        
    }
    [loader showAnimation:self.view];
    
}

-(void)hideAnimator{
    //commenting the swipe back feature for future
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    if ([loader isLoaderAvail]){
        [loader hideAnimatior:self.view];
        loader = nil;
    }

}
- (void)cancelButtonTapped:(id)sender{
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
}
- (void)backButtonClicked:(UIButton*)sender{
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
}
-(CGRect)saveBtnBounds{
     return CGRectZero;
}
- (void)editMNJSaveButtonTapped:(id)sender{
}

-(void)customizeNavBarWithTitle:(NSString *)title{
    
    [self addNavigationBarTitleWithCancelAndSaveButton:title withLeftNavTilte:K_NAVBAR_LEFT_TITLE_CANCEL withRightNavTitle:K_NAVBAR_RIGHT_TITLE_SAVE];
}
- (void)addNavigationBarTitleWithCancelAndSaveButton:(NSString*)navigationTitle withLeftNavTilte:(NSString *)leftNavTitle withRightNavTitle:(NSString *)rightNavTilte {
    
    float _font = 15.0;
    
    [self addNavigationBarWithTitle:navigationTitle];
    
    
    if (leftNavTitle && 0 < leftNavTitle.length) {
        [self addLeftButtonOfNavigationBarWithTitle:leftNavTitle AndFontSize:_font];
    }
    
    if (rightNavTilte && 0 < rightNavTilte.length) {
        [self addRightButtonOfNavigationBarWithTitle:rightNavTilte AndFontSize:_font];
    }
}

- (void)addLeftButtonOfNavigationBarWithTitle:(NSString*)paramTitle AndFontSize:(float)paramFontSize{
    if(navigationBarLeftBtn)
        navigationBarLeftBtn    =   nil;
    navigationBarLeftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationBarLeftBtn.frame = CGRectMake(0, 0, 60, 40);
    [navigationBarLeftBtn setTitle:paramTitle forState:UIControlStateNormal];
    [navigationBarLeftBtn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:paramFontSize]];
    [self setNavigationLeftButtonEdgeInset];
    navigationBarLeftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    navigationBarLeftBtn.backgroundColor = [UIColor clearColor];
    [navigationBarLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBarLeftBtn addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [self createBarButtonItemWithButton:navigationBarLeftBtn];
}
- (void)addRightButtonOfNavigationBarWithTitle:(NSString*)paramTitle AndFontSize:(float)paramFontSize{
    if(navigationBarRightBtn)
        navigationBarRightBtn    =   nil;
    navigationBarRightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [navigationBarRightBtn setFrame:CGRectMake(0, 0, 60, 40)];
    [self setNavigationRightButtonEdgeInsect];
    [navigationBarRightBtn setTitle:paramTitle forState:UIControlStateNormal];
    navigationBarRightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [navigationBarRightBtn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:paramFontSize]];
    
    [navigationBarRightBtn setTitleColor:Clr_Edit_Profile_Blue forState:UIControlStateNormal];
    [navigationBarRightBtn addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [self createBarButtonItemWithButton:navigationBarRightBtn];
}
-(void)saveButtonPressed{
    
}
-(void)listenForAppNotification:(NSString*)paramNotificationName WithAction:(BOOL)paramAction{
    if (paramAction) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedBaseAppNotification:) name:paramNotificationName object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:paramNotificationName object:nil];
    }
}
-(void)receivedBaseAppNotification:(NSNotification*)paramNotificationObj{
    if (nil != paramNotificationObj) {
        
        NSString *notificationName = paramNotificationObj.name;
        
        if ([UIApplicationWillEnterForegroundNotification isEqualToString:notificationName]) {
            //remove loader
            if (loader.isLoaderAvail)
            {
                [self showAnimator];
                
            }else{
                [self hideAnimator];
            }
        }
    }
}
@end
