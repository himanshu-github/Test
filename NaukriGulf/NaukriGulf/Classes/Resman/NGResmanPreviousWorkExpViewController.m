//
//  NGResmanPreviousWorkExpViewController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 24/03/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanPreviousWorkExpViewController.h"
#import "NGResmanFresherEducationViewController.h"
#import "AutocompletionTableView.h"

typedef NS_ENUM(NSUInteger, kResmanPreviousWorkExpFieldTag) {
    kResmanPreviousWorkExpFieldTagDesignation=1,
    kResmanPreviousWorkExpFieldTagPreviousCompany=2
};

@interface NGResmanPreviousWorkExpViewController ()<AutocompletionTableViewDelegate,ProfileEditCellDelegate,NGErrorViewDelegate>{

    NSString *designation;
    NSString *previousCompany;
    
    AutocompletionTableView *autoCompleter;
    NSArray *suggesterDataDesignation;
    NSArray *suggesterDataCompany;
    
    NSLayoutConstraint *autoCompletionHeightConstraints;
    UIView *suggestorBackgroundView;
    
    UIView *footerView;
    
    NSInteger yForAutoCompletionTable;
    
    NGResmanDataModel *resmanModel;
}

@end

@implementation NGResmanPreviousWorkExpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    suggesterDataDesignation = [self getDesignationSuggestors];
    suggesterDataCompany = [self getCompanySuggestors];
    
    [self setSaveButtonTitleAs:@"Next"];
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    
    if(resmanModel){
        if(resmanModel.prevDesignation)
            designation = resmanModel.prevDesignation;
        if(resmanModel.previousCompany)
            previousCompany = resmanModel.previousCompany;
    }
    
    [self.scrollHelper listenToKeyboardEvent:YES];
    self.scrollHelper.headerHeight = RESMAN_HEADER_CELL_HEIGHT;
    self.scrollHelper.rowHeight = 75;
    
    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Almost There..."];
    
    [self addSkipButton];
    
    [NGDecisionUtility checkNetworkStatus];

}
-(void)viewWillDisappear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillDisappear:animated];
    
    [self.scrollHelper listenToKeyboardEvent:NO];
}
-(void) viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewDidAppear:animated];
    
    [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_PREV_EXP_EXPERIENCED];
}
-(NSArray *)getDesignationSuggestors
{
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedDesignationWithFrequency:DESIGNATION_SUGGESTOR_KEY];
    return suggestors;
}
-(NSArray *)getCompanySuggestors
{
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedCompanyWithFrequency:COMPANY_SUGGESTOR_KEY];
    return suggestors;
}
- (NSMutableArray*)checkAllValidations{
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    BOOL isDesignationValid = (0 >= [vManager validateValue:designation withType:ValidationTypeString].count);
    
    BOOL isPrevCompanyValid = (0 >= [vManager validateValue:previousCompany withType:ValidationTypeString].count);
    
    //NOTE:Blocker user if any of the field is empty
    if(NO == isDesignationValid){
        [arr addObject:@"Previous Designation"];
        [self setItem:kResmanPreviousWorkExpFieldTagDesignation InErrorCollectionWithActionAdd:YES];
    }
    
    if (NO == isPrevCompanyValid){
        [arr addObject:@"Previous Employer"];
        [self setItem:kResmanPreviousWorkExpFieldTagPreviousCompany InErrorCollectionWithActionAdd:YES];
    }
    
    [self.editTableView reloadData];
    
    return arr;
}
- (void)setItem:(NSInteger)paramIndex InErrorCollectionWithActionAdd:(BOOL)paramIsAdd{
    NSInteger rowForItem = paramIndex;
    if (paramIsAdd) {
        [errorCellArr addObject:[NSNumber numberWithInteger:rowForItem]];
    }else{
        [errorCellArr removeObject:[NSNumber numberWithInteger:rowForItem]];
    }
}
-(NSMutableDictionary*)getParametersInDictionary{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setCustomObject:designation forKey:@"designation"];
    
    [params setCustomObject:designation forKey:@"designationEN"];
    
    [params setCustomObject:previousCompany forKey:@"organization"];
    [params setCustomObject:previousCompany forKey:@"organizationEN"];
    
    
    NSMutableDictionary *finalParams = [[NSMutableDictionary alloc] init];
    [finalParams setCustomObject:params forKey:@"MiniWorkExperience"];

    return finalParams;
}

