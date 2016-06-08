//
//  NGResmanExpBasicDetailsViewController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 13/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanExpBasicDetailsViewController.h"
#import "NGCalenderPickerView.h"
#import "NGValueSelectionViewController.h"
#import "DDExpYear.h"
#import "DDExpMonth.h"
#import "DDCurrency.h"


typedef NS_ENUM(NSUInteger, kResmanExpBasicDetailFieldTag) {
    kResmanExpBasicDetailFieldTagPageHeader=0,
    kResmanExpBasicDetailFieldTagTotalExp,
    kResmanExpBasicDetailFieldTagDesignation,
    kResmanExpBasicDetailFieldTagCompany,
    kResmanExpBasicDetailFieldTagCurrency,
    kResmanExpBasicDetailFieldTagCurrentSalary
};

@interface NGResmanExpBasicDetailsViewController ()<AutocompletionTableViewDelegate,ProfileEditCellDelegate,NGCalenderDelegate,ValueSelectorDelegate>{
    
    
    NGResmanDataModel *resmanModel;
    AutocompletionTableView *autoCompleter;
    NSArray *suggesterDataDesignation;
    NSArray *suggesterDataCompany;
    NSLayoutConstraint *autoCompletionHeightConstraints;
    UIView *suggestorBackgroundView;
    NSString *currentDesignation;
    NSString *currentCompany;
    
    BOOL isPickerExist; //    Check isPickerExist on right side of panel
    NGCalenderPickerView *valuePicker; // a Controller class for displaying in right side of panel
    BOOL isValueSelectorExist; // Check isValueSelectorExist on right side of panel
    
    NSMutableDictionary *allExperiencePickerParams;
    NSMutableArray *ddContentArr;
    NGCustomPickerModel *pickerModel;
    NSMutableDictionary* selectedExpOfYears;
    NSMutableDictionary* selectedExpOfMonths;
    
    NSString *salary;
    NSMutableDictionary *currency;
    
    UIView *footerView;
    
    NSInteger yForAutoCompletionTable;
}
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side

@end

@implementation NGResmanExpBasicDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isValueSelectorExist    =   NO;
    suggesterDataDesignation = [self getDesignationSuggestors];
    suggesterDataCompany = [self getCompanySuggestors];
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;

}
-(void)viewWillAppear:(BOOL)animated{
   
    
    [self.scrollHelper listenToKeyboardEvent:YES];
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    
    self.scrollHelper.headerHeight = RESMAN_HEADER_CELL_HEIGHT;
    self.scrollHelper.rowHeight = 75;
    [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageExperienceBasicDetails];
    
    [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_WORK_EXP_EXPERIENCED];

    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 1/4"];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    
    [self setSaveButtonTitleAs:@"Next"];
    
    if (resmanModel) {
        currentDesignation = resmanModel.designation;
        currentCompany = resmanModel.company;
        
        if ([resmanModel.totalExp objectForKey:KEY_EXP_YEAR] && [[resmanModel.totalExp objectForKey:KEY_EXP_YEAR] objectForKey:KEY_ID]) {
            selectedExpOfYears = [resmanModel.totalExp objectForKey:KEY_EXP_YEAR];
        }else{
            selectedExpOfYears = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_ID,@"",KEY_VALUE, nil];
        }
        
        if ([resmanModel.totalExp objectForKey:KEY_EXP_MONTH] && [[resmanModel.totalExp objectForKey:KEY_EXP_MONTH] objectForKey:KEY_ID]) {
            selectedExpOfMonths = [resmanModel.totalExp objectForKey:KEY_EXP_MONTH];
        }else{
            selectedExpOfMonths = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_ID,@"",KEY_VALUE, nil];
        }
        
       salary = resmanModel.currentSalary;
       currency = resmanModel.currency? resmanModel.currency:[NSMutableDictionary dictionary];

        
    }else{
        currentDesignation = nil;
        currentCompany = nil;
        salary = nil;
    }
    
    allExperiencePickerParams = [[NSMutableDictionary alloc]init];
    
    
    // to reflect error cell array while moving back
    [self.editTableView reloadData];
    [NGDecisionUtility checkNetworkStatus];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.scrollHelper listenToKeyboardEvent:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    [super viewDidAppear:animated];
    [self setAutomationLabel];


}
-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:@"ExperienceBasicDeails_table" forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
    
}
/**
 *   a Experience Picker View appears on right side on editing the Experience textfield.
 */
