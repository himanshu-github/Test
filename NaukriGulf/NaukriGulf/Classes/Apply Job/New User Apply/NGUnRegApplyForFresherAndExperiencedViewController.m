//
//  NGUnRegApplyForFresherAndExperiencedViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/21/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGUnRegApplyForFresherAndExperiencedViewController.h"
#import "NGValueSelectionRequestModal.h"
#import "NGValueSelectionResponseModal.h"
#import "NGLayeredValueSelectionViewController.h"
#import "DDUGCourse.h"
#import "DDPGCourse.h"
#import "DDPPGCourse.h"
#import "DDNationality.h"
#import "DDCountry.h"

@interface NGUnRegApplyForFresherAndExperiencedViewController ()<ProfileEditCellDelegate,AutocompletionTableViewDelegate,LayeredValueSelectionDelegate,NGValueSelectionRequestModal>{
    
    BOOL isValueSelectorExist;

    //Freshers
    NSMutableDictionary *basicCourse;
    NSMutableDictionary *basicSpecialization;
    NSMutableDictionary *mastersCourse;
    NSMutableDictionary *mastersSpecialization;
    NSMutableDictionary *doctorateCourse;
    NSMutableDictionary *doctorateSpecialization;
    NSMutableDictionary* country;
    NSMutableDictionary* city;
    NSMutableDictionary* nationality;

    
    //Experienced
    
    NSString *designation;
    NGTextField *designationTxtFld;
    
    //
    
    NSLayoutConstraint *autoCompletionHeightConstraints;
    UIView *suggestorBackgroundView;
    
    //array
    
    NSMutableArray *dropdownItems;
    NSMutableArray *ugCoursesWithSpecArr;
    NSMutableArray *pgCoursesWithSpecArr;
    NSMutableArray *doctCoursesWithSpecArr;
    NSMutableArray *nationalityArr;
    NSMutableArray *countryAndCityModalArr;
    
    NGAppDelegate *appDelegate;
    
    
    //apply model
     NGApplyFieldsModel* applyModelObj;
     NGJobDetails *jobObj;
    
}

@end

@implementation NGUnRegApplyForFresherAndExperiencedViewController

- (void)viewDidLoad {
  
    [AppTracer traceStartTime:TRACER_ID_UNREG_APPLY_FRESHERS_PAGE];
    
    [super viewDidLoad];
    appDelegate = APPDELEGATE;
    [self addNavigationBarWithBackAndPageNumber:@"2/2" withTitle:@"Almost there..."];
    self.editTableView.scrollEnabled = NO;
    isValueSelectorExist = NO;
    [self setSaveButtonTitleAs:@"Save and Apply"];
    [self updateDefaultValues];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDefaultValues)
                                                 name:DropDownServerUpdate object:nil];

}

