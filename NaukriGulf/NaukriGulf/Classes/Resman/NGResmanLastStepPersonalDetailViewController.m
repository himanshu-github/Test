//
//  NGResmanLastStepPersonalDetailViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 3/12/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanLastStepPersonalDetailViewController.h"
#import "NGCalenderPickerView.h"
#import "AutocompletionTableView.h"
#import "NGValueSelectionViewController.h"
#import "DDReligion.h"
#import "DDMaritalStatus.h"
#import "DDLanguage.h"

typedef enum {
    
    K_ROW_TYPE_INFO = 0,
    K_ROW_TYPE_DOB,
    K_ROW_TYPE_ALTERNATE_EMAIL,
    K_ROW_TYPE_RELIGION,
    K_ROW_TYPE_OTHER_RELIGION,
    K_ROW_TYPE_MARITAL_STATUS,
    K_ROW_TYPE_LANGUAGES,
    
}rowType;




@interface NGResmanLastStepPersonalDetailViewController ()<ProfileEditCellDelegate,NGCalenderDelegate,AutocompletionTableViewDelegate,ValueSelectorDelegate>{
    
    NGAppDelegate *appDelegate;
    NGResmanDataModel *resmanModel;
    BOOL isOtherReligion;
    NGTextField *userNameTxtFld;
    NSMutableArray *cellsArr;
    
    NSMutableDictionary *allDatePickerParams;
    BOOL invalidEmailId;
    NGCalenderPickerView *datePicker; // a date picker controller class
    
    AutocompletionTableView *autoCompleter;
    NSLayoutConstraint *autoCompletionHeightConstraints;
    UIView *suggestorBackgroundView;
    NSDictionary *autoCorrectEmailSuggester;
    NSString *suggestedEmailAddressForUser;
    NSArray *suggesterData;
    NSString *errorTitle;
    
    BOOL isSuggestingCorrectedDomain;
    UIView *footerView;
    
    NSInteger yForAutoCompletionTable;
}
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side

@end

@implementation NGResmanLastStepPersonalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self addNavigationBarWithBackAndRightButtonTitle:@"Submit" WithTitle:@" Hurray! Last Step"];
    
    [self setSaveButtonTitleAs:@"Submit"];
    appDelegate = (NGAppDelegate*)[NGAppDelegate appDelegate];
  
    cellsArr = [[NSMutableArray alloc] init];
    allDatePickerParams = [[NSMutableDictionary alloc]init];
     suggesterData = [self getSuggestors];
    autoCorrectEmailSuggester = [NGDirectoryUtility autoEmailCorrectionSuggesters];
    isSuggestingCorrectedDomain= FALSE;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;

    
}

-(void) customizeCellArr {
    
    [cellsArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_INFO]];
    [cellsArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_DOB]];
    [cellsArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_ALTERNATE_EMAIL]];
    [cellsArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_RELIGION]];
    
    if ([[resmanModel.religion objectForKey:KEY_VALUE] isEqualToString:@"Other"]) {
       [cellsArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]];
    }
    
    
    [cellsArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]];
    [cellsArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_LANGUAGES]];
    
}


