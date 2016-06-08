//
//  NGEditWorkExperienceViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/13/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditWorkExperienceViewController.h"
#import "AutocompletionTableView.h"
#import "NGEditProfileSegmentedCell.h"
#import "NGCalenderPickerView.h"
#import "NGProjectRemoveInfoCell.h"
#import "NGEditProfileTextviewCell.h"

@interface NGEditWorkExperienceViewController ()<ProfileEditCellDelegate,ProfileEditCellSegmentDelegate,NGCalenderDelegate,DeleteInfoCellDelegate,EditProfileTextViewCellDelegate,AutocompletionTableViewDelegate>{
    
    NSMutableDictionary *allDatePickerParams;
    NSString *designation;
    NSString *organisation;
    NSString *currentCompany;
    NSString *startDate;
    NSString *tillDate;
    NSString *jobProfile;
    NSInteger selectedIndex;
 
    NGCalenderPickerView *datePicker;
    BOOL shouldHideRemoveButton;
    
    NSLayoutConstraint *autoCompletionHeightConstraints;
    NSLayoutConstraint *autoCompletionTopConstraints;
    UIView *suggestorBackgroundView;
    
    AutocompletionTableView *autoCompleter;
    NSArray *suggesterDataDesignation;
    NSArray *suggesterDataCompany;
    
    BOOL isInitialParamDictUpdated;
}

@end

@implementation NGEditWorkExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self customizeNavBarWithTitle:@"Work Experience"];
    
    suggesterDataDesignation = [self getDesignationSuggestors];
    suggesterDataCompany = [self getCompanySuggestors];
    
    allDatePickerParams = [[NSMutableDictionary alloc]init];
    [self setAllDatePickers];
    selectedIndex =2;
    isInitialParamDictUpdated = NO;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    if(self.isSwipePopDuringTransition)
        return;
    self.isRequestInProcessing= FALSE;
    [self updateDataWithParams:self.modalClassObj];
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
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"edit_workExperience_table"] forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
}


-(void) addconstaint {
    
    NSLayoutConstraint *autoCompletionLeftConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSInteger yForAutoCompletionTable = 44;
        yForAutoCompletionTable += 20;
    
    autoCompletionTopConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:yForAutoCompletionTable];
    
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

- (void)updateAutoCompletionTableViewConstraintWithNewFrame:(CGRect)paramNewFrame{
    
    if (CGRectEqualToRect(CGRectZero, paramNewFrame)) {
        autoCompletionHeightConstraints.constant = 600;
    }else{
        autoCompletionHeightConstraints.constant = paramNewFrame.size.height;
    }
    [autoCompleter updateConstraints];
    [[self view] setNeedsLayout];
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

#pragma mark - AutoCompleteTableViewDelegate
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
    
    if (ROW_TYPE_DESIGNATION == paramTextField.tag) {
        autoCompleter.suggestionsDictionary = suggesterDataDesignation;//will be same for both search and modify search
        
    }else if (ROW_TYPE_ORGANISATOIN == paramTextField.tag){
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

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
 
    NSInteger textFieldTag = autoCompleter.textField.tag;
    
    if (ROW_TYPE_DESIGNATION == textFieldTag) {
        return suggesterDataDesignation;
        
    }else if (ROW_TYPE_ORGANISATOIN == textFieldTag){
        return suggesterDataCompany;
        
    }else{
        return nil;
    }
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText {
    
    NSInteger textFieldTag = autoCompleter.textField.tag;
    
    if (ROW_TYPE_DESIGNATION == textFieldTag) {
        designation = selectedText;
        
    }else if (ROW_TYPE_ORGANISATOIN == textFieldTag){
        organisation = selectedText;
        
    }else{
        //dummy
    }
    [self.view endEditing:YES];
}

-(void)showingTheOptions:(BOOL)status{
    
    [self hideSuggesterBackGrndView:status];
}

- (void)handleSingleTapOnSuggestorBackGrndView{
    
    [self hideSuggestorView];
}

-(void)hideSuggestorView{
    [self.view endEditing:YES];
    
    autoCompleter.hidden = YES;
    [self hideSuggestorBackGrndView:YES];
}
-(void)hideSuggestorBackGrndView:(BOOL)status{
    
    suggestorBackgroundView.hidden = status;
}

-(void)hideSuggesterBackGrndView:(BOOL)status{
    
    [suggestorBackgroundView setHidden:!status];
    
}
/* hiding the Suggestor view when user click on outside of it.
 */

-(void)addTapGestureToSuggestorBackGroundView{
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnSuggestorBackGrndView)];
    [suggestorBackgroundView addGestureRecognizer:singleFingerTap];
    
}