-(void) viewWillAppear:(BOOL)animated{
    
    applyModelObj = self.jobHandler.unregApplyModal;
    jobObj = self.jobHandler.jobObj;
    
    NSString *screenType = @"";
    
    if(!applyModelObj.isFresher){
        
        self.editTableView.scrollEnabled = FALSE;
        screenType = K_GA_APPLAY_FORM2_UNREG_EXPERIENCE_SCREEN;
    }
    else{
        
        self.editTableView.scrollEnabled = TRUE;
        screenType = K_GA_APPLAY_FORM2_UNREG_EDUCATION_SCREEN;
    }

     [NGGoogleAnalytics sendScreenReport:screenType];
     [NGDecisionUtility checkNetworkStatus];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkRegisteredUser];
    [AppTracer traceEndTime:TRACER_ID_UNREG_APPLY_FRESHERS_PAGE];
}
-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear: YES];
    [AppTracer clearLoadTime:TRACER_ID_UNREG_APPLY_FRESHERS_PAGE];
    
}
- (void)updateDefaultValues{
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (!ugCoursesWithSpecArr)
        ugCoursesWithSpecArr = [[NSMutableArray alloc] init];
    
    if (!pgCoursesWithSpecArr)
        pgCoursesWithSpecArr = [[NSMutableArray alloc] init];
    
    if (!doctCoursesWithSpecArr)
        doctCoursesWithSpecArr = [[NSMutableArray alloc] init];
    
    if(!nationalityArr)
        nationalityArr = [[NSMutableArray alloc] init];
    
    if (!countryAndCityModalArr)
        countryAndCityModalArr = [[NSMutableArray alloc] init];

 
    NSMutableArray* arrGraduation = [NSMutableArray arrayWithArray:
                                     [NGDatabaseHelper getAllDDData:DDC_UGCOURSE]];
    
    NSMutableArray* arrPostGraduation = [NSMutableArray arrayWithArray:
                                         [NGDatabaseHelper getAllDDData:DDC_PGCOURSE]];
    
    NSMutableArray* arrDoct = [NSMutableArray arrayWithArray:
                               [NGDatabaseHelper getAllDDData:DDC_PPGCOURSE]];
    
    //fill UG courses+ spec detail
    if (0>=[vManager validateArray:arrGraduation withType:ValidationTypeArray].count) {
        
        for (DDBase* obj in arrGraduation){
            
            NGValueSelectionRequestModal* modal = [[NGValueSelectionRequestModal alloc] init];
            modal.value = obj.valueName;
            if ([modal.value isEqual:[NSNull null]])
                continue;
            modal.identifier = obj.valueID.stringValue;
            
            NSArray* specsForCourses = [NGDatabaseHelper sortEducationSpec:
                                        DROPDOWN_VALUE_NAME onArray:
                                        ((NSSet*)[obj valueForKey:@"specs"]).allObjects];
           

            NGValueSelectionRequestModal* modalObj;
            for (DDBase* obj2 in specsForCourses){
                
                modalObj = [[NGValueSelectionRequestModal alloc] init];
                modalObj.identifier = obj2.valueID.stringValue;
                modalObj.value = obj2.valueName;
                [modal.requestModalArr addObject:modalObj];
                modalObj = nil;
            }
            [ugCoursesWithSpecArr addObject:modal];
            modal = nil;
        }
    }
    

    
    //fill PG courses+ spec detail
    
    if (0>=[vManager validateArray:arrPostGraduation withType:ValidationTypeArray].count) {
        
        for (DDBase* obj in arrPostGraduation){
            
            NGValueSelectionRequestModal* modal = [[NGValueSelectionRequestModal alloc] init];
            modal.value = obj.valueName;
            if ([modal.value isEqual:[NSNull null]])
                continue;
            modal.identifier = obj.valueID.stringValue;
            
            NSArray* specsForCourses = [NGDatabaseHelper sortEducationSpec:
                                        DROPDOWN_VALUE_NAME onArray:
                                        ((NSSet*)[obj valueForKey:@"specs"]).allObjects];
            
            NGValueSelectionRequestModal* modalObj;
            for (DDBase* obj2 in specsForCourses){
                
                modalObj = [[NGValueSelectionRequestModal alloc] init];
                modalObj.identifier = obj2.valueID.stringValue;
                modalObj.value = obj2.valueName;
                [modal.requestModalArr addObject:modalObj];
                modalObj = nil;
            }
            [pgCoursesWithSpecArr addObject:modal];
            modal = nil;
        }
    }
    
    
    //fill doctorate
    
    if (0>=[vManager validateArray:arrDoct withType:ValidationTypeArray].count) {
        
        for (DDBase* obj in arrDoct){
            
            NGValueSelectionRequestModal* modal = [[NGValueSelectionRequestModal alloc] init];
            modal.value = obj.valueName;
            if ([modal.value isEqual:[NSNull null]])
                continue;
            modal.identifier = obj.valueID.stringValue;
            
            NSArray* specsForCourses = [NGDatabaseHelper sortEducationSpec:
                                        DROPDOWN_VALUE_NAME onArray:
                                        ((NSSet*)[obj valueForKey:@"specs"]).allObjects];
            
            NGValueSelectionRequestModal* modalObj;
            for (DDBase* obj2 in specsForCourses){
                
                modalObj = [[NGValueSelectionRequestModal alloc] init];
                modalObj.identifier = obj2.valueID.stringValue;
                modalObj.value = obj2.valueName;
                [modal.requestModalArr addObject:modalObj];
                modalObj = nil;
            }
            [doctCoursesWithSpecArr addObject:modal];
            modal = nil;
        }
    }
    
    //Fill City

    NSMutableArray *  finalArr = [NSMutableArray arrayWithArray:[NGDatabaseHelper getSortedDataWhereKey:DROPDOWN_SORTED_ID andClass:[DDCountry class]]];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:finalArr forKey:KEY_DATAARRAY];
    [dict setCustomObject:finalArr forKey:@"ContentArr"];
    [dict setCustomObject:@"Country" forKey:@"Header"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"SingleSelect"];
    [dict setCustomObject:[NSNumber numberWithInteger:DDC_COUNTRY] forKey:K_DROPDOWN_TYPE];
    
    NSArray *countryAndCityArr = [dict objectForKey:KEY_DATAARRAY];
    if (0>=[vManager validateArray:countryAndCityArr withType:ValidationTypeArray].count) {
        
        for (DDBase* obj1 in countryAndCityArr){
            
            NGValueSelectionRequestModal* modal = [[NGValueSelectionRequestModal alloc] init];
            modal.value = obj1.valueName;
            if ([modal.value isEqual:[NSNull null]])
                continue;
            modal.identifier = [obj1.valueID stringValue];
            
            NGValueSelectionRequestModal* modalObj;
            NSArray* arrCities = [NGDatabaseHelper sortArrayOfCountryCityWithOtherListAtEnd:DROPDOWN_VALUE_NAME onArray:((NSSet*)[obj1 valueForKey:@"cities"]).allObjects];

            for (DDBase* obj2 in arrCities){
                
                modalObj = [[NGValueSelectionRequestModal alloc] init];
                modalObj.identifier = obj2.valueID.stringValue;
                modalObj.value = obj2.valueName;
                [modal.requestModalArr addObject:modalObj];
                modalObj = nil;
            }
            [countryAndCityModalArr addObject:modal];
            modal = nil;
        }
    }
  
    
    //Fill Nationality    
    NSMutableArray* arrNationalities = [NSMutableArray arrayWithArray:[NGDatabaseHelper getAllDDData:DDC_NATIONALITY]];
    
    for (DDNationality* obj in arrNationalities){
        
        NGValueSelectionRequestModal* modal = [[NGValueSelectionRequestModal alloc] init];
        modal.value = [dict objectForKey:@"label"];
        modal.value = obj.valueName;
        if ([modal.value isEqual:[NSNull null]])
            continue;
        modal.identifier = [NSString stringWithFormat:@"%@",obj.valueID];
        modal.requestModalArr = nil;
        [nationalityArr addObject:modal];
        modal = nil;
    }
}

