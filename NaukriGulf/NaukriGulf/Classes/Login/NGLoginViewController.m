//
//  NGLoginViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 02/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLoginViewController.h"
#import "NGResetPasswordViewController.h"
#import "NGFormCell.h"
#import "NGResmanLoginDetailsViewController.h"

NSString * const K_ALERT_MSG = @"If you have trouble filling this form on mobile, you can always register later from our Desktop site";
NSString * const K_ALERT_TITLE = @"Redirecting to mobile site";

@interface NGLoginViewController ()<LoginHelperDelegate>
{
   NGResetPasswordViewController *passwordResetVC ;
   LOGINVIEWTYPE currentViewType;
   NGLoader* loader;
   BOOL wouldDissappear;
    __weak IBOutlet UIButton *applyWithoutRegisterationBtn;
}
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (strong, nonatomic)  NGTextField *txtEmailID;
@property (strong, nonatomic)  NGTextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblForgetPassword;
@property (weak, nonatomic) IBOutlet UIView *viewForLoginToApply;
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *commonBtn;
@property (weak, nonatomic) IBOutlet UIView *shakecontainerView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end



@implementation NGLoginViewController

int const tagIndexConstant = 200;

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    [AppTracer traceStartTime:TRACER_ID_LOGIN];
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
   
    UITapGestureRecognizer *tapLabelForForgetPassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoResetPassword)];
    [self.lblForgetPassword addGestureRecognizer:tapLabelForForgetPassword];
    
    [self getStyleOnPage];
    
    NSMutableDictionary* dictForEmail=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:VALIDATION_TYPE_EMPTY],@"Validation Type",ERROR_MESSAGE_EMPTY_EMAIL,@"Error Message",[NSValue valueWithCGRect:self.txtPassword.frame],KEY_FRAME, nil];
    [self.txtEmailID setValidation:dictForEmail];
    
    
    if ([NGDecisionUtility isValidString:_titleForLoginView]) {
        [self addNavigationBarWithCloseBtnWithTitle:_titleForLoginView];
    }else{
        [self addNavigationBarWithCloseBtnWithTitle:@"Login"];
    }
    
    [applyWithoutRegisterationBtn setHidden:TRUE];
    
    if(currentViewType == LOGINVIEWTYPE_APPLY_VIEW){

        [self.commonBtn setTitle:@"Register and Apply" forState:UIControlStateNormal];
        [applyWithoutRegisterationBtn setHidden:FALSE];
    }
    
    [self initializeAccessibilityLabels];
    
    self.isSwipePopGestureEnabled = NO;
    self.isSwipePopDuringTransition = NO;
    
}

-(void)initializeAccessibilityLabels {
    [UIAutomationHelper setAccessibiltyLabel:@"email_txtFld" forUIElement:self.txtEmailID];
    [UIAutomationHelper setAccessibiltyLabel:@"password_txtFld" forUIElement:self.txtPassword];
    [UIAutomationHelper setAccessibiltyLabel:@"forgotpassword_lbl" value:self.lblForgetPassword.text forUIElement:self.lblForgetPassword];
    [UIAutomationHelper setAccessibiltyLabel:@"register_btn" value:self.commonBtn.titleLabel.text forUIElement:self.commonBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"login_btn" value:self.loginButton.titleLabel.text forUIElement:self.loginButton];
    [UIAutomationHelper setAccessibiltyLabel:@"error_view" forUIElement:self.errorView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    if(self.isSwipePopDuringTransition)
        return;
    [super viewWillAppear:animated];
   
    [self hideKeyboardOnTapOutsideKeyboard];
    
    //Adding view for acknowledging the user
    //that password reset link has been sent to his emailid.
    if (passwordResetVC.isResetPasswordClicked)
    {
        [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:[NGSavedData getForgetPasswordMessage] animationTime:7 showAnimationDuration:0.5];
            passwordResetVC.isResetPasswordClicked=FALSE;
    }
    [NGDecisionUtility checkNetworkStatus];

}

-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    [super viewDidAppear:animated];
    [NGHelper sharedInstance].appState = APP_STATE_LOGIN;
    [AppTracer traceEndTime:TRACER_ID_LOGIN];
    
    if (self.showAlreadyRegisteredError)
    {
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"This email id is already registered with Naukrigulf. Please Login or Retrieve your password." animationTime:7 showAnimationDuration:0.5];
        self.showAlreadyRegisteredError = NO;
    }
}