#pragma Mark -
#pragma Adding TextFiled in key skill tuple for handling the AutoSuggestor  delegate
/**
 *   a Date Picker View appears on right side on editing the started Working form and till date textField
 */

-(void)setAllDatePickers{
    //// Date Picker Start Date
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:[NSNumber numberWithInteger:ROW_TYPE_START_DATE] forKey:@"ID"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayMonth"];
    [dict setCustomObject:[NSNumber numberWithBool:FALSE] forKey:@"DisplayDay"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayYear"];
    [dict setCustomObject:@"Started Working From" forKey:@"Header"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:-50]] forKey:@"MinYear"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:0]] forKey:@"MaxYear"];
    
    [allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",ROW_TYPE_START_DATE]];
    
    //// Date Picker Till Date
    dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:[NSNumber numberWithInteger:ROW_TYPE_TILL_DATE] forKey:@"ID"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayMonth"];
    [dict setCustomObject:[NSNumber numberWithBool:FALSE] forKey:@"DisplayDay"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayYear"];
    [dict setCustomObject:@"Till" forKey:@"Header"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:-50]] forKey:@"MinYear"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:0]] forKey:@"MaxYear"];
    [allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",ROW_TYPE_TILL_DATE]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (shouldHideRemoveButton) {
        return 6;
    }
    else return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == ROW_TYPE_REMOVE_EXPERIENCE)
        return 66;
    
    if(indexPath.row == ROW_TYPE_JOB_PROFILE){
        return 120;
    }
    if (indexPath.row == ROW_TYPE_CURRENT_COMPANY)
        return 95;
    
    return K_CONTACT_DEATILS_ROW_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    NSInteger row = indexPath.row;
    
    
    switch (row) {
            
        case ROW_TYPE_DESIGNATION:{
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_WORK_EXPERIENCE;
            cell.delegate = self;
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:designation forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_WORK_EXPERIENCE] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            
            
//            cell.titleLableStr = @"Designation";
//            cell.titlePlaceholderStr = @"Specify Designation";
//            cell.titleStr = designation;
//            cell.isEditable = YES;
//            cell.showAccessoryView = NO;
//            cell.index = indexPath.row;
//            cell.txtTitle.accessibilityLabel = @"Designation_txtFld";
//            cell.keyTxtCharLimit = [NSNumber numberWithInt:50];
//            [cell configureEditProfileCell];
//            cell.delegate = self;
//            cell.txtTitle.tag = ROW_TYPE_DESIGNATION;
            
            
            [self addAutoCompleterForTextField:cell.txtTitle];

            return cell;
            break;
        }
        case ROW_TYPE_ORGANISATOIN:{
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_WORK_EXPERIENCE;
            cell.delegate = self;
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];

            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:organisation forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_WORK_EXPERIENCE] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            
            
//            cell.titleLableStr = @"Organisation" ;
//            cell.titlePlaceholderStr = @"Specify Organisation";
//            cell.titleStr = organisation;
//            cell.isEditable = YES;
//            cell.showAccessoryView = NO;
//            cell.index = indexPath.row;
//            cell.txtTitle.accessibilityLabel = @"organisation_txtFld";
//            cell.keyTxtCharLimit = [NSNumber numberWithInt:50];
//            [cell configureEditProfileCell];
//            cell.delegate = self;
//            cell.txtTitle.tag  = ROW_TYPE_ORGANISATOIN;
            [self addAutoCompleterForTextField:cell.txtTitle];
            return cell;
            break;
        }
        case ROW_TYPE_CURRENT_COMPANY:{
            
            NSString* cellIndentifier = @"EditProfileSegmentedCell";
            
            NGEditProfileSegmentedCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            cell.delegate = self;
            
            NSMutableArray* arrTitles = [[NSMutableArray alloc] initWithObjects:
                                         EDIT_EXP_FIRST_SEGMENT_VALUE,EDIT_EXP_SECOND_SEGMENT_VALUE, nil];
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            cell.iSelectedButton = selectedIndex;
            [dictToPass setCustomObject:@"Current Company?" forKey:K_KEY_EDIT_PLACEHOLDER];
            [dictToPass setCustomObject:arrTitles forKey:K_KEY_EDIT_TITLE];
            [cell configureEditProfileSegmentedCell:dictToPass];
            dictToPass = nil;
            return cell;
            break;
            
        }
        case ROW_TYPE_START_DATE:{
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_WORK_EXPERIENCE;
            cell.delegate = self;
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];

            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:startDate forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_WORK_EXPERIENCE] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            
            
