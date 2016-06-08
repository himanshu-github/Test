//
//  NGResmanLoginDetailsViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/13/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanLoginDetailsViewController.h"
#import "NGResmanFresherOrExpViewController.h"
#import "NGResmanFresherEducationViewController.h"
#import "NGApplyFieldsModel.h"
#import "NGResmanSaveButtonCell.h"
#import "NGResmanSocialLoginCell.h"
#import "NGSocialLoginManager.h"
#import "NGResmanSocialEmailRegistrationViewController.h"


@interface NGResmanLoginDetailsViewController ()<ProfileEditCellDelegate,AutocompletionTableViewDelegate, SocialLoginProtocol,NGSocialLoginManagerDelegate>
{
    NSString *userName;
    NSString *password;
    BOOL isEmailRegistered;
    NGTextField *passwordTxtFld;
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
    
    /**
     This bool is checked before calling the @p NGLoginViewController. If this bool is set TRUE, then the NGLoginViewController will be opened without the error message. otherwise, the NGLoginViewController will be opened with the error message.
     */
    BOOL isAlreadyRegisteredTapped;
 
    
    UIView *footerView;
    NSInteger yForAutoCompletionTable;
}

@end

@implementation NGResmanLoginDetailsViewController

- (void)viewDidLoad
{
    [AppTracer traceStartTime:TRACER_ID_RESMAN_LOGIN_DETAILS];
    
    [super viewDidLoad];
    
    
    [self setSaveButtonTitleAs:@"Next"];
     suggesterData = [self getSuggestors];
     autoCorrectEmailSuggester = [NGDirectoryUtility autoEmailCorrectionSuggesters];
    isSuggestingCorrectedDomain= FALSE;
    
# pragma mark Commenting for next release
//    [self addAlreadyRegsisteredFooter];
    
    self.isSwipePopGestureEnabled = NO;
    self.isSwipePopDuringTransition = NO;

}

-(void) viewWillAppear:(BOOL)animated
{
    if(self.isSwipePopDuringTransition)
        return;
    
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

    if (_isComingFromMailer || _isComingFromUnregApply)
        [self setUnregDataToResman];

    [self setDefaultValues];
    [NGDecisionUtility checkNetworkStatus];

    [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_REGISTRATION withModel:nil]];
}

-(void)setUnregDataToResman{
    
    NGApplyFieldsModel* applyModel = [[DataManagerFactory getStaticContentManager]getApplyFields];
    if (!applyModel) 
        applyModel = [[NGApplyFieldsModel alloc] init];
    
    resmanModel.isFresher = applyModel.isFresher;
    resmanModel.name = applyModel.name;
    resmanModel.userName = applyModel.emailId;
    resmanModel.gender = applyModel.gender;
    resmanModel.designation = applyModel.currentDesignation;
    if (applyModel.mobileNumber.length) {
        NSArray* arrLocal = [applyModel.mobileNumber componentsSeparatedByString:@"+"];
        resmanModel.countryCode = [arrLocal firstObject];
        resmanModel.mobileNum = [arrLocal lastObject];
    }

    if ([applyModel.doctCourse objectForKey:KEY_ID]){
        [resmanModel.highestEducation setCustomObject:@"Doctorate" forKey:KEY_VALUE];
        [resmanModel.highestEducation setCustomObject:@"3" forKey:KEY_ID];
    }
    else if ([applyModel.pgCourse objectForKey:KEY_ID]){
        [resmanModel.highestEducation setCustomObject:@"Masters" forKey:KEY_VALUE];
        [resmanModel.highestEducation setCustomObject:@"2" forKey:KEY_ID];
    }
    else if ([applyModel.gradCourse objectForKey:KEY_ID]){
        [resmanModel.highestEducation setCustomObject:@"Basic" forKey:KEY_VALUE];
        [resmanModel.highestEducation setCustomObject:@"1" forKey:KEY_ID];
    }
    resmanModel.ugCourse = applyModel.gradCourse;
    resmanModel.ugSpec = applyModel.gradspecialisation;
    resmanModel.pgCourse = applyModel.pgCourse;
    resmanModel.pgSpec = applyModel.pgSpecialisation;
    resmanModel.ppgCourse = applyModel.doctCourse;
    resmanModel.ppgSpec = applyModel.doctspecialisation;
    resmanModel.country = applyModel.country;
    resmanModel.city = applyModel.city;
    
    if ([NGDecisionUtility isValidDropDownItem:resmanModel.country] && [NGDecisionUtility isValidDropDownItem:resmanModel.city]) {
        
        NSString *resmanCityId = [NSString stringWithFormat:@"%@.%@",[resmanModel.country objectForKey:KEY_ID],[resmanModel.city objectForKey:KEY_ID]];
        
        [resmanModel.city setCustomObject:resmanCityId forKey:KEY_ID];
        
        resmanModel.isOtherCity = [@"1000" isEqualToString:[resmanModel.city objectForKey:KEY_ID]] ? YES : NO;
    }
    
    resmanModel.nationality = applyModel.nationality;
    
    [resmanModel.totalExp setCustomObject:[applyModel.workEx objectForKey:KEY_YEAR_DICTIONARY] forKey:KEY_EXP_YEAR];
    [resmanModel.totalExp setCustomObject:[applyModel.workEx objectForKey:KEY_MONTH_DICTIONARY] forKey:KEY_EXP_MONTH];
    [[DataManagerFactory getStaticContentManager] saveResmanFields:resmanModel];
}

