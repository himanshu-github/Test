//
//  NGEditContactDetailViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditContactDetailViewController.h"
#import "AutocompletionTableView.h"

@interface NGEditContactDetailViewController ()<AutocompletionTableViewDelegate>{
    
    NSString* mobileNumber;
    NSString* mobileCountryCode;
    NSString *phoneCountyCode;
    NSString* areaCode;
    NSString* phoneNumber;
    NSString* emailAddress;
    NSString* errorTitle;
    
    NSArray *suggesterData;
    NSDictionary *autoCorrectEmailSuggester;
    AutocompletionTableView *autoCompleter;
    NSLayoutConstraint *autoCompletionHeightConstraints;
    UIView *suggestorBackgroundView;
    
    BOOL isEmailAutoCorrectionDecisionPending;
    NSString *suggestedEmailAddressForUser;
    
    BOOL isInitialParamDictUpdated;
    
}

@end
#define EMAIL_TEXTFIELD 25
#define MOBILE_COUNTRY_TEXTFIELD 1000
#define MOBILE_NUMBER_TEXTFIELD 1001

@implementation NGEditContactDetailViewController

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
    
    autoCorrectEmailSuggester = [NGDirectoryUtility autoEmailCorrectionSuggesters];
    
    suggesterData = [self getSuggestors];
    [self customizeNavBarWithTitle:@"Contact Details"];
    self.editTableView.scrollEnabled = NO;
    [self addStaticLabel];
    isInitialParamDictUpdated = NO;
    self.isSwipePopDuringTransition = NO;
    self.isSwipePopGestureEnabled = YES;
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    self.isRequestInProcessing = NO;
    [NGDecisionUtility checkNetworkStatus];

}
#pragma mark - Update Initial Params
-(void)updateInitialParams{
    if(!isInitialParamDictUpdated){
        self.initialParamDict  = [self getParametersInDictionary];
        isInitialParamDictUpdated = YES;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    [super viewDidAppear:animated];
    [self setAutomationLabel];
    [self updateInitialParams];


}
-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:@"editContactDetail_table" forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addStaticLabel{
    
    NSInteger startY= K_CONTACT_DEATILS_ROW_HEIGHT * K_CONTACT_DEATILS_NO_OF_ROWS ;
    
    NGLabel* staticLabel= [[NGLabel alloc] initWithFrame:CGRectMake(10,startY, self.view.bounds.size.width-20, 50)];
    [staticLabel setText:K_EDIT_CONTACT_DETAIL_STATIC_LABEL];
    [staticLabel setNumberOfLines:0];
    [staticLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [staticLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:12.0]];
    [staticLabel setTextAlignment:NSTextAlignmentCenter];
    [staticLabel setTextColor:[UIColor lightGrayColor]];
    [staticLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [staticLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:staticLabel];
    
}


#pragma mark - Button Action

/**** Overriding from BaseviewController  ***/

- (void)editMNJSaveButtonTapped:(id)sender{
    
    [self onSave:nil];
}

-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    [self onSave:nil];
}



-(void)onSave:(id)sender{
    
    [self hideKeyboardAndSuggester];
    
    NSMutableArray* arrValidations = [self checkValidations];
    if (!errorTitle.length)
        errorTitle = @"Incorrect Details!";
    
    NSString * errorMessage = @"";
    
    if([arrValidations count]){
        
        for (int i = 0; i< [arrValidations count]; i++) {
            
            if (i == [arrValidations count]-1)
                errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@",
                                                                      [arrValidations fetchObjectAtIndex:i]]];
            else
                errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@,",
                                                                      [arrValidations fetchObjectAtIndex:i]]];
        }
        
        [NGUIUtility showAlertWithTitle:errorTitle withMessage:
         [NSArray arrayWithObjects:errorMessage, nil]
                    withButtonsTitle:@"OK" withDelegate:nil];
        
        self.isRequestInProcessing = NO;
    }
    else{
        
        //if email auto correction decision then return from here
        if(isEmailAutoCorrectionDecisionPending){
            return;
        }
        [self sendSaveRequest];
    }
}
-(NSMutableDictionary*)getParametersInDictionary{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (mobileNumber.length >0 && mobileCountryCode.length > 0) {
        [params setCustomObject:[NSString stringWithFormat:@"%@+%@",mobileCountryCode,mobileNumber] forKey:@"mphone"];
    }else{
        [params setCustomObject:@"" forKey:@"mphone"];
    }
    
    if (phoneCountyCode.length>0 && areaCode.length>0 && phoneNumber.length > 0) {
        [params setCustomObject:[NSString stringWithFormat:@"%@+%@+%@",phoneCountyCode,areaCode,phoneNumber] forKey:@"rphone"];
    }else{
        [params setCustomObject:@"" forKey:@"rphone"];
    }
    if (![emailAddress isEqualToString:self.modalClassObj.username]) {
        
        [params setCustomObject:emailAddress forKey:@"username"];
    }
    else
        [params setCustomObject:emailAddress forKey:@"username"];

    
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    return params;
}
- (void)sendSaveRequest{
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EDIT_PROFILE withEventLabel:K_GA_EVENT_EDIT_PROFILE withEventValue:nil];
    
    if (!self.isRequestInProcessing) {
        [self setIsRequestInProcessing:YES];
        [self showAnimator];
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
        
        
        __weak NGEditContactDetailViewController *weakSelf = self;
        NSMutableDictionary *params =[self updateTheRequestParameterForSendingInitialValueOfChanges:[self getParametersInDictionary]];

        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.isRequestInProcessing = NO;
                [weakSelf hideAnimator];
                
                if (responseInfo.isSuccess) {
                    NSString *statusStr = [(NSDictionary*)responseInfo.parsedResponseData objectForKey:KEY_UPDATE_RESUME_STATUS];
                    if ([statusStr isEqualToString:@"success"]) {
                        [weakSelf.editDelegate editedContactDetailsWithSuccess:YES];
                        [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                    }
                }else{
                    [weakSelf performSelector:@selector(reEnableSaveButton) withObject:nil afterDelay:2.0];
                    NSDictionary *errorDict = [responseInfo.responseData JSONValue];
                    if([[[[errorDict objectForKey:@"error"]objectForKey:@"customData"] objectForKey:@"username"] isEqualToString:@"ALREADY_EXISTS"]){
                        
                        [NGUIUtility showAlertWithTitle:@"Error!" withMessage:[NSArray arrayWithObjects:@"Email Id already exists.Please choose a different one", nil] withButtonsTitle:@"Ok" withDelegate:nil];
                        
                    }else if ([[[[errorDict objectForKey:@"error"]objectForKey:@"customData"] objectForKey:@"username"] isEqualToString:@"INVALID"]){
                        
                        [NGUIUtility showAlertWithTitle:[[errorDict objectForKey:@"error"]objectForKey:@"message"] withMessage:@[@"Email Id is incorrect"] withButtonsTitle:@"Ok" withDelegate:nil];
                        
                    }else{
                        
                        [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[@"Some error occurred at server"] withButtonsTitle:@"Ok" withDelegate:nil];
                        
                    }
                    
                }
                
            });
            
            
            
        }];
    }
    
}

