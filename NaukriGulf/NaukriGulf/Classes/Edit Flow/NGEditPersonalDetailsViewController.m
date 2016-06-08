//
//  NGEditPersonalDetailsViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 07/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEditPersonalDetailsViewController.h"
#import "NGEditProfileSegmentedCell.h"
#import "DDNationality.h"
#import "DDReligion.h"
#import "DDMaritalStatus.h"
#import "DDCountry.h"
#import "DDLanguage.h"

enum CellType : NSInteger{
    DATE_OF_BIRTH = 0,
    GENDER = 1,
    NATIONALITY = 2,
    RELIGION = 3,
    MARITAL_STATUS = 4,
    DRIVING_LICENSE = 7,
    DRIVING_LICENSE_LOCATION = 5,
    LANGUAGES = 6
};

@interface NGEditPersonalDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,ProfileEditCellDelegate,ProfileEditCellSegmentDelegate>{

    NGCalenderPickerView *datePicker; // a date picker controller class
    BOOL isValueSelectorExist; //  if valueselector controller  is present or not
    BOOL isCalenderExist; //  if date picker controller is present or not
    
    
    NSString *dob,*gender, *dl;
    NSInteger selectedGenderIndex,selectedDLIndex;
    
    NSMutableDictionary* dictLanguages;
    NSMutableDictionary* dictReligion;
    NSMutableDictionary* dictMaritalStatus;
    NSMutableDictionary* dictNationality;
    NSMutableDictionary* dictDLCountry;
    
    BOOL isInitialParamDictUpdated;
}




/**
 *  dictionary containing another dictonary as object
 */
@property (strong, nonatomic) NSMutableDictionary *allDatePickerParams;
/**
 *  a Custom animation appears on loading operations
 */
@property (strong, nonatomic) NGLoader* loader;

@property (nonatomic, strong) NSMutableArray *cellsArr;
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side


@end

@implementation NGEditPersonalDetailsViewController

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self customizeNavBarWithTitle:@"Personal Details"];
    
    [self.editTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.editTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    [self customizeUI];
    
     dictLanguages = [NSMutableDictionary dictionary];
     dictReligion = [NSMutableDictionary dictionary];
     dictMaritalStatus = [NSMutableDictionary dictionary];
     dictNationality = [NSMutableDictionary dictionary];
     dictDLCountry = [NSMutableDictionary dictionary];
     self.allDatePickerParams = [[NSMutableDictionary alloc]init];
     [self setAllDatePickers];
    
    isInitialParamDictUpdated = NO;
    self.isSwipePopDuringTransition = NO;
    self.isSwipePopGestureEnabled = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [NGHelper sharedInstance].appState = APP_STATE_EDIT_FLOW;
    [super viewDidAppear:animated];
    self.isRequestInProcessing= FALSE;
    [self setAutomationLabel];
    [self updateInitialParams];

}
-(void)viewWillAppear:(BOOL)animated{

    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    [NGDecisionUtility checkNetworkStatus];

}
#pragma mark - Update Initial Params
-(void)updateInitialParams{
    if(!isInitialParamDictUpdated){
        self.initialParamDict  = [self getParametersInDictionary];
        isInitialParamDictUpdated = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.loader isLoaderAvail]) {
        [self.loader hideAnimatior:self.view];
    }
}

-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"edit_personalDetail_table"] forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
}

#pragma mark - Memory Management

- (void)dealloc {
    //[self releaseMemory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)releaseMemory{
    
    
    self.loader = nil;

    self.fieldsArray =     nil;
    
    if(isValueSelectorExist){
        
        [APPDELEGATE.container removeChildViewControllerFromContainer:_valueSelector];
        [APPDELEGATE.container setRightMenuViewController:nil];
        _valueSelector.requestParams = nil;
        _valueSelector.delegate = nil;
        _valueSelector = nil;
    }
    if(isCalenderExist){
        
        [APPDELEGATE.container removeChildViewControllerFromContainer:datePicker];
        [APPDELEGATE.container setRightMenuViewController:nil];
        datePicker.delegate =   nil;
        datePicker  =   nil;
        
        
    }
    
    if([self.allDatePickerParams allKeys]){
        [self.allDatePickerParams removeAllObjects];
    }
    self.allDatePickerParams =   nil;
    
    self.editDelegate = nil;
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
 *   Method handle drop drown selction for DOB
 *
 */

-(void)handleDatePickersOnSelectionOfDate:(NSString *)date {
    
    dob = date;
    NSInteger index = [self.cellsArr indexOfObject:[NSNumber numberWithInteger:DATE_OF_BIRTH]];
    [self.editTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
   
}

#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    [self hideAnimator];
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
    [self.editDelegate editedPersonalDetailsWithSuccess:YES];
    self.isRequestInProcessing= FALSE;

}
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [self hideAnimator];
    self.isRequestInProcessing= FALSE;
}
#pragma mark -
#pragma mark TextField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}