/**
 This method overrides the UI of @p Self.savebtn button and changes the button to @p Already-Registered button. This is because @p Already-Registered button cannot be added seperately in the view controller.
 */

-(void) addAlreadyRegsisteredFooter
{
    [self convertButtonToAlreadyRegisteredButton:self.saveBtn];
}

-(void) viewDidAppear:(BOOL)animated
{
    if(self.isSwipePopDuringTransition)
        return;

    [AppTracer traceEndTime:TRACER_ID_RESMAN_LOGIN_DETAILS];
    
    [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_REGISTER];
    
    [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageCreateAccount];
 
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
    
    [AppTracer clearLoadTime:TRACER_ID_RESMAN_LOGIN_DETAILS];
}

-(void)setDefaultValues
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:KEY_DUPLICATE_APPLY])
    {
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:nil title:@"" subTitle:ERROR_MESSAGE_DUPLICATE_APPLY animationTime:5 showAnimationDuration:0];
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:KEY_DUPLICATE_APPLY];
        
    }
    userName = resmanModel.userName;
    //password = resmanModel.password;
    
    //NOTE:To refresh UI,while comming from
    //resman notification.
    [errorCellArr removeAllObjects];
    [self.editTableView reloadData];
}

-(NSArray *)getSuggestors {
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedStringsFromKey:K_EMAIL_DOMAIN_SUGGESTOR_KEY];
    return suggestors;
}

#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
# pragma mark Commenting for next release
//    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == ROW_TYPE_CELL_HEADING)
    {
        return RESMAN_HEADER_CELL_HEIGHT;
    }
    else if(indexPath.row == ROW_TYPE_USERNAME)
    {
        return 75;
    }
    else if(indexPath.row == ROW_TYPE_PASSWORD)
    {
        return 90;
    }
# pragma mark Commenting for next release
//    else if(indexPath.row == ROW_TYPE_NEXT_BUTTON)
//    {
//        return 56;
//    }
//    else if(indexPath.row == ROW_TYPE_SOCIAL_LOGIN)
//    {
//        if (SCREEN_HEIGHT == 480)
//            return 90;
//        else
//            return 130;
//    }
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
        case ROW_TYPE_CELL_HEADING:{
            
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
                 return cell;
            }
            
            break;
        }
            
            
        case ROW_TYPE_USERNAME:{
            
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
        case ROW_TYPE_PASSWORD:{
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.editModuleNumber = k_RESMAN_PAGE_LOGIN_DETAIL;

            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:password forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_LOGIN_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:indexPath.row];
            
            [cell.txtTitle displayHideBtn: passwordTxtFld.secureTextEntry];
            passwordTxtFld = cell.txtTitle;
            return cell;

        }
# pragma mark Commenting for next release
//        case ROW_TYPE_NEXT_BUTTON:
//        {
//            NSString* cellIndentifier = @"SaveButtonCell";
//            NGResmanSaveButtonCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
//            return cell;
//        }
//            
//        case ROW_TYPE_SOCIAL_LOGIN:
//        {
//            NSString* cellIndentifier = @"SocialLoginCell";
//            NGResmanSocialLoginCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
//            cell.delegate = self;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
//            return cell;
//        }
            
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
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

- (void)textField:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index {
    
    switch (textField.tag) {
            
        case ROW_TYPE_USERNAME:
            userName = textField.text;
            break;
        case ROW_TYPE_PASSWORD:
            password = textField.text;
            break;
        default:
            break;
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_USERNAME:
            userName = textFieldValue;
            [self hideKeyboardAndSuggester];
            
            break;
         case ROW_TYPE_PASSWORD:
            password = textFieldValue;
            break;
        default:
            break;
    }
}