//            cell.titleLableStr = @"Started Working From";
//            cell.titlePlaceholderStr = @"Month, Year";
//            cell.titleStr = startDate;
//            cell.isEditable = NO;
//            cell.showAccessoryView = YES;
//            cell.index = indexPath.row;
//            cell.txtTitle.accessibilityLabel = @"startdate_txtFld";
//            cell.delegate = self;
//            [cell configureEditProfileCell];
            return cell;
            break;
            
            
        }
            
        case ROW_TYPE_TILL_DATE:{
            
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_WORK_EXPERIENCE;
            cell.delegate = self;
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:tillDate forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_WORK_EXPERIENCE] forKey:@"ControllerName"];
            [dictToPass setCustomObject:currentCompany forKey:@"currentCompany"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            
            
            
//            cell.titleLableStr = @"Till";
//            cell.titlePlaceholderStr = @"Month, Year";
//            cell.titleStr = tillDate;
//            cell.isEditable = NO;
//            cell.showAccessoryView = YES;
//            cell.index = indexPath.row;
//            cell.txtTitle.accessibilityLabel = @"tillDate_txtFld";
//            if ([currentCompany isEqualToString:CURRENT_COMPANY_YES]) {
//                cell.showAccessoryView = FALSE;
//            }
//            [cell configureEditProfileCell];
//            cell.delegate = self;
            return cell;
            break;
        }
            
        case ROW_TYPE_JOB_PROFILE:{
            
            NSString* cellIndentifier = @"EditProfileTextViewCell";
            
            NGEditProfileTextviewCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if(cell==nil)
                cell = [[NGEditProfileTextviewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:cellIndentifier];
            
            cell.txtview.returnKeyType = UIReturnKeyDone;
            cell.editModuleNumber = WORK_EXPERIENCE;
            cell.delegate = self;
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:jobProfile forKey:K_KEY_EDIT_TITLE];
            [dictToPass setCustomObject:@"Describe your Job Profile" forKey:K_KEY_EDIT_PLACEHOLDER];
            [dictToPass setCustomObject:@"FALSE" forKey:K_KEY_HIDDEN_PLACEHOLDER];
            [dictToPass setCustomObject:[NSNumber numberWithInt:255] forKey:K_KEY_TEXT_CHARACTER_LIMIT];
            cell.index = indexPath.row;
            [UIAutomationHelper setAccessibiltyLabel:@"jobProfile_txtView" forUIElement:cell.txtview];
            [cell configureEditProfileTextviewCell:dictToPass];
            dictToPass = nil;
            return cell;
            
            break;
            
            
    }
            
        case ROW_TYPE_REMOVE_EXPERIENCE: {
            
            
            NGProjectRemoveInfoCell *cell = (NGProjectRemoveInfoCell *)[self.editTableView dequeueReusableCellWithIdentifier:@"NIProjectRemoveInfoCell"];
            cell.accessibilityLabel = @"removeExp_cell";
            cell.tag = indexPath.row;
            return cell;
            break;
            
            
            
        }
        default:
            break;
    }
    
      return nil;
    
}


#pragma mark button delegate methods