- (NSMutableArray*)checkValidations{
    
    NSArray* numbers;
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    errorTitle = @"";
    
    BOOL isPhoneIncomp = FALSE;
    bool isMobIncomp  = FALSE;
    
    
    BOOL bIsPhoneNumberEmpty = NO;
    BOOL bIsMobileNumberEmpty = NO;
    BOOL bIsValidMobileNumber = NO; // no special character
    BOOL bIsValidPhoneNumber = NO;
    
    if (mobileCountryCode.length || mobileNumber.length) {
        
        if(mobileCountryCode.length == 0 || mobileNumber.length == 0){
            isMobIncomp = TRUE;
        }
        
    }
    
    
    if (phoneCountyCode.length || phoneNumber.length || areaCode.length) {
        
        if(phoneCountyCode.length == 0 || phoneNumber.length == 0 || areaCode.length == 0){
            isPhoneIncomp = TRUE;
        }
    }
    
    
    if(isMobIncomp){
        
        errorTitle = @"Incomplete Details!";
        [arr addObject:@"Please fill complete mobile number"];
        [errorCellArr addObject:[NSNumber numberWithInteger:0]];//for prefrance
        
    }
    
    if(isPhoneIncomp){
        
        errorTitle = @"Incomplete Details!";
        if(!isMobIncomp)
            [arr addObject:@"Please fill complete phone number"];
        else
            [arr addObject:@" phone number"];
        
        [errorCellArr addObject:[NSNumber numberWithInteger:1]];//for prefrance
        
    }
    
    if(!isPhoneIncomp && !isMobIncomp) {
        if(mobileCountryCode.length == 0 || mobileNumber.length == 0)
            bIsMobileNumberEmpty = YES;
        
        if (phoneCountyCode.length == 0 || areaCode.length == 0 || phoneNumber.length == 0)
            bIsPhoneNumberEmpty = YES;
        
        if(!bIsMobileNumberEmpty) {
            
            NSString *completeMobileNumber = [NSString stringWithFormat:@"%@+%@",mobileCountryCode,mobileNumber];
            
            numbers = [completeMobileNumber componentsSeparatedByString:@"+"];
           
            for(NSString *str in numbers){
                (0>=[[ValidatorManager sharedInstance] validateValue:str withType:ValidationTypeNumber].count)?(bIsValidMobileNumber = YES):(bIsValidMobileNumber = NO);
                
                if (!bIsValidMobileNumber) {
                    break;
                }
                
            }
        }
        if(!bIsPhoneNumberEmpty) {
            
            NSString *completPhoneNumber = [NSString stringWithFormat:@"%@+%@+%@",phoneCountyCode,areaCode,phoneNumber];
            
            numbers = [completPhoneNumber componentsSeparatedByString:@"+"];
            
            for(NSString *str in numbers){
                
                (0>=[[ValidatorManager sharedInstance] validateValue:str withType:ValidationTypeNumber].count)?(bIsValidPhoneNumber = YES):(bIsValidPhoneNumber = NO);
                
                if(!bIsValidPhoneNumber){
                    break;
                }
            }
        }
        
        if (bIsMobileNumberEmpty) {
            
            if (bIsPhoneNumberEmpty){
                
                errorTitle = @"Incomplete Details!";
                [arr addObject:@"Please fill either Mobile or Telephone number"];
                [errorCellArr addObject:[NSNumber numberWithInteger:0]];//for prefrance
            }
            
        }else if (bIsPhoneNumberEmpty){
            
            if (bIsMobileNumberEmpty){
                
                errorTitle = @"Incomplete Details!";
                [arr addObject:@"Please fill either Mobile or Telephone number"];
                [errorCellArr addObject:[NSNumber numberWithInteger:0]];
                
            }
            else if(!bIsValidMobileNumber){
                [arr addObject:K_ERROR_MESSAGE_ONLY_NUMERIC_STRING];
                [errorCellArr addObject:[NSNumber numberWithInteger:0]];
                
            }
            
        }else{
            
            if(!bIsValidMobileNumber){
                [arr addObject:K_ERROR_MESSAGE_ONLY_NUMERIC_STRING];
                [errorCellArr addObject:[NSNumber numberWithInteger:0]];
                
            }
            
            if(!bIsValidPhoneNumber){
                if (![arr containsObject:K_ERROR_MESSAGE_ONLY_NUMERIC_STRING]) {
                   
                    [arr addObject:K_ERROR_MESSAGE_ONLY_NUMERIC_STRING];
                    
                }
                
                [errorCellArr addObject:[NSNumber numberWithInteger:1]];
                
            }
            
            
        }
    }
    
    
    if(emailAddress) {
        emailAddress = [emailAddress trimCharctersInSet :
                        [NSCharacterSet whitespaceCharacterSet]];
    }
    
    if((0<[[ValidatorManager sharedInstance] validateValue:emailAddress withType:ValidationTypeEmail].count)){
        
        [arr addObject:ERROR_MESSAGE_VALID_EMAIL];
        [errorCellArr addObject:[NSNumber numberWithInteger:2]];
        
        
    }else{
        
        //if we found any error above no need to check further
        if (0 < arr.count) {
            [self.editTableView reloadData];
            return arr;
        }
        
        //now check for email auto correction
        NSDictionary *emailDomains = [autoCorrectEmailSuggester objectForKey:@"email_domains"];
        if (emailDomains) {
            NSString *domainFromUser = [[[[emailAddress componentsSeparatedByString:@"@"] lastObject] componentsSeparatedByString:@"."] firstObject];
            
            
            if ([NGDecisionUtility isEmailDomainRestricted:domainFromUser]) {
                [NGUIUtility showAlertWithTitle:@"Invalid Detail!" withMessage:@[@"Invalid Email id"] withButtonsTitle:@"Ok" withDelegate:nil];
                
                isEmailAutoCorrectionDecisionPending = YES;
                
            }else{
                NSString *autoCorrectedEmail = [emailDomains objectForKey:domainFromUser.lowercaseString];
                if (autoCorrectedEmail) {
                    //show alert to user
                    
                    suggestedEmailAddressForUser = [emailAddress stringByReplacingOccurrencesOfString:domainFromUser withString:autoCorrectedEmail];
                    
                    
                    NSString *msgToUser = [[autoCorrectEmailSuggester objectForKey:@"user_message"] stringByReplacingOccurrencesOfString:@"@" withString:suggestedEmailAddressForUser];
                    
                    NSString *msgButtons = [NSString stringWithFormat:@"%@,%@",[autoCorrectEmailSuggester objectForKey:@"user_message_ok"],[autoCorrectEmailSuggester objectForKey:@"user_message_cancel"]];
                    
                    [NGUIUtility showAlertWithTitle:[autoCorrectEmailSuggester objectForKey:@"user_message_title"] withMessage:@[msgToUser] withButtonsTitle:msgButtons withDelegate:self];
                    
                    isEmailAutoCorrectionDecisionPending = YES;
                }
            }
        }
    }
    [self.editTableView reloadData];
    
    return arr;
}
-(void)customAlertbuttonClicked:(NSInteger)index{
    
    [NGHelper sharedInstance].isAlertShowing = FALSE;
    
    if (0 == index) {
        //modifiy alert button pressed
        emailAddress = suggestedEmailAddressForUser;
    }
    isEmailAutoCorrectionDecisionPending = NO;
    [self sendSaveRequest];
}