-(void)setDropdownData{
    
}
-(void)checkRegisteredUser{
    
    self.view.userInteractionEnabled = NO;
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_CHECK_REGISTERED_USER];
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:_jobHandler.applyModelEmail,@"email", nil] handler:^(NGAPIResponseModal *responseData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.view.userInteractionEnabled = YES;
            if (responseData.isSuccess) {
                NSString* emailExistStr = [[responseData.responseData JSONValue] objectForKey:KEY_REGISTERED_EMAIL_DATA];
                
                if ([emailExistStr isEqualToString:@"true"]) {
                    [self showErrorBannerForEmail];
                }
            }else{
                [self showErrorBannerForEmail];
            }
        });
    }];
}

-(void) showErrorBannerForEmail{
    
    _jobHandler.isEmailRegistered = YES;
    [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"This email id already exists in our database. You may Login or retrieve your password else specify a different id to apply. " animationTime:4 showAnimationDuration:0.5];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backButtonClicked{
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (applyModelObj.isFresher) {
        return  5;
    } else
        return 3;
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

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    NSString* cellIndentifier = @"EditProfileCell";
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = K_EDIT_UNREG_APPLY_FRESHERS;
    cell.delegate = self;
    
    NSInteger row = [self getRowNumberForIndexpath:indexPath];
    switch (row) {
            
        case ROW_TYPE_BASIC_EDUCATION_UNREG:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[self getCourseNameAndSpecialisationFrom:applyModelObj.gradCourse andSpecialisation:applyModelObj.gradspecialisation] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY_FRESHERS] forKey:@"ControllerName"];
            cell.index = ROW_TYPE_BASIC_EDUCATION_UNREG;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            
//            
//            cell.titleLableStr = @"Basic Education Details";
//            cell.titlePlaceholderStr = @"Select Course, Specialization";
//            cell.titleStr = [self getCourseNameAndSpecialisationFrom:applyModelObj.gradCourse andSpecialisation:applyModelObj.gradspecialisation];
//            cell.isEditable = NO;
//            cell.showAccessoryView = YES;
//            cell.txtTitle.accessibilityLabel = @"basic_txtFld";
            break;
        }
        case ROW_TYPE_MASTER_EDUCATION_UNREG:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[self getCourseNameAndSpecialisationFrom:applyModelObj.pgCourse  andSpecialisation:applyModelObj.pgSpecialisation] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY_FRESHERS] forKey:@"ControllerName"];
            cell.index = ROW_TYPE_MASTER_EDUCATION_UNREG;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            
            
//            cell.titleLableStr = @"Post Graduation Details" ;
//            cell.titlePlaceholderStr = @"Select Course, Specialization";
//            cell.titleStr = [self getCourseNameAndSpecialisationFrom:applyModelObj.pgCourse  andSpecialisation:applyModelObj.pgSpecialisation];
//            cell.isEditable = NO;
//            cell.showAccessoryView = YES;
//            cell.index = ROW_TYPE_MASTER_EDUCATION;
//            cell.txtTitle.accessibilityLabel = @"master_txtFld";
            break;
        }
        case ROW_TYPE_DOCTORATE_EDUCATION_UNREG:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[self getCourseNameAndSpecialisationFrom:applyModelObj.doctCourse andSpecialisation:applyModelObj.doctspecialisation] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY_FRESHERS] forKey:@"ControllerName"];
            cell.index = ROW_TYPE_DOCTORATE_EDUCATION_UNREG;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            
