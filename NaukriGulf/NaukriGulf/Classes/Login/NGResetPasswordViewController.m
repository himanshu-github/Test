//
//  NGResetPasswordViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 02/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGResetPasswordViewController.h"
#import "NGFormCell.h"

@interface NGResetPasswordViewController ()
{
    NGLoader* loader; // Use a Custom animator to show that a task is in progress
    BOOL wouldDissappear;
    NSInteger tagIndexForResetPassword;

}
@property (weak, nonatomic) IBOutlet NGTextField *txtEmailID;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@property (weak, nonatomic) IBOutlet UIView *forgetPasswordView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation NGResetPasswordViewController


#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
   
    [AppTracer traceStartTime:TRACER_ID_RESET_PASSWORD];
    
    [super viewDidLoad];
    
    tagIndexForResetPassword=200;
    
    [self addNavigationBarWithBackBtnWithTitle:@"Reset Password"];
    
    [self.txtEmailID setTextFieldStyle];
    NSMutableDictionary* dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:VALIDATION_TYPE_EMPTY],@"Validation Type",ERROR_MESSAGE_EMPTY_EMAIL,@"Error Message",[NSValue valueWithCGRect:self.txtEmailID.frame],KEY_FRAME, nil];
    [self.txtEmailID setValidation:dict];
    [self initializeAccessibilityLabels];
    
}

-(void)initializeAccessibilityLabels {
    [UIAutomationHelper setAccessibiltyLabel:@"email_txtFld" forUIElement:self.txtEmailID];
    [UIAutomationHelper setAccessibiltyLabel:@"submit_btn" forUIElement:self.submitButton];
    [UIAutomationHelper setAccessibiltyLabel:@"errormessage_lbl" value:self.errorMessage.text forUIElement:self.errorMessage];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
     self.isResetPasswordClicked=FALSE;
    [NGGoogleAnalytics sendScreenReport:K_GA_FORGOT_PASSWORD_SCREEN];
    
    [AppTracer traceEndTime:TRACER_ID_RESET_PASSWORD];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    wouldDissappear = YES;
    if ([loader isLoaderAvail]) {
        [loader hideAnimatior:self.view];
    }
    
    [AppTracer clearLoadTime:TRACER_ID_RESET_PASSWORD];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - IBActions

- (IBAction)resetPasswordLinkSent:(id)sender {
    
    [_txtEmailID stripWhiteSpace];
    NSString* emailID = [_txtEmailID text];
    
    if (emailID.length == 0){
        [NGUIUtility showAlertWithTitle:@"Incomplete Details"
                         withMessage:[NSArray arrayWithObjects:@"Please enter your email.", nil] withButtonsTitle:@"OK" withDelegate:nil];
    }else if([NGDecisionUtility isValidEmail:emailID]){
        [self sendForgetPasswordLink];
    }else{
        [NGUIUtility showAlertWithTitle:@"Incorrect Details!"
                         withMessage:[NSArray arrayWithObjects:@"Invalid email Id", nil] withButtonsTitle:@"OK" withDelegate:nil];
    }
    
}

#pragma mark - Private Methods
/**
 *  @name Private Methods
 */
/**
 *   Method basically generates request with SERVICE_TYPE_FORGET_PASSWORD and show animation with loader for that duration
 */
-(void)sendForgetPasswordLink {
   
    [self.txtEmailID resignFirstResponder];
    loader = [[NGLoader alloc] initWithFrame:self.view.frame];
    [loader showAnimation:self.view];
    
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    [params setValue:self.txtEmailID.text forKey:@"email"];
    
    __weak NGResetPasswordViewController *weakVC = self;
    __weak NGLoader *weakLoader = loader;
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_FORGET_PASSWORD];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        
        if(responseData.isSuccess){
            
            [NGSavedData saveForgetPasswordMessage:FORGOT_PASSWORD_SUCCESS_MESSAGE];
            
            weakVC.isResetPasswordClicked=TRUE;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakLoader hideAnimatior:weakVC.view];
                [weakVC.navigationController popViewControllerAnimated:YES];
            });
            
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [NGUIUtility showAlertWithTitle:@"Invalid Details"
                                 withMessage:[NSArray arrayWithObjects:@"The Email/Username entered is not in our records.", nil] withButtonsTitle:@"Ok" withDelegate:nil];
                
                [weakLoader hideAnimatior:weakVC.view];
            });
        }
        
    }];
}

/**
 *  Method shows error view with the error from response data
 */
-(void)showErrorView {
    
    if (self.errorView.hidden)
    {
        NSArray *subViewsInScrollView = [self.forgetPasswordView subviews];
        
        for (UIView *subview in subViewsInScrollView)
        {
            CGRect frame = subview.frame;
            frame.origin.y+=45;
            subview.frame = frame;
            
        }
        self.errorView.hidden=NO;
        self.txtEmailID.viewFrame=self.txtEmailID.frame;

    }
}

/**
 *  Method hides the error view if it is displayed
 */
-(void)hideErrorView {
    if (!self.errorView.hidden){
        NSArray *subViewsInScrollView = [self.forgetPasswordView subviews];
        
        for (UIView *subview in subViewsInScrollView)
        {
            CGRect frame = subview.frame;
            frame.origin.y-=45;
            subview.frame = frame;
        }
        
        self.errorView.hidden=YES;
        self.txtEmailID.viewFrame=self.txtEmailID.frame;
    }
    
}
#pragma mark - Tableview delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexRow = [indexPath row];
    if (0 == indexRow) {
        //username and password fields
        NGFormCell *cell = (NGFormCell*)[tableView dequeueReusableCellWithIdentifier:@"forgotPwdInputCell"];
        [cell configureDataForInputType:forgotPwd index:indexRow];
        
        if (0==indexRow) {
            cell.inputTextField.text = [NGSavedData getEmailID];
            _txtEmailID = [cell inputTextField];
        }else{
            //dummy
        }
        [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
        
        return cell;
    }else{
        //dummy
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    long rowEditing = textField.tag-tagIndexForResetPassword;
    
    float inset = IS_IPHONE5?220:240;
    
    
    [_formTableView setContentInset:UIEdgeInsetsMake(0, 0, inset, 0)];
    
    [_formTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:rowEditing inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row = textField.tag-tagIndexForResetPassword+1;
    BOOL shouldRestoreInset = NO;
    if(row <= [_formTableView numberOfRowsInSection:0])
    {
        NGFormCell *cell = (NGFormCell *)[_formTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if([cell isKindOfClass:[NGFormCell class]])
        {
            NGTextField* nxnTxtField = (NGTextField*)[cell.contentView viewWithTag:row+tagIndexForResetPassword];
            if([nxnTxtField isKindOfClass:[NGTextField class]])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(!wouldDissappear){}
                });
                
            }
            
        }
        else
            shouldRestoreInset = YES;
    }
    else
        shouldRestoreInset = YES;
    
    if(shouldRestoreInset)
        [_formTableView setContentInset:UIEdgeInsetsZero];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)backButtonClicked:(id)sender{
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
}
@end
