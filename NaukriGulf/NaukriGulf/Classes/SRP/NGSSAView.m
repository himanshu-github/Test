//
//  NGSSAView.m
//  NaukriGulf
//
//  Created by Arun Kumar on 06/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSSAView.h"
#import <QuartzCore/QuartzCore.h>
#import "NGSearchJobsViewController.h"



@interface NGSSAView ()
{
    NGLoader* loader;
    NSString *emailID;
    NSInteger navBarHeightAsPeriOS;
    CGFloat selfHeight;
    BOOL isKeyboardOpen;
    NSInteger keyboardHeight;
}

@property (weak, nonatomic) IBOutlet NGTextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *jobAlertBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
@property (weak, nonatomic) IBOutlet UIView *jobAlertView;

-(IBAction)jobAlertTapped:(id)sender;
@end

@implementation NGSSAView

#pragma mark -
#pragma mark UIViewController Methods


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setClipsToBounds:NO];
    isKeyboardOpen = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    self.jobAlertView.hidden = YES;
    self.errorLbl.hidden = YES;
    
    [self showSendMoreJobs];
    
    [self.emailTxtFld setTextFieldStyle];
    [self setAutomationLabels];
}
-(void)keyboardWillShow:(NSNotification*)paramNotification {
    
    if (_needToListenKeyboardEvent) {
        CGRect keyboardFrame = [[[paramNotification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        keyboardHeight = keyboardFrame.size.height;
        
        isKeyboardOpen = YES;
        
        [NGUIUtility slideView:self.view toXPos:0 toYPos:self.view.frame.origin.y-keyboardHeight duration:0.25f delay:0.0f];
    }
}

-(void)keyboardDidHide {
    isKeyboardOpen = NO;
}
-(void)setAutomationLabels{
    [UIAutomationHelper setAccessibiltyLabel:@"ssa_btn" forUIElement:_ssaBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"jobAlert_btn" forUIElement:_jobAlertBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"ssa_btn" forUIElement:_ssaBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"email_txtFld" forUIElement:_emailTxtFld];[UIAutomationHelper setAccessibiltyLabel:@"error_lbl" value:_errorLbl.text forUIElement:_errorLbl];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    selfHeight = self.view.frame.size.height;
    navBarHeightAsPeriOS = NAVIGATION_BAR_HEIGHT;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.isAutomaticOpen) {
        [self ssaTapped:self.ssaBtn];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([loader isLoaderAvail]) {
        [loader hideAnimatior:self.view];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

#pragma mark -
#pragma mark Private Methods


/**
 *  Chaging app state to STATE_NONE while loading more/new jobs.
 */

-(void)showSendMoreJobs{
    self.state = STATE_NONE;
}

/**
 *  Displays job alert view.
 */

-(void)showJobAlertView{
    self.state = STATE_JOB_ALERT;
    
    self.jobAlertView.hidden = NO;
    self.errorLbl.hidden = YES;
    
    
    NSString *emailID_ = [NGSavedData getEmailID];
    if (![emailID_ isEqual:@""]) {
        self.emailTxtFld.text = emailID_;
    }
    
    [self.emailTxtFld setTextFieldStyle];
}

/**
 *  Displays modify job alert view.
 */

-(void)showModifyJobAlertView{
    self.state = STATE_MODIFY_ALERT;
    
    [self hideBlurViewTapped];
    
    [NGUIUtility showAlertWithTitle:@"Your search is very basic" withMessage:[NSArray arrayWithObject:@"You might receive jobs that are not exactly matching your need."] withButtonsTitle:@"Modify Alert, Save Anyway" withDelegate:self];
}
-(void)customAlertbuttonClicked:(NSInteger)index{
    
    [NGHelper sharedInstance].isAlertShowing = FALSE;
    
    if (0 == index) {
        //modifiy alert button pressed
        [self modifyAlertTapped:nil];
    }else if (1 == index){
        [self createAnywayTapped:nil];
    }else{
        //dummy
    }
}

/**
 *  Hide the blur view.
 */
-(void)hideBlurViewTapped
{
    if(self.isAutomaticOpen)
    {
        [NGUIUtility slideView:self.view toXPos:0 toYPos:SCREEN_HEIGHT+navBarHeightAsPeriOS duration:0.25f delay:0.0f];
    }
    else
    {
        [NGUIUtility slideView:self.view toXPos:0 toYPos:SCREEN_HEIGHT-navBarHeightAsPeriOS duration:0.25f delay:0.0f];
    }
    
    [self removeAllSSAViews];
}

- (void)hideSSAViewFromSuperView{
    [self hideBlurViewTapped];
}

/**
 *  Creates the SSA.
 */

-(void)createSSA{
    
    
    loader = [[NGLoader alloc] initWithFrame:self.view.superview.frame];
    [loader showAnimation:self.view.superview];
    
    NSInteger expParamOfSearch = [[_paramsDict objectForKey:@"Experience"] integerValue];
    NSString  *strExpParamOfSearch = expParamOfSearch<0 || expParamOfSearch==Const_Any_Exp_Tag?@"":[NSString stringWithFormat:@"%ld",(long)expParamOfSearch];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.paramsDict objectForKey:@"Keywords"],@"keyword",[self.paramsDict objectForKey:@"Location"],@"location",strExpParamOfSearch,@"workExpYr",emailID,@"emailId",@"srp_ios",@"ssaloc", nil];
    
    
    
    NSArray *nameAPIArr = [NSArray arrayWithObjects:@"titles",@"freshness",@"ctc",@"country",@"gender",@"expRange",@"industry",@"citysrp",@"companyType", nil];
    
    NSArray *nameRequestArr = [NSArray arrayWithObjects:@"JobTitles",@"Freshness",@"ClusterCTC",@"ClusterCountry",@"ClusterGender",@"ClusterExperience",@"ClusterInd",@"ClusterCity",@"CompanyType", nil];
    
    
    for (NSInteger i = 0; i<nameAPIArr.count; i++) {
        NSString *nameAPI = [nameAPIArr fetchObjectAtIndex:i];
        NSString *nameRequest = [nameRequestArr fetchObjectAtIndex:i];
        
        if ([self.paramsDict objectForKey:nameRequest]) {
            [params setCustomObject:[self.paramsDict objectForKey:nameRequest] forKey:nameAPI];
        }
    }
    
    __weak NGSSAView *weakView = self;
    __weak NGLoader *weakLoader = loader;
    
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SSA];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakLoader hideAnimatior:weakView.view.superview];
            
            if (responseData.isSuccess) {
                
                [NGMessgeDisplayHandler showSuccessBannerFromBottomWindow:nil title:@"Your Job Alert has been created." subTitle:@"We will email you matching Jobs" animationTime:2 showAnimationDuration:0.5];
            }else{
                if ([responseData responseCode] == K_RESPONSE_ERROR) {
                    @try{
                        NSDictionary *errorDic = [[responseData parsedResponseData] objectForKey:@"error"];
                        NSString *errorTitle = [errorDic objectForKey:@"message"];
                        NSArray *errorArray = (NSArray*)[errorDic objectForKey:@"validationErrorDetails"];
                        NSString *errorMessage = [[[errorArray firstObject] objectForKey:@"emailId"] objectForKey:@"message"];
                        if (errorMessage) {
                            [NGUIUtility showAlertWithTitle:errorTitle withMessage:@[@"Email Id is incorrect"] withButtonsTitle:@"Ok" withDelegate:nil];
                        }
                    }@catch(NSException *ex){
                        [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[@"Some error occurred at server"] withButtonsTitle:@"Ok" withDelegate:nil];
                    }
                }
            }
        });
    }];
    
    
    [NGUIUtility slideView:self.view toXPos:0 toYPos:SCREEN_HEIGHT+navBarHeightAsPeriOS duration:0.25f delay:0.0f];
    
    [self removeAllSSAViews];
}