#pragma mark
#pragma mark Validations
/**
 *  Method check the validation on all strings and return the result in Yes or NO
 *
 *  @return if yes, validation is applied for particular key
 */


#pragma mark - Server Delegates



#pragma mark - Contact Number Delegate

-(void)textFieldDelegateDidStartEditing:(UITextField *)textfield havingIndex:(NSInteger)index{
    
    if(textfield.tag == EMAIL_TEXTFIELD){
        
        autoCompleter.isErrorViewVisibleInSearch= NO;
        
        [self addSuggestorBackGroundView:textfield.frame.origin.y-150];
        
        [NGUIUtility slideView:self.editTableView toXPos:0 toYPos:self.editTableView.frame.origin.y-150 duration:0.25f delay:0.0f];
    }
}

- (void)textFieldDelegateDidEndEditing:(UITextField *)textfield havingIndex:(NSInteger)index{
    
    if(textfield.tag == EMAIL_TEXTFIELD){
        [NGUIUtility slideView:self.editTableView toXPos:0 toYPos:self.editTableView.frame.origin.y+150 duration:0.25f delay:0.0f];
    }
    
}
-(BOOL)textFieldDelegateShouldReturn:(UITextField*)textField{
    if(textField.tag == EMAIL_TEXTFIELD){
        [self hideKeyboardAndSuggester];
    }
    return YES;
}
- (void)textFieldDelegate:(UITextField *)textfield havingIndex:(NSInteger)index{
    
    if (K_RESIDENCE_PHONE_COUNTRY_CODE == textfield.tag)
        phoneCountyCode = textfield.text;
    else  if (K_RESIDENCE_PHONE_AREA_CODE == textfield.tag)
        areaCode = textfield.text;
    else if (K_RESIDENCE_PHONE_NUMBER == textfield.tag)
        phoneNumber = textfield.text;
    else if(textfield.tag == EMAIL_TEXTFIELD){
        
        emailAddress = textfield.text;
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag==EMAIL_TEXTFIELD)
    {
        if (textField.text.length >= 80 && range.length == 0)
            return NO;
        return YES;
    }
    
    
    if (textField.tag==MOBILE_COUNTRY_TEXTFIELD)
    {
        if (textField.text.length >= 5 && range.length == 0)
            return NO;
        return YES;
    }
    
    if (textField.tag==K_RESIDENCE_PHONE_COUNTRY_CODE)
    {
        if (textField.text.length >= 10 && range.length == 0)
            return NO;
        return YES;
    }
    
    if (textField.tag ==K_RESIDENCE_PHONE_AREA_CODE)
    {
        if (textField.text.length >= 10 && range.length == 0)
            return NO;
        return YES;
    }
    
    if (textField.tag ==MOBILE_NUMBER_TEXTFIELD)
    {
        if (textField.text.length >= 12 && range.length == 0)
            return NO;
        return YES;
    }
    
    if (textField.tag==K_RESIDENCE_PHONE_NUMBER)
    {
        if (textField.text.length >= 15 && range.length == 0)
            return NO;
        return YES;
    }
    
    else
        return YES;
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return K_CONTACT_DEATILS_NO_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return K_CONTACT_DEATILS_NO_OF_ROWS;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float fHeight = K_CONTACT_DEATILS_ROW_HEIGHT;
    return fHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    float sectionHeight = 0.0f;
    if (0 == section) {
        sectionHeight = 60;
    }
    return sectionHeight;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionFooterView = [[UIView alloc] init];
    [sectionFooterView setAutoresizesSubviews:NO];
    sectionFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    sectionFooterView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *lblHelpText = [[UILabel alloc] init];
    [lblHelpText setAutoresizesSubviews:NO];
    [lblHelpText setNumberOfLines:0];
    [lblHelpText setLineBreakMode:NSLineBreakByWordWrapping];
    [lblHelpText setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:14.0f]];
    [lblHelpText setTextAlignment:NSTextAlignmentCenter];
    [lblHelpText setTextColor:[UIColor colorWithRed:156.0f/255 green:154.0f/255 blue:154.0f/255 alpha:1.0f]];
    [lblHelpText setText:@"Important: Change in email id will also change your username. The new email id will become your username for login."];
    
    lblHelpText.frame = CGRectMake(15, 0, sectionFooterView.frame.size.width-30, sectionFooterView.frame.size.height);
    
    [sectionFooterView addSubview:lblHelpText];
    
    return sectionFooterView;
}
- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    UITableViewCell* cell = nil;
    
    switch (indexPath.row) {
            
        case 0:{
            
            NSString* cellIndentifier = @"EditContactDetailMobileCell";
            NGContactDetailMobileCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if(cell==nil)
                cell = [[NGContactDetailMobileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.delegate = self;
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:mobileCountryCode forKey:@"mobileCountryCode"];
            [dictToPass setCustomObject:mobileNumber forKey:@"mobileNumber"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_CONTACT_DETAIL_PAGE] forKey:@"ControllerName"];
            [cell configureMobileCellWithData:dictToPass andIndexPath:indexPath];
            return cell;
            break;
            
        }
        case 1:{
            
            NSString* cellIndentifier = @"EditContactNumberCell";
            NGEditContactNumberCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if(cell==nil)
                cell = [[NGEditContactNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            cell.editModuleNumber = K_EDIT_CONTACT_DETAIL_PAGE;
            cell.delegate = self;
            
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:phoneCountyCode forKey:K_KEY_EDIT_COUNTRY_CODE];
            [dictToPass setCustomObject:areaCode forKey:K_KEY_EDIT_AREA_CODE];
            [dictToPass setCustomObject:phoneNumber forKey:K_KEY_EDIT_PHONE_NUMBER];
            [cell configureEditContactNumberCellWithData:dictToPass andIndexPath:indexPath];
            return cell;
            break;
            
        }
        case 2:{
            
            NSString* cellIndentifier = @"EditContactEmailCell";
            NGEditContactEmailCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if(cell==nil)
                cell = [[NGEditContactEmailCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:cellIndentifier];
            
            cell.editModuleNumber = K_EDIT_CONTACT_DETAIL_PAGE;
            cell.delegate = self;
            
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:@"Email Address" forKey:K_KEY_EDIT_PLACEHOLDER];
            [dictToPass setCustomObject:@"view only" forKey:K_KEY_EDIT_PLACEHOLDER2];
            [dictToPass setCustomObject:emailAddress forKey:K_KEY_EDIT_TITLE];
            cell.index = indexPath.row;
            cell.txtTitle.accessibilityLabel = @"emailAddress_txtFld";
            cell.txtTitle.tag = EMAIL_TEXTFIELD;
            [cell setAccessibilityLabel:@"emailAddress_cell"];
            [cell configureEditContactEmailCell:dictToPass];
            [self addAutoCompleterForTextField:cell.txtTitle];
            [cell.txtTitle setKeyboardType:UIKeyboardTypeEmailAddress];
            dictToPass = nil;
            return cell;
            break;
            
        }
            
        default:
            break;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            
            break;
        }
        case 1:{
            
            NGEditContactNumberCell* cell = (NGEditContactNumberCell*)[self.editTableView
                                                                       cellForRowAtIndexPath:indexPath];
            [cell.txtCountryCode becomeFirstResponder];
            [cell.txtAreaCode becomeFirstResponder];
            [cell.txtNumber becomeFirstResponder];
            
            break;
        }
        case 2:{
            
            return;
        }
            
        default:
            break;
    }
    
}