#pragma mark - Memory Management
- (void)viewDidUnload {
    [super viewDidUnload];
    [self setErrorView:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    wouldDissappear = YES;
    if ([loader isLoaderAvail]) {
        [loader hideAnimatior:self.view];
    }
    [AppTracer clearLoadTime:TRACER_ID_LOGIN];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)loginClicked:(id)sender {
    
    
     self.navigationItem.rightBarButtonItem.enabled = NO;
    [_txtEmailID resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    [self.txtEmailID stripWhiteSpace];
    
    BOOL isValidEmailString = [NGDecisionUtility isTextFieldNotEmpty:_txtEmailID.text];
    BOOL isValidPasswordString = [NGDecisionUtility isTextFieldNotEmpty:_txtPassword.text];
    
    
    if (isValidEmailString && isValidPasswordString) {
        
        if ([NGDecisionUtility isValidEmail:_txtEmailID.text]) {
            
            loader = [[NGLoader alloc] initWithFrame:self.view.frame];
            [loader showAnimation:self.view];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_txtEmailID.text,@"username",_txtPassword.text,@"password", nil];
            
            [self.view endEditing:YES];
            __weak NGLoginViewController *mySelfVC = self;
            __weak NGLoader *weakLoader = loader;

            [AppTracer traceStartTime:TRACER_ID_MNJ_DASHBOARD];

            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_LOGIN];
            
            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
                    if (responseData.isSuccess) {
                        
                        NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
                        
                        NSString *conMnj = [responseDataDict objectForKey:KEY_LOGIN_CONMNJ]?[responseDataDict objectForKey:KEY_LOGIN_CONMNJ]:[responseDataDict objectForKey:KEY_LOGIN_AUTH];
                        [NGLoginHelper sharedInstance].delegate = mySelfVC;
                        [NGLoginHelper sharedInstance].conMnj = conMnj;
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [mySelfVC hideErrorView];
                            
                            
                        });
                        
                    }else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.navigationItem.rightBarButtonItem.enabled = YES;
                            [weakLoader hideAnimatior:mySelfVC.view];
                            if (responseData.responseCode == 401) {
                                [self showErrorView];
                                return ;
                            }
                            
                            ValidatorManager *vManager = [ValidatorManager sharedInstance];
                            NSString *userMessage = @"Some technical error occurred at Server!!";
                            if (0 >= [vManager validateValue:responseData.statusMessage withType:ValidationTypeString].count) {
                                userMessage = responseData.statusMessage;
                            }
                            
                            [NGUIUtility showAlertWithTitle:@"Invalid Details" withMessage:@[userMessage] withButtonsTitle:@"OK" withDelegate:nil];
                            
                        });
                        
                    }
                
            }];
            
        }else{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [NGUIUtility showAlertWithTitle:@"Incorrect Details" withMessage:@[@"Please specify valid Email Id"] withButtonsTitle:@"OK" withDelegate:nil];
        }
        
        
    }else{
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (!isValidEmailString && !isValidPasswordString) {
            [NGUIUtility showAlertWithTitle:@"Incorrect Details" withMessage:@[@"Please specify Email Id and Password"] withButtonsTitle:@"OK" withDelegate:nil];
        }else if (!isValidEmailString) {
            [NGUIUtility showAlertWithTitle:@"Incorrect Details" withMessage:@[@"Please specify Email Id"] withButtonsTitle:@"OK" withDelegate:nil];
        }else if (!isValidPasswordString){
            [NGUIUtility showAlertWithTitle:@"Incorrect Details" withMessage:@[@"Please specify Password"] withButtonsTitle:@"OK" withDelegate:nil];
        }else{
            //dummy
        }
        
        
    }
    
 }