-(void) viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    [self.scrollHelper listenToKeyboardEvent:YES];
    self.scrollHelper.headerHeight = RESMAN_HEADER_CELL_HEIGHT;
    self.scrollHelper.rowHeight = 75;
    
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    if (!resmanModel) {
        resmanModel = [[NGResmanDataModel alloc] init];
    }
    //if user already filled this page's date then
    //fetch that data from user profile and sync it with
    //resman model
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    if (nil!=objModel && ![objModel isKindOfClass:[NSNull class]]) {
        
        //Date of birth
        if (nil!=objModel.dateOfBirth && 0<objModel.dateOfBirth.length) {
            resmanModel.dob = [NGDateManager getDateInLongStyle:objModel.dateOfBirth];
            [self handleDatePickersOnSelectionOfDate:resmanModel.dob];
        }
        
        
        //religion
        if ([NGDecisionUtility isValidDropDownItem:objModel.religion]) {
            [self handleDDOnSelection:@{
                                        K_DROPDOWN_TYPE:[NSNumber numberWithInteger:DDC_RELIGION],
                                        K_DROPDOWN_SELECTEDVALUES:@[[objModel.religion objectForKey:KEY_VALUE]],
                                        K_DROPDOWN_SELECTEDIDS:@[[objModel.religion objectForKey:KEY_ID]]
                                        }
             ];
            
        }
        
        //marital status
        if ([NGDecisionUtility isValidDropDownItem:objModel.maritalStatus]) {
            [self handleDDOnSelection:@{
                                        K_DROPDOWN_TYPE:[NSNumber numberWithInteger:DDC_MARITAL_STATUS],
                                        K_DROPDOWN_SELECTEDVALUES:@[[objModel.maritalStatus objectForKey:KEY_VALUE]],
                                        K_DROPDOWN_SELECTEDIDS:@[[objModel.maritalStatus objectForKey:KEY_ID]]
                                        }
             ];
            
        }
        
        
        //3 languges from user
        NSString* langStr = [objModel.languagesKnown objectForKey:KEY_VALUE];
        if(0>=[[ValidatorManager sharedInstance] validateValue:langStr withType:ValidationTypeString].count)
        {
            langStr = [langStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray* knownLangArray = [langStr componentsSeparatedByString:@","];
            NSString* languageId = [objModel.languagesKnown objectForKey:KEY_ID];
            languageId = [languageId stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray* knownLangIdArray = [languageId componentsSeparatedByString:@","];
            
            [self handleDDOnSelection:@{
                                        K_DROPDOWN_TYPE:[NSNumber numberWithInteger:DDC_LANGUAGE],
                                        K_DROPDOWN_SELECTEDVALUES:knownLangArray,
                                        K_DROPDOWN_SELECTEDIDS:knownLangIdArray
                                        }
             ];
            
        }
        
    }
    objModel = nil;
    

    if (resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_PERSONAL_DETAILS_FRESHER];
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_PERSONAL_DETAILS_EXPERIENCED];
    }
    
    [self setAllDatePickers];
    [self setDefaultValues];
    [self customizeCellArr];
    [NGDecisionUtility checkNetworkStatus];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.scrollHelper listenToKeyboardEvent:NO];
}
-(void) setDefaultValues {
    
    // Set Date of Birth
    if (nil != resmanModel.dob && 0 < resmanModel.dob.length) {
        NSString *dob = [NGDateManager getDateInLongStyle:resmanModel.dob];
        
        if (!dob) {
            
            dob = [NSString stringWithFormat:@"January 1, 1980"];
        }
        NSMutableDictionary *dict = [allDatePickerParams objectForKey:[NSString stringWithFormat:@"%ld",(long)K_ROW_TYPE_DOB]];
        
        [dict setCustomObject:dob forKey:@"SelectedDate"];
        
        [allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%ld",(long)K_ROW_TYPE_DOB]];
    }
    
    // Set Other Religion
    
    if ([[resmanModel.religion objectForKey:KEY_VALUE] isEqualToString:@"Other"]) {
        isOtherReligion = TRUE;
    }

    [self.editTableView reloadData];
}

-(void) setAllDatePickers {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:[NSNumber numberWithInteger:K_ROW_TYPE_DOB] forKey:@"ID"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayMonth"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayDay"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayYear"];
    [dict setCustomObject:@"Date of Birth" forKey:@"Header"];
    
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:-80]] forKey:@"MinYear"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:-14]] forKey:@"MaxYear"];
        
    [allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%ld",(long)K_ROW_TYPE_DOB]];

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
    
    if (isOtherReligion) {
        return 7;
    }
    return 6;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case K_ROW_TYPE_INFO:
            
            return 50;
            
        default:return 75;
           
    }
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    NGProfileEditCell *cell;
    NSInteger row = [self getRowNumberFor:indexPath.row];
    
    switch (row) {
            
       case K_ROW_TYPE_INFO:{
           
           NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:@"" ];
           if (cell == nil)
           {
               cell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
               UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
               txtLabel.textAlignment = NSTextAlignmentCenter;
               [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
               txtLabel.text =@"More Details About You";
               txtLabel.textColor = [UIColor darkGrayColor];
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               [cell.contentView addSubview:txtLabel];
               return cell;
           }
     }
    
        case K_ROW_TYPE_DOB:{
        
            cell = [self getEditProfileCellForIndexPath:indexPath];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:resmanModel.dob forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_LAST_STEP_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            cell.delegate = self;
            cell.otherDataStr = nil;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            return cell;
            

        }
        case K_ROW_TYPE_ALTERNATE_EMAIL:{
            
            cell = [self getEditProfileCellForIndexPath:indexPath];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:resmanModel.alternateEmail forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_LAST_STEP_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            cell.delegate = self;
            cell.otherDataStr = nil;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            [self addAutoCompleterForTextField:cell.txtTitle];
            userNameTxtFld = cell.txtTitle;
            return cell;
  
        }
            
        case K_ROW_TYPE_RELIGION:{
            cell = [self getEditProfileCellForIndexPath:indexPath];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[resmanModel.religion objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_LAST_STEP_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            cell.otherDataStr = nil;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            return cell;
   
        }
            
        case K_ROW_TYPE_OTHER_RELIGION:{
            
            cell = [self getEditProfileCellForIndexPath:indexPath];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:resmanModel.otherReligion forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_LAST_STEP_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = K_ROW_TYPE_OTHER_RELIGION;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            return cell;
            break;

        }
            
        case K_ROW_TYPE_MARITAL_STATUS:{
            
            
            cell = [self getEditProfileCellForIndexPath:indexPath];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[resmanModel.maritalStatus objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_LAST_STEP_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            cell.editModuleNumber = k_RESMAN_LAST_STEP_PERSONAL_DETAILS;
            cell.delegate = self;
            cell.otherDataStr = nil;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            return cell;
            break;

        }
            
        case K_ROW_TYPE_LANGUAGES:{
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = k_RESMAN_LAST_STEP_PERSONAL_DETAILS;
            cell.delegate = self;
            cell.otherDataStr = nil;
            
            
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[resmanModel.languages objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_LAST_STEP_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];            
            return cell;
            break;

        }
            
            
    }

    return nil;
}

-(NGProfileEditCell*) getEditProfileCellForIndexPath : (NSIndexPath*) indexPath {
    
    NSString* cellIndentifier = @"EditProfileCell";
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = k_RESMAN_LAST_STEP_PERSONAL_DETAILS;
    cell.delegate = self;
    return  cell;
    
}



-(NSInteger) getRowNumberFor:(NSInteger) row {
    
    if (isOtherReligion) {
        return row;
    }else{
        
        if (row > K_ROW_TYPE_RELIGION) {
            row++;
        }
    }
    
    return row;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    [self hideSuggesterBackGrndView:YES];
    
    NSInteger row = [[cellsArr objectAtIndex:indexPath.row]integerValue];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];

    switch (row) {
            
        case K_ROW_TYPE_DOB:{

            if(!datePicker){
                datePicker = [[NGCalenderPickerView alloc]initWithNibName:nil bundle:nil];
            }
            [APPDELEGATE.container setRightMenuViewController:datePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            datePicker.delegate = self;
            NSInteger currentYear = [[NGDateManager getCurrentDateComponents]year];
            NSInteger minusFourtyYearBack = currentYear-40;

            NSString *selectedDOB = resmanModel.dob;
            if(!selectedDOB)
                selectedDOB = [NSString stringWithFormat:@"January 1,%ld",(long)minusFourtyYearBack];
            datePicker.selectedValue = selectedDOB;
            datePicker.headerTitle = @"Date of Birth";
            datePicker.calType = NGCalenderTypeDDMMYYYY;
            NSInteger yearMaxLimit = currentYear - 15;
            datePicker.maxYear =[NSNumber numberWithInteger:yearMaxLimit];
            [datePicker refreshData];
            

            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
                if(datePicker.selectedValue.length == 0)
                    [datePicker adjustDateInMiddle];
                
            }];
            
            break;
     

        }

        case K_ROW_TYPE_RELIGION:{
            //_valueSelector = nil;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            
            if(0>=[vManager validateValue:[resmanModel.religion objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [resmanModel.religion objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_RELIGION;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
            
            break;

        }
            
        case K_ROW_TYPE_MARITAL_STATUS:{
            //_valueSelector = nil;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            
            if(0>=[vManager validateValue:[resmanModel.maritalStatus objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [resmanModel.maritalStatus objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_MARITAL_STATUS;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
            break;
            
        }
            
            
        case K_ROW_TYPE_LANGUAGES:{
            
            //_valueSelector = nil;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            
            if(0>=[vManager validateValue:[resmanModel.languages objectForKey:KEY_ID] withType:ValidationTypeArray].count)
                _valueSelector.arrPreSelectedIds = [resmanModel.languages objectForKey:KEY_ID];
            _valueSelector.dropdownType = DDC_LANGUAGE;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
            
            break;

        }
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
 *   Method handle drop drown selction for DOB
 *
 */

-(void)handleDatePickersOnSelectionOfDate:(NSString *)date {
    
    resmanModel.dob = date;
    NSInteger index = [cellsArr indexOfObject:[NSNumber numberWithInteger:K_ROW_TYPE_DOB]];
    [self.editTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - textfield



-(void) textFieldDidStartEditing:(NSInteger)index{
    
    if (index == K_ROW_TYPE_ALTERNATE_EMAIL) {
        
        self.scrollHelper.rowType = NGScrollRowTypeSuggestorInsetOffset;
        self.scrollHelper.shiftVal = 75+50;
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:K_ROW_TYPE_OTHER_RELIGION inSection:0];
        
        [self addSuggestorBackGroundView:yForAutoCompletionTable];
    }
    
    if (index == K_ROW_TYPE_OTHER_RELIGION) {
        self.scrollHelper.rowType = NGScrollRowTypeNormal;
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:K_ROW_TYPE_OTHER_RELIGION inSection:0];
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    
    
    switch (index) {
            
        case K_ROW_TYPE_ALTERNATE_EMAIL:{
            
            resmanModel.alternateEmail = textField.text;
            [self hideKeyboardAndSuggester];
            
            break;

        }
            
        case K_ROW_TYPE_OTHER_RELIGION:{
            
            resmanModel.otherReligion = textField.text;
            break;

        }
            
    }
    
    [self.editTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}


- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{
    [self hideSuggesterBackGrndView:YES];

}


#pragma mark - auto completor


-(NSArray *)getSuggestors {
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedStringsFromKey:K_EMAIL_DOMAIN_SUGGESTOR_KEY];
    return suggestors;
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
    }
    [paramTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [paramTextField addTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

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
    resmanModel.alternateEmail = selectedText;
    [self hideSuggesterBackGrndView:YES];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ValueSelector Delegate
-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }
    

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    
}
/**
 *  method created for updating the textField  with response
 *
 *  @param responseParams NSDictionary class
 */
-(void)handleDDOnSelection:(NSDictionary *)responseParams {
    
    NSInteger ddType = [[responseParams objectForKey:K_DROPDOWN_TYPE]integerValue];
    NSArray *arrSelectedIds = [responseParams objectForKey:K_DROPDOWN_SELECTEDIDS];
    NSArray* arrSelectedValues = [responseParams objectForKey:K_DROPDOWN_SELECTEDVALUES];
    
    switch (ddType) {
            
        case DDC_RELIGION:{
            if (arrSelectedIds.count>0) {
                
                resmanModel.religion = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                        [arrSelectedValues firstObject],KEY_VALUE,
                                        [arrSelectedIds firstObject],KEY_ID,
                                        nil];
            }else
                
                resmanModel.religion  = nil;
        
            
            if ([[resmanModel.religion objectForKey:KEY_VALUE] isEqualToString:@"Other"]) {
                isOtherReligion = TRUE;
               
                [resmanModel.religion setObject:@"1000" forKey:KEY_ID]  ;
                
                resmanModel.otherReligion = nil;
                
                [cellsArr insertObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION] atIndex:K_ROW_TYPE_OTHER_RELIGION];
                
                if ([errorCellArr containsObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]]) {
                    
                    [errorCellArr removeObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]];
                    [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_LANGUAGES]];
                }

                if ([errorCellArr containsObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]]) {
                    
                    [errorCellArr removeObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]];
                    [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]];
                }
                
          
                
            }else{
                if (isOtherReligion) {
                    
                    if ([errorCellArr containsObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]]) {
                        
                        [errorCellArr removeObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]];
                    }
                    if ([errorCellArr containsObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]]) {
                        [errorCellArr removeObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]];
                        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]];
                    }

                    if ([errorCellArr containsObject:[NSNumber numberWithInt:K_ROW_TYPE_LANGUAGES]]) {
                        
                        [errorCellArr removeObject:[NSNumber numberWithInt:K_ROW_TYPE_LANGUAGES]];
                        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]];
                    }
                    
                    
                    
                }
                
                isOtherReligion = FALSE;
                [cellsArr removeObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]];
            }
            break;
        }
            
            
        case DDC_MARITAL_STATUS:{
            if (arrSelectedIds.count>0) {
                
                resmanModel.maritalStatus = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                             [arrSelectedValues firstObject],KEY_VALUE,
                                             [arrSelectedIds firstObject],KEY_ID,
                                             nil];
                
                
            }else
                
                resmanModel.maritalStatus = nil;
            
            break;
            
        case DDC_LANGUAGE:{
            if (arrSelectedIds.count>0) {
                
                resmanModel.languages = [[NSMutableDictionary alloc]initWithObjectsAndKeys:

                                       [NSString getStringsFromArray:arrSelectedValues],KEY_VALUE,
                                         arrSelectedIds, KEY_ID,

                                       [NSString getStringsFromArray:arrSelectedValues],KEY_VALUE,
                                          [arrSelectedIds copy], KEY_ID,

                                         nil];
                
            }else
                
                resmanModel.languages = nil;
        
            break;
        }
            
    }
    }
    [self.editTableView reloadData];

}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self hideSuggesterBackGrndView:YES];
    [self resignFirstResponder];
}