-(void) saveResmanFieldsInDatabase {
    resmanModel.prevDesignation= designation;
    resmanModel.previousCompany= previousCompany;
    [[DataManagerFactory getStaticContentManager] saveResmanFields:resmanModel];
}

-(void)saveButtonPressed{
    [self.view endEditing:YES];
   
    NSString *errorTitle = @"Invalid Details";
    NSMutableArray *arrValidations = [self checkAllValidations];
    NSString *errorMessage = @"Please specify ";
        if([arrValidations count]){
            
            for (NSInteger i = [arrValidations count]-1; i>=0; i--) {
                
                if (i == 0)
                    errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@",
                                                                          [arrValidations fetchObjectAtIndex:i]]];
                else
                    errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@, ",
                                                                          [arrValidations fetchObjectAtIndex:i]]];
            }
            
            [NGUIUtility showAlertWithTitle:errorTitle withMessage:
             [NSArray arrayWithObjects:errorMessage, nil]
                        withButtonsTitle:@"OK" withDelegate:nil];
            
        }else{
            
        //preventing double click of user on nav bar next button
        if (!self.isRequestInProcessing) {
            
            [self setIsRequestInProcessing:YES];
            
            [self showAnimator];
            
            designation = [NSString stripTags:designation];
            previousCompany = [NSString getFilteredText:previousCompany];
            
            [self saveResmanFieldsInDatabase];
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
            
            __weak NGResmanPreviousWorkExpViewController *weakSelf = self;
            NSMutableDictionary *params = [self getParametersInDictionary];

            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf hideAnimator];
                    
                    weakSelf.isRequestInProcessing = NO;
                    
                    if (responseInfo.isSuccess) {
                        NGResmanFresherEducationViewController *freshEduVC = [[NGResmanFresherEducationViewController alloc] init];
                        [(IENavigationController*)self.navigationController pushActionViewController:freshEduVC Animated:YES];

                    }
                    
                });
                
            }];
        }
    }
}
-(void)skipButtonPressed:(UIButton*)sender{
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_SKIP_PREV_EXP_EXPERIENCED withEventLabel:K_GA_RESMAN_EVENT_SKIP_PREV_EXP_EXPERIENCED withEventValue:nil];
    
    [NGUIUtility showAlertWithTitle:nil withMessage:[NSArray arrayWithObjects:@"Let the Employers know of your rich Work Experience. Are you sure you want to skip?", nil]
                withButtonsTitle:@"No,Yes" withDelegate:self];
}
-(void)customAlertbuttonClicked:(NSInteger)index{
    if (0 == index) {
        //do nothing
    }else if (1 == index){
        //discard data and take user to education detail page
        NGResmanFresherEducationViewController *freshEduVC = [[NGResmanFresherEducationViewController alloc] init];
        [(IENavigationController*)self.navigationController pushActionViewController:freshEduVC Animated:YES];
    }else{
        //dummy
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        
        NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:@"" ];
        if (cell == nil)
        {
            cell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
            txtLabel.textAlignment = NSTextAlignmentCenter;
            [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
            txtLabel.text =@"Your Previous Work Experiences";
            txtLabel.textColor = [UIColor darkGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:txtLabel];
            return cell;
        }
        
       
    }else{
        NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
        [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
        return cell;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0==indexPath.row) {
        return RESMAN_HEADER_CELL_HEIGHT;
    }
    return 75;
}
- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    static NSString* cellIndentifier = @"EditProfileCell";
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = k_RESMAN_PAGE_PREVIOUS_WORK_EXP;
    cell.delegate = self;
    
    [cell.txtTitle setTextColor:[UIColor darkTextColor]];
    [cell.lblOtherTitle setTextColor:[UIColor darkGrayColor]];
  
    
    NSInteger rowIndex = [indexPath row];
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    cell.otherDataStr = nil;
    
    switch (rowIndex) {
        case kResmanPreviousWorkExpFieldTagDesignation:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:designation forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_PREVIOUS_WORK_EXP] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];
            [self addAutoCompleterForTextField:cell.txtTitle];
        }break;
            
        case kResmanPreviousWorkExpFieldTagPreviousCompany:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:previousCompany forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_PREVIOUS_WORK_EXP] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];
            [self addAutoCompleterForTextField:cell.txtTitle];

        }break;
            
        default:
            break;
    }

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (AutocompletionTableView *)addAutoCompleterForTextField:(UITextField*)paramTextField{
    
    if (!autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        autoCompleter = [[AutocompletionTableView alloc] initWithTextField:paramTextField inViewController:self withOptions:options withDefaultStyle:NO];
        autoCompleter.autoCompleteDelegate = self;
        autoCompleter.isEmailAddressSuggestor = NO;
        
        [self.view addSubview:autoCompleter];
        
        [self addconstaint];
        
        autoCompleter.isMultiSelect = NO;
    }
    
    if (kResmanPreviousWorkExpFieldTagDesignation == paramTextField.tag) {
        autoCompleter.suggestionsDictionary = suggesterDataDesignation;//will be same for both search and modify search
        
    }else if (kResmanPreviousWorkExpFieldTagPreviousCompany == paramTextField.tag){
        autoCompleter.suggestionsDictionary = suggesterDataCompany;//will be same for both search and modify search
    }else{
        //dummy
    }
    
    if (NO == [paramTextField respondsToSelector:@selector(textFieldValueChanged:)]) {
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
    NSInteger textFieldTag = autoCompleter.textField.tag;
    
    if (kResmanPreviousWorkExpFieldTagDesignation == textFieldTag) {
        return suggesterDataDesignation;
        
    }else if (kResmanPreviousWorkExpFieldTagPreviousCompany == textFieldTag){
        return suggesterDataCompany;
        
    }else{
        return nil;
    }
}
- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText {
    NSInteger textFieldTag = autoCompleter.textField.tag;
    
    if (kResmanPreviousWorkExpFieldTagDesignation == textFieldTag) {
        designation = selectedText;
        
    }else if (kResmanPreviousWorkExpFieldTagPreviousCompany == textFieldTag){
        previousCompany = selectedText;
        
    }else{
        //dummy
    }
}
-(void)hideKeyboardAndSuggester{
    
    [self.view endEditing:YES];
    [self hideSuggesterBackGrndView:YES];
    
    //auto completion row to 0, so that
    //pre-populated values dont get visible
    [autoCompleter clearAutoCompletionTable];
}
-(void)hideSuggesterBackGrndView:(BOOL)status{
    [suggestorBackgroundView setHidden:status];
    [autoCompleter setHidden:status];
}
-(void)addTapGestureToSuggestorBackGroundView{
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnSuggestorBackGrndView)];
    [suggestorBackgroundView addGestureRecognizer:singleFingerTap];
}
- (void)handleSingleTapOnSuggestorBackGrndView{
    
    [self hideKeyboardAndSuggester];
}