- (void)textFieldDidStartEditing:(UITextField*)textField havingIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_USERNAME:
           
            self.scrollHelper.rowType = NGScrollRowTypeSuggestor;
            NSIndexPath *userIndexPath = [NSIndexPath indexPathForItem:ROW_TYPE_USERNAME inSection:0];
            self.scrollHelper.indexPathOfScrollingRow = userIndexPath;
            
            autoCompleter.isErrorViewVisibleInSearch= NO;
            [self addSuggestorBackGroundView:yForAutoCompletionTable];
            
             break;
    }
    
}

- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_USERNAME:
            [self hideKeyboardAndSuggester];
            [passwordTxtFld becomeFirstResponder];
            break;
        case ROW_TYPE_PASSWORD: [passwordTxtFld endEditing:YES];
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SocialLogin Methods

-(void) facebookButtonPressed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAnimator];
        
    });

    [NGSocialLoginManager sharedInstance].resmanModel = resmanModel;
    [NGSocialLoginManager sharedInstance].delegate = self;
    [[NGSocialLoginManager sharedInstance] facebookButtonPressed];
    
}
-(void)getResmanModelWithFacebookLogin:(NGResmanDataModel*)resModel
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAnimator];

        [self showAnimator];
    });

    resmanModel = resModel;
    //TODO: assuming not registered till we get the api
    __weak typeof(self) weakSelf = self;

    [weakSelf checkifSocialIdAlreadyRegistered:^(NGAPIResponseModal *modal) {


        userName = resmanModel.userName;
        password = resmanModel.password;
        [weakSelf saveResmanFieldsInDatabase];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf performSelector:@selector(displayEmailFieldAlonePage) withObject:nil afterDelay:1.0];
        });
        return ;
        
        
        if(modal.isSuccess){
        
            //TODO: assuming emailid not received from social accounts
            
            
            if(resmanModel.userName){
            //email received from social accounts
            
                
            
            }
            else{
            //email not received from social accounts
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayEmailFieldAlonePage];
                    
                });

            }
                
            
        
        }
        else{
        //TODO: handle error in API
        
        }
        
        
    }];
  
}


-(void) gPlusButtonPressed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAnimator];
        
    });
    [NGSocialLoginManager sharedInstance];
    [NGSocialLoginManager sharedInstance].resmanModel = resmanModel;
    [NGSocialLoginManager sharedInstance].delegate = self;
    [[NGSocialLoginManager sharedInstance] gPlusButtonPressed];
}
-(void)getResmanModelWithGPlusLogin:(NGResmanDataModel*)resModel{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAnimator];
        [self showAnimator];
    });

    resmanModel = resModel;
    //TODO: assuming not registered till we get the api
    __weak typeof(self) weakSelf = self;

    [weakSelf checkifSocialIdAlreadyRegistered:^(NGAPIResponseModal *modal) {
        
        userName = resmanModel.userName;
        password = resmanModel.password;
        [weakSelf saveResmanFieldsInDatabase];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf performSelector:@selector(displayEmailFieldAlonePage) withObject:nil afterDelay:1.0];
        });
        return ;
        
        
        if(modal.isSuccess){
            
            //TODO: assuming emailid not received from social accounts
            
            
            if(resmanModel.userName){
                //email received from social accounts
                
                
                
            }
            else{
                //email not received from social accounts
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayEmailFieldAlonePage];
                    
                });
                
            }
            
            
            
        }
        else{
            //TODO: handle error in API
            
        }
        
        
    }];
}
-(void)errorInGplusLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAnimator];
        
        
    });


}
-(void)errorInFacebookLogin{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAnimator];
        
        
    });

}
-(void) displayEmailFieldAlonePage
{
    [self hideAnimator];

    NGResmanSocialEmailRegistrationViewController *socialRegEmailVC = [[NGResmanSocialEmailRegistrationViewController alloc] initWithNibName:nil bundle:nil];
    if(_isComingFromMailer)
        socialRegEmailVC.isComingFromMailer = _isComingFromMailer;
    
    if(_isComingFromUnregApply)
        socialRegEmailVC.isComingFromUnregApply = _isComingFromUnregApply;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:socialRegEmailVC Animated:YES];
    
}
#pragma mark
-(void)checkifSocialIdAlreadyRegistered:(void (^)(NGAPIResponseModal* modal))callback{

    //TODO: implement when we get the API
    NGAPIResponseModal *model = [[NGAPIResponseModal alloc]init];
    callback(model);

}