-(void)cellSegmentClicked:(NSInteger)selectedSegmentIndex ofRow:(NSInteger)rowNumber{
    
    selectedIndex = selectedSegmentIndex;
    switch (selectedIndex) {
            
        case 1: {
            
            currentCompany = CURRENT_COMPANY_YES;
            tillDate = CURRENT_COMPANY_VALUE;
            
            break;
        }
            
        case 2: {
            
            currentCompany = CURRENT_COMPANY_NO;
            tillDate = nil;
            
            break;
        }
            
        default:
            break;
    }
    
    [self.editTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    switch (indexPath.row) {
    
        case ROW_TYPE_START_DATE:{
            
            if(!datePicker){
                datePicker = [[NGCalenderPickerView alloc]initWithNibName:nil bundle:nil];
            }
            [APPDELEGATE.container setRightMenuViewController:datePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            datePicker.delegate = self;
      
     
            datePicker.selectedValue = startDate?startDate:@"";
            datePicker.headerTitle = @"Started Working From";
            datePicker.delegate = self;
            datePicker.calType = NGCalenderTypeMMYYYY;
            [datePicker refreshData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
                if(datePicker.selectedValue.length == 0)
                    [datePicker adjustDateInMiddle];
                
            }];
            
   
        }
            
            break;
            
        case ROW_TYPE_TILL_DATE:{
            
            if ([currentCompany isEqualToString:CURRENT_COMPANY_YES]) {
                return;
            }
            if(!datePicker){
                datePicker = [[NGCalenderPickerView alloc]initWithNibName:nil bundle:nil];
            }
            [APPDELEGATE.container setRightMenuViewController:datePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            datePicker.selectedValue = tillDate?tillDate:@"";
            datePicker.headerTitle = @"Till";
            datePicker.delegate = self;
            datePicker.calType = NGCalenderTypeMMYYYY;
            [datePicker refreshData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
                if(datePicker.selectedValue.length == 0)
                    [datePicker adjustDateInMiddle];
                
            }];

            break;
        }
            
        case ROW_TYPE_REMOVE_EXPERIENCE:{
            
            [self showDeletePopUp];
            break;
        }
            
            
        default:
            break;
    }

}

-(void)showDeletePopUp {
    
    
    [NGUIUtility showDeleteAlertWithMessage:@"Do you want to delete this experience?" withDelegate:self];
    
}

#pragma mark UIAlertView Delegate



-(void) customAlertbuttonClicked:(int)index {
    
    [NGHelper sharedInstance].isAlertShowing = FALSE;
    
    if(index == 0) {
        [self showAnimator];
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DELETE_RESUME];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setCustomObject:self.modalClassObj.workExpID forKey:@"id"];
        [params setCustomObject:@"0" forKey:@"resId"];
        NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
        [finalParams setCustomObject:params forKey:@"workExperience"];
        
        __weak typeof(self) weakSelf = self;
        
        [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:finalParams,@"where", nil] handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hideAnimator];
                weakSelf.isRequestInProcessing = FALSE;
                
                if (responseInfo.isSuccess) {
                    
                    [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                    [weakSelf.editDelegate editedWorkExpWithSuccess:YES];
                }
                
            });
        }];
    }
    
}


#pragma mark - NGCalender Delegate
-(void)didSelectCalenderPickerWithValues:(NSDictionary *)responseParams success:(BOOL)successFlag andPickerType:(BOOL)isPickerTypeValue{
    
    if(successFlag)
    {
        
        if(isPickerTypeValue)
        {
            
        }
        else{
            
            [self handleDatePickersOnSelectionOfDate:[responseParams objectForKey:@"selectedDate"]];

        }
        
    }

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];

    
}

/**
 *   Method handle drop drown selction for Start and Till date
 *
 */

