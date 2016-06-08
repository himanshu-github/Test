//
//  NGResmanSocialEmailRegistrationViewController.m
//  NaukriGulf
//
//  Created by Himanshu on 3/29/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGResmanSocialEmailRegistrationViewController.h"
#import "NGResmanFresherEducationViewController.h"
#import "NGResmanExpBasicDetailsViewController.h"
#import "NGResmanFresherOrExpViewController.h"

@interface NGResmanSocialEmailRegistrationViewController ()<AutocompletionTableViewDelegate, ProfileEditCellDelegate>
{

    NSString *userName;
    BOOL isEmailRegistered;
    NGTextField *userNameTxtFld;
    AutocompletionTableView *autoCompleter;
    NSLayoutConstraint *autoCompletionHeightConstraints;
    UIView *suggestorBackgroundView;
    NSDictionary *autoCorrectEmailSuggester;
    NSString *suggestedEmailAddressForUser;
    NSArray *suggesterData;
    NSString *errorTitle;
    BOOL invalidEmailId;
    NGResmanDataModel *resmanModel;
    BOOL isSuggestingCorrectedDomain;
    NGLoader *loader;
    UIView *footerView;

    NSInteger yForAutoCompletionTable;

}
@end

@implementation NGResmanSocialEmailRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AppTracer traceStartTime:TRACER_ID_RESMAN_SOCIAL_EMAIL_REGISTRATION];
    
    [super viewDidLoad];
    
    [self setSaveButtonTitleAs:@"Next"];
    suggesterData = [self getSuggestors];
    autoCorrectEmailSuggester = [NGDirectoryUtility autoEmailCorrectionSuggesters];
    isSuggestingCorrectedDomain= FALSE;
    

}
-(void) viewDidAppear:(BOOL)animated
{
    [AppTracer traceEndTime:TRACER_ID_RESMAN_SOCIAL_EMAIL_REGISTRATION];
    
    [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_SOCIAL_REGISTER];
    
    //set the current page as create account page only.
    [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageCreateAccount];
    
}

-(NSArray *)getSuggestors {
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedStringsFromKey:K_EMAIL_DOMAIN_SUGGESTOR_KEY];
    return suggestors;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.editTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.editTableView.tableFooterView = [UIView new];

    [self.scrollHelper listenToKeyboardEvent:YES];
    self.scrollHelper.headerHeight = RESMAN_HEADER_CELL_HEIGHT;
    self.scrollHelper.rowHeight = 75;

    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Let's Get Started"];
    resmanModel = [[DataManagerFactory getStaticContentManager] getResmanFields];
    if (!resmanModel)
        resmanModel = [[NGResmanDataModel alloc] init];

    [self setDefaultValues];
    [NGDecisionUtility checkNetworkStatus];
    
    
    //TODO: implement the spotlight for this screen once get confirmation
   // [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_REGISTRATION withModel:nil]];
    
}
-(void)backButtonClicked:(UIButton *)sender
{
    [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageNone];
    [super backButtonClicked:sender];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [self.scrollHelper listenToKeyboardEvent:NO];
    
    [AppTracer clearLoadTime:TRACER_ID_RESMAN_SOCIAL_EMAIL_REGISTRATION];
}

-(void)setDefaultValues
{
//    if([[NSUserDefaults standardUserDefaults] boolForKey:KEY_DUPLICATE_APPLY])
//    {
//        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:nil title:@"" subTitle:ERROR_MESSAGE_DUPLICATE_APPLY animationTime:5 showAnimationDuration:0];
//        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:KEY_DUPLICATE_APPLY];
//        
//    }
    userName = resmanModel.userName;
   
    //NOTE:To refresh UI,while comming from
    //resman notification.
    [errorCellArr removeAllObjects];
    [self.editTableView reloadData];
}
#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row == ROW_TYPE_HEADING)
    {
        return 50;
    }
    else if(indexPath.row == ROW_TYPE_EMAIL)
    {
        return 75;
    }
    else
    {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    
    switch (indexPath.row)
    {
        case ROW_TYPE_HEADING:{
            
            NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:@"" ];
            if (cell == nil)
            {
                cell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
                txtLabel.textAlignment = NSTextAlignmentCenter;
                [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
                txtLabel.text = @"Register using your Email Id";
                txtLabel.textColor = [UIColor darkGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:txtLabel];
//                
//                UILabel *separatorLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
//                separatorLbl.backgroundColor = seperatorColor;
//                [cell.contentView addSubview:separatorLbl];

                return cell;
            }
            
            break;
        }
            
            
        case ROW_TYPE_EMAIL:{
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.editModuleNumber = k_RESMAN_PAGE_LOGIN_DETAIL;
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:userName forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_LOGIN_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:indexPath.row];
            [self addAutoCompleterForTextField:cell.txtTitle];
            userNameTxtFld = cell.txtTitle;
            
            return cell;
            
            break;
        }
            
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (nil == footerView) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 1.0f)];
        [footerView setBackgroundColor:UITABLEVIEW_SEPERATOR_COLOR];
        
        self.scrollHelper.tableViewFooter = footerView;
    }
    return footerView;
}
#pragma mark- Textfield delegates- Profile Edits
- (void)textField:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index {
    
    switch (textField.tag) {
            
        case ROW_TYPE_EMAIL:
            userName = textField.text;
            break;
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_EMAIL:
            userName = textFieldValue;
            [self hideKeyboardAndSuggester];
            break;
       
        default:
            break;
    }
}