- (IBAction)newUserApplyClicked:(UIButton *)sender {
    
    [self dismissKeyboardOnTap];
    if(currentViewType == LOGINVIEWTYPE_APPLY_VIEW){
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_REGISTER_FROM_LOGIN withEventLabel:K_GA_EVENT_REGISTER_FROM_LOGIN_APPLY withEventValue:nil];
        [NGHelper sharedInstance].isResmanViaApply= YES;
        
    }else{
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_REGISTER_FROM_LOGIN withEventLabel:K_GA_EVENT_REGISTER_FROM_LOGIN withEventValue:nil];
       
        [NGHelper sharedInstance].isResmanViaApply= NO;
    }
    
    NGResmanLoginDetailsViewController *resmanVc = [[NGResmanLoginDetailsViewController alloc] initWithNibName:nil bundle:nil];
    [(IENavigationController*)self.navigationController pushActionViewController:resmanVc Animated:YES];
    
}

#pragma mark login helper delegate
-(void)doneFetchingProfile:(NGMNJProfileModalClass *)profileModal{
    
    [loader hideAnimatior:self.view];

    if ([NGSpotlightSearchHelper sharedInstance].isComingFromSpotlightSearch){
        
        [[NGSpotlightSearchHelper sharedInstance] handleSpotlightItemClick];
        [NGSpotlightSearchHelper sharedInstance].isComingFromSpotlightSearch = NO;
    }
    
    else{
        
        if (currentViewType == LOGINVIEWTYPE_REGISTER_VIEW)
            [[NGLoginHelper sharedInstance]showMNJHome];
        else
            [self loggedInApply];
    }
  
    
    [NGLoginHelper sharedInstance].delegate = nil;

}

#pragma mark - Public Methods
/**
 *  @name Public Methods
 */
/**
 *  Login view consist of two types * (Apply Views / Register Views)
 *  Method shows the login view  according to the type declared
 *  @param viewType enum values are for showing current view type
 */
-(void)showViewWithType:(LOGINVIEWTYPE)viewType{
    
    if(viewType == LOGINVIEWTYPE_APPLY_VIEW){
        currentViewType = LOGINVIEWTYPE_APPLY_VIEW;
    }
    else{
        currentViewType = LOGINVIEWTYPE_REGISTER_VIEW;
    }
}

#pragma mark - Private Methods
/**
 *  @name Private Methods
 */
/**
 *  Method used for dismissing the keyboard
 */
-(void)dismissKeyboardOnTap {
    
    [self.txtEmailID resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}
/**
 *  Method is called on pressing the save Button and initiate a service request for saving this information to server.
 *
 *  @param sender NGButton
 */
-(void)closeTapped:(id)sender{
}

/**
 *  Method used to update the view presented by updating the background color , txtEmailID,txtPassword.
 */
-(void)getStyleOnPage {
    [self.txtEmailID setTextFieldStyle];
    [self.txtPassword setTextFieldStyle];
     self.txtPassword.secureTextEntry=YES;
}
/**
 *  This method is used to reset the password  by navigating to NGResetPasswordViewController fo
 */
-(void)gotoResetPassword {
    [self.txtEmailID resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    passwordResetVC = [[NGHelper sharedInstance].othersStoryboard instantiateViewControllerWithIdentifier:@"ResetPassword"];
    [(IENavigationController*)self.navigationController pushActionViewController:passwordResetVC Animated:YES];
}

/**
 *  This method is used to update secureTextEntry of textField
 *
 *  @param textField UITextField object.
 */
-(void) toggleTextFieldSecureEntry: (UITextField*) textField {
    BOOL isFirstResponder = textField.isFirstResponder; //store whether textfield is firstResponder
    
    if (isFirstResponder) [textField resignFirstResponder]; //resign first responder if needed, so that setting the attribute to YES works
    textField.secureTextEntry = !textField.secureTextEntry; //change the secureText attribute to opposite
    if (isFirstResponder) [self.txtPassword becomeFirstResponder]; //give the field focus again, if it was first responder initially
}
/**
 *   A Method on trigger generates the request for login in th application.
 */
-(void)loggedInApply{
    
    [self dismissKeyboardOnTap];
    NGJobsHandlerObject *obj =  [[NGJobsHandlerObject alloc]init];
    obj.openJDLocation =  self.openJDLocation;
    obj.Controller =  self;
    obj.jobObj =  self.jobObj;
    obj.applyState = LoginApplyStateRegisterd;
    [[NGApplyJobHandler sharedManager] jobHandlerAppliedForFinalStep:obj];
    
    
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:NO];
}

/**
 *   Method display error if username or password are not correct and show shake animation
 */
-(void)showErrorView {
    
    [NGUIUtility showAlertWithTitle:@"Invalid Details" withMessage:@[@"Invalid Email Id or Password"] withButtonsTitle:@"OK" withDelegate:nil];
    
}

/**
 *  Method to hide the current executed error
 */
-(void)hideErrorView {
    if (!self.errorView.hidden){
        NSArray *subViewsInScrollView = [self.containerView subviews];
        
        for (UIView *subview in subViewsInScrollView)
        {
            CGRect frame = subview.frame;
            frame.origin.y-=40;
            subview.frame = frame;
        }
        self.errorView.hidden=YES;
        self.txtEmailID.viewFrame=self.txtEmailID.frame;
        [self.containerScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-40)];
    }
}