-(void)handleDatePickersOnSelectionOfDate:(NSString *)date{
    
    if([datePicker.headerTitle isEqualToString:@"Till"])
    {
        tillDate = date;
        [self.editTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:ROW_TYPE_TILL_DATE inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
    
        startDate = date;
        [self.editTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:ROW_TYPE_START_DATE inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
   
    
}


#pragma mark - Public Methods
/**
 *  @name Public Method
 */
/**
 *  Public Method initiated on  view appear and updates the textfield Values with NGMNJProfileModalClass object
 *
 *  @param obj a JsonModelObject contains predefined value for textField
 */

-(void)updateDataWithParams:(NGWorkExpDetailModel *)obj {
    
    
    self.modalClassObj = obj;
    
    if (!self.modalClassObj) {
        //// add work exp
        
        shouldHideRemoveButton = TRUE;
        
    }else{
        //// edit work exp
        
        designation = self.modalClassObj.designation;
        organisation = self.modalClassObj.organization;
        
        if (0>=[[ValidatorManager sharedInstance] validateValue:self.modalClassObj.startDate withType:ValidationTypeDate].count) {
            startDate = [NGDateManager formatDateInMonthYear:self.modalClassObj.startDate];
            
            NSMutableDictionary *dict = [allDatePickerParams objectForKey:[NSString stringWithFormat:@"%d",ROW_TYPE_START_DATE]];
            
            [dict setCustomObject:startDate forKey:@"SelectedDate"];
            [allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",ROW_TYPE_START_DATE]];
        }else{
            startDate = @"";
        }
        
        
        NSString *tillDateStr = self.modalClassObj.endDate;
        if ([tillDateStr isEqualToString:@"Present"]) {
            tillDate = @"Present";
            currentCompany=CURRENT_COMPANY_YES;
            selectedIndex = 1;
        }else{
            currentCompany =  CURRENT_COMPANY_NO;
            selectedIndex = 2;
  
            if (0>=[[ValidatorManager sharedInstance] validateValue:self.modalClassObj.endDate withType:ValidationTypeDate].count) {
                tillDate = [NGDateManager formatDateInMonthYear:tillDateStr];
                
                NSMutableDictionary *dict = [allDatePickerParams objectForKey:[NSString stringWithFormat:@"%d",ROW_TYPE_TILL_DATE]];
                
                [dict setCustomObject:tillDate forKey:@"SelectedDate"];
                
                [allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",ROW_TYPE_TILL_DATE]];
            }else{
                tillDate = @"";
            }
            
        }
        
        jobProfile = self.modalClassObj.jobProfile;
    }
    
    [self.editTableView reloadData];
}

#pragma mark - textfield delegates

- (void)textFieldDidStartEditing:(UITextField*)textField havingIndex:(NSInteger)index{
    
    if (index == ROW_TYPE_DESIGNATION) {
        
        autoCompleter.isErrorViewVisibleInSearch= NO;
        autoCompleter.textField = textField;
        
    }else if (index == ROW_TYPE_ORGANISATOIN){
        
        autoCompleter.isErrorViewVisibleInSearch= NO;
        autoCompleter.textField = textField;
        
        [NGUIUtility slideView:self.editTableView toXPos:0 toYPos:self.editTableView.frame.origin.y-75 duration:0.25f delay:0.0f];
        
    }
}

-(void) textField:(UITextField *)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    switch (index) {
        
        case ROW_TYPE_ORGANISATOIN:
            organisation = textFieldValue;
            break;
            
        case ROW_TYPE_DESIGNATION:
            designation = textFieldValue;
            break;
        default:
            break;
    }
}


- (void)textFieldDidEndEditing:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    [self hideSuggestorView];
    switch (index) {
            
        case ROW_TYPE_ORGANISATOIN:
            organisation = textFieldValue;
            [NGUIUtility slideView:self.editTableView toXPos:0 toYPos:self.editTableView.frame.origin.y+75 duration:0.25f delay:0.0f];
            break;
            
        case ROW_TYPE_DESIGNATION:
            designation = textFieldValue;
            break;
            
        default:
            break;
    }

}
- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_DESIGNATION:
            [self hideSuggestorView];
            designation = textField.text;
            break;
            
        case ROW_TYPE_ORGANISATOIN:
            [self hideSuggestorView];
            organisation = textField.text;
            break;
        
        default:
            break;
    }
    
    
}
/**
 *   Method on trigger create the request for serviceType : SERVICE_TYPE_UPDATE_RESUME and check for validation
 *
 *  @param sender NGButton
 */
-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    [self.view endEditing:YES];
    [self onSave:nil];
}