#pragma mark- View methods

#pragma mark commenting for next release

//-(void)alreadyRegisteredPressed: (id)sender
//{
//        UIButton *button = (UIButton *)sender;
//        if (button.tag != EDIT_MNJ_SAVE_BTN)
//        {
//            [self saveButtonTapped:nil];
//        }
//        else
//        {
//            isAlreadyRegisteredTapped = TRUE;
//            NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
//            [appStateHandler setDelegate:self];
//            
//            [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:YES];
//        }
//    
//}

-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    [AppTracer traceStartTime:TRACER_ID_RESMAN_FRSHER_OR_EXP];

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
            
            [self checkIfEmailAlreadyRegistered];
        }
     }

}

-(void) convertButtonToAlreadyRegisteredButton:(UIButton *) button
{
    [button setBackgroundColor:[UIColor whiteColor]];
    
    NSMutableAttributedString *alreadyRegistered = [[NSMutableAttributedString alloc] initWithString:@"Already Registered? " attributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:(CGFloat)[FONT_SIZE_16 floatValue]], NSForegroundColorAttributeName: [UIColor grayColor]}];
    
    NSMutableAttributedString *login = [[NSMutableAttributedString alloc] initWithString:@"Login" attributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:(CGFloat)[FONT_SIZE_16 floatValue]], NSForegroundColorAttributeName: Clr_Blue_SearchJob}];
    
    [alreadyRegistered appendAttributedString:login];
    
    [button setAttributedTitle:alreadyRegistered forState:UIControlStateNormal];
}

-(void) convertButtonToSaveButton:(UIButton *) button
{
    button.backgroundColor = Clr_Blue_SearchJob;
    
    [[button titleLabel] setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:(CGFloat)FONT_SIZE_17.floatValue]];
    [[button titleLabel] setTextColor:[UIColor whiteColor]];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button setAttributedTitle:nil forState:UIControlStateNormal];
    
}

#pragma mark - Password hardcoded for now

-(void) saveResmanFieldsInDatabase {
    resmanModel.userName= userName;
    resmanModel.password= password;
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

-(NSMutableArray*) checkPasswordValidations: (NSMutableArray*)errArr
{
    NSMutableArray *passwordValidatorArray = [[ValidatorManager sharedInstance] validateValue:password withType:ValidationTypePassword withMinLength:PASSWORD_MIN_LENGTH withMaxLength:DEFAULT_MAX_LENGTH];
    
    if (passwordValidatorArray.count) {
        
        [errorCellArr addObject:[NSNumber numberWithInteger:2]];
        
        [passwordValidatorArray containsObject:[NSNumber numberWithInt:ValidationErrorTypeEmpty]]?[errArr addObject:@"Password"]:[errArr addObject:@"valid Password"];
    }
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

-(NSMutableArray*) checkValidations
{
    
    NSMutableArray *errArr= [[NSMutableArray alloc] init];
    [errorCellArr removeAllObjects];
   
    [self checkPasswordValidations:errArr];
    [self checkEmailValidations:errArr];
    
    [self.editTableView reloadData];
    return errArr;
    
}

-(void)customAlertbuttonClicked:(int)index{
    
    [NGHelper sharedInstance].isAlertShowing = FALSE;
    if (index == 0) {
        //modifiy alert button pressed
        userName = suggestedEmailAddressForUser;
        userNameTxtFld.text = userName;
        
    }
    [self checkIfEmailAlreadyRegistered];
    isSuggestingCorrectedDomain = FALSE;
    
    
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
                    
                    NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
                    [appStateHandler setDelegate:self];
                    
                    [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:YES];
                }
                else{
                    [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];
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

-(void)setPropertiesOfVC:(id)vc{
    
    if([vc isKindOfClass:[NGLoginViewController class]])
    {
        NGLoginViewController* viewC = (NGLoginViewController*)vc;
        
        //[viewC showViewWithType:LOGINVIEWTYPE_REGISTER_VIEW];
        [viewC setTitleForLoginView:@"Job Seeker Login"];
        
#pragma mark remove next line for next release
        viewC.showAlreadyRegisteredError = YES;
#pragma mark commenting for next release
//        if (!isAlreadyRegisteredTapped) {
//            viewC.showAlreadyRegisteredError = YES;
//            isAlreadyRegisteredTapped = !isAlreadyRegisteredTapped;
//        }
    }
    
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
    
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

@end