- (void)textFieldDidStartEditing:(UITextField*)textField havingIndex:(NSInteger)index{
    if(textField.tag == kResmanPreviousWorkExpFieldTagDesignation){
        
        self.scrollHelper.rowType = NGScrollRowTypeSuggestor;
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:kResmanPreviousWorkExpFieldTagDesignation inSection:0];
        
        autoCompleter.isErrorViewVisibleInSearch= NO;
        autoCompleter.textField = textField;
        [self addSuggestorBackGroundView:yForAutoCompletionTable];
        
    }else if (textField.tag == kResmanPreviousWorkExpFieldTagPreviousCompany){
        self.scrollHelper.rowType = NGScrollRowTypeSuggestor;
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:kResmanPreviousWorkExpFieldTagPreviousCompany inSection:0];
        
        autoCompleter.isErrorViewVisibleInSearch= NO;
        autoCompleter.textField = textField;
        [self addSuggestorBackGroundView:yForAutoCompletionTable];
        
    }else{
        //dummy
    }
}
- (void)textFieldDidEndEditing:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case kResmanPreviousWorkExpFieldTagDesignation:
            [self hideKeyboardAndSuggester];
            designation = textField.text;
            break;
            
        case kResmanPreviousWorkExpFieldTagPreviousCompany:
            [self hideKeyboardAndSuggester];
            previousCompany = textField.text;
            break;
            
        default:
            break;
    }
    
    
}
- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case kResmanPreviousWorkExpFieldTagDesignation:
            [self hideKeyboardAndSuggester];
            designation = textField.text;
            break;
            
        case kResmanPreviousWorkExpFieldTagPreviousCompany:
            [self hideKeyboardAndSuggester];
            previousCompany = textField.text;
            break;
            
        default:
            break;
    }
    
    
}

- (void)textField:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case kResmanPreviousWorkExpFieldTagDesignation:
            designation = textField.text;
            break;
            
        case kResmanPreviousWorkExpFieldTagPreviousCompany:
            previousCompany = textField.text;
            break;
            
        default:
            break;
    }
    
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
-(void)showingTheOptions:(BOOL)status{
    
    [self hideSuggesterBackGrndView:!status];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