- (void)textFieldDidStartEditing:(UITextField*)textField havingIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_EMAIL:
            
            self.scrollHelper.rowType = NGScrollRowTypeSuggestor;
            NSIndexPath *userIndexPath = [NSIndexPath indexPathForItem:ROW_TYPE_EMAIL inSection:0];
            self.scrollHelper.indexPathOfScrollingRow = userIndexPath;
            
            autoCompleter.isErrorViewVisibleInSearch= NO;
            [self addSuggestorBackGroundView:yForAutoCompletionTable];
            
            break;
    }
    
}

- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_EMAIL:
            [self hideKeyboardAndSuggester];
            break;
    };
}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    yForAutoCompletionTable = 44 + 23;
    
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
    userName = selectedText;
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
        tempFrame.origin.y = yPos;
        suggestorBackgroundView = [[UIView alloc] initWithFrame:tempFrame];
        suggestorBackgroundView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:suggestorBackgroundView belowSubview:autoCompleter];
        [self.view bringSubviewToFront:autoCompleter];
        [self hideSuggesterBackGrndView:YES];
        [self addTapGestureToSuggestorBackGroundView];
    }else{
        CGRect newFrame = suggestorBackgroundView.frame;
        newFrame.origin.y = yPos;
        [suggestorBackgroundView setFrame:newFrame];
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

-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    

    [self hideKeyboardAndSuggester];
    
    NSMutableArray* arrValidations = [self checkValidations];
    if (!errorTitle.length)
        errorTitle = @"Incorrect Details!";
    
    NSString * errorMessage = @"Please specify ";
    
    if([arrValidations count]){
        
        for (NSInteger i = [arrValidations count]-1; i>=0; i--) {
            
            if (i == 0){
                if (arrValidations.count > 1) {
                    errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"and %@",
                                                                          [arrValidations fetchObjectAtIndex:i]]];
                }else if (arrValidations.count == 1){
                    
                    errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@",
                                                                          [arrValidations fetchObjectAtIndex:i]]];
                }
                
            }
            else {
                
                if (i == 1) {
                    
                    errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@ ",
                                                                          [arrValidations fetchObjectAtIndex:i]]];
                    
                }else {
                    
                    errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@, ",
                                                                          [arrValidations fetchObjectAtIndex:i]]];
                }
            }
        }
        
        [NGUIUtility showAlertWithTitle:errorTitle withMessage:
         [NSArray arrayWithObjects:errorMessage, nil]
                       withButtonsTitle:@"OK" withDelegate:nil];
        
        self.isRequestInProcessing = NO;
    }
    else{
        if (!isSuggestingCorrectedDomain && !invalidEmailId) {
            
            
            //TODO: commenting the check emaildidalready registered check and take to the next page
            [self displayNextPage];

            //[self checkIfEmailAlreadyRegistered];
        }
    }
    
}

-(NSMutableArray*) checkValidations
{
    
    NSMutableArray *errArr= [[NSMutableArray alloc] init];
    [errorCellArr removeAllObjects];
    [self checkEmailValidations:errArr];
    [self.editTableView reloadData];
    return errArr;
    
}