//            cell.titleLableStr = @"Doctorate Details";
//            cell.titlePlaceholderStr = @"Select Course, Specialization";
//            cell.titleStr = [self getCourseNameAndSpecialisationFrom:applyModelObj.doctCourse andSpecialisation:applyModelObj.doctspecialisation];
//            cell.isEditable = NO;
//            cell.showAccessoryView = YES;
//            cell.index = ROW_TYPE_DOCTORATE_EDUCATION_UNREG;
//            cell.txtTitle.accessibilityLabel = @"doctorate_txtFld";
            break;
            
        }
        case ROW_TYPE_CURRENT_LOCATION_UNREG:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[self getCourseNameAndSpecialisationFrom:applyModelObj.country andSpecialisation:applyModelObj.city] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY_FRESHERS] forKey:@"ControllerName"];
            cell.index = ROW_TYPE_CURRENT_LOCATION_UNREG;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            
//            cell.titleLableStr = @"Where are you currently Located";
//            cell.titlePlaceholderStr = @"Select Country, City";
//            cell.titleStr = [self getCourseNameAndSpecialisationFrom:applyModelObj.country andSpecialisation:applyModelObj.city];
//            cell.isEditable = NO;
//            cell.showAccessoryView = YES;
//            cell.index = ROW_TYPE_CURRENT_LOCATION_UNREG;
//            cell.txtTitle.accessibilityLabel = @"location_txtFld";
            
            break;
        }
            
            
        case ROW_TYPE_NATIONALITY_UNREG:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[self getNationality:applyModelObj.nationality] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY_FRESHERS] forKey:@"ControllerName"];
            cell.index = ROW_TYPE_NATIONALITY_UNREG;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            
            
//            cell.titleLableStr = @"What is your Nationality";
//            cell.titlePlaceholderStr = @"Select Nationality";
//            cell.titleStr = [self getNationality:applyModelObj.nationality];
//            cell.isEditable = NO;
//            cell.showAccessoryView = YES;
//            cell.index = ROW_TYPE_NATIONALITY_UNREG;
//            cell.txtTitle.accessibilityLabel = @"nationality_func_txtFld";
            
            break;
        }
           
        case ROW_TYPE_DESIGNATION_UNREG:{
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:applyModelObj.currentDesignation forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY_FRESHERS] forKey:@"ControllerName"];
            cell.editModuleNumber = K_EDIT_WORK_EXPERIENCE;
            cell.index = ROW_TYPE_DESIGNATION_UNREG;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            designationTxtFld = (NGTextField*)cell.txtTitle;
            [self addAutoCompleter];
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];

            
            
            
//            designationTxtFld = (NGTextField*)cell.txtTitle;
//            [self addAutoCompleter];
//            cell.editModuleNumber = K_EDIT_WORK_EXPERIENCE;
//            cell.delegate = self;
//            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
//            cell.titleLableStr = @"Designation";
//            cell.titlePlaceholderStr = @"What is your Current Designation";
//            cell.titleStr = applyModelObj.currentDesignation;
//            cell.isEditable = YES;
//            cell.showAccessoryView = NO;
//            cell.index = ROW_TYPE_DESIGNATION_UNREG;
//            cell.txtTitle.accessibilityLabel = @"Designation_txtFld";
//            cell.keyTxtCharLimit = [NSNumber numberWithInt:50];
//            [cell configureEditProfileCell];
//            cell.delegate = self;
            
            return cell;
            break;
        }

        default:
            break;
    }
    
    return cell;
    
}


-(NSInteger) getRowNumberForIndexpath:(NSIndexPath*) indexPath {

    if (applyModelObj.isFresher) {
    
        return indexPath.row;
    }
    
    else{
       
        switch (indexPath.row) {
           
            case 0: return ROW_TYPE_DESIGNATION_UNREG;
            break;
                
            default: return indexPath.row +2;
                break;
        }
        
    }

}


- (AutocompletionTableView *)getautoCompleter
{
    
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:designationTxtFld inViewController:self withOptions:options withDefaultStyle:NO];
        _autoCompleter.autoCompleteDelegate = self;
        _autoCompleter.suggestionsDictionary = [self getSuggestors];
        
        
        [self.view addSubview:_autoCompleter];
        
        [self addconstaint];
    }
    return _autoCompleter;
}