-(void)setAllEditExperiencePickers {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableArray* arrColumn1 = [[ddContentArr fetchObjectAtIndex:0] objectForKey:K_DROPDOWN_CONTENT_ARRAY_SECTION1];
    
    NSMutableArray* arrColumn2 = [[ddContentArr fetchObjectAtIndex:1] objectForKey:K_DROPDOWN_CONTENT_ARRAY_SECTION1];
    
    [dict setCustomObject:@"Experience" forKey:K_KEY_PICKER_HEADER];
    [dict setCustomObject:@"2" forKey:K_KEY_PICKER_TOTAL_COLUMN];
    [dict setCustomObject:arrColumn1 forKey:K_KEY_PICKER_ARRAY_COLUMN_1];
    [dict setCustomObject:arrColumn2 forKey:K_KEY_PICKER_ARRAY_COLUMN_2];
    [dict setCustomObject:@"Years" forKey:K_KEY_PICKER_LABEL_COLUMN_1];
    [dict setCustomObject:@"Months" forKey:K_KEY_PICKER_LABEL_COLUMN_2];
    [dict setCustomObject:[NSNumber numberWithInt:31] forKey:K_KEY_PICKER_DISABLE_VALUE];
    
    [dict setCustomObject:[NSNumber numberWithInteger:DD_EDIT_EXPERIENCE] forKey:K_DROPDOWN_TYPE];
    [allExperiencePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%lu",(unsigned long)kResmanExpBasicDetailFieldTagTotalExp]];
    
    arrColumn1 = nil;
    arrColumn2 = nil;
    dict = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*)checkAllValidations{
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (0 < [vManager validateValue:[selectedExpOfYears objectForKey:KEY_ID] withType:ValidationTypeString].count && 0 < [vManager validateValue:[selectedExpOfMonths objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Total Work Experience"];
        [self setItem:kResmanExpBasicDetailFieldTagTotalExp InErrorCollectionWithActionAdd:YES];
    }
    
    if (0 < [vManager validateValue:currentDesignation withType:ValidationTypeString].count){
        
        [arr addObject:@"Current Designation"];
        [self setItem:kResmanExpBasicDetailFieldTagDesignation InErrorCollectionWithActionAdd:YES];
    }
    
    
    if (0 < [vManager validateValue:currentCompany withType:ValidationTypeString].count){
        
        [arr addObject:@"Current Employer"];
        [self setItem:kResmanExpBasicDetailFieldTagCompany InErrorCollectionWithActionAdd:YES];
    }
    
    if (0 < [vManager validateValue:salary withType:ValidationTypeString].count){
        
        [arr addObject:@"Monthly Salary"];
        [self setItem:kResmanExpBasicDetailFieldTagCurrentSalary InErrorCollectionWithActionAdd:YES];
    }
    else {
        
        if(0<[vManager validateValue:salary withType:ValidationTypeNumber].count){
            
            [arr addObject:@"Only Digits are allowed in salary"];
            [self setItem:kResmanExpBasicDetailFieldTagCurrentSalary InErrorCollectionWithActionAdd:YES];
            
        }
        
       else  if([salary integerValue] < 0  || [salary integerValue]== 0||  [salary integerValue] > 100000000 ){
        
            [arr addObject:@"Monthly salary range allowed is 1 - 100000000"];
           [self setItem:kResmanExpBasicDetailFieldTagCurrentSalary InErrorCollectionWithActionAdd:YES];
           
            
        }
    }
    
    
    if (0 < [vManager validateValue:[currency objectForKey:KEY_VALUE] withType:ValidationTypeString].count){
        
        [arr addObject:@"Currency"];
        [self setItem:kResmanExpBasicDetailFieldTagCurrency InErrorCollectionWithActionAdd:YES];
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
-(void)saveButtonPressed{
    [self.view endEditing:YES];
    
    NSString *errorTitle = @"Invalid Details";
    NSMutableArray *arrValidations = [self checkAllValidations];
    NSString *errorMessage = @"Please specify ";
    
    if([arrValidations count]){
        
        for (int i = 0; i< [arrValidations count]; i++) {
            
            if (i == [arrValidations count]-1)
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
            
            currentDesignation = [NSString stripTags:currentDesignation];
            currentCompany = [NSString stripTags:currentCompany];
            
            
            NSMutableDictionary *totalExpDic = [[NSMutableDictionary alloc] init];
            
            [totalExpDic setCustomObject:selectedExpOfYears forKey:@"yearExp"];
            [totalExpDic setCustomObject:selectedExpOfMonths forKey:@"monthExp"];
            resmanModel.designation = currentDesignation;
            resmanModel.company = currentCompany;
            resmanModel.currentSalary = salary;
            resmanModel.currency = currency;
            resmanModel.totalExp = totalExpDic;
            
            [self setIsRequestInProcessing:NO];
            
            [[DataManagerFactory getStaticContentManager] saveResmanFields:resmanModel];
            
            NGResmanExpProfessionalDetailsViewController *expProfessionalDetailVC = [[NGResmanExpProfessionalDetailsViewController alloc] init];
            [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:expProfessionalDetailVC Animated:YES];
        }
    }
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return RESMAN_HEADER_CELL_HEIGHT;
    }
    return 75;
}
- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    if (indexPath.row == 0) {
        
        NGCustomValidationCell *headerCell = [self.editTableView dequeueReusableCellWithIdentifier:@""];
        if (headerCell == nil)
        {
            headerCell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            txtLabel.textAlignment = NSTextAlignmentCenter;
            [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
            txtLabel.text =@"Mention your Work Experience details";
            txtLabel.textColor = [UIColor darkGrayColor];
            headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [headerCell.contentView addSubview:txtLabel];
            return headerCell;
        }
        
        
    }
    
    static NSString* cellIndentifier = @"EditProfileCell";
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = k_RESMAN_PAGE_EXP_BASIC_DETAIL;
    cell.delegate = self;
    
    [cell.txtTitle setTextColor:[UIColor darkTextColor]];
    [cell.lblOtherTitle setTextColor:[UIColor darkGrayColor]];
 //   NSString *txtTitleAccessibilityString = @"";
 //   NSString *cellAccessibilityString = @"";
    
    NSInteger rowIndex = [indexPath row];
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    cell.otherDataStr = nil;
    
    switch (rowIndex) {
            
        case kResmanExpBasicDetailFieldTagTotalExp:{
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[self getFinalExperience] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_BASIC_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];
        }
            break;
            
        case kResmanExpBasicDetailFieldTagDesignation:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:currentDesignation forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_BASIC_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];
            [self addAutoCompleterForTextField:cell.txtTitle];
        }break;
            
        case kResmanExpBasicDetailFieldTagCompany:{
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:currentCompany forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_BASIC_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];
            [self addAutoCompleterForTextField:cell.txtTitle];
        }break;
            
        case kResmanExpBasicDetailFieldTagCurrentSalary:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:salary forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_BASIC_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];
        }
            break;
           
        case kResmanExpBasicDetailFieldTagCurrency :{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[currency objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_BASIC_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];
            break;

        }
            
        default:
            break;
    }
    if (indexPath.row) {
    
        
        return cell;

    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //We need to hide keyboard, hence we required this
    [self.view endEditing:YES];
    
    
    NSInteger rowSelected = [indexPath row];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    switch (rowSelected) {
        case kResmanExpBasicDetailFieldTagTotalExp:{
            //experience
            isPickerExist = YES;
            if(!valuePicker){
                valuePicker = [[NGCalenderPickerView alloc] initWithNibName:nil bundle:nil];
                valuePicker.delegate = self;
                
            }
            
            [APPDELEGATE.container setRightMenuViewController:valuePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            
            valuePicker.calType = NGCalenderTypeMMYYYY;
            valuePicker.isPickerTypeValue = YES;
            
            valuePicker.selectedValueColumn1 = (0>=[vManager validateValue:[selectedExpOfYears objectForKey:KEY_ID] withType:ValidationTypeString].count)?[selectedExpOfYears objectForKey:KEY_ID]:@"0";
            
            valuePicker.selectedValueColumn2 = (0>=[vManager validateValue:[selectedExpOfMonths objectForKey:KEY_ID] withType:ValidationTypeString].count)?[selectedExpOfMonths objectForKey:KEY_ID]:@"0";
            
            [valuePicker setPickerModel:pickerModel];
            [valuePicker displayDropdownData:DD_EDIT_EXPERIENCE];

            [valuePicker refreshData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
               
            }];
            
        }break;
            
        case kResmanExpBasicDetailFieldTagCurrency:{
            
            if (!_valueSelector)
            {
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            if(0>=[vManager validateValue:[currency objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [currency objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_CURRENCY;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
            break;
         
        }
        
        default:
            break;
    }
    vManager = nil;
    
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
    
    if (kResmanExpBasicDetailFieldTagDesignation == paramTextField.tag) {
        autoCompleter.suggestionsDictionary = suggesterDataDesignation;//will be same for both search and modify search

    }else if (kResmanExpBasicDetailFieldTagCompany == paramTextField.tag){
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
    
    if (kResmanExpBasicDetailFieldTagDesignation == textFieldTag) {
         return suggesterDataDesignation;
        
    }else if (kResmanExpBasicDetailFieldTagCompany == textFieldTag){
        return suggesterDataCompany;
        
    }else{
        return nil;
    }
}
- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText {
    
    NSInteger textFieldTag = autoCompleter.textField.tag;
    
    if (kResmanExpBasicDetailFieldTagDesignation == textFieldTag) {
        currentDesignation = selectedText;
        
    }else if (kResmanExpBasicDetailFieldTagCompany == textFieldTag){
        currentCompany = selectedText;
        
    }else{
        //dummy
    }
    
    
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
    
    //auto completion row to 0, so that
    //pre-populated values dont get visible
    [autoCompleter clearAutoCompletionTable];
    
}

- (void)textFieldDidStartEditing:(UITextField*)textField havingIndex:(NSInteger)index{
    if(textField.tag == kResmanExpBasicDetailFieldTagDesignation){
        
        if (IS_IPHONE4) {
            self.scrollHelper.rowType = NGScrollRowTypeSuggestorOffSet;
        }else{
            self.scrollHelper.rowType = NGScrollRowTypeSuggestor;
        }

        NSIndexPath *designationIndexPath = [NSIndexPath indexPathForItem:kResmanExpBasicDetailFieldTagDesignation inSection:0];
        self.scrollHelper.indexPathOfScrollingRow = designationIndexPath;
        
        autoCompleter.isErrorViewVisibleInSearch= NO;
        autoCompleter.textField = textField;
        [self addSuggestorBackGroundView:yForAutoCompletionTable];
        
    }else if (textField.tag == kResmanExpBasicDetailFieldTagCompany){
        if (IS_IPHONE4) {
            self.scrollHelper.rowType = NGScrollRowTypeSuggestorOffSet;
        }else{
            self.scrollHelper.rowType = NGScrollRowTypeSuggestor;
        }
        NSIndexPath *companyIndexPath = [NSIndexPath indexPathForItem:kResmanExpBasicDetailFieldTagCompany inSection:0];
        self.scrollHelper.indexPathOfScrollingRow = companyIndexPath;
        
        autoCompleter.isErrorViewVisibleInSearch= NO;
        autoCompleter.textField = textField;
        [self addSuggestorBackGroundView:yForAutoCompletionTable];
        
    }else if(textField.tag == kResmanExpBasicDetailFieldTagCurrentSalary){
        self.scrollHelper.rowType = NGScrollRowTypeNormal;
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:kResmanExpBasicDetailFieldTagCurrentSalary inSection:0];
        
    }else{
        
    }
}
- (void)textFieldDidEndEditing:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
   
    switch (textField.tag) {
            
        case kResmanExpBasicDetailFieldTagDesignation:
            [self hideKeyboardAndSuggester];
            currentDesignation = textField.text;
            
            break;
            
        case kResmanExpBasicDetailFieldTagCompany:
            [self hideKeyboardAndSuggester];
            currentCompany = textField.text;
            
            break;
            
        case kResmanExpBasicDetailFieldTagCurrentSalary:
            salary = textField.text;
            [self.editTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
            
        default:
            break;
    }


}
- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{
    
    switch (textField.tag) {
    
        case kResmanExpBasicDetailFieldTagDesignation:
            [self hideKeyboardAndSuggester];
            currentDesignation = textField.text;
            break;
            
        case kResmanExpBasicDetailFieldTagCompany:
            [self hideKeyboardAndSuggester];
            currentCompany = textField.text;
            break;
        case kResmanExpBasicDetailFieldTagCurrentSalary:
            salary = textField.text;
            break;
            
        default:
            break;
    }
    
    
}

- (void)textField:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
  
    switch (textField.tag) {
            
        case kResmanExpBasicDetailFieldTagDesignation:
            currentDesignation = textField.text;
            break;
            
        case kResmanExpBasicDetailFieldTagCompany:
            currentCompany = textField.text;
            break;
        case kResmanExpBasicDetailFieldTagCurrentSalary:
            salary = textField.text;
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
-(void)hideSuggesterBackGrndView:(BOOL)status{
    [suggestorBackgroundView setHidden:status];
    [autoCompleter setHidden:status];
}

#pragma mark - NGCalender Delegate
-(void)didSelectCalenderPickerWithValues:(NSDictionary *)responseParams success:(BOOL)successFlag andPickerType:(BOOL)isPickerTypeValue{
    
    if(successFlag)
    {
        
        if(isPickerTypeValue)
        {
            [self handleDDOnSelection:responseParams];
        }
        else{
            
        }
    }

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    [self.editTableView reloadData];
    
}

#pragma mark ValueSelector Delegate
/**
 *  @name Value Selector Delegate
 */
-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    [self.editTableView reloadData];
    
}
/**
 *  Method updates the ddContentArr objects with selected value from drop down list / TextFields
 *
 *  @param responseParams  NSDictionary class conatining objects  for particular Keys
 */
-(void)handleDDOnSelection:(NSDictionary *)responseParams {
    
    NSInteger ddType = [[responseParams objectForKey:K_DROPDOWN_TYPE]integerValue];
    NSArray *arrSelectedIds = [responseParams objectForKey:K_DROPDOWN_SELECTEDIDS];
    NSArray* arrSelectedValues = [responseParams objectForKey:K_DROPDOWN_SELECTEDVALUES];
    
    switch (ddType) {
            
        case DD_EDIT_EXPERIENCE:{
            //year
            NSString *tmpSelectedExpYrs = [responseParams objectForKey:K_KEY_PICKER_SELECTED_VALUE_1];
            NSArray *selectedValues = @[tmpSelectedExpYrs];
         
            if (selectedValues.count>0) {
                
                [selectedExpOfYears setValue:tmpSelectedExpYrs forKey:KEY_VALUE];
                [selectedExpOfYears setValue:[selectedValues fetchObjectAtIndex:0] forKey:KEY_ID];
                [resmanModel.totalExp setValue:selectedExpOfYears forKey:@"yearExp"];
                [self setItem:kResmanExpBasicDetailFieldTagTotalExp InErrorCollectionWithActionAdd:NO];
            }
            
            //month
            NSString *tmpSelectedExpMonths = [responseParams objectForKey:K_KEY_PICKER_SELECTED_VALUE_2];
            selectedValues = @[tmpSelectedExpMonths];
            if (selectedValues.count>0) {
                
                [selectedExpOfMonths setValue:tmpSelectedExpMonths forKey:KEY_VALUE];
                [selectedExpOfMonths setValue:[selectedValues firstObject] forKey:KEY_ID];
                [resmanModel.totalExp setValue:selectedExpOfMonths forKey:@"monthExp"];
                [self setItem:kResmanExpBasicDetailFieldTagTotalExp InErrorCollectionWithActionAdd:NO];
            }
            selectedValues = nil;
        }
            break;
            
        case DDC_CURRENCY :{
            
         
            if (arrSelectedIds.count) {
                [currency setCustomObject:[arrSelectedValues fetchObjectAtIndex:0] forKey:KEY_VALUE];
                [currency setCustomObject:[arrSelectedIds fetchObjectAtIndex:0] forKey:KEY_ID];
                
            }else{
                
                [currency setCustomObject:@"" forKey:KEY_VALUE];
                [currency setCustomObject:@"" forKey:KEY_ID];
            }

        }
            
            
        default:
            break;
    }
    
}
- (NSString*)getFinalExperience{
    
    NSString *tmpExpYear = [selectedExpOfYears objectForKey:KEY_VALUE];
    NSString *tmpExpMonth = [selectedExpOfMonths objectForKey:KEY_VALUE];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if ([@"" isEqualToString:[selectedExpOfYears objectForKey:KEY_ID]] && [@"" isEqualToString:[selectedExpOfMonths objectForKey:KEY_ID]]) {
        return nil;
    }
    
    if (0<[vManager validateValue:tmpExpYear withType:ValidationTypeString].count) {
        tmpExpYear = @"0";
    }
    if (0<[vManager validateValue:tmpExpMonth withType:ValidationTypeString].count) {
        tmpExpMonth = @"0";
    }
    
    
    NSString* finalString = @"";
    NSString* appendString1 = @"Years";
    NSString* appendString2 = @"Months";
    
    if ([tmpExpYear isEqualToString:@"0"] ||
        [tmpExpYear isEqualToString:@"1"])
        appendString1 = @"Year";
    
    if ([tmpExpMonth isEqualToString:@"0"] ||
        [tmpExpMonth isEqualToString:@"1"])
        appendString2 = @"Month";
    
    if ([tmpExpMonth isEqualToString:@"0"])
        finalString = [NSString stringWithFormat:@"%@ %@",tmpExpYear, appendString1];
    else
        finalString = [NSString stringWithFormat:@"%@ %@ - %@ %@",
                       tmpExpYear,appendString1, tmpExpMonth, appendString2];
    if ([finalString isEqualToString:@"fresher Years"] ||
        [finalString isEqualToString:@"fresher Year"] ) {
        finalString = @"0 Year";
    }
    return finalString;
}
-(void)dealloc{
    self.editTableView.delegate = nil;
}
@end