/**
 *  Method on trigger perform the customization of UI
 */
-(void)customizeUI {
    self.cellsArr = [[NSMutableArray alloc]init];
    [self.cellsArr addObject:[NSNumber numberWithInteger:DATE_OF_BIRTH]];
    [self.cellsArr addObject:[NSNumber numberWithInteger:GENDER]];
    [self.cellsArr addObject:[NSNumber numberWithInteger:NATIONALITY]];
    [self.cellsArr addObject:[NSNumber numberWithInteger:RELIGION]];
    [self.cellsArr addObject:[NSNumber numberWithInteger:MARITAL_STATUS]];
    [self.cellsArr addObject:[NSNumber numberWithInteger:DRIVING_LICENSE]];
    [self.cellsArr addObject:[NSNumber numberWithInteger:LANGUAGES]];
    
    selectedGenderIndex = 1;
    selectedDLIndex = 2;
}


/**
 *   On trigger  this method check for the validations in  textField and store the value in array
 *
 *  @return If Yes,  validation is applied ,
 */
-(NSMutableArray*)checkAllValidations {
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    errorFieldIndex = -1;
    if (0<[vManager validateValue:dob withType:ValidationTypeString].count) {
        [arr addObject:@"Date of Birth"];
        [errorCellArr addObject:[NSNumber numberWithInteger:0]];
        
    }
    
    if (0<[vManager validateValue:[dictNationality objectForKey:KEY_VALUE] withType:ValidationTypeString].count) {
        [arr addObject:@"Nationality"];
        [errorCellArr addObject:[NSNumber numberWithInteger:2]];
        
    }
    
    
    
    if (selectedDLIndex==1) {
        if (0<[vManager validateValue:[dictDLCountry objectForKey:KEY_VALUE] withType:ValidationTypeString].count) {
            [arr addObject:@"Driving License"];
            [errorCellArr addObject:[NSNumber numberWithInteger:6]];
            
        }
    }
    
    if (!((NSArray*)[dictLanguages objectForKey:KEY_VALUE]).count) {
        [arr addObject:@"Languages"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[self.cellsArr indexOfObject:[NSNumber numberWithInteger:LANGUAGES]]]];
        
    }
    
    
    return arr;
}

-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}

- (void)saveButtonTapped:(id)sender{
    [self.view endEditing:YES];
    [self onSave:nil];
}