//Removes the Job alert view.

-(void)removeJobAlertView{
    self.jobAlertView.hidden = YES;
    [self.emailTxtFld setTextFieldStyle];
    [self.emailTxtFld resignFirstResponder];
}


//Removes all the SSA views(JobAlert View & ModifyAlert View )

-(void)removeAllSSAViews{
    
    APPDELEGATE.container.leftMenuPanEnabled=YES;
    
    [self removeJobAlertView];
    
    [[NGAnimator sharedInstance] removeBlurrView:self.blurrView];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:11];
    if (btn) {
        btn.tag = 10;
    }
    
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)ssaTapped:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag==10) {
        btn.tag = 11;
        if ([[NGHelper sharedInstance] isUserLoggedIn])
        {
            [self jobAlertTapped:self.jobAlertBtn];
            
            return;
        }
        else
        {
            [self showJobAlertView];
        }
        
        [NGUIUtility slideView:self.view toXPos:0 toYPos:SCREEN_HEIGHT - (selfHeight+navBarHeightAsPeriOS) duration:0.25f delay:0.0f];
        
        self.blurrView = [[NGAnimator sharedInstance] showBlurrView];
        
        APPDELEGATE.container.leftMenuPanEnabled=NO;
        
        [self.view.superview insertSubview:self.blurrView belowSubview:self.view];
        
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlurViewTapped)];
        self.blurrView.userInteractionEnabled=YES;
        [self.blurrView addGestureRecognizer:tapGesture];
        
    }else{
        btn.tag = 10;
        if (self.isAutomaticOpen) {
            [NGUIUtility slideView:self.view toXPos:0 toYPos:SCREEN_HEIGHT+navBarHeightAsPeriOS duration:0.25f delay:0.0f];
        }else{
            [NGUIUtility slideView:self.view toXPos:0 toYPos:SCREEN_HEIGHT-navBarHeightAsPeriOS duration:0.25f delay:0.0f];
        }
        
        [self removeAllSSAViews];
    }
    
    
}