-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    
    [self.view endEditing:YES];
    [self hideSuggesterBackGrndView:YES];
    
    NSMutableArray* arrValidations = [self checkValidations];
    if (!errorTitle.length)
        errorTitle = @"Incorrect Details!";
    
    NSString * errorMessage = @"Please specify ";
    
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
        
        self.isRequestInProcessing = NO;
    }
    else{
        
        //if email auto correction decision then return from here
        [self makeApiCall];
    }
    
}
-(NSMutableDictionary*)getParametersInDictionary{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setCustomObject:[NGDateManager getDateFromLongStyle:resmanModel.dob] forKey:@"dateOfBirth"];
    
    [params setObject:[self getReligionDict] forKey:@"religion"];
    [params setObject:[resmanModel.maritalStatus objectForKey:KEY_ID] forKey:@"maritalStatus"];
    
    if([[ValidatorManager sharedInstance] validateValue:resmanModel.alternateEmail withType:ValidationTypeEmail].count< 1) {
        
        [params setCustomObject:resmanModel.alternateEmail forKey:@"alternateEmail"];
    }
    
    NSString* languageId = [NSString getStringsFromArray:
                            [resmanModel.languages objectForKey:KEY_ID]];
    
    [params setCustomObject:languageId  forKey:@"languagesKnown"];
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];

    return params;
    
}
-(void) makeApiCall{
    
    
    if (!isSuggestingCorrectedDomain && !invalidEmailId) {
        
        [[DataManagerFactory getStaticContentManager]saveResmanFields:resmanModel];
        
        [self showAnimator];
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
        
        
        __weak NGResmanLastStepPersonalDetailViewController *weakSelf = self;
        NSMutableDictionary *params = [self getParametersInDictionary];

        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hideAnimator];
                
                if (responseInfo.isSuccess) {
                    
                    [self performSelector:@selector(showMessage:) withObject:@"Congratulations! Profile Saved Successfully" afterDelay:.5];
                    
                    [[NGLoginHelper sharedInstance]showMNJHome];
                    
                }else{
                    
                    NSString *errorMsg = @"Some problem occurred at server";
                    
                    [NGUIUtility showAlertWithTitle:@"Error" withMessage:[NSArray arrayWithObject:errorMsg] withButtonsTitle:@"Ok" withDelegate:nil];
                    
                }
                
            });
            
            
        }];
        
    }
}