-(NSMutableDictionary*)getParametersInDictionary{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *dob1 = [NGDateManager getDateFromLongStyle:dob];
    [params setCustomObject:dob1 forKey:@"dateOfBirth"];
    
    gender = @"Male";
    if (selectedGenderIndex==2) {
        gender = @"Female";
    }
    [params setCustomObject:gender forKey:@"gender"];
    
    dl = @"n";
    if (selectedDLIndex==1) {
        dl = @"y";
        NSString *dlCountry = [dictDLCountry objectForKey:KEY_ID];
        if (dlCountry)
            [params setCustomObject:dlCountry forKey:@"drivingLicenseCountry"];
        else
            [params setCustomObject:@"" forKey:@"drivingLicenseCountry"];
        
        
    }
    [params setCustomObject:dl forKey:@"drivingLicense"];
    
    NSArray *ddNameArr = [NSArray arrayWithObjects:@"nationality",@"religion",@"maritalStatus", nil];
    
    for (NSInteger i = 0; i<ddNameArr.count; i++) {
        NSString *ddName = [ddNameArr fetchObjectAtIndex:i];
        
        
        NSString* selectedId = @"";
        switch (i) {
            case 0:
                selectedId = [dictNationality objectForKey:KEY_ID];
                break;
                
            case 1:
                selectedId = [dictReligion objectForKey:KEY_ID];
                break;
                
            case 2:
                selectedId = [dictMaritalStatus objectForKey:KEY_ID];
                break;
                
            default:
                break;
        }
        
        
        
        if (i==1) {
            if (selectedId) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setCustomObject:selectedId forKey:@"id"];
                NSString *other = @"Other";
                [dict setCustomObject:other forKey:@"other"];
                [dict setCustomObject:other forKey:@"otherEN"];
                [params setCustomObject:dict forKey:ddName];
            }
            else
                [params setCustomObject:@"" forKey:ddName];
            
            
        }else{
            if (selectedId)
                [params setCustomObject:selectedId forKey:ddName];
            else
                [params setCustomObject:@"" forKey:ddName];
            
        }
        
    }
    
    
    NSArray *idArr = [dictLanguages objectForKey:KEY_ID];
    
    if (idArr && idArr.count>0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setCustomObject:idArr forKey:@"id"];
        
        [params setCustomObject:[NSString getStringsFromArrayWithoutSpace:idArr] forKey:@"languagesKnown"];
    }else{
        [params setCustomObject:@"" forKey:@"languagesKnown"];
    }
    
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    return params;

}
-(void)onSave:(id)sender{
    
    NSString *errorTitle;
    [self.view endEditing:YES];
    [errorCellArr removeAllObjects];
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
        
        
        __weak NGEditPersonalDetailsViewController *weakSelf = self;
        
        NSMutableDictionary *params =[self updateTheRequestParameterForSendingInitialValueOfChanges:[self getParametersInDictionary]];

        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (responseInfo.isSuccess) {
                    [weakSelf hideAnimator];
                    [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                    [weakSelf.editDelegate editedPersonalDetailsWithSuccess:YES];
                    weakSelf.isRequestInProcessing= FALSE;
                }else{
                    [weakSelf hideAnimator];
                    weakSelf.isRequestInProcessing= FALSE;
                }
                
            });
            
            
        }];
        
        
    }
    
}


/**
 *  Method on trigger adds NSMutableDictionary containig custom objects in allDatePickerParams
 */