/**
 *  @name Public Method
 */
/**
 *  Public Method initiated for on view appear and updates the textfield Values with NGMNJProfileModalClass object
 *
 *  @param obj a JsonModelObject contains predefined value for textField
 */
- (void)updateDataWithParams:(NGMNJProfileModalClass *)obj{
    self.modalClassObj = obj;
    
    NSString *mobile = self.modalClassObj.mphone;
    if (![mobile isEqualToString:@""]) {
        NSArray *mobileArr = [mobile componentsSeparatedByString:@"+"];
        if (mobileArr.count==3) {
            
            mobileCountryCode = [mobileArr fetchObjectAtIndex:0];
            mobileNumber = [mobileArr fetchObjectAtIndex:2];
            
        }
        else{
            
            mobileCountryCode = [mobileArr fetchObjectAtIndex:0];
            mobileNumber = [mobileArr fetchObjectAtIndex:1];
            
        }
        
    }
    
    NSString *telephone = self.modalClassObj.rphone;
    if (![telephone isEqualToString:@""]) {
        NSArray *telephoneArr = [telephone componentsSeparatedByString:@"+"];
        phoneCountyCode = [telephoneArr fetchObjectAtIndex:0];
        areaCode = [telephoneArr fetchObjectAtIndex:1];
        phoneNumber = [telephoneArr fetchObjectAtIndex:2];
    }
    
    emailAddress = self.modalClassObj.username;
    
    [self.editTableView reloadData];
    
}