-(void) addconstaint {
    
    NSLayoutConstraint *autoCompletionLeftConstraints = [NSLayoutConstraint constraintWithItem:_autoCompleter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSInteger yForAutoCompletionTable = 64;
    
    NSLayoutConstraint *autoCompletionTopConstraints = [NSLayoutConstraint constraintWithItem:_autoCompleter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:yForAutoCompletionTable];
    
    NSLayoutConstraint *autoCompletionRightConstraints = [NSLayoutConstraint constraintWithItem:_autoCompleter attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *autoCompletionWidthConstraints = [NSLayoutConstraint constraintWithItem:_autoCompleter attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    autoCompletionHeightConstraints = [NSLayoutConstraint constraintWithItem:_autoCompleter attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:600.0];
    
    
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
    [_autoCompleter updateConstraints];
    [[self view] setNeedsLayout];
}



-(NSArray *)getSuggestors
{
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedDesignationWithFrequency:DESIGNATION_SUGGESTOR_KEY];
    return suggestors;
    
}


#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return  [self getSuggestors];
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText {
    // invoked when an available suggestion is selected
    
    applyModelObj.currentDesignation = [[selectedText componentsSeparatedByString:@","] objectAtIndex:0];
    designationTxtFld.text = applyModelObj.currentDesignation;
    [self.view endEditing:YES];
    
}



-(void)showingTheOptions:(BOOL)status{
    
    [self hideSuggesterBackGrndView:status];
}

- (void)handleSingleTapOnSuggestorBackGrndView{
    
    [self hideSuggestorView];
}

-(void)hideSuggestorView{
    
    [designationTxtFld resignFirstResponder];
    _autoCompleter.hidden = YES;
    [self hideSuggestorBackGrndView:YES];
}
-(void)hideSuggestorBackGrndView:(BOOL)status{
    
    suggestorBackgroundView.hidden = status;
}

-(void)hideSuggesterBackGrndView:(BOOL)status{
    
    [suggestorBackgroundView setHidden:!status];
    
}
-(void)addSuggestorBackGroundView :(float)yPos{
    
    if (!suggestorBackgroundView) {
        
        CGRect tempFrame = self.view.frame;
        tempFrame.origin.y = yPos+44;
        suggestorBackgroundView = [[UIView alloc] initWithFrame:tempFrame];
        suggestorBackgroundView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:suggestorBackgroundView belowSubview:_autoCompleter];
        [self.view bringSubviewToFront:_autoCompleter];
        [self hideSuggesterBackGrndView:NO];
        [suggestorBackgroundView setHidden:YES];
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

#pragma Mark -
#pragma Adding TextFiled in key skill tuple for handling the AutoSuggestor  delegate

-(void)addAutoCompleter{
    
    _autoCompleter = [self getautoCompleter];
    _autoCompleter.isMultiSelect = TRUE;
    [designationTxtFld setClearButtonMode:UITextFieldViewModeWhileEditing];
    [designationTxtFld addTarget:_autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - textfield delegates

-(void) textFieldDidStartEditing:(NSInteger)index{
    
    if (index == ROW_TYPE_DESIGNATION_UNREG) {
        
        self.autoCompleter.isErrorViewVisibleInSearch= NO;
        
        CGFloat paddingSuggectionView = K_AUTOSUGGESTOR_HEIGHT_IOS7;
        
        [self.autoCompleter setTopPositionForSuggestorView:designationTxtFld.frame.origin.y+paddingSuggectionView];
        
        [self addSuggestorBackGroundView:designationTxtFld.frame.origin.y+paddingSuggectionView];
        
        
    }
}


- (void)textFieldDidEndEditing:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    [self hideSuggestorView];
    switch (index) {
            
        case ROW_TYPE_DESIGNATION_UNREG:
            applyModelObj.currentDesignation = [NSString stripTags:textFieldValue];
            textField.text =applyModelObj.currentDesignation;
            break;
        default:
            break;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];

    NSMutableArray* dataArr;
    NSMutableArray* titleArr;
    NSInteger dropDownType;
    NSString* preSelectedId;
    NGValueSelectionResponseModal* modal;

    NGProfileEditCell *cell  = (NGProfileEditCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    switch (cell.index) {
        case ROW_TYPE_BASIC_EDUCATION_UNREG:
            
            titleArr = [[NSMutableArray alloc]initWithObjects:@"Course",@"Specialization", nil];
            dataArr = [NSMutableArray arrayWithArray:ugCoursesWithSpecArr];
            dropDownType = DDC_UGCOURSE;
            preSelectedId = [applyModelObj.gradCourse objectForKey:KEY_ID];
            modal = [[NGValueSelectionResponseModal alloc] init];
            modal.selectedId = [applyModelObj.gradCourse objectForKey:KEY_ID];
            modal.selectedValue = [applyModelObj.gradCourse objectForKey:KEY_VALUE];
            modal.valueSelectionResponseObj = [[NGValueSelectionResponseModal alloc] init];
            modal.valueSelectionResponseObj.selectedId = [applyModelObj.gradspecialisation objectForKey:KEY_ID];
            modal.valueSelectionResponseObj.selectedValue = [applyModelObj.gradspecialisation objectForKey:KEY_VALUE];
            break;
            
        case  ROW_TYPE_MASTER_EDUCATION_UNREG:
            
            titleArr = [[NSMutableArray alloc]initWithObjects:@"Course",@"Specialization", nil];
            dataArr = [NSMutableArray arrayWithArray:pgCoursesWithSpecArr];
            dropDownType = DDC_PGCOURSE;
            preSelectedId = [applyModelObj.pgCourse objectForKey:KEY_ID];
            modal = [[NGValueSelectionResponseModal alloc] init];
            modal.selectedId = [applyModelObj.pgCourse objectForKey:KEY_ID];
            modal.valueSelectionResponseObj = [[NGValueSelectionResponseModal alloc] init];
            modal.valueSelectionResponseObj.selectedId = [applyModelObj.pgSpecialisation objectForKey:KEY_ID];
            modal.selectedValue = [applyModelObj.pgCourse objectForKey:KEY_VALUE];
            modal.valueSelectionResponseObj.selectedValue = [applyModelObj.pgSpecialisation objectForKey:KEY_VALUE];
            

            break;
            
        case  ROW_TYPE_DOCTORATE_EDUCATION_UNREG:
            
            titleArr = [[NSMutableArray alloc]initWithObjects:@"Course",@"Specialization", nil];
            dataArr = [NSMutableArray arrayWithArray:doctCoursesWithSpecArr];
            dropDownType = DDC_PPGCOURSE;
            preSelectedId = [applyModelObj.doctCourse objectForKey:KEY_ID];
            modal = [[NGValueSelectionResponseModal alloc] init];
            modal.selectedId = [applyModelObj.doctCourse objectForKey:KEY_ID];
            modal.valueSelectionResponseObj = [[NGValueSelectionResponseModal alloc] init];
             modal.valueSelectionResponseObj.selectedId = [applyModelObj.doctspecialisation objectForKey:KEY_ID];
            modal.selectedValue = [applyModelObj.doctCourse objectForKey:KEY_VALUE];
            modal.valueSelectionResponseObj.selectedValue = [applyModelObj.doctspecialisation objectForKey:KEY_VALUE];
            

            break;
            
        case  ROW_TYPE_CURRENT_LOCATION_UNREG:
            
            titleArr = [[NSMutableArray alloc]initWithObjects:@"Country",@"City", nil];
            dataArr = [NSMutableArray arrayWithArray:countryAndCityModalArr];
            dropDownType = DDC_COUNTRY;
            preSelectedId = [applyModelObj.country objectForKey:KEY_ID];
            modal = [[NGValueSelectionResponseModal alloc] init];
            modal.selectedId = [applyModelObj.country objectForKey:KEY_ID];
            modal.valueSelectionResponseObj = [[NGValueSelectionResponseModal alloc] init];
            modal.valueSelectionResponseObj.selectedId = [applyModelObj.city objectForKey:KEY_ID];
            modal.selectedValue = [applyModelObj.country objectForKey:KEY_VALUE];
            modal.valueSelectionResponseObj.selectedValue = [applyModelObj.city objectForKey:KEY_VALUE];
            
      
            break;
        
        case  ROW_TYPE_NATIONALITY_UNREG:
            
            titleArr = [[NSMutableArray alloc]initWithObjects:@"Nationality", nil];
            dataArr = [NSMutableArray arrayWithArray:nationalityArr];
            dropDownType = DDC_NATIONALITY;
            preSelectedId = [applyModelObj.nationality objectForKey:KEY_ID];
            modal = [[NGValueSelectionResponseModal alloc] init];
            modal.selectedId = [applyModelObj.nationality objectForKey:KEY_ID];
            modal.valueSelectionResponseObj.selectedId = nil;
            modal.selectedValue = [applyModelObj.nationality objectForKey:KEY_VALUE];
            
            break;
        default:
            break;
    }
    
    
    if(dataArr)
    {
        [self showValueSelectionLayer:dataArr havingTitles:titleArr
                     havingSelectedId:preSelectedId
                               ofType:dropDownType
                     preSelectedModal:modal];
        
        titleArr = nil;
        dataArr = nil;
        modal = nil;
        
    }

}



#pragma mark - Selection Layer
-(void)showValueSelectionLayer:(NSMutableArray*)dataArr
                  havingTitles:(NSMutableArray*)titleArr
              havingSelectedId:(NSString*)selectedId
                        ofType: (NSInteger)ddType
              preSelectedModal:(NGValueSelectionResponseModal*)modal

{
    NGLayeredValueSelectionViewController* selectionLayerVC = [[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"layerSelection"];
    
    selectionLayerVC.delegateOfLayerViewController = self;
    selectionLayerVC.displayData = dataArr;
    selectionLayerVC.arrTitles = titleArr;
    selectionLayerVC.dropdownType = ddType;
    selectionLayerVC.selectedId = selectedId;
    selectionLayerVC.iLayerProgressStatus = 1;
    selectionLayerVC.valueSelectionResponseModal = modal;
       

    if(ddType == DDC_COUNTRY||ddType == DDC_INDUSTRY_TYPE||ddType == DDC_NATIONALITY||ddType == DDC_FAREA || ddType == DDC_LOCATION)
    selectionLayerVC.showSearchBar = YES;
    else
    selectionLayerVC.showSearchBar = NO;
  
    [[NGHelper sharedInstance].valueSelectionLayerArray removeAllObjects];
    [[NGHelper sharedInstance].valueSelectionLayerArray addObject:selectionLayerVC];
    [appDelegate.container setRightMenuViewController:selectionLayerVC];
    appDelegate.container.rightMenuPanEnabled=NO;
    
    [appDelegate.container toggleRightSideMenuCompletion:nil];

}



#pragma mark - LayeredValueSelector Delegate
/**
 *  @name LayeredValueSelector Delegate
 * */
-(void)layerValueSelected:(NGValueSelectionResponseModal*)selectedModal{
    
    [[NGHelper sharedInstance].valueSelectionLayerArray removeLastObject];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    switch (selectedModal.dropDownType)
    {
        case  DDC_UGCOURSE:{
            if (0>=[vManager validateValue:selectedModal.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.selectedValue withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedValue withType:ValidationTypeString].count)
            {
                
                [applyModelObj.gradCourse setValue:selectedModal.selectedId forKey:KEY_ID];
                [applyModelObj.gradCourse setValue:selectedModal.selectedValue forKey:KEY_VALUE];
                
                [applyModelObj.gradspecialisation setValue:selectedModal.valueSelectionResponseObj.selectedId forKey:KEY_ID];
                [applyModelObj.gradspecialisation setValue:selectedModal.valueSelectionResponseObj.selectedValue forKey:KEY_VALUE];
                
            }else{
               
                [applyModelObj.gradCourse setValue:@"" forKey:KEY_ID];
                [applyModelObj.gradCourse setValue:@""  forKey:KEY_VALUE];
                [applyModelObj.gradspecialisation setValue:@""  forKey:KEY_ID];
                [applyModelObj.gradspecialisation setValue:@"" forKey:KEY_VALUE];
                
               
            }
            
            break;
        }
          
            
        case  DDC_PGCOURSE:{
            
            if (0>=[vManager validateValue:selectedModal.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.selectedValue withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedValue withType:ValidationTypeString].count)
            {
                
                [applyModelObj.pgCourse setValue:selectedModal.selectedId forKey:KEY_ID];
                [applyModelObj.pgCourse setValue:selectedModal.selectedValue forKey:KEY_VALUE];
                
                [applyModelObj.pgSpecialisation setValue:selectedModal.valueSelectionResponseObj.selectedId forKey:KEY_ID];
                [applyModelObj.pgSpecialisation setValue:selectedModal.valueSelectionResponseObj.selectedValue forKey:KEY_VALUE];
                
            }else{
                
                [applyModelObj.pgCourse setValue:@"" forKey:KEY_ID];
                [applyModelObj.pgCourse setValue:@""  forKey:KEY_VALUE];
                [applyModelObj.pgSpecialisation setValue:@""  forKey:KEY_ID];
                [applyModelObj.pgSpecialisation setValue:@"" forKey:KEY_VALUE];
                
                
            }
            
            break;
        }
            
            
            
        case  DDC_PPGCOURSE:{
            
            if (0>=[vManager validateValue:selectedModal.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.selectedValue withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedValue withType:ValidationTypeString].count)
            {
                
                [applyModelObj.doctCourse setValue:selectedModal.selectedId forKey:KEY_ID];
                [applyModelObj.doctCourse setValue:selectedModal.selectedValue forKey:KEY_VALUE];
                
                [applyModelObj.doctspecialisation setValue:selectedModal.valueSelectionResponseObj.selectedId forKey:KEY_ID];
                [applyModelObj.doctspecialisation setValue:selectedModal.valueSelectionResponseObj.selectedValue forKey:KEY_VALUE];
                
            }else{
                
                [applyModelObj.doctCourse setValue:@"" forKey:KEY_ID];
                [applyModelObj.doctCourse setValue:@""  forKey:KEY_VALUE];
                [applyModelObj.doctspecialisation setValue:@""  forKey:KEY_ID];
                [applyModelObj.doctspecialisation setValue:@"" forKey:KEY_VALUE];
                
                
            }
            
            break;
            
        }
        case  DDC_COUNTRY:{
            
            if (0>=[vManager validateValue:selectedModal.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.selectedValue withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedValue withType:ValidationTypeString].count)
            {
                
                [applyModelObj.country setValue:selectedModal.selectedId forKey:KEY_ID];
                [applyModelObj.country setValue:selectedModal.selectedValue forKey:KEY_VALUE];
                
                [applyModelObj.city setValue:selectedModal.valueSelectionResponseObj.selectedId forKey:KEY_ID];
                [applyModelObj.city setValue:selectedModal.valueSelectionResponseObj.selectedValue forKey:KEY_VALUE];
                
            }else{
                
                [applyModelObj.country setValue:@"" forKey:KEY_ID];
                [applyModelObj.country setValue:@""  forKey:KEY_VALUE];
                [applyModelObj.city setValue:@""  forKey:KEY_ID];
                [applyModelObj.city setValue:@"" forKey:KEY_VALUE];
                
            }
            
            break;
        }
            
            
        case  DDC_NATIONALITY:{
            
            if (0>=[vManager validateValue:selectedModal.selectedId withType:ValidationTypeString].count && 0>=[vManager validateValue:selectedModal.selectedValue withType:ValidationTypeString].count)
            {
                
                [applyModelObj.nationality setValue:selectedModal.selectedId forKey:KEY_ID];
                [applyModelObj.nationality setValue:selectedModal.selectedValue forKey:KEY_VALUE];
                
            }else{
                
                [applyModelObj.nationality setValue:@"" forKey:KEY_ID];
                [applyModelObj.nationality setValue:@""  forKey:KEY_VALUE];
                
            }
            
            break;
        }
        default:
            break;
    }
    vManager = nil;
    

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    [self.editTableView reloadData];
}


-(NSString*) getCourseNameAndSpecialisationFrom: (NSDictionary *) course andSpecialisation:(NSDictionary*) specialisation {
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    BOOL isValidString = (0>=[vManager validateValue:[course objectForKey:KEY_VALUE] withType:ValidationTypeString].count) && [specialisation objectForKey:KEY_VALUE];
    return isValidString?[NSString stringWithFormat:@"%@, %@",[course objectForKey:KEY_VALUE],[specialisation objectForKey:KEY_VALUE]]:nil;
    
}

-(NSString*) getNationality: (NSDictionary *)nation {
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    BOOL isValidString = 0>=[vManager validateValue:[nation objectForKey:KEY_VALUE] withType:ValidationTypeString].count;
    return isValidString?[NSString stringWithFormat:@"%@",[nation objectForKey:KEY_VALUE]]:nil;

}

-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    
    [self.view endEditing:YES];
    
    NSArray *errors = [self checkValidations];
    
    if(errors.count==0){
        
        NSString* strYrExp = [[applyModelObj.workEx objectForKey:KEY_YEAR_DICTIONARY] objectForKey:KEY_ID];
        if ([strYrExp isEqualToString:@"30+"]) {
            
            NSDictionary* dict = [applyModelObj.workEx objectForKey:KEY_YEAR_DICTIONARY];
            [dict setCustomObject:@"30plus" forKey:KEY_ID];
        }
        
        
        NGJobsHandlerObject *obj = [[NGJobsHandlerObject alloc]init];
        obj.jobObj = jobObj;
        obj.unregApplyModal =  applyModelObj;
        obj.Controller =  self;
        obj.applyState = LoginApplyStateUnRegistered;
        obj.isEmailRegistered = _jobHandler.isEmailRegistered;
        obj.openJDLocation = _jobHandler.openJDLocation;
        [[NGApplyJobHandler sharedManager] jobHandlerAppliedForFinalStep:obj];
        
        NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
        [staticContentManager saveApplyFields:applyModelObj];
        
    }

}

-(NSArray*) checkValidations{
    
    NSMutableArray *errorMessages = [[NSMutableArray alloc] init];
    
    NSString * errorMessage = @"Please specify your ";
    
    if(!applyModelObj.isFresher && (!applyModelObj.currentDesignation || !applyModelObj.currentDesignation.length)){
        
        [errorMessages addObject:@"Designation"];
        
    }else{
        
    }
    
    if (([applyModelObj.country objectForKey:KEY_VALUE] == nil) || ([applyModelObj.city objectForKey:KEY_VALUE] == nil)|| (![[applyModelObj.country objectForKey:KEY_VALUE] length]) || (![[applyModelObj.city objectForKey:KEY_VALUE] length])){
        
        [errorMessages addObject:@"City"];
    }
       
    if (![applyModelObj.nationality objectForKey:KEY_VALUE] || (![[applyModelObj.nationality objectForKey:KEY_VALUE] length])) {
        
        [errorMessages addObject:@"Nationality"];
    }
    
    if(errorMessages.count) {
    
    for (NSInteger i = 0; i< [errorMessages count]; i++) {
        
        if (i == [errorMessages count]-1)
            errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@",
                                                                  [errorMessages fetchObjectAtIndex:i]]];
        else
            errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@, ",
                                                                  [errorMessages fetchObjectAtIndex:i]]];
    }
    
    [NGUIUtility showAlertWithTitle:@"Incomplete Details!" withMessage:[NSArray arrayWithObjects:errorMessage, nil]
                withButtonsTitle:@"OK" withDelegate:nil];
    }
    
    return errorMessages;
}


@end