-(IBAction)jobAlertTapped:(id)sender{
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_SAVE_ALERT withEventLabel:K_GA_EVENT_SAVE_ALERT withEventValue:nil];
    
    if ([[ NGHelper sharedInstance] isUserLoggedIn])
    {
        emailID=[NGSavedData getEmailID];
        if ([NGDecisionUtility isLooseCriteria:self.paramsDict]) {
            
            
            APPDELEGATE.container.leftMenuPanEnabled=NO;
            
            [self showModifyJobAlertView ];
        }else{
            [self createSSA];
        }
        return;
    }
    
    [self.emailTxtFld stripWhiteSpace];
    if ([NGDecisionUtility isValidEmail:self.emailTxtFld.text]) {
        emailID = self.emailTxtFld.text;
        [NGSavedData saveEmailID:self.emailTxtFld.text];
        
        [self removeJobAlertView];
        
        if ([NGDecisionUtility isLooseCriteria:self.paramsDict]) {
            
            [self showModifyJobAlertView ];
        }else{
            [self createSSA];
        }
        
        
    }else{
        self.emailTxtFld.layer.borderColor=[[UIColor colorWithRed:200.0/255.0f green:129.0/255.0f blue:132.0/255.0f alpha:1.0f]CGColor];
        self.errorLbl.hidden = NO;
    }
}


-(void)modifyAlertTapped:(id)sender{
    
    [NGUIUtility slideView:self.view toXPos:0 toYPos:SCREEN_HEIGHT+navBarHeightAsPeriOS duration:0.25f delay:0.0f];
    
    
    NGSearchJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JobSearch"];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setCustomObject:[self.paramsDict objectForKey:@"Keywords"] forKey:@"Keywords"];
    [paramsDict setCustomObject:emailID forKey:@"EmailID"];
    navgationController_.inputParams = paramsDict;
    navgationController_.comingVia = K_GA_SEARCH_RESULT_PAGE;
    navgationController_.classType = K_CLASS_MODIFY_SEARCH;
    
    IENavigationController *navVC = (IENavigationController *)APPDELEGATE.container.centerViewController;
    [navVC  pushActionViewController:navgationController_ Animated:YES ];
}

-(void)createAnywayTapped:(id)sender{
    [self createSSA];
}



#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.state = STATE_ENTER_EMAIL;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.state = STATE_JOB_ALERT;
    
    if (!isKeyboardOpen) {
        [NGUIUtility slideView:self.view toXPos:0 toYPos:self.view.frame.origin.y+keyboardHeight duration:0.25f delay:0.0f];
    }
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.state = STATE_JOB_ALERT;
    [NGUIUtility slideView:self.view toXPos:0 toYPos:self.view.frame.origin.y+keyboardHeight duration:0.25f delay:0.0f];
    [textField resignFirstResponder];
    return YES;
}


#pragma mark JobManager Delegate
-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    [loader hideAnimatior:self.view.superview];
    [NGMessgeDisplayHandler showSuccessBannerFromBottomWindow:nil title:@"Your Job Alert has been created." subTitle:@"We will email you matching Jobs" animationTime:2 showAnimationDuration:0.5];
}
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [loader hideAnimatior:self.view.superview];
    
    if ([responseData responseCode] == K_RESPONSE_ERROR) {
        @try{
            NSDictionary *errorDic = [[responseData parsedResponseData] objectForKey:@"error"];
            NSString *errorTitle = [errorDic objectForKey:@"message"];
            NSArray *errorArray = (NSArray*)[errorDic objectForKey:@"validationErrorDetails"];
            NSString *errorMessage = [[[errorArray firstObject] objectForKey:@"emailId"] objectForKey:@"message"];
            if (errorMessage) {
                [NGUIUtility showAlertWithTitle:errorTitle withMessage:@[@"Email Id is incorrect"] withButtonsTitle:@"Ok" withDelegate:nil];
            }
        }@catch(NSException *ex){
            [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[@"Some error occurred at server"] withButtonsTitle:@"Ok" withDelegate:nil];
        }
    }
}

@end