/**
 *  A Custom animation generates shake effect using CA Layer on error
 */
- (void)showShakeAnimationOnErrorValidation {

    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = 2;
    shakeAnimation.duration = 0.1;
    shakeAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0, 0.0, 0.0)],[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0, 0.0, 0.0)], nil];
    [self.shakecontainerView.layer addAnimation:shakeAnimation forKey:nil];
    [self dismissKeyboardOnTap];
    self.txtEmailID.layer.borderColor=[UIColorFromRGB(0xaaaaaa)CGColor];
    self.txtPassword.layer.borderColor=[UIColorFromRGB(0xaaaaaa)CGColor];
}

#pragma mark - Tableview delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexRow = [indexPath row];
    if (0 == indexRow || 1 == indexRow) {
        //username and password fields
        NGFormCell *cell = (NGFormCell*)[tableView dequeueReusableCellWithIdentifier:@"loginInputCell"];
        [cell configureDataForInputType:loginForm index:indexRow];
        
        if (0==indexRow) {
            
            cell.inputTextField.text = [NGSavedData getEmailID];
            _txtEmailID = [cell inputTextField];
            [_txtEmailID setReturnKeyType:UIReturnKeyNext];

        }else if (1 == indexRow){
            _txtPassword = [cell inputTextField];
            [cell.inputTextField displayHideBtn:FALSE];
            [_txtPassword setReturnKeyType:UIReturnKeyGo];
        }else{
            //dummy
        }
        [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
        
        return cell;
    }else if (2 == indexRow){
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"loginForgotPwdCell"];
        return cell;

    }else{
        //dummy
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2){
        //for forgot password
        return 43;
    }
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[NGFormCell class]])
    {
        NGTextField* txtField = ((NGFormCell*)cell).inputTextField;
        if(![txtField isFirstResponder]){}
    }
}
#pragma mark - UITextField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _txtPassword) {
        
        NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        textField.text = updatedString;
        
        return NO; // imp to fix live bug (hide button overwrites last pasword text)
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _txtEmailID){
        
        [_txtPassword becomeFirstResponder];
    }
    
    else if(textField == _txtPassword){
        
        [textField resignFirstResponder];
        
        [self loginClicked:nil];
    }
    return YES;
}
- (IBAction)forgotPasswordPressed:(id)sender{
   
    [self gotoResetPassword];
}


- (IBAction)applyWithRegistrationClicked:(id)sender {

    NGJobsHandlerObject *obj =  [[NGJobsHandlerObject alloc]init];
    obj.jobObj = self.jobObj;
    obj.openJDLocation =  self.openJDLocation;
    obj.viewLoadingStartTime = nil;
    obj.Controller =  self;
    obj.applyState =  LoginApplyStateUnRegistered;
    [[NGApplyJobHandler sharedManager] jobHandlerWithNewUserApply:obj];


}

@end