#pragma mark - Mobile Number Delegate


- (void)textFieldDidEndEditing:(UITextField *)textField havingIndex:(NSInteger)index;
{
    if(textField.tag == MOBILE_COUNTRY_TEXTFIELD) {
        
        mobileCountryCode = textField.text;
        
    }
    if(textField.tag == MOBILE_NUMBER_TEXTFIELD){
        
        mobileNumber = textField.text;
    }
    
    
}


#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    
    self.isRequestInProcessing = NO;
    NSString *statusStr = [(NSDictionary*)responseData.parsedResponseData objectForKey:KEY_UPDATE_RESUME_STATUS];
    if ([statusStr isEqualToString:@"success"]) {
        [self.editDelegate editedContactDetailsWithSuccess:YES];
        [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
    }
    [self hideAnimator];
    
}
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    
    self.isRequestInProcessing = NO;
    [self hideAnimator];
    [self performSelector:@selector(reEnableSaveButton) withObject:nil afterDelay:2.0];
   NSDictionary *errorDict = [responseData.responseData JSONValue];
    if([[[[errorDict objectForKey:@"error"]objectForKey:@"customData"] objectForKey:@"username"] isEqualToString:@"ALREADY_EXISTS"]){
        
        [NGUIUtility showAlertWithTitle:@"Error!" withMessage:[NSArray arrayWithObjects:@"Email Id already exists.Please choose a different one", nil] withButtonsTitle:@"Ok" withDelegate:nil];
        
    }else if ([[[[errorDict objectForKey:@"error"]objectForKey:@"customData"] objectForKey:@"username"] isEqualToString:@"INVALID"]){
        
        [NGUIUtility showAlertWithTitle:[[errorDict objectForKey:@"error"]objectForKey:@"message"] withMessage:@[@"Email Id is incorrect"] withButtonsTitle:@"Ok" withDelegate:nil];
        
    }else{
        
        [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[@"Some error occurred at server"] withButtonsTitle:@"Ok" withDelegate:nil];
        
    }
    
}
- (AutocompletionTableView *)addAutoCompleterForTextField:(UITextField*)paramTextField{
    
    if (!autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        autoCompleter = [[AutocompletionTableView alloc] initWithTextField:paramTextField inViewController:self withOptions:options withDefaultStyle:NO];
        autoCompleter.autoCompleteDelegate = self;
        autoCompleter.isEmailAddressSuggestor = YES;
        autoCompleter.suggestionsDictionary = suggesterData;//will be same for both search and modify search
        
        [self.view addSubview:autoCompleter];
        
        [self addconstaint];
        
        autoCompleter.isMultiSelect = NO;
        [paramTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [paramTextField addTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return autoCompleter;
}
-(void) addconstaint {
    
    NSLayoutConstraint *autoCompletionLeftConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSInteger yForAutoCompletionTable = 44;
    yForAutoCompletionTable += 23;
    
    
    NSLayoutConstraint *autoCompletionTopConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:yForAutoCompletionTable];
    
    NSLayoutConstraint *autoCompletionRightConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *autoCompletionWidthConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    autoCompletionHeightConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:600];
    
    
    [self.view addConstraint:autoCompletionLeftConstraints];
    [self.view addConstraint:autoCompletionTopConstraints];
    
    [self.view addConstraint:autoCompletionRightConstraints];
    [self.view addConstraint:autoCompletionWidthConstraints];
    [self.view addConstraint:autoCompletionHeightConstraints];
    
    [self.view setNeedsLayout];
}
-(NSArray *)getSuggestors
{
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedStringsFromKey:K_EMAIL_DOMAIN_SUGGESTOR_KEY];
    return suggestors;
}
#pragma mark - AutoCompleteTableViewDelegate
- (void)updateAutoCompletionTableViewConstraintWithNewFrame:(CGRect)paramNewFrame{
    
    if (CGRectEqualToRect(CGRectZero, paramNewFrame)) {
        autoCompletionHeightConstraints.constant = 600;
    }else{
        autoCompletionHeightConstraints.constant = paramNewFrame.size.height;
    }
    [autoCompleter updateConstraints];
    [[self view] setNeedsLayout];
}
- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return  suggesterData;
}
- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText {
    emailAddress = selectedText;
}
-(void)showingTheOptions:(BOOL)status{
    
    [self hideSuggesterBackGrndView:!status];
}
-(void)hideSuggesterBackGrndView:(BOOL)status{
    [suggestorBackgroundView setHidden:status];
    [autoCompleter setHidden:status];
}
-(void)addSuggestorBackGroundView :(float)yPos{
    
    if (!suggestorBackgroundView) {
        
        CGRect tempFrame = self.view.frame;
        tempFrame.origin.y = yPos+44;
        suggestorBackgroundView = [[UIView alloc] initWithFrame:tempFrame];
        suggestorBackgroundView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:suggestorBackgroundView belowSubview:autoCompleter];
        [self.view bringSubviewToFront:autoCompleter];
        [self hideSuggesterBackGrndView:YES];
        [self addTapGestureToSuggestorBackGroundView];
    }
}
/* hiding the Suggestor view when user click on outside of it.
 */

-(void)addTapGestureToSuggestorBackGroundView{
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnSuggestorBackGrndView)];
    [suggestorBackgroundView addGestureRecognizer:singleFingerTap];
    
}
- (void)handleSingleTapOnSuggestorBackGrndView{
    
    [self hideKeyboardAndSuggester];
}

-(void)hideKeyboardAndSuggester{
    
    [self.view endEditing:YES];
    [self hideSuggesterBackGrndView:YES];
}
-(void) dealloc {
    
    _modalClassObj = nil;
}
@end