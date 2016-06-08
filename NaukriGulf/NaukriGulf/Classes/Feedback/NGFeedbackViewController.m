//
//  NGFeedbackViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 01/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGFeedbackViewController.h"

#import "NGFormCell.h"
@interface NGFeedbackViewController ()
{
    NGLoader* loader; // Use a Custom animator to show that a task is in progress
    __weak IBOutlet UITableView *formTableView;
    
    NSString *feedback;
    NSString *email;
    NSString *name;
    
}
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic)  UITextView *txtViewFeedback;
@property (weak, nonatomic)  NGTextField *txtEmail;
@property (weak, nonatomic)  NGTextField *txtFullName;

@end

@implementation NGFeedbackViewController

NSString* const feedbackPlaceholder = @"Your Valuable Feedback";

int const tagIndex = 200;

#pragma mark - ViewController LifeCycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad {
    
    
    [AppTracer traceStartTime:TRACER_FEEDBACK_VIEW_CONTROLLER];
    
    [super viewDidLoad];
    
  
    if([[NGHelper sharedInstance] isUserLoggedIn]) {
    
        [self addNavigationBarWithCloseBtnWithTitle:@"Feedback"];
 
    }
    else{
        
        [self addNavigationBarWithCloseBtnWithTitle:@"Contact Us"];
      }
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    

}


-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    [NGHelper sharedInstance].appState = APP_STATE_FEEDBACK;
    [super viewDidAppear:animated];
    [self hideKeyboardOnTapOutsideKeyboard];
    
    [NGGoogleAnalytics sendScreenReport:K_GA_FEEDBACK_SCREEN];
    feedback=@"";
    email=@"";
    name=@"";
    
    [AppTracer traceEndTime:TRACER_FEEDBACK_VIEW_CONTROLLER];
}

-(void)viewWillAppear:(BOOL)animated {
    if(self.isSwipePopDuringTransition)
        return;
    [super viewWillAppear:YES];
    [NGAppDelegate appDelegate].container.leftMenuPanEnabled = NO;
    [NGDecisionUtility checkNetworkStatus];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NGAppDelegate appDelegate].container.leftMenuPanEnabled = YES;
    
    if ([loader isLoaderAvail]) {
        [loader hideAnimatior:self.view];
    }
    
    [AppTracer clearLoadTime:TRACER_FEEDBACK_VIEW_CONTROLLER];
}

#pragma mark - Memoey Management
-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
      [super releaseMemory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)sendFeedback:(id)sender {
    
    [self.view endEditing:YES];
    
    if(![self checkForRequiredFields])
    {
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_SEND_FEEDBACK withEventLabel:K_GA_EVENT_SEND_FEEDBACK withEventValue:nil];
        
        NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
        
        feedback=[NSString stripTags:feedback];
        feedback=[NSString formatSpecialCharacters:feedback];
        feedback = [feedback trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [params setValue:feedback forKey:@"comment"];
        NSString *iosInfo = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion]];
        [params setValue:iosInfo forKey:@"mtype"];
        
        [params setValue:@"iOS App Feedback" forKey:@"subject"];
        
        if ([[NGHelper sharedInstance] isUserLoggedIn])
        {
            [params setValue:[[NGSavedData getUserDetails] valueForKey:@"name"] forKey:@"name"];
            [params setValue:[NGSavedData getEmailID] forKey:@"email"];
        }
        else
        {
            [params setValue:name forKey:@"name"];
            [params setValue:email forKey:@"email"];
        }
        
        
        loader = [[NGLoader alloc] initWithFrame:self.view.frame];
        [loader showAnimation:self.view];
        
        
        __weak NGFeedbackViewController *weakVC = self;
        __block UITextView *weakTxtViewFeedback = self.txtViewFeedback;
        __block UITextField *weakTxtEmail = self.txtEmail;
        __block UITextField *weakTxtFullName = self.txtFullName;
        __weak NGLoader *weakLoader = loader;
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_FEEDBACK];
        
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(responseData.isSuccess){
                    
                    [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Thank you for your feedback. Your message has been sent" animationTime:3 showAnimationDuration:0.5];
                    weakTxtViewFeedback.text = feedbackPlaceholder;
                    weakTxtEmail.text = nil;
                    weakTxtFullName.text   = nil;
                    [weakLoader hideAnimatior:weakVC.view];
                    
                }else{
                    if ([responseData responseCode] == K_RESPONSE_ERROR) {
                        @try{
                            NSDictionary *errorDic = [[[responseData responseData] JSONValue] objectForKey:@"error"];
                            NSString *errorTitle = [errorDic objectForKey:@"message"];
                            NSArray *errorArray = (NSArray*)[errorDic objectForKey:@"validationErrorDetails"];
                            NSString *errorMessage = [[[errorArray firstObject] objectForKey:@"email"] objectForKey:@"message"];
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
        
        
        feedback=@"";
        email=@"";
        name=@"";
    }
}


#pragma mark - Private Methods
/**
 *  @name Private Methods
 */
/**
 *   This method is used for dismissing Keyboard on all the textFields,
 */
- (void)dismissKeyboardOnTap {
    [self.txtEmail resignFirstResponder];
    [self.txtFullName resignFirstResponder];
    [self.txtViewFeedback resignFirstResponder];
   
}


/**
 *  Method used for checking the validtion on txtViewFeedback,txtEmail
 *
 *  @return If Yes, validation is applied.
 */
- (BOOL)checkForRequiredFields {
    
    BOOL isInvalidData = FALSE;
 
    NSMutableArray *errorArr = [[NSMutableArray alloc] init];
    NSMutableArray *invalidArr = [[NSMutableArray alloc] init];
  
    feedback=[NSString tripWhiteSpace:feedback];
    
    if([feedback isEqualToString:@""] || [feedback isEqualToString:feedbackPlaceholder])
	{
        [errorArr addObject:@"Feedback"];
        isInvalidData=TRUE;
    }

    if(![[NGHelper sharedInstance] isUserLoggedIn]){
        
        if(self.txtFullName.text.length>0){
            
            self.txtFullName.validationType = VALIDATION_TYPE_SPECIALCHAR_OR_NUMERIC;
            if ([NGDecisionUtility doesStringContainSpecialCharOrNumeric:self.txtFullName.text]){
                isInvalidData= YES;
                [invalidArr addObject:@"Name"];
            }
        }

        if (email.length>0)
        {
            self.txtEmail.validationType = VALIDATION_TYPE_VALIDEMAIL;
            if (![NGDecisionUtility isValidEmail:email])
            {
                isInvalidData= YES;
                [invalidArr addObject:@"Email"];
            }
            
        }
        
      }

    NSString *msg =@"";
    
    if(errorArr.count > 0) {
        msg = [NSString stringWithFormat:@"Please enter %@", [errorArr objectAtIndex:0]];
        [errorArr removeObjectAtIndex:0];
      
        for(NSString *err in errorArr){
             msg = [msg stringByAppendingString:[NSString stringWithFormat:@", %@",err]];
        }
        
    }else if (invalidArr.count > 0) {
        
        msg = [NSString stringWithFormat:@"Please enter valid %@", [invalidArr objectAtIndex:0]];
        [invalidArr removeObjectAtIndex:0];
        
        for(NSString *err in invalidArr){
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@", %@",err]];
        }
        
        
    }
    if(msg.length > 0) {
   
        [NGUIUtility showAlertWithTitle:@"Incomplete Details!" withMessage:
         [NSArray arrayWithObjects:msg, nil]
                    withButtonsTitle:@"OK" withDelegate:nil];
        
         return YES;
    }
       return isInvalidData;
}



#pragma mark - Tableview delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([[NGHelper sharedInstance] isUserLoggedIn]){
    
        return 1;
    }
    else{
        
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCell"];
        UITextView* txtView = ((UITextView*)[cell.contentView viewWithTag:tagIndex+indexPath.row]);
        if ([[NGHelper sharedInstance] isUserLoggedIn]) {
          
            [txtView setReturnKeyType:UIReturnKeyDone];
       
        }else{
            
            [txtView setReturnKeyType:UIReturnKeyNext];
            
        }
        
        [UIAutomationHelper setAccessibiltyLabel:@"feedback_txtView" forUIElement:txtView];
        return cell;
    }
    else
    {
        NGFormCell *cell = (NGFormCell*)[tableView dequeueReusableCellWithIdentifier:@"inputCell"];
        [cell configureDataForInputType:contactUs index:indexPath.row];
        switch (indexPath.row) {
            case 1:
                self.txtFullName = cell.inputTextField;
                cell.inputTextField.returnKeyType  = UIReturnKeyNext;
                
                break;
                case 2:
                self.txtEmail =  cell.inputTextField;
                cell.inputTextField.returnKeyType  = UIReturnKeyDone;
                
            default:
                break;
        }
         
        return cell;
    }
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 200;
   
    else return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [formTableView setContentInset:UIEdgeInsetsZero];

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[NGFormCell class]])
    {
        NGTextField* txtField = ((NGFormCell*)cell).inputTextField;
        if(![txtField isFirstResponder]){}
    }
}

#pragma mark - textview delegates

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:feedbackPlaceholder])
        textView.text = @"";
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"])
     {
         
         if ([[NGHelper sharedInstance] isUserLoggedIn]) {
         
             [textView resignFirstResponder];
         } else{
             
             [self.txtFullName becomeFirstResponder];
         }

        return NO;
        
    }
    if (textView.text.length >= 280 && range.length == 0){
        return FALSE;
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{

    if([textView.text isEqualToString:@""])
        textView.text = feedbackPlaceholder;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:feedbackPlaceholder]) {
        [textView setText:@""];
    }
}


#pragma mark - UITextField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger rowEditing = textField.tag-tagIndex;
    
    float inset = IS_IPHONE5?220:240;
    
    
    [formTableView setContentInset:UIEdgeInsetsMake(0, 0, inset, 0)];
    
    [formTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:rowEditing inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.txtEmail){
       
        [formTableView setContentInset:UIEdgeInsetsZero];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.txtFullName){
        
        [self.txtEmail becomeFirstResponder];
    }else {
    
        [textField resignFirstResponder];
    }
    return YES;
}


-(UIToolbar*)customToolBarForKeyBoard
{
    
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolBar.frame = CGRectMake(0, 0, 320, 50);
    [toolBar setTintColor:UIColorFromRGB(0x403E3F)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [toolBar sizeToFit];
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)];
    
    
    [doneButton setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:15],
                                         NSForegroundColorAttributeName: UIColorFromRGB(0X75cafb)
                                         } forState:UIControlStateNormal];
    NSArray *items  =   [[NSArray alloc] initWithObjects:doneButton,nil];
    
    [toolBar setItems:items];
    
    
    return toolBar;
}
- (IBAction)sendFormTapped:(id)sender {

 NSMutableArray* orderedArrayOfInputValues = [[NSMutableArray alloc]init];
    NSInteger rows =  [formTableView numberOfRowsInSection:0];
    for (int row = 0; row < rows; row++)
    {
        UITableViewCell *cell = [formTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        UIView* view = [cell.contentView viewWithTag:row+tagIndex];
        NSString* inputText = nil;
        if([view isKindOfClass:[NGTextField class]])
        {
            inputText = ((NGTextField*)view).text;
            switch (row) {
                case 1:
                    self.txtFullName =((NGTextField*)view);
                    break;
               case 2:
                    self.txtEmail = ((NGTextField*)view);
                default:
                    break;
            }
        }
        else if([view isKindOfClass:[UITextView class]]){
            inputText = ((UITextView*)view).text;
            self.txtViewFeedback = ((UITextView*)view);
        }
        
        if(inputText.length>0)
            [orderedArrayOfInputValues addObject:((UITextView*)view).text];
        else
            [orderedArrayOfInputValues addObject:@""];
    }
    
    feedback = [orderedArrayOfInputValues objectAtIndex:0];
    
    if(orderedArrayOfInputValues.count >= 2){
    
        name = [orderedArrayOfInputValues objectAtIndex:1];
    }
    if(orderedArrayOfInputValues.count == 3
       ) {
    
        email = [orderedArrayOfInputValues objectAtIndex:2];
    }
    [self sendFeedback:nil];

}

@end