-(NSMutableArray*) checkEmailValidations: (NSMutableArray*) errArr
{
    isSuggestingCorrectedDomain = FALSE;
    invalidEmailId = FALSE;
    
    if (userName.length == 0) {
        
        [errArr addObject:@"Email Id"];
        [errorCellArr addObject:[NSNumber numberWithInteger:1]];
        return errArr;
        
    }else if(userName.length > 80) {
        
        [errArr addObject:@"valid Email Id"];
        [errorCellArr addObject:[NSNumber numberWithInteger:1]];
        return errArr;
        
    }
    
    NSMutableArray *emailValidatorArray = [[ValidatorManager sharedInstance] validateValue:userName withType:ValidationTypeEmail];
    
    
    if((0<emailValidatorArray.count)){
        
        [emailValidatorArray containsObject:[NSNumber numberWithInt:ValidationErrorTypeEmpty]]?nil:[errArr addObject:@"valid Email Id"];
        ;
        [errorCellArr addObject:[NSNumber numberWithInteger:1]];
        
        
    }else {
        //now check for email auto correction
        
        if (errorCellArr.count) {
            return errArr;
        }
        
        NSDictionary *emailDomains = [autoCorrectEmailSuggester objectForKey:@"email_domains"];
        if (emailDomains) {
            NSString *domainFromUser = [[[[userName componentsSeparatedByString:@"@"] lastObject] componentsSeparatedByString:@"."] firstObject];
            
            
            if ([NGDecisionUtility isEmailDomainRestricted:domainFromUser]) {
                [NGUIUtility showAlertWithTitle:@"Invalid Details!" withMessage:@[@"Use a domain different from naukri.com & naukrigulf.com"] withButtonsTitle:@"Ok" withDelegate:nil];
                invalidEmailId = TRUE;
                
            }else{
                NSString *autoCorrectedEmail = [emailDomains objectForKey:domainFromUser.lowercaseString];
                if (autoCorrectedEmail) {
                    //show alert to user
                    
                    suggestedEmailAddressForUser = [userName stringByReplacingOccurrencesOfString:domainFromUser withString:autoCorrectedEmail];
                    
                    NSString *msgToUser = [[autoCorrectEmailSuggester objectForKey:@"user_message"] stringByReplacingOccurrencesOfString:@"@" withString:suggestedEmailAddressForUser];
                    
                    NSString *msgButtons = [NSString stringWithFormat:@"%@,%@",[autoCorrectEmailSuggester objectForKey:@"user_message_ok"],[autoCorrectEmailSuggester objectForKey:@"user_message_cancel"]];
                    
                    [NGUIUtility showAlertWithTitle:[autoCorrectEmailSuggester objectForKey:@"user_message_title"] withMessage:@[msgToUser] withButtonsTitle:msgButtons withDelegate:self];
                    
                    isSuggestingCorrectedDomain = TRUE;
                }
            }
        }
    }
    return errArr;
}

-(void) checkIfEmailAlreadyRegistered {
    
    [self showAnimator];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_CHECK_REGISTERED_USER];
    
    __weak typeof(self) weakSelf = self;
    __block BOOL blockIsEmailRegistered = isEmailRegistered;
    
    
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:userName,@"email", nil] handler:^(NGAPIResponseModal *responseInfo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAnimator];
            
            if (responseInfo.isSuccess) {
                
                [NGSavedData saveEmailID:userName];
                NSString* emailExistStr = [[responseInfo.responseData JSONValue] objectForKey:KEY_REGISTERED_EMAIL_DATA];
                blockIsEmailRegistered = [emailExistStr isEqualToString:@"true"]?TRUE:FALSE;
                
                if (blockIsEmailRegistered) {
                    //show message that the email-id already registered .Please use another email-id.
                    
                    [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"This email id is already registered with Naukrigulf. Please Login or Retrieve your password." animationTime:7 showAnimationDuration:0.5];

                }
                else{
                    
                    //not registered   then go to next page.
                    [weakSelf displayNextPage];
                }
            }else{
                blockIsEmailRegistered = FALSE;
                [NGUIUtility showAlertWithTitle:@"Oops!" withMessage:[NSArray arrayWithObject:@"Connection could not be established. Please try again"]withButtonsTitle:@"Ok" withDelegate:nil];
                
            }
        });
        
    }];
    
    
    
    
}

-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    
    [self hideAnimator];
    isEmailRegistered = FALSE;
    [self hideAnimator];
}

#pragma mark- Password Hardcode for now
//TODO:Password Hardcode for now
-(void) saveResmanFieldsInDatabase {
    resmanModel.userName= userName;
    resmanModel.password = @"naukrigulf";//hard code as api is missing
    [[DataManagerFactory getStaticContentManager] saveResmanFields:resmanModel];
}
-(void) displayNextPage {
    
    [self saveResmanFieldsInDatabase];
    
    if (_isComingFromMailer)
        [NGHelper sharedInstance].isResmanViaMailer = YES;
    else
        [NGHelper sharedInstance].isResmanViaMailer = NO;
    
    if (_isComingFromUnregApply){
        
        [NGHelper sharedInstance].isResmanViaUnregApply = YES;
        if(resmanModel.isFresher){
            
            [[NGResmanNotificationHelper sharedInstance] setUserAsFresher:YES];
            NGResmanFresherEducationViewController *fresherEduDetailVC = [[NGResmanFresherEducationViewController alloc] initWithNibName:nil bundle:nil];
            [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:fresherEduDetailVC Animated:YES];
        }else {
            
            [[NGResmanNotificationHelper sharedInstance] setUserAsFresher:NO];
            
            NGResmanExpBasicDetailsViewController *expBasicDetailVC = [[NGResmanExpBasicDetailsViewController alloc] initWithNibName:nil bundle:nil];
            
            [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:expBasicDetailVC Animated:YES];
        }
        
    }else{
        
        NGResmanFresherOrExpViewController *fresherOrExpVc = [[NGResmanFresherOrExpViewController alloc] initWithNibName:nil bundle:nil];
        [(IENavigationController*)self.navigationController pushActionViewController:fresherOrExpVc Animated:YES];
    }
    
}

@end