-(void)setAllDatePickers {
    //// Date of Birth
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:[NSNumber numberWithInteger:DATE_OF_BIRTH] forKey:@"ID"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayMonth"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayDay"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayYear"];
    [dict setCustomObject:@"Date of Birth" forKey:@"Header"];
    
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:-80]] forKey:@"MinYear"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:-14]] forKey:@"MaxYear"];
    
    [self.allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%ld",(long)DATE_OF_BIRTH]];
    
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
            
        case DDC_NATIONALITY:{
            
            if (arrSelectedIds.count >0) {
                [dictNationality setCustomObject:[arrSelectedIds firstObject]  forKey:KEY_ID];
                [dictNationality setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            }else{
                [dictNationality setCustomObject:@""  forKey:KEY_ID];
                [dictNationality setCustomObject:@"" forKey:KEY_VALUE];
            }
            break;
        }
            
        case DDC_RELIGION:{
            
            if (arrSelectedIds.count >0) {
                [dictReligion setCustomObject:[arrSelectedIds firstObject]  forKey:KEY_ID];
                [dictReligion setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            }else{
                [dictReligion setCustomObject:@""  forKey:KEY_ID];
                [dictReligion setCustomObject:@"" forKey:KEY_VALUE];
            }
            break;
        }
            
            
        case DDC_MARITAL_STATUS:{
            if (arrSelectedIds.count >0) {
                [dictMaritalStatus setCustomObject:[arrSelectedIds firstObject]  forKey:KEY_ID];
                [dictMaritalStatus setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            }else{
                [dictMaritalStatus setCustomObject:@""  forKey:KEY_ID];
                [dictMaritalStatus setCustomObject:@"" forKey:KEY_VALUE];
            }
            break;
        }
            
        case DDC_COUNTRY:{
            
            if (arrSelectedIds.count >0) {
                [dictDLCountry setCustomObject:[arrSelectedIds firstObject]  forKey:KEY_ID];
                [dictDLCountry setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            }else{
                [dictDLCountry setCustomObject:@""  forKey:KEY_ID];
                [dictDLCountry setCustomObject:@"" forKey:KEY_VALUE];
            }
            break;
        }
            
        case DDC_LANGUAGE:{
            
            if (arrSelectedIds.count >0) {
                [dictLanguages setCustomObject:arrSelectedIds   forKey:KEY_ID];
                [dictLanguages setCustomObject:arrSelectedValues  forKey:KEY_VALUE];
            }else{
                
                [dictLanguages setCustomObject:[NSArray array] forKey:KEY_ID];
                [dictLanguages setCustomObject:[NSArray array] forKey:KEY_VALUE];
            }

            
            break;
        }
            
        default:
            break;
    }
    
    [self.editTableView reloadData];
}

/**
 *  a Method used for returning the array which contains the value for idKey
 *
 *  @param selectedArr array containing selected objects
 *  @param dataArr     array containing all objects
 *  @param idkey       key used for fetching the object from the Dctionary
 *  @param valueKey    key used  for getting the object from dataArr
 *
 *  @return NSArray 
 */
-(NSArray *)getIDsForSelectedValues:(NSArray *)selectedArr inContents:(NSArray *)dataArr withIDKey:(NSString *)idkey valueKey:(NSString *)valueKey{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i<dataArr.count; i++) {
        NSDictionary *dict = [dataArr fetchObjectAtIndex:i];
        NSString *value = [dict objectForKey:valueKey];
        if ([selectedArr containsObject:value]) {
            [arr addObject:[dict objectForKey:idkey]];
        }
    }
    
    return arr;
}


#pragma mark - Public 
/**
 *  @name Public Method
 */
/**
 *  Method triggered when the view appears, and update the textField with NGMNJProfileModalClass object
 *
 *  @param obj NGMNJProfileModalClass
 */
-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj{
   
    self.modalClassObj = obj;
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (0>=[vManager validateValue:self.modalClassObj.dateOfBirth withType:ValidationTypeDate].count) {
        dob = [NGDateManager getDateInLongStyle:self.modalClassObj.dateOfBirth];
        
        NSMutableDictionary *dict = [self.allDatePickerParams objectForKey:[NSString stringWithFormat:@"%ld",(long)DATE_OF_BIRTH]];
        
        [dict setCustomObject:dob forKey:@"SelectedDate"];

        [self.allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%ld",(long)DATE_OF_BIRTH]];
    }
    
    
    
    if ([self.modalClassObj.gender isEqualToString:@"Male"]) {
        selectedGenderIndex = 1;
    }else{
        selectedGenderIndex = 2;
    }
    
    [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInteger:DDC_NATIONALITY],K_DROPDOWN_TYPE,
                        [NSArray arrayWithObjects:[self.modalClassObj.nationality objectForKey:KEY_VALUE], nil], K_DROPDOWN_SELECTEDVALUES,
                        [NSArray arrayWithObjects:[self.modalClassObj.nationality objectForKey:KEY_ID],nil], K_DROPDOWN_SELECTEDIDS,
                               nil]];
    
    [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:DDC_RELIGION],K_DROPDOWN_TYPE,
                            [NSArray arrayWithObjects:[self.modalClassObj.religion objectForKey:KEY_VALUE], nil], K_DROPDOWN_SELECTEDVALUES,
                               [NSArray arrayWithObjects:[self.modalClassObj.religion objectForKey:KEY_ID], nil], K_DROPDOWN_SELECTEDIDS,
                               nil]];
    
    [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:DDC_MARITAL_STATUS],K_DROPDOWN_TYPE,[NSArray arrayWithObjects:[self.modalClassObj.maritalStatus objectForKey:KEY_VALUE], nil], K_DROPDOWN_SELECTEDVALUES,
                               [NSArray arrayWithObjects:[self.modalClassObj.maritalStatus objectForKey:KEY_ID], nil], K_DROPDOWN_SELECTEDIDS,
                               nil]];
    
    if ([self.modalClassObj.dlStr isEqualToString:@"n"]) {
        selectedDLIndex = 2;
    }else{
        selectedDLIndex = 1;
    }
    
    [self cellSegmentClicked:selectedDLIndex ofRow:DRIVING_LICENSE];
    
    [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:DDC_COUNTRY],K_DROPDOWN_TYPE,
                            [NSArray arrayWithObjects:[self.modalClassObj.dlCountry objectForKey:KEY_VALUE], nil], K_DROPDOWN_SELECTEDVALUES,
                               [NSArray arrayWithObjects:[self.modalClassObj.dlCountry objectForKey:KEY_ID], nil], K_DROPDOWN_SELECTEDIDS,
                               nil]];
    
    NSString* langStr = [self.modalClassObj.languagesKnown objectForKey:KEY_VALUE];
     if(0>=[vManager validateValue:langStr withType:ValidationTypeString].count)
     {
         langStr = [langStr stringByReplacingOccurrencesOfString:@" " withString:@""];
         NSArray* knownLangArray = [langStr componentsSeparatedByString:@","];
         NSString* languageId = [self.modalClassObj.languagesKnown objectForKey:KEY_ID];
         languageId = [languageId stringByReplacingOccurrencesOfString:@" " withString:@""];
         NSArray* knownLangIdArray = [languageId componentsSeparatedByString:@","];

         [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:DDC_LANGUAGE],K_DROPDOWN_TYPE,
                                    knownLangArray, K_DROPDOWN_SELECTEDVALUES,
                                    knownLangIdArray, K_DROPDOWN_SELECTEDIDS,
                                    nil]];

     }
    
    [self.editTableView reloadData];
}

