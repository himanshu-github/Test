//
//  NGEditEducationViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditEducationViewController.h"
#import "DDBase.h"
#import "DDCountry.h"
#import "DDUGCourse.h"
#import "DDPGCourse.h"
#import "DDPPGCourse.h"

@interface NGEditEducationViewController (){
    
    
    NGCalenderPickerView *datePicker; // a date picker controller class
    BOOL isValueSelectorExist; //  if valueselector controller  is present or not
    BOOL isCalenderExist; //  if date picker controller is present or not

    NSString *courseType;
    NSString *otherCourseType;
    NSString *specialisation;
    NSString *otherSpecialisation;
    NSString *yearOfGrad;
    
    BOOL showOtherCourseField;
    BOOL showOtherSpecialisationField;
    NSString *courseTypeName;
    int ddCourseType;
    int ddSpecType;
    NSMutableDictionary *allDatePickerParams;
    NSString *errorTitle;
    NSString *title;
    
    NSMutableDictionary* dictCourse;
    NSMutableDictionary* dictSpec;
    NSMutableDictionary* dictCountry;
    
    BOOL isInitialParamDictUpdated;
    
}
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side

@end

@implementation NGEditEducationViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.editTableView.scrollEnabled = NO;
    
    dictCourse = [NSMutableDictionary dictionary];
    dictSpec = [NSMutableDictionary dictionary];
    dictCountry = [NSMutableDictionary dictionary];
    allDatePickerParams = [[NSMutableDictionary alloc]init];
    
    [self setAllDatePickers];
    
    isInitialParamDictUpdated = NO;
    self.isSwipePopDuringTransition = NO;
    self.isSwipePopGestureEnabled = YES;
    
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    self.isRequestInProcessing = NO;
    if ([self.courseTypeValue isEqualToString:@"ppg"]) {
        
        title = @"Doctorate Education";
        courseTypeName = @"Doctorate";
        ddCourseType = DDC_PPGCOURSE;
        ddSpecType = DDC_PPGSPEC;
        
    }else if ([self.courseTypeValue isEqualToString:@"pg"]) {
        
        title = @"Master Education";
        courseTypeName = @"Masters";
        ddCourseType = DDC_PGCOURSE;
        ddSpecType = DDC_PGSPEC;
    }else {
        
        title = @"Basic Education";
        courseTypeName = @"Basic";
        ddCourseType = DDC_UGCOURSE;
        ddSpecType = DDC_UGSPEC;
    }
    
    [self customizeNavBarWithTitle:title];
    

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
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"edit_%@_table",[title stringByReplacingOccurrencesOfString:@" " withString:@""]] forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)updateDataWithParams:(NGEducationDetailModel *)obj{
    
    self.modalClassObj = obj;
    
    if (self.modalClassObj) {
        
        NSArray *ddNameArr = [NSArray arrayWithObjects:self.modalClassObj.country,self.modalClassObj.course,self.modalClassObj.specialization, nil];
        
        NSArray *ddTypeArr = [NSArray arrayWithObjects:
                              [NSNumber numberWithInteger:DDC_COUNTRY],
                              [NSNumber numberWithInteger:DDC_UGCOURSE],
                              [NSNumber numberWithInteger:DDC_UGSPEC], nil];
        
        for (NSInteger i = 0; i<ddNameArr.count; i++) {
            NSDictionary *ddName = [ddNameArr fetchObjectAtIndex:i];
            NSNumber *ddType = [ddTypeArr fetchObjectAtIndex:i];
            
            if (![[ddName objectForKey:KEY_VALUE]isEqualToString:@""]) {
                [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:ddType,K_DROPDOWN_TYPE,
                    [NSArray arrayWithObjects:[ddName objectForKey:KEY_VALUE], nil],K_DROPDOWN_SELECTEDVALUES,
                    [NSArray arrayWithObjects:[ddName objectForKey:KEY_ID], nil],
                        K_DROPDOWN_SELECTEDIDS,
                    [ddName objectForKey:KEY_SUBVALUE],@"OtherValues",nil]];
            }
            
        }
        
        if (self.modalClassObj.year) {
            
            yearOfGrad = self.modalClassObj.year;
            
            NSMutableDictionary *dict = [allDatePickerParams objectForKey:[NSString stringWithFormat:@"%d",ROW_TYPE_YEAR_OF_GRAD]];
            
            [dict setCustomObject:yearOfGrad forKey:@"SelectedDate"];
            
            [allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",ROW_TYPE_YEAR_OF_GRAD]];
        }
        
    }
    
    
}