-(void) showMessage: (NSString *) msg{
    [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:msg animationTime:3 showAnimationDuration:0.5];
}
-(NSMutableDictionary*) getReligionDict {
    
    
    NSMutableDictionary *religionDict = [[NSMutableDictionary alloc]init];
    [religionDict setObject:[resmanModel.religion objectForKey:KEY_ID ] forKey:@"id"];
    if (isOtherReligion) {
        
        [religionDict setCustomObject:resmanModel.otherReligion forKey:@"otherEN"];
        [religionDict setCustomObject:resmanModel.otherReligion forKey:@"other"];
        
    }else{
        
        [religionDict setCustomObject:@"" forKey:@"otherEN"];
        [religionDict setCustomObject:@"" forKey:@"other"];

    }
    
    return religionDict;
}

-(NSMutableArray*) checkValidations {
    
    isSuggestingCorrectedDomain = FALSE;
    invalidEmailId = FALSE;
    NSMutableArray *errArr= [[NSMutableArray alloc] init];
    [errorCellArr removeAllObjects];
    
    if (0 < [[ValidatorManager sharedInstance] validateValue:resmanModel.dob withType:ValidationTypeString].count) {
        
        [errArr addObject:@"Date of Birth"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_DOB]];
        
    }
    
    
  if (resmanModel.alternateEmail.length > 0) {
        
        NSMutableArray *emailValidatorArray = [[ValidatorManager sharedInstance] validateValue:resmanModel.alternateEmail withType:ValidationTypeEmail];
        
        if((0<emailValidatorArray.count)){
         
            [errArr addObject:@"valid Alternate Email Id"];
            [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_ALTERNATE_EMAIL]];
            
        }
        
    }
    
    if (0 < [[ValidatorManager sharedInstance] validateValue:[resmanModel.religion objectForKey:KEY_VALUE] withType:ValidationTypeString].count) {
        
        [errArr addObject:@"Religion"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_RELIGION]];
        
    }
   
    if(resmanModel.religion && [[resmanModel.religion objectForKey:KEY_VALUE] isEqualToString:@"Other"]){
        
        if (0 < [[ValidatorManager sharedInstance] validateValue:resmanModel.otherReligion withType:ValidationTypeString].count) {
            
            [errArr addObject:@"Other Religion"];
            [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]];
            
        }

    }
    
    if (0 < [[ValidatorManager sharedInstance] validateValue:[resmanModel.maritalStatus objectForKey:KEY_VALUE ] withType:ValidationTypeString].count) {
        
        [errArr addObject:@"Marital Status"];
        
        if (isOtherReligion) {
           
            [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]];
            
        }else{
            
            [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_OTHER_RELIGION]];
        }
        
        
    }
    if (0 < [[ValidatorManager sharedInstance] validateValue:[resmanModel.languages objectForKey:KEY_VALUE] withType:ValidationTypeString].count) {
        
        [errArr addObject:@"Languages you know"];
        if (isOtherReligion) {
           [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_LANGUAGES]];
        }else{
            
            [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MARITAL_STATUS]];
        }
        
    }
    
    
        //now check for email auto correction
    [self.editTableView reloadData];
    
    if (errorCellArr.count) {
            return errArr;
        }
    
    
    if (resmanModel.alternateEmail) {
        
    
    NSDictionary *emailDomains = [autoCorrectEmailSuggester objectForKey:@"email_domains"];
        if (emailDomains) {
            NSString *domainFromUser = [[[[resmanModel.alternateEmail componentsSeparatedByString:@"@"] lastObject] componentsSeparatedByString:@"."] firstObject];
            
            
            if ([NGDecisionUtility isEmailDomainRestricted:domainFromUser]) {
                [NGUIUtility showAlertWithTitle:@"Invalid Details!" withMessage:@[@"Use a domain different from naukri.com & naukrigulf.com"] withButtonsTitle:@"Ok" withDelegate:nil];
                invalidEmailId = TRUE;
                
                
            }else{
                NSString *autoCorrectedEmail = [emailDomains objectForKey:domainFromUser.lowercaseString];
                if (autoCorrectedEmail) {
                    //show alert to user
                    
                    suggestedEmailAddressForUser = [resmanModel.alternateEmail stringByReplacingOccurrencesOfString:domainFromUser withString:autoCorrectedEmail];
                    
                    NSString *msgToUser = [[autoCorrectEmailSuggester objectForKey:@"user_message"] stringByReplacingOccurrencesOfString:@"@" withString:suggestedEmailAddressForUser];
                    
                    NSString *msgButtons = [NSString stringWithFormat:@"%@,%@",[autoCorrectEmailSuggester objectForKey:@"user_message_ok"],[autoCorrectEmailSuggester objectForKey:@"user_message_cancel"]];
                    
                    [NGUIUtility showAlertWithTitle:[autoCorrectEmailSuggester objectForKey:@"user_message_title"] withMessage:@[msgToUser] withButtonsTitle:msgButtons withDelegate:self];
                    
                    isSuggestingCorrectedDomain = TRUE;
                }
            }
        }
    
    }
    
    return nil;
}


-(void)customAlertbuttonClicked:(int)index{
    
    [NGHelper sharedInstance].isAlertShowing = FALSE;
    if (index == 0) {
        resmanModel.alternateEmail = suggestedEmailAddressForUser;
        userNameTxtFld.text = resmanModel.alternateEmail;
        isSuggestingCorrectedDomain = FALSE;
        
    }
    
    isSuggestingCorrectedDomain = FALSE;
    [self makeApiCall];
}
@end