#pragma mark UITableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cellsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    enum CellType type = [[self.cellsArr objectAtIndex:indexPath.row]integerValue];
    
    
    switch (type) {
        case DATE_OF_BIRTH:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_PERSONAL_DETAILS;
            cell.delegate = self;
            
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            cell.otherDataStr = nil;
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:dob forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            return cell;
            break;
        }
            
        case GENDER:{
            NSString* cellIndentifier = @"EditProfileSegmentedCell";
            
            NGEditProfileSegmentedCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            cell.delegate = self;
            
            NSMutableArray* arrTitles = [[NSMutableArray alloc] initWithObjects:
                                         @"Male",@"Female", nil];
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            cell.iSelectedButton = selectedGenderIndex;
            cell.rowIndex = GENDER;
            [dictToPass setCustomObject:@"Gender" forKey:K_KEY_EDIT_PLACEHOLDER];
            [dictToPass setCustomObject:arrTitles forKey:K_KEY_EDIT_TITLE];
            [cell configureEditProfileSegmentedCell:dictToPass];
            dictToPass = nil;
            return cell;
            break;
        }
            
        case NATIONALITY:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_PERSONAL_DETAILS;
            cell.delegate = self;
            
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            cell.otherDataStr = nil;
            
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictNationality objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            return cell;
            break;
        }
            
        case RELIGION:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_PERSONAL_DETAILS;
            cell.delegate = self;
            
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            cell.otherDataStr = nil;
            
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictReligion objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            return cell;
            break;
        }
            
        case MARITAL_STATUS:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_PERSONAL_DETAILS;
            cell.delegate = self;
            
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            cell.otherDataStr = nil;
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictMaritalStatus objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            return cell;
            break;
        }
            
        case DRIVING_LICENSE:{
            NSString* cellIndentifier = @"EditProfileSegmentedCell";
            
            NGEditProfileSegmentedCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            cell.delegate = self;
            
            NSMutableArray* arrTitles = [[NSMutableArray alloc] initWithObjects:
                                         @"Yes",@"No", nil];
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            cell.iSelectedButton = selectedDLIndex;
            cell.rowIndex = DRIVING_LICENSE;
            [dictToPass setCustomObject:@"Driving License" forKey:K_KEY_EDIT_PLACEHOLDER];
            [dictToPass setCustomObject:arrTitles forKey:K_KEY_EDIT_TITLE];
            [cell configureEditProfileSegmentedCell:dictToPass];
            dictToPass = nil;
            return cell;
            break;
        }
            
        case DRIVING_LICENSE_LOCATION:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_PERSONAL_DETAILS;
            cell.delegate = self;
            
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            cell.otherDataStr = nil;
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictDLCountry objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            return cell;
            break;
        }
            
        case LANGUAGES:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_PERSONAL_DETAILS;
            cell.delegate = self;
            
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            cell.otherDataStr = nil;
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[NSString getStringsFromArray:
                                         [dictLanguages objectForKey:KEY_VALUE]] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            return cell;
            break;
        }
        default:
            break;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    enum CellType type = [[self.cellsArr objectAtIndex:indexPath.row]integerValue];
    
    switch (type) {
        case GENDER:
            return 95;
            break;
            
        case DRIVING_LICENSE:
            return 95;
            break;
            
        default:
            return 75;
            break;
    }
    
    return 75;
}