/**
 *   a Date Picker View appears on right side on editing the Visa textField
 */
-(void)setAllDatePickers {
    //// Date Picker Visa Date
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:[NSNumber numberWithInteger:ROW_TYPE_YEAR_OF_GRAD] forKey:@"ID"];
    [dict setCustomObject:[NSNumber numberWithBool:FALSE] forKey:@"DisplayMonth"];
    [dict setCustomObject:[NSNumber numberWithBool:FALSE] forKey:@"DisplayDay"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayYear"];
    [dict setCustomObject:@"Year Of Passing" forKey:@"Header"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:-50]] forKey:@"MinYear"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:5]] forKey:@"MaxYear"];
    [allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",ROW_TYPE_YEAR_OF_GRAD]];
}



/**
 *  Method updates the ddContentArr objects with selected value from drop down list / TextFields
 *
 *  @param responseParams  NSDictionary class conatining objects  for particular Keys
 */
-(void)handleDDOnSelection:(NSDictionary *)responseParams{
    
    NSInteger ddType = [[responseParams objectForKey:K_DROPDOWN_TYPE]integerValue];
    NSArray *arrSelectedIds = [responseParams objectForKey:K_DROPDOWN_SELECTEDIDS];
    NSArray* arrSelectedValues = [responseParams objectForKey:K_DROPDOWN_SELECTEDVALUES];
    

    switch (ddType) {
            
        case DDC_UGCOURSE:
        case DDC_PGCOURSE:
        case DDC_PPGCOURSE:{
           
            
            if (arrSelectedIds.count>0) {
                [dictCourse setCustomObject:[arrSelectedIds fetchObjectAtIndex:0]
                                                                    forKey:KEY_ID];
                [dictCourse setCustomObject:[arrSelectedValues fetchObjectAtIndex:0]
                                                                    forKey:KEY_VALUE];
              
            }else{
                
                [dictCourse setCustomObject:@"" forKey:KEY_ID];
                [dictCourse setCustomObject:@"" forKey:KEY_VALUE];
            }
            courseType = [dictCourse objectForKey:KEY_VALUE];
            specialisation = @"";
            [dictSpec setCustomObject:[NSArray array] forKey:KEY_ID];
            [dictSpec setCustomObject:[NSArray array] forKey:KEY_VALUE];
            
        
            if ([courseType isEqualToString:@"Other"]) {
                showOtherCourseField = TRUE;
                otherCourseType = [responseParams objectForKey:@"OtherValues"];
                [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInteger:DDC_UGSPEC],K_DROPDOWN_TYPE,
                                       [NSArray arrayWithObjects:@"Other", nil],K_DROPDOWN_SELECTEDVALUES,
                                           [NSArray arrayWithObjects:@"1000", nil],K_DROPDOWN_SELECTEDIDS,
                                           nil]];
                
            }else{
                showOtherCourseField = FALSE;
                otherCourseType = nil;
                [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInteger:DDC_UGSPEC],K_DROPDOWN_TYPE,
                                           [NSArray array], K_DROPDOWN_SELECTEDVALUES,nil]];
            }
            
            break;
        }
            
        case DDC_UGSPEC:
        case DDC_PGSPEC:
        case DDC_PPGSPEC:{
            
            if (arrSelectedIds.count>0) {
                NSArray* arrIds = [(NSString*)[arrSelectedIds fetchObjectAtIndex:0] componentsSeparatedByString:@"."];
                
                [dictSpec setCustomObject:[arrIds lastObject] forKey:KEY_ID];
                [dictSpec setCustomObject:[arrSelectedValues fetchObjectAtIndex:0] forKey:KEY_VALUE];
                
            }else{
                
                [dictSpec setCustomObject:@"" forKey:KEY_ID];
                [dictSpec setCustomObject:@"" forKey:KEY_VALUE];
            }
            specialisation = [dictSpec objectForKey:KEY_VALUE];
            if ([specialisation isEqualToString:@"Other"]) {
                showOtherSpecialisationField = TRUE;
                otherSpecialisation = [responseParams objectForKey:@"OtherValues"];
                
            }else{
                showOtherSpecialisationField = FALSE;
                otherSpecialisation = nil;
                
            }
            
            
            break;
        }
            
            
        case DDC_COUNTRY:{

            if (arrSelectedIds.count>0) {
                [dictCountry setCustomObject:[arrSelectedIds fetchObjectAtIndex:0] forKey:KEY_ID];
                [dictCountry setCustomObject:[arrSelectedValues fetchObjectAtIndex:0] forKey:KEY_VALUE];
            }else{
                [dictCountry setCustomObject:@"" forKey:KEY_ID];
                [dictCountry setCustomObject:@"" forKey:KEY_VALUE];
            }
            
            break;
        }
            
        default:
            break;
    }
    
    [self.editTableView reloadData];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self getNumberOfRows];
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
    cell.editModuleNumber = K_EDIT_EDUCATION_DETAIL_PAGE;
    cell.delegate = self;
    
    NSInteger row = [self getRowForIndexpath:indexPath];
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    
    
    switch (row) {
            
        case ROW_TYPE_COURSE_TYPE:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictCourse objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_EDUCATION_DETAIL_PAGE] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            
            break;
        }
        case ROW_TYPE_OTHER_COURSE_TYPE:{
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:otherCourseType forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_EDUCATION_DETAIL_PAGE] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            break;
        }
        case ROW_TYPE_SPECIALISATION:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictSpec objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_EDUCATION_DETAIL_PAGE] forKey:@"ControllerName"];
            [dictToPass setCustomObject:courseType forKey:@"courseType"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            break;
            
        }
        case ROW_TYPE_OTHER_SPECIALISATION:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:otherSpecialisation forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_EDUCATION_DETAIL_PAGE] forKey:@"ControllerName"];
            //[dictToPass setCustomObject:courseType forKey:@"courseType"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            
            break;
        }
            
        case ROW_TYPE_YEAR_OF_GRAD:{
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:yearOfGrad forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_EDUCATION_DETAIL_PAGE] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            
            break;
        }
            
        case ROW_TYPE_COUNTRY : {
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictCountry objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_EDUCATION_DETAIL_PAGE] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            break;
        }
            
        default:
            break;
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    NGProfileEditCell *cell =(NGProfileEditCell*) [self.editTableView cellForRowAtIndexPath:indexPath];
    NSInteger cellType = cell.txtTitle.tag;
    
    isValueSelectorExist = YES;
    ValidatorManager *vManager = [ValidatorManager sharedInstance];

    if (!_valueSelector) {
        
        _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
        _valueSelector.delegate = self;
        
    }
    [APPDELEGATE.container setRightMenuViewController:_valueSelector];
    APPDELEGATE.container.rightMenuPanEnabled = NO;
    
    
    switch (cellType) {
            
        case ROW_TYPE_COURSE_TYPE:{
            
            if(0>=[vManager validateValue:[dictCourse objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [dictCourse objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];
            
            _valueSelector.dropdownType = ddCourseType;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];

        }
            break;
            
        case ROW_TYPE_SPECIALISATION:{
            
            if ([courseType isEqualToString:@""] || [courseType isEqualToString:@"Other"])
                return;
            
            Class myClass;
            if (ddCourseType == DDC_UGCOURSE)
                myClass = [DDUGCourse class];
            else if (ddCourseType == DDC_PGCOURSE)
                myClass = [DDPGCourse class];
            else
                myClass = [DDPPGCourse class];
            
        
            
            DDBase* obj = [[NGDatabaseHelper searchForType:KEY_ID havingValue:[dictCourse objectForKey:KEY_ID] andClass:myClass] fetchObjectAtIndex:0];
            _valueSelector.objDDBase = obj;
            if(0>=[vManager validateValue:[dictSpec objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [dictSpec objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            
            _valueSelector.dropdownType = ddSpecType;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
        }
            break;
            
        case ROW_TYPE_YEAR_OF_GRAD: {
            
           // _valueSelector = nil;
            
            if (!datePicker) {
                datePicker = [[NGCalenderPickerView alloc]initWithNibName:nil bundle:nil];
            }
            [APPDELEGATE.container setRightMenuViewController:datePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;

            datePicker.selectedValue = yearOfGrad?yearOfGrad:@"";
            datePicker.headerTitle = @"Year Of Passing";
            datePicker.delegate = self;
            datePicker.calType = NGCalenderTypeYYYY;
            datePicker.minYear =[NSNumber numberWithInteger:1950];
            datePicker.maxYear =[NSNumber numberWithInteger:2018];
            
            [datePicker refreshData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
                if(datePicker.selectedValue.length == 0)
                    [datePicker adjustDateInMiddle];
                
            }];

   
            
        }
            break;
            
        case ROW_TYPE_COUNTRY:
            
            if(0>=[vManager validateValue:[dictCountry objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [dictCountry objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_COUNTRY;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];

            break;
            
        default: return;
            break;
    }
    
       
}

#pragma mark - row calculations

-(NSInteger)getNumberOfRows{
    
    if(showOtherCourseField && showOtherSpecialisationField){
        return 6;
    }
    else if (showOtherCourseField || showOtherSpecialisationField){
        return 5;
    }
    else return 4;
}

- (NSInteger)getRowForIndexpath:(NSIndexPath*)paramIndexPath{
    
    NSInteger row = paramIndexPath.row;
    
    if(showOtherCourseField && showOtherSpecialisationField){
        return row;
    }
    else if (showOtherCourseField){
        
        if(row > 2) return  ++row ;
        else return row;
    }
    else if (showOtherSpecialisationField){
        
        if (row > 0) {
            
            return  ++row;
        }
    }else {
        
        switch (row) {
            case 0 : return  row;
                break;
            case 1 : return  row+1;
                break;
            case 2 :
            case 3: return   row+2;
                break;
        }
    }
    return row;
}

#pragma mark ValueSelector Delegate

-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }
    

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
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
 *   Method handle drop drown selction for Graduation Year
 *
 *  @param responseParams  NSDictionary class containing objects for key *(ID, Date)*
 */


-(void)handleDatePickersOnSelectionOfDate:(NSString *)date {
    
    yearOfGrad = date;
    
    [self.editTableView reloadData];
    
}


- (void)textField:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index {
    
    switch (textField.tag) {
            
        case ROW_TYPE_OTHER_COURSE_TYPE:
            otherCourseType = textField.text;
            break;
        case ROW_TYPE_OTHER_SPECIALISATION:
            otherSpecialisation = textField.text;
            break;
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_OTHER_COURSE_TYPE:
            otherCourseType = textField.text;
            break;
        case ROW_TYPE_OTHER_SPECIALISATION:
            otherSpecialisation = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
    [self.editDelegate editedEducationWithSuccess:YES];
    [self hideAnimator];
    self.isRequestInProcessing = FALSE;
    
}
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [self hideAnimator];
    self.isRequestInProcessing = FALSE;
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
    
    
    NSString* courseID = [dictCourse objectForKey:KEY_ID];
    if (courseID.length>0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setCustomObject:courseID forKey:@"id"];
        
        NSString *other = @"Other";
        
        if (showOtherCourseField) {
            other = [NSString getFilteredText:otherCourseType];
        }
        
        [dict setCustomObject:other forKey:@"other"];
        [dict setCustomObject:other forKey:@"otherEN"];
        
        [params setCustomObject:dict forKey:[NSString stringWithFormat:@"%@Course",self.courseTypeValue]];
    }
    
    
    NSString* specId = [dictSpec objectForKey:KEY_ID];
    if (specId.length>0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setCustomObject:[NSString stringWithFormat:@"%@.%@",
                               courseID,specId] forKey:@"id"];
        
        NSString *other = @"Other";
        
        if (showOtherSpecialisationField)
            other = [NSString getFilteredText:otherSpecialisation];
        
        
        [dict setCustomObject:other forKey:@"other"];
        [dict setCustomObject:other forKey:@"otherEN"];
        
        [params setCustomObject:dict forKey:[NSString stringWithFormat:@"%@Spec",self.courseTypeValue]];
    }
    
    [params setCustomObject:yearOfGrad forKey:[NSString stringWithFormat:@"%@Year",self.courseTypeValue]];
    
    NSString* countryId = [dictCountry objectForKey:KEY_ID];
    if (countryId.length>0) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setCustomObject:countryId forKey:@"id"];
        
        [params setCustomObject:countryId forKey:[NSString stringWithFormat:@"%@Country",self.courseTypeValue]];
    }else{
        [params setCustomObject:@"" forKey:[NSString stringWithFormat:@"%@Country",self.courseTypeValue]];
    }
    
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    
    return params;
}


-(void)onSave:(id)sender{

    [errorCellArr removeAllObjects];
    
    [self.view endEditing:YES];
    
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
        
        self.isRequestInProcessing = FALSE;
    }
    else{

        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EDIT_PROFILE withEventLabel:K_GA_EVENT_EDIT_PROFILE withEventValue:nil];
        if (!self.isRequestInProcessing) {
            
            [self setIsRequestInProcessing:YES];
            
            [self showAnimator];
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
            
        
            
            __weak NGEditEducationViewController *weakSelf = self;
            NSMutableDictionary *params =[self updateTheRequestParameterForSendingInitialValueOfChanges:[self getParametersInDictionary]];

            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf hideAnimator];
                        weakSelf.isRequestInProcessing = FALSE;
                    
                    if (responseInfo.isSuccess) {
                        [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                        [weakSelf.editDelegate editedEducationWithSuccess:YES];
                    }
                    
                });
            }];
            
    
        }
        
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
    
    if (0<[vManager validateValue:courseType withType:ValidationTypeString].count) {
        
        [arr addObject:@"Course type"];
        [errorCellArr addObject:[NSNumber numberWithInteger:0]];
    }
    if(showOtherCourseField)
    {
        if (0<[vManager validateValue:otherCourseType withType:ValidationTypeString].count) {
            [arr addObject:@"Other Course Type"];
            [errorCellArr addObject:[NSNumber numberWithInteger:1]];
        }
    }
    
    if (0<[vManager validateValue:specialisation withType:ValidationTypeString].count) {
        [arr addObject:@"Specialisation"];
        
        if (showOtherCourseField) {
            [errorCellArr addObject:[NSNumber numberWithInteger:2]];;
        }else{
            [errorCellArr addObject:[NSNumber numberWithInteger:1]];;
        }
        
    }
    if(showOtherSpecialisationField)
    {
        if (0<[vManager validateValue:otherSpecialisation withType:ValidationTypeString].count) {
           
            [arr addObject:@"Other Specialisation"];
            
            if (showOtherCourseField) {
                [errorCellArr addObject:[NSNumber numberWithInteger:3]];
            }else{
                [errorCellArr addObject:[NSNumber numberWithInteger:2]];
            }
        }
    }
    
    if (0<[vManager validateValue:yearOfGrad withType:ValidationTypeString].count) {
        
        [arr addObject:@"Year Of Passing"];
        
        if(showOtherCourseField && showOtherSpecialisationField){
            [errorCellArr addObject:[NSNumber numberWithInteger:4]];
        }else if (showOtherCourseField || showOtherSpecialisationField){
            [errorCellArr addObject:[NSNumber numberWithInteger:3]];
        }else{
            [errorCellArr addObject:[NSNumber numberWithInteger:2]];
        }
    
    }
    
    if (0<[vManager validateValue:[dictCountry objectForKey:KEY_VALUE] withType:ValidationTypeString].count) {
        
        [arr addObject:@"Country"];
        
        if(showOtherCourseField && showOtherSpecialisationField){
            [errorCellArr addObject:[NSNumber numberWithInteger:5]];
        }else if (showOtherCourseField || showOtherSpecialisationField){
            [errorCellArr addObject:[NSNumber numberWithInteger:4]];
        }else{
            [errorCellArr addObject:[NSNumber numberWithInteger:3]];
        }
    }

    return arr;
}

-(void) dealloc {
    
    self.modalClassObj = nil;
    self.courseTypeValue = nil;
}


@end