-(NSMutableDictionary*)getParametersInDictionary{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setCustomObject:[NSString stripTags:designation] forKey:@"designation"];
    
    [params setCustomObject:[NSString stripTags:designation] forKey:@"designationEN"];
    
    [params setCustomObject:[NSString getFilteredText:organisation] forKey:@"organization"];
    [params setCustomObject:[NSString getFilteredText:organisation] forKey:@"organizationEN"];
    
    [params setCustomObject:[NGDateManager getDateFromMonthYear:startDate] forKey:@"startDate"];
    
    NSString *endDateStr = tillDate;
    if ([endDateStr isEqualToString:@"Present"]) {
        [params setCustomObject:endDateStr forKey:@"endDate"];
    }else{
        [params setCustomObject:[NGDateManager getDateFromMonthYear:endDateStr] forKey:@"endDate"];
    }
    
    [params setCustomObject:jobProfile forKey:@"jobProfile"];
    [params setCustomObject:jobProfile forKey:@"jobProfileEN"];
    
    [params setCustomObject:@"0" forKey:@"resId"];
    
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
    [finalParams setCustomObject:params forKey:@"workExperience"];
    
    if (self.modalClassObj) {
        [finalParams setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.modalClassObj.workExpID,@"id", nil] forKey:@"where"];
    }
    
    return finalParams;

}
-(void)onSave:(id)sender{
    
    NSString *errorTitle;
    [self.view endEditing:YES];
    [errorCellArr removeAllObjects];
    if(![self isValidDate]) {
        
        [NGUIUtility showAlertWithTitle:@"Error!" withMessage:
         [NSArray arrayWithObjects:@"Sorry, Start date can not exceed End date", nil]
                    withButtonsTitle:@"OK" withDelegate:nil];
        
    }
    NSMutableArray* arrValidations = [self checkAllValidations];
    
    if (!errorTitle.length)
        errorTitle = @"Incomplete Details!";
    
    NSString * errorMessage = @"Please specify ";
    
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
        
        [self.editTableView reloadData];
    }
    
    else if (!self.isRequestInProcessing) {
            
            [self setIsRequestInProcessing:YES];
            
            [self showAnimator];
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EDIT_PROFILE withEventLabel:K_GA_EVENT_EDIT_PROFILE withEventValue:nil];
            
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
            
        
        
        __weak NGEditWorkExperienceViewController *weakSelf = self;
        
        NSMutableDictionary *params =[self updateTheRequestParameterForSendingInitialValueOfChanges:[self getParametersInDictionary]];

            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf hideAnimator];
                    weakSelf.isRequestInProcessing = FALSE;
                    
                    if (responseInfo.isSuccess) {
                        [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                        [weakSelf.editDelegate editedWorkExpWithSuccess:YES];
                    }
                    
                });
                
            }];

            
        }
    
}


/**
 *   On trigger  this method check for the validations in  textField and store the value in array
 *
 *  @return If Yes,  validation is applied ,
 */
-(NSMutableArray*) checkAllValidations{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (0<[vManager validateValue:designation withType:ValidationTypeString].count) {
        
        [arr addObject:@"Designation"];
        [errorCellArr addObject:[NSNumber numberWithInteger:0]];
    }else{
        
        designation = [[designation componentsSeparatedByString:@","] objectAtIndex:0];
    }
    
    if (0<[vManager validateValue:organisation withType:ValidationTypeString].count) {
        [arr addObject:@"Organisation"];
        [errorCellArr addObject:[NSNumber numberWithInteger:1]];
    }
    
    if (0<[vManager validateValue:startDate withType:ValidationTypeString].count) {
        [arr addObject:@"Start Date"];
        [errorCellArr addObject:[NSNumber numberWithInteger:3]];;
        
    }
    
    if (0<[vManager validateValue:tillDate withType:ValidationTypeString].count) {
        
        [arr addObject:@"Till Date"];
        [errorCellArr addObject:[NSNumber numberWithInteger:4]];
    }
    
    return arr;
    
}

#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    [self hideAnimator];
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
    [self.editDelegate editedWorkExpWithSuccess:YES];
    self.isRequestInProcessing= FALSE;
    
}
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [self hideAnimator];
    self.isRequestInProcessing = FALSE;
}

-(BOOL)isValidDate{
    
    BOOL isValid = NO;
    
    NSString *startDatestr = [NGDateManager formatDateMonthYearStringToServerFormat:startDate];
    
    NSString *endDateStr = [NGDateManager formatDateMonthYearStringToServerFormat:tillDate];
    
    if([NGDateManager isValideDate:startDate] && [NGDateManager isValideDate:tillDate]){
        if([NGDateManager  isValidStartDateEndate:startDatestr withEndDate:endDateStr]){
            isValid = YES;
        }
        
    }
    return isValid;
    
}
#pragma mark - Profile edit cell delegate

- (void)textViewDidEndEditing:(NSString *)textViewValue havingIndex:(NSInteger)index{
    
    [self.editTableView setContentInset:UIEdgeInsetsZero];
    
    jobProfile = textViewValue;
}
-(void) textViewDidStartEditing:(NSInteger)index{
    
    float inset = IS_IPHONE5?170:150;
    
    [self.editTableView setContentInset:UIEdgeInsetsMake(0, 0, inset, 0)];
    [self.editTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:index inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];
    
    
}

-(void) dealloc {
    
    self.modalClassObj = nil;
}
@end