#pragma mark button delegate methods

-(void)cellSegmentClicked:(NSInteger)selectedSegmentIndex ofRow:(NSInteger)rowNumber{
    
    
    switch (rowNumber) {
            
        case GENDER: {
            
            selectedGenderIndex = selectedSegmentIndex;
            
            break;
        }
            
        case DRIVING_LICENSE: {
            
            selectedDLIndex = selectedSegmentIndex;
            
            NSInteger index = [self.cellsArr indexOfObject:[NSNumber numberWithInteger:DRIVING_LICENSE]];
            NSInteger indexOfLoc = [self.cellsArr indexOfObject:[NSNumber numberWithInteger:DRIVING_LICENSE_LOCATION]];
            
            if (selectedDLIndex==1) {
                if (indexOfLoc==NSNotFound) {
                    [self.cellsArr insertObject:[NSNumber numberWithInteger:DRIVING_LICENSE_LOCATION] atIndex:index+1];
                    [self.editTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index+1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            }else{
                if (indexOfLoc!=NSNotFound) {
                    [self.cellsArr removeObject:[NSNumber numberWithInteger:DRIVING_LICENSE_LOCATION]];
                    
                    [self.editTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index+1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            }
            
            
            break;
        }
            
        default:
            break;
    }
    
    [self.editTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    enum CellType type = [[self.cellsArr objectAtIndex:indexPath.row]integerValue];
    
    switch (type) {
            
        case DATE_OF_BIRTH:{
            
            if(!datePicker){
                datePicker = [[NGCalenderPickerView alloc]initWithNibName:nil bundle:nil];
            }
            [APPDELEGATE.container setRightMenuViewController:datePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            datePicker.delegate = self;
            NSInteger currentYear = [[NGDateManager getCurrentDateComponents]year];

            NSInteger minusFourtyYearBack = currentYear-40;
            
            NSString *selectedDOB = dob;
            if(!selectedDOB)
                selectedDOB = [NSString stringWithFormat:@"January 1,%ld",(long)minusFourtyYearBack];
            datePicker.selectedValue = selectedDOB;
            datePicker.selectedValue = selectedDOB;
            
            datePicker.headerTitle = @"Date of Birth";
            datePicker.delegate = self;
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
           
        case NATIONALITY:
        case RELIGION:
        case MARITAL_STATUS:
        case DRIVING_LICENSE_LOCATION:
        case LANGUAGES:{
            ValidatorManager *vManager = [ValidatorManager sharedInstance];
            isValueSelectorExist = YES;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            
            if (type == NATIONALITY) {
                if(0>=[vManager validateValue:[dictNationality objectForKey:KEY_ID] withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[dictNationality objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                _valueSelector.dropdownType = DDC_NATIONALITY;
                [_valueSelector displayDropdownData];
            }
            else if (type == RELIGION) {
                if(0>=[vManager validateValue:[dictReligion objectForKey:KEY_ID] withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[dictReligion objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                _valueSelector.dropdownType = DDC_RELIGION;
                [_valueSelector displayDropdownData];
            }
            else if (type == MARITAL_STATUS) {
                if(0>=[vManager validateValue:[dictMaritalStatus objectForKey:KEY_ID] withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[dictMaritalStatus objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                _valueSelector.dropdownType = DDC_MARITAL_STATUS;
                [_valueSelector displayDropdownData];
            }
            else if (type == DRIVING_LICENSE_LOCATION) {
                
                if(0>=[vManager validateValue:[dictDLCountry objectForKey:KEY_ID] withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[dictDLCountry objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                _valueSelector.dropdownType = DDC_COUNTRY;
                [_valueSelector displayDropdownData];
            }
            else if (type == LANGUAGES) {
                if(0>=[vManager validateValue:[dictLanguages objectForKey:KEY_ID] withType:ValidationTypeArray].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithArray:[dictLanguages objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                _valueSelector.dropdownType = DDC_LANGUAGE;
                [_valueSelector displayDropdownData];
            }

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
            
            break;
        }
            
        default:
            break;
    }
    
}

@end
