//
//  NGEditBasicDetailsViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 06/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.edotwork
//

#import "NGEditBasicDetailsViewController.h"
#import "NGValueSelectionResponseModal.h"
#import "NGValueSelectionRequestModal.h"
#import "DDExpYear.h"
#import "DDExpMonth.h"
#import "DDSalaryRange.h"
#import "DDWorkStatus.h"
#import "DDCountry.h"
#import "DDCity.h"
#import "DDCurrency.h"

typedef enum{
    BasicDetailsTagName = 1,
    BasicDetailsTagDesignation,
    BasicDetailsTagLocation,
    BasicDetailsTagOtherLocation,
    BasicDetailsTagVisaStatus,
    BasicDetailsTagVisaDate,
    BasicDetailsTagExperience,
    BasicDetailsTagSalary,
    BasicDetailsTagCurrency
}BasicDetailsTag;

@interface NGEditBasicDetailsViewController ()<ProfileEditCellDelegate>{
    
    
    NGCalenderPickerView *valuePicker; // a Controller class for displaying in right side of panel
    BOOL isPickerExist; //    Check isPickerExist on right side of panel
    
    BOOL isValueSelectorExist; // Check isValueSelectorExist on right side of panel
    
    NSDictionary* selectedExpOfYears;
    NSDictionary* selectedExpOfMonths;
    
    NSString *salary;
    NSMutableDictionary *selectedCurrency;
    
    NSString* name;
    NSString* designation;
    
    NSMutableDictionary *selectedCountry;
    NSMutableDictionary *selectedCity;
    
    NSString* otherCity;
    NSString* visaDate;
    NSDictionary* selectedVisaStatus;
    
    BOOL isVisaDateEnabled;
    
    NGAppDelegate *appDelegate;
    
    NGCustomPickerModel *pickerModel;
    
    
    BOOL isCalenderExist; //    Check isCalenderExist on right side of panel
    
    NSMutableArray *countryAndCityModalArr;
    
    NSMutableDictionary *dicOfRowsForCellsValue;
    
    UIColor *disabedTextColor;
    
    NGCalenderPickerView *datePicker;// a Controller class for displaying Dates, Months and Years in right side of panel
    
    BOOL isInitialParamDictUpdated;

    
}

/**
 *   dictionary contains objects for Visa key
 */
@property (strong, nonatomic) NSMutableDictionary *allDatePickerParams;
/**
 *  a Custom animation appears on loading services
 */
@property (strong, nonatomic) NGLoader* loader;
/**
 *   A Boolean value , if Yes shows a textField beneath city textField with * Enter Other Location * placeHolder
 */
@property (nonatomic) BOOL isOtherCityType;

@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side


@end

@implementation NGEditBasicDetailsViewController

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];

    appDelegate = APPDELEGATE;
    
    isCalenderExist         =   NO;
    isValueSelectorExist    =   NO;
    
    [self customizeNavBarWithTitle:@"Basic Details"];
    CGFloat colorCode = 164.0/255.0;
    disabedTextColor = [UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f];
    
    [self.editTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.editTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    if (!countryAndCityModalArr){
        countryAndCityModalArr = [[NSMutableArray alloc] init];
    }
    
    dicOfRowsForCellsValue = [NSMutableDictionary new];
    self.allDatePickerParams = [[NSMutableDictionary alloc]init];
 
    
    [self setAllDatePickers];
    [self setAllCountryAndCityModals];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setAllCountryAndCityModals)
                                                 name:DropDownServerUpdate object:nil];
    
    
    
    
    
    isInitialParamDictUpdated = NO;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [NGHelper sharedInstance].appState = APP_STATE_EDIT_FLOW;
    [super viewDidAppear:animated];
    [self setAutomationLabel];
    [self updateInitialParams];

}
-(void)viewWillAppear:(BOOL)animated
{
    if(self.isSwipePopDuringTransition)
        return;

    [super viewWillAppear:animated];
    [NGDecisionUtility checkNetworkStatus];

}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.loader isLoaderAvail]) {
        [self.loader hideAnimatior:self.view];
    }
}

#pragma mark - Update Initial Params
-(void)updateInitialParams{
    if(!isInitialParamDictUpdated){
        self.initialParamDict  = [self getParametersInDictionary];
        isInitialParamDictUpdated = YES;
    }
}
#pragma mark - Memory Management
- (void)dealloc {
    //[self releaseMemory];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)releaseMemory {
    
    [super releaseMemory];
    
    self.loader = nil;
    
    self.modalClassObj = nil;
    
  
    
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
    
    selectedVisaStatus = nil;
    selectedCity = nil;
    selectedCountry = nil;
    otherCity = nil;
    selectedExpOfYears = nil;
    selectedExpOfMonths = nil;
    selectedCurrency = nil;
    
}

-(void)setAutomationLabel{

    [UIAutomationHelper setAccessibiltyLabel:@"editBasicDetail_table" forUIElement:self.editTableView withAccessibilityEnabled:NO];
    

}
#pragma mark -
#pragma mark TextField delegate

- (void)textFieldDidStartEditing:(UITextField *)textField havingIndex:(NSInteger)index
{
    if(textField.tag == BasicDetailsTagOtherLocation)
    {
        [self.editTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES
         ];
    }
    else if (textField.tag == BasicDetailsTagSalary)
    {
        [self.editTableView setContentOffset:CGPointMake(0.0, self.editTableView.contentOffset.y + 260.0) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    [self setValuesViaTextField:textField];
    
    if(textField.tag == BasicDetailsTagSalary)
    {
        [self.editTableView setContentOffset:CGPointMake(0.0, self.editTableView.contentOffset.y - 260.0) animated:YES];

    }
}
- (void)textFieldDidReturn:(UITextField *)textField forIndex:(NSInteger)index{
    [self setValuesViaTextField:textField];
    [textField resignFirstResponder];
}
- (void)setValuesViaTextField:(UITextField*)paramTextField{
    if (BasicDetailsTagName == [paramTextField tag]) {
        name = [paramTextField text];
    }else if (BasicDetailsTagSalary == [paramTextField tag]) {
        salary = [paramTextField text];
    }else if (BasicDetailsTagOtherLocation == [paramTextField tag]){
        otherCity = [paramTextField text];
        if (_isOtherCityType) {
            [self setOtherCityDetailsViaCityValue:[selectedCity objectForKey:KEY_VALUE] AndSubValue:otherCity];
        }
    }else{
        //dummy
    }
}

/**
 *  Method is called on pressing the save Button and initiate a service request for saving this information to server.
 *
 *  @param sender NGButton
 */
-(void)staticTapped:(id)sender {
    [self.view endEditing:YES];
    
    NSMutableArray* arrValidations = [self checkAllValidations];
    if([arrValidations count] >0){
        [self handleErrorInValidation:arrValidations];
    }
    else{
        if (!self.isRequestInProcessing) {
            [self setIsRequestInProcessing:YES];
            [self sendGoogleAnalyticEvent];
            [self hitServiceOfProfileUpdate];
        }
    }
}

- (NSMutableArray*)checkAllValidations{
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (0 < [vManager validateValue:name withType:ValidationTypeString].count){
        [arr addObject:@"Name cannot be blank"];
        [self setItem:BasicDetailsTagName InErrorCollectionWithActionAdd:YES];
    }
    

    if (0 < [vManager validateValue:[selectedCountry objectForKey:KEY_VALUE] withType:ValidationTypeString].count && 0 < [vManager validateValue:[selectedCity objectForKey:KEY_VALUE] withType:ValidationTypeString].count){
        
        [arr addObject:@"Location cannot be blank"];
        [self setItem:BasicDetailsTagLocation InErrorCollectionWithActionAdd:YES];
    }
    if (0 < [vManager validateValue:salary withType:ValidationTypeString].count){
        [arr addObject:@"Salary cannot be blank"];
        [self setItem:BasicDetailsTagSalary InErrorCollectionWithActionAdd:YES];
    }
    if (_isOtherCityType) {
        
        if ([otherCity isEqualToString:@""]){
            [arr addObject:@"Other Location city cannot be blank"];
            [self setItem:BasicDetailsTagOtherLocation InErrorCollectionWithActionAdd:YES];
        }
        
    }
    
    
    if (0 < [vManager validateValue:[selectedVisaStatus objectForKey:KEY_VALUE] withType:ValidationTypeString].count){
        
        [arr addObject:@"Visa status cannot be blank"];
        [self setItem:BasicDetailsTagVisaStatus InErrorCollectionWithActionAdd:YES];
    }
    if (isVisaDateEnabled && 0 < [vManager validateValue:visaDate withType:ValidationTypeString].count) {
        [arr addObject:@"Visa Expiracy date cannot be blank"];
        [self setItem:BasicDetailsTagVisaDate InErrorCollectionWithActionAdd:YES];
    }
    
    if (0 < [vManager validateValue:[selectedExpOfYears objectForKey:KEY_VALUE] withType:ValidationTypeString].count && 0 < [vManager validateValue:[selectedExpOfMonths objectForKey:KEY_VALUE] withType:ValidationTypeString].count){
        
        [arr addObject:@"Experience cannot be blank"];
        [self setItem:BasicDetailsTagExperience InErrorCollectionWithActionAdd:YES];
    }

    
    if (0 < [vManager validateValue:[selectedCurrency objectForKey:KEY_VALUE] withType:ValidationTypeString].count){
        
        [arr addObject:@"Currency cannot be blank"];
        [self setItem:BasicDetailsTagCurrency InErrorCollectionWithActionAdd:YES];
    }
    
    
    if([arr count]>3){
        for (int i =3; i< [arr count]; i++)[arr removeObjectAtIndex:i];
    }
    
    [self.editTableView reloadData];
    
    return arr;
}
-(void)sendGoogleAnalyticEvent{
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EDIT_PROFILE withEventLabel:K_GA_EVENT_EDIT_PROFILE withEventValue:nil];

}
-(void)handleErrorInValidation:(NSMutableArray*)arrValidations{
    
    NSString * errorMessage = @"";

    for (int i = 0; i< [arrValidations count]; i++) {
        
        if (i == [arrValidations count]-1)
            errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@",
                                                                  [arrValidations fetchObjectAtIndex:i]]];
        else
            errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@, ",
                                                                  [arrValidations fetchObjectAtIndex:i]]];
    }
    
    NSRange commaRange = [errorMessage rangeOfString:@"," options:NSBackwardsSearch];
    if (NSNotFound != commaRange.location) {
        NSString *firstHalfPart = [errorMessage substringToIndex:commaRange.location];
        NSString *secondHalfPart = [errorMessage substringFromIndex:commaRange.location+2];
        errorMessage = [NSString stringWithFormat:@"%@ and %@",firstHalfPart,secondHalfPart];
        firstHalfPart = secondHalfPart = nil;
    }
    
    NSString *msgHeader = @"Incomplete Details!";
    if ([arrValidations containsObject:K_ERROR_MESSAGE_SPECIAL_CHARACTER]) {
        msgHeader = @"Invalid Details!";
    }
    
    [NGUIUtility showAlertWithTitle:msgHeader withMessage:
     [NSArray arrayWithObjects:errorMessage, nil]
                   withButtonsTitle:@"OK" withDelegate:nil];
    [self setIsRequestInProcessing:NO];
    msgHeader = nil;

}
-(NSMutableDictionary*)getParametersInDictionary{
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setCustomObject:[NSString stripTags:name] forKey:@"name"];
    
    NSString *countryID = @"";
    
    
    if (selectedCountry && 0>=[vManager validateValue:[selectedCountry objectForKey:KEY_ID] withType:ValidationTypeString].count) {
        countryID = [selectedCountry objectForKey:KEY_ID];
        [params setCustomObject:countryID forKey:@"country"];
    }
    
    if (selectedCity && 0>=[vManager validateValue:[selectedCity objectForKey:KEY_ID] withType:ValidationTypeString].count) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setCustomObject:[NSString stringWithFormat:@"%@.%@",countryID,[selectedCity objectForKey:KEY_ID]] forKey:@"id"];
        [dict setCustomObject:@"Other" forKey:@"other"];
        [dict setCustomObject:@"Other" forKey:@"otherEN"];
        
        if (_isOtherCityType) {
            [dict setCustomObject:@"Other" forKey:@"other"];
            [dict setCustomObject:[NSString stripTags:otherCity] forKey:@"otherEN"];
        }
        
        [params setCustomObject:dict forKey:@"city"];
    }
    
    if (0>=[vManager validateValue:[selectedVisaStatus objectForKey:KEY_ID] withType:ValidationTypeString].count) {
        [params setCustomObject:[selectedVisaStatus objectForKey:KEY_ID] forKey:@"visaStatus"];
    }else{
        [params setCustomObject:@"0" forKey:@"visaStatus"];
    }
    
    
    if (visaDate) {
        [params setCustomObject:[NGDateManager getDateFromMonthYear:visaDate] forKey:@"visaExpiryDate"];
    }else{
        [params setCustomObject:@"" forKey:@"visaExpiryDate"];
    }
    
    BOOL isThirtyPlus = NO;
    if (0>=[vManager validateValue:[selectedExpOfYears objectForKey:KEY_ID] withType:ValidationTypeString].count) {
        NSString *experience = [selectedExpOfYears objectForKey:KEY_ID];
        [params setCustomObject:experience forKey:@"totalExperienceYears"];
        isThirtyPlus = [experience isEqualToString:@"30plus"] ? YES : NO;
    }
    
    if (0>=[vManager validateValue:[selectedExpOfMonths objectForKey:KEY_ID] withType:ValidationTypeString].count) {
        NSString *monthExp = @"";
        @try{
            monthExp = 0 < [[selectedExpOfMonths objectForKey:KEY_ID] integerValue]?[selectedExpOfMonths objectForKey:KEY_ID]:@"";
        }@catch(NSException *ex){
            monthExp = @"";
        }
        
        [params setCustomObject:monthExp forKey:@"totalExperienceMonths"];
    }else{
        if (!isThirtyPlus) {
            [params setCustomObject:@"" forKey:@"totalExperienceMonths"];
        }
    }
    
    [params setCustomObject:[NSString stripTags:salary] forKey:@"salary"];
    if (0>=[vManager validateValue:[selectedCurrency objectForKey:KEY_ID] withType:ValidationTypeString].count) {
        [params setCustomObject:[selectedCurrency objectForKey:KEY_ID] forKey:@"currency"];
    }
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    
    vManager = nil;

    return params;

}
-(void)hitServiceOfProfileUpdate{
    
    self.loader = [[NGLoader alloc] initWithFrame:self.view.frame];
    [self.loader showAnimation:self.view];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    __weak NGEditBasicDetailsViewController *weakSelf = self;
    
    NSMutableDictionary *params =[self updateTheRequestParameterForSendingInitialValueOfChanges:[self getParametersInDictionary]];

    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.loader hideAnimatior:weakSelf.view];
        });
        
        if (responseInfo.isSuccess) {
            NSDictionary* responseDataDict = (NSDictionary*)responseInfo.parsedResponseData;
            NSString *statusStr = [responseDataDict objectForKey:KEY_UPDATE_RESUME_STATUS];
            if ([statusStr isEqualToString:KEY_SUCCESS_RESPONSE]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.editDelegate respondsToSelector:@selector(editedBasicDetailsWithSuccess:)]) {
                        [weakSelf.editDelegate editedBasicDetailsWithSuccess:YES];
                    }
                    
                    [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                });
                
            }
            [weakSelf setIsRequestInProcessing:NO];
        }else{
            [weakSelf setIsRequestInProcessing:NO];
        }
    }];


}
/**
 *   a Date Picker View appears on right side on editing the Visa textField
 */
-(void)setAllDatePickers {
    
    //// Date Picker Visa Date
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:[NSNumber numberWithInteger:BasicDetailsTagVisaDate] forKey:@"ID"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayMonth"];
    [dict setCustomObject:[NSNumber numberWithBool:FALSE] forKey:@"DisplayDay"];
    [dict setCustomObject:[NSNumber numberWithBool:TRUE] forKey:@"DisplayYear"];
    [dict setCustomObject:@"Visa Valid Till" forKey:@"Header"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:-10]] forKey:@"MinYear"];
    [dict setCustomObject:[NSNumber numberWithInteger:[NGDateManager yearsFromCurrentYearWithValue:20]] forKey:@"MaxYear"];
    [self.allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",BasicDetailsTagVisaDate]];
}
/**
 *   a Country and their city modal array for layered View appears on right side on editing the country and city
 */
-(void)setAllCountryAndCityModals{
    
    NSArray *countryAndCityArr = [NSMutableArray arrayWithArray:
                                [NGDatabaseHelper getSortedDataWhereKey:DROPDOWN_SORTED_ID andClass:[DDCountry class]]];
    if (0>=[[ValidatorManager sharedInstance] validateArray:countryAndCityArr withType:ValidationTypeArray].count) {
        
        for (DDBase* obj in countryAndCityArr){
            
            NGValueSelectionRequestModal* modal = [[NGValueSelectionRequestModal alloc] init];
            modal.value = obj.valueName;
            if ([modal.value isEqual:[NSNull null]])
                continue;
            modal.identifier = obj.valueID.stringValue;
            
            NGValueSelectionRequestModal* modalObj;
            //sort cities
            NSArray* arrCities = [NGDatabaseHelper sortArrayOfCountryCityWithOtherListAtEnd:DROPDOWN_VALUE_NAME onArray:((NSSet*)[obj valueForKey:@"cities"]).allObjects];

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
}


/**
 *   Method handle drop drown selction for Visa
 *
 *  @param responseParams  NSDictionary class
 */


-(void)handleDatePickersOnSelectionOfDate:(NSString *)date {
 
    visaDate = date;

    if(0>=[[ValidatorManager sharedInstance] validateValue:visaDate withType:ValidationTypeString].count){
        [self setItem:BasicDetailsTagVisaDate InErrorCollectionWithActionAdd:NO];
    }
}



#pragma mark - Public Method

/**
 *  @name Public Method
 */
/**
 *  Public Method initiated when  view appear and updates the textfield Values with NGMNJProfileModalClass object
 *
 *  @param obj a JsonModelObject contains predefined value for textField
 */
-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj {
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    self.modalClassObj = obj;
    
    name = self.modalClassObj.name;
    designation = _modalClassObj.currentDesignation;
    selectedCountry = [_modalClassObj.country mutableCopy];
    if (nil == selectedCountry) {
        selectedCountry = [NSMutableDictionary new];
    }
    
    selectedCity = [_modalClassObj.city mutableCopy];
    if (nil == selectedCity) {
        selectedCity = [NSMutableDictionary new];
    }
    
    [self setOtherCityDetailsViaCityValue:[selectedCity objectForKey:KEY_VALUE] AndSubValue:[selectedCity objectForKey:KEY_SUBVALUE]];
    //serve save city id like <countryid.cityid> ex:<index.other>--><80.1000>, so break this to 1000
    //and set to city id, so that our value selectors can work properly
    NSString *cityId = [selectedCity objectForKey:KEY_ID];
    if (NSNotFound != [cityId rangeOfString:@"." options:NSCaseInsensitiveSearch].location) {
        NSArray *idsArray = [cityId componentsSeparatedByString:@"."];
        if (idsArray && 2 == [idsArray count]) {
            [selectedCity setValue:[idsArray lastObject] forKey:KEY_ID];
        }
    }
    
    selectedExpOfYears = [_modalClassObj.totalExpYears mutableCopy];
    if (nil == selectedExpOfYears) {
        selectedExpOfYears = [NSMutableDictionary new];
    }
    
    selectedExpOfMonths = [_modalClassObj.totalExpMonths mutableCopy];
    if (nil == selectedExpOfMonths) {
        selectedExpOfMonths = [NSMutableDictionary new];
    }
    
    salary = self.modalClassObj.salary;
    selectedCurrency = [_modalClassObj.currency mutableCopy];
    if (nil == selectedCurrency) {
        selectedCurrency = [NSMutableDictionary new];
    }
    
    visaDate = self.modalClassObj.visaExpiryDate;
    selectedVisaStatus = [self.modalClassObj.visaStatus mutableCopy];
    if (nil == selectedVisaStatus) {
        selectedVisaStatus = [NSMutableDictionary new];
    }

    if (0<[vManager validateValue:[selectedVisaStatus objectForKey:KEY_VALUE] withType:ValidationTypeString].count || 0<[vManager validateValue:visaDate withType:ValidationTypeString].count) {
        isVisaDateEnabled = NO;
    }
 
    
    if (0>=[vManager validateValue:[selectedVisaStatus objectForKey:KEY_ID] withType:ValidationTypeString].count) {
        
        [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:DDC_WORK_STATUS],K_DROPDOWN_TYPE,
            [NSArray arrayWithObjects:[self.modalClassObj.visaStatus objectForKey:KEY_ID], nil], K_DROPDOWN_SELECTEDIDS,[NSArray arrayWithObjects:[self.modalClassObj.visaStatus objectForKey:KEY_VALUE], nil],K_DROPDOWN_SELECTEDVALUES, nil]];
    }
    
    if (0>=[vManager validateValue:visaDate withType:ValidationTypeDate].count) {
        visaDate = [NGDateManager formatDateInMonthYear:visaDate];
        
        NSMutableDictionary *dict = [self.allDatePickerParams objectForKey:[NSString stringWithFormat:@"%d",BasicDetailsTagVisaDate]];
        
        [dict setCustomObject:visaDate forKey:@"SelectedDate"];
        
        [self.allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",BasicDetailsTagVisaDate]];
    }
    
    [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:DDC_CURRENCY],K_DROPDOWN_TYPE,[NSArray arrayWithObjects:[self.modalClassObj.currency objectForKey:KEY_ID], nil], K_DROPDOWN_SELECTEDIDS,nil]];
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
    
    NSArray *selectedIds = [NSArray arrayWithArray:[responseParams objectForKey:K_DROPDOWN_SELECTEDIDS]];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    switch (ddType) {
            
        case DDC_WORK_STATUS:{
            
            NSString *tmpVisaStatusValue = nil;
            if (0>=[vManager validateArray:selectedIds withType:ValidationTypeArray].count) {
                
                NSArray* selectedVal = [responseParams objectForKey:K_DROPDOWN_SELECTEDVALUES];
                tmpVisaStatusValue = [selectedVal firstObject];
                if(tmpVisaStatusValue != nil)
                 [selectedVisaStatus setValue:tmpVisaStatusValue forKey:KEY_VALUE];
                isVisaDateEnabled = YES;
                
                if (selectedIds) {
                    [selectedVisaStatus setValue:[selectedIds firstObject] forKey:KEY_ID];
                    //remove this cell from error array ,if present
                    [self setItem:BasicDetailsTagVisaStatus InErrorCollectionWithActionAdd:NO];
                }
                
                NSArray *visaArr = [NSArray arrayWithObjects:@"Citizen", nil];
                
                if (![visaArr containsObject:tmpVisaStatusValue] && ![tmpVisaStatusValue isEqualToString:@""])
                    isVisaDateEnabled = YES;
                else
                {
                    isVisaDateEnabled = NO;
                    visaDate = nil;
                    NSMutableDictionary *dict = [self.allDatePickerParams objectForKey:[NSString stringWithFormat:@"%d",BasicDetailsTagVisaDate]];
                    
                    [dict setCustomObject:@"" forKey:@"SelectedDate"];
                    
                    [self.allDatePickerParams setCustomObject:dict forKey:[NSString stringWithFormat:@"%d",BasicDetailsTagVisaDate]];
                }
            }else{
                
                [selectedVisaStatus setValue:@"" forKey:KEY_VALUE];
                [selectedVisaStatus setValue:@"" forKey:KEY_ID];
                
                isVisaDateEnabled = NO;
                visaDate = nil;
            }
            break;
        }
      
            
        case DDC_CURRENCY:{
            NSString *tmpSelectedCurrency = nil;
            
            if (0>=[vManager validateArray:selectedIds withType:ValidationTypeArray].count) {
                
                NSArray* selectedVal = [responseParams objectForKey:K_DROPDOWN_SELECTEDVALUES];
                tmpSelectedCurrency = [selectedVal firstObject];
                if (tmpSelectedCurrency)
                    [selectedCurrency setValue:tmpSelectedCurrency forKey:KEY_VALUE];
            }else{
                tmpSelectedCurrency = @"";
            }
            
            if (selectedIds && 0<[selectedIds count]) {
                [selectedCurrency setValue:[selectedIds firstObject] forKey:KEY_ID];
            }else{
                [selectedCurrency setValue:nil forKey:KEY_ID];
                [selectedCurrency setValue:nil forKey:KEY_VALUE];
            }
            
            break;
        }
        case DD_EDIT_EXPERIENCE:{
            //year
            NSString *tmpSelectedExpYrs = [responseParams objectForKey:
                                           K_KEY_PICKER_SELECTED_VALUE_1];
            NSArray *selectedValues = @[tmpSelectedExpYrs];
            
            
            if (selectedValues.count>0) {
                
                NSString* strId = [selectedValues firstObject];
                if ([strId isEqualToString:@"30+"])
                    strId = @"30plus";
                [selectedExpOfYears setValue:tmpSelectedExpYrs forKey:KEY_VALUE];
                [selectedExpOfYears setValue:strId forKey:KEY_ID];
            }
            
            //month
            selectedValues = nil;
            NSString *tmpSelectedExpMonths = [responseParams objectForKey:
                                              K_KEY_PICKER_SELECTED_VALUE_2];
            selectedValues = @[tmpSelectedExpMonths];
            
            if (selectedValues) {
                [selectedExpOfMonths setValue:tmpSelectedExpMonths forKey:KEY_VALUE];
                [selectedExpOfMonths setValue:[selectedValues firstObject] forKey:KEY_ID];
            }
            selectedValues = nil;
        }
            break;
        default:
            break;
    }
    
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
        
            [self handleDatePickersOnSelectionOfDate:[responseParams objectForKey:@"selectedDate"]];

        }

    }
    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    [self.editTableView reloadData];


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
        case  DD_EDIT_COUNTRY_CITY:{
            
            if (0>=[vManager validateValue:selectedModal.selectedId withType:
                    ValidationTypeString].count &&
                0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedId withType:ValidationTypeString].count &&
                0>=[vManager validateValue:selectedModal.selectedValue withType:ValidationTypeString].count &&
                0>=[vManager validateValue:selectedModal.valueSelectionResponseObj.selectedValue withType:ValidationTypeString].count)
            {
                
                [selectedCountry setValue:selectedModal.selectedId forKey:KEY_ID];//KEY_ID
                [selectedCountry setValue:selectedModal.selectedValue forKey:KEY_VALUE];
                
                [selectedCity setValue:selectedModal.valueSelectionResponseObj.selectedId forKey:KEY_ID];
                [selectedCity setValue:selectedModal.valueSelectionResponseObj.selectedValue forKey:KEY_VALUE];
                
                [self setOtherCityDetailsViaCityValue:[selectedCity objectForKey:KEY_VALUE] AndSubValue:[selectedCity objectForKey:KEY_SUBVALUE]];
                
                [self setItem:BasicDetailsTagLocation InErrorCollectionWithActionAdd:NO];
                
            }else{
                
                [selectedCountry setValue:@"" forKey:KEY_ID];
                [selectedCountry setValue:@"" forKey:KEY_VALUE];
                
                [selectedCity setValue:@"" forKey:KEY_ID];
                [selectedCity setValue:@"" forKey:KEY_VALUE];
                [selectedCity setValue:@"" forKey:KEY_SUBVALUE];
                
                _isOtherCityType = NO;
                otherCity = nil;
            }
        }
            break;
        default:
            break;
    }
    vManager = nil;

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    [self.editTableView reloadData];
}

#pragma mark - JobManager Delegate
/**
 *  @name  JobManager Delegate
 */
/**
 *  a delegate methods perform actions regarding to sucess flag 
 *
 *  @param responseData NSDictionary Class
 *  @param flag         If Yes, currentview is pop out using [NGAnimator sharedInstance]
 */

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    
    NSDictionary* responseDataDict = (NSDictionary*)responseData.parsedResponseData;
    NSString *statusStr = [responseDataDict objectForKey:KEY_UPDATE_RESUME_STATUS];
    if ([statusStr isEqualToString:KEY_SUCCESS_RESPONSE]) {
        if ([self.editDelegate respondsToSelector:@selector(editedBasicDetailsWithSuccess:)]) {
            [self.editDelegate editedBasicDetailsWithSuccess:YES];
        }
        [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
    }
    [self setIsRequestInProcessing:NO];
}

-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [self.loader hideAnimatior:self.view];
    [self setIsRequestInProcessing:NO];
}


-(void)saveButtonPressed{
    [self staticTapped:nil];
}
#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowNumber = 7;
    if(isVisaDateEnabled && _isOtherCityType){
        rowNumber = 9;
    }else if (_isOtherCityType || isVisaDateEnabled){
        rowNumber = 8;
    }else{
        //dummy
    }
    
    return rowNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == [indexPath section] && 1 == [indexPath row]) {
        return 120;
    }
    
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    NSString* cellIndentifier = @"EditProfileCell";
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = K_EDIT_BASIC_DETAIL_PAGE;
    cell.delegate = self;
    
    BasicDetailsTag basicDetailTag = BasicDetailsTagName;
    
    NSInteger row = [[self indexPathToDisplayForIndexPath:indexPath] row];
    
    [cell.txtTitle setTextColor:[UIColor darkTextColor]];
    [cell.lblOtherTitle setTextColor:[UIColor darkGrayColor]];
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    cell.otherDataStr = nil;
    
    if (row == 0) {
        
        basicDetailTag = BasicDetailsTagName;
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:name forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];
        
        
    }else if (1 == row){
        
        basicDetailTag = BasicDetailsTagDesignation;
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:designation forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];

        
    }else if (2 == row){
        basicDetailTag = BasicDetailsTagLocation;
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:[self getFinalCountryAndCityString] forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];

    }if ( 3 == row) {
        
        basicDetailTag = BasicDetailsTagOtherLocation;
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:_isOtherCityType?otherCity:@"" forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.isEditable=_isOtherCityType;
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];
        

        
    }else if (4 == row){
        
        basicDetailTag = BasicDetailsTagVisaStatus;
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:[selectedVisaStatus objectForKey:KEY_VALUE] forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];

    }else if (5 == row){
        
        basicDetailTag = BasicDetailsTagVisaDate;
        
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:visaDate forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];

    }else if (6 == row){
        
        basicDetailTag = BasicDetailsTagExperience;
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:[self getFinalExperience] forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];


    }else if (7 == row){

        basicDetailTag = BasicDetailsTagSalary;
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:salary forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];

    }
    else if (8 == row){
        
        basicDetailTag = BasicDetailsTagCurrency;
        NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
        [dictToPass setCustomObject:[selectedCurrency objectForKey:KEY_VALUE] forKey:@"data"];
        [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_BASIC_DETAIL_PAGE] forKey:@"ControllerName"];
        cell.index = indexPath.row;
        [cell configureEditProfileCellWithData:dictToPass andIndex:row];
        
    }
    [dicOfRowsForCellsValue setCustomObject:[NSNumber numberWithInteger:[indexPath row]] forKey:[NSString stringWithFormat:@"%d",basicDetailTag]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //We need to hide keyboard, hence we required this
    [self.view endEditing:YES];
    
    
    NSInteger rowSelected = [[self indexPathToDisplayForIndexPath:indexPath] row];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    switch (rowSelected) {
        case 0:{
            
        }break;
            
        case 1:{
            
        }break;
            
        case 2:{
            //country+city multilayer
            NSMutableArray* dataArr;
            NSMutableArray* titleArr;
            NSInteger dropDownType;
            NSString* preSelectedId;
            NGValueSelectionResponseModal* modal;
            
            titleArr = [[NSMutableArray alloc]initWithObjects:@"Country",@"City", nil];
            dataArr = [NSMutableArray arrayWithArray:countryAndCityModalArr];
            dropDownType = DD_EDIT_COUNTRY_CITY;
            preSelectedId = [selectedCountry objectForKey:KEY_ID];
            modal = [[NGValueSelectionResponseModal alloc] init];
            modal.selectedId = [selectedCountry objectForKey:KEY_ID];
            modal.selectedValue = [selectedCountry objectForKey:KEY_VALUE];
            modal.valueSelectionResponseObj = [[NGValueSelectionResponseModal alloc] init];
            modal.valueSelectionResponseObj.selectedId = [selectedCity objectForKey:KEY_ID];
            modal.valueSelectionResponseObj.selectedValue = [selectedCity objectForKey:KEY_VALUE];
            
            
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

        }break;
            
        case 3:{
            
        }break;
            
        case 4:{
            
            //visa status
            isValueSelectorExist = YES;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            if(0>=[vManager validateValue:[selectedVisaStatus objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [selectedVisaStatus objectForKey:KEY_ID]];
            
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];
            _valueSelector.dropdownType = DDC_WORK_STATUS;
            [_valueSelector displayDropdownData];
            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];

            
        }break;
            
        case 5:{
            //visa date
            if (!isVisaDateEnabled) {
                return; //return from here is visa type do not required visa date
            }
            
            isCalenderExist = YES;
            
            
         
            if(!datePicker){
                datePicker = [[NGCalenderPickerView alloc]initWithNibName:nil bundle:nil];
            }
            [APPDELEGATE.container setRightMenuViewController:datePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;

            
            datePicker.selectedValue = visaDate?visaDate:@"";
            datePicker.headerTitle = @"Visa Valid Till";
            datePicker.delegate = self;
            datePicker.calType = NGCalenderTypeMMYYYY;
            datePicker.minYear =[NSNumber numberWithInteger:2006];
            datePicker.maxYear =[NSNumber numberWithInteger:2033];
            [datePicker refreshData];
            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
                if(datePicker.selectedValue.length==0)
                    [datePicker adjustDateInMiddle];
                
            }];
            
        }
            break;
            
        case 6:{
            //experience
            isPickerExist = YES;
            if(!valuePicker){
                valuePicker = [[NGCalenderPickerView alloc] initWithNibName:nil bundle:nil];
                
            }
            valuePicker.delegate = self;

            valuePicker.isPickerTypeValue = YES;
            valuePicker.calType = NGCalenderTypeMMYYYY;
            
            [APPDELEGATE.container setRightMenuViewController:valuePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            
            
            valuePicker.selectedValueColumn1 = (0>=[vManager validateValue:[selectedExpOfYears objectForKey:KEY_ID] withType:ValidationTypeString].count)?[selectedExpOfYears objectForKey:KEY_ID]:@"0";
            
            valuePicker.selectedValueColumn2 = (0>=[vManager validateValue:[selectedExpOfMonths objectForKey:KEY_ID] withType:ValidationTypeString].count)?[selectedExpOfMonths objectForKey:KEY_ID]:@"0";
    
            [valuePicker displayDropdownData:DD_EDIT_EXPERIENCE];
            [valuePicker refreshData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
               
            }];
            
        }
            break;
            
        case 7:{
            //Salary status
        }break;
            
        case 8:{
            //Currency type
            isValueSelectorExist = YES;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            if(0>=[vManager validateValue:[selectedCurrency objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    [selectedCurrency objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];
            
            
            _valueSelector.dropdownType = DDC_CURRENCY;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
        }break;
            
        default:
            break;
    }
    vManager = nil;
    
}

- (NSIndexPath*)indexPathToDisplayForIndexPath:(NSIndexPath*)paramIndexPath{
    if (0 == paramIndexPath.section) {
        if (isVisaDateEnabled && _isOtherCityType) {
            return paramIndexPath;
        }else if (isVisaDateEnabled && !_isOtherCityType){
            if (paramIndexPath.row > 2) {
                return ([NSIndexPath indexPathForRow:(paramIndexPath.row+1) inSection:paramIndexPath.section]);
            }
            
        }else if (!isVisaDateEnabled && _isOtherCityType){
            if (paramIndexPath.row > 4) {
                return ([NSIndexPath indexPathForRow:(paramIndexPath.row+1) inSection:paramIndexPath.section]);
            }
            
        }else if(!isVisaDateEnabled && !_isOtherCityType){
            
            switch ([paramIndexPath row]) {
                case 0 ... 2:
                    return paramIndexPath;
                    break;
                case 3:
                    return ([NSIndexPath indexPathForRow:(paramIndexPath.row+1) inSection:paramIndexPath.section]);
                    break;
                case 4://+2 becz we don't have both othercity and visa date visible
                    return ([NSIndexPath indexPathForRow:(paramIndexPath.row+2) inSection:paramIndexPath.section]);;
                    break;
                case 5:
                    return ([NSIndexPath indexPathForRow:(paramIndexPath.row+2) inSection:paramIndexPath.section]);
                    break;
                case 6:
                    return ([NSIndexPath indexPathForRow:(paramIndexPath.row+2) inSection:paramIndexPath.section]);
                    break;
                default:
                    break;
            }
            
        }else{
            //dummy
        }
        
        
        
        if (!_isOtherCityType && paramIndexPath.row > 2) {
            return ([NSIndexPath indexPathForRow:(paramIndexPath.row+1) inSection:paramIndexPath.section]);
            
        }
    }
    return paramIndexPath;
}
- (NSString*)getFinalExperience{
    
    NSString *tmpExpYear = [selectedExpOfYears objectForKey:KEY_VALUE];
    NSString *tmpExpMonth = [selectedExpOfMonths objectForKey:KEY_VALUE];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
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
        finalString = [NSString stringWithFormat:@"%@ %@, %@ %@",
                       tmpExpYear,appendString1, tmpExpMonth, appendString2];
    if ([finalString isEqualToString:@"fresher Years"] ||
        [finalString isEqualToString:@"fresher Year"] ) {
        finalString = @"0 Year";
    }
    return finalString;
}
- (NSString*)getFinalCountryAndCityString{
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    BOOL isValidString = (0>=[vManager validateValue:[selectedCountry objectForKey:KEY_VALUE] withType:ValidationTypeString].count) && [selectedCity objectForKey:KEY_VALUE];
    vManager = nil;
    return isValidString?[NSString stringWithFormat:@"%@, %@",[selectedCountry objectForKey:KEY_VALUE],[selectedCity objectForKey:KEY_VALUE]]:nil;
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
    selectionLayerVC.showSearchBar = YES;
    [[NGHelper sharedInstance].valueSelectionLayerArray removeAllObjects];
    [[NGHelper sharedInstance].valueSelectionLayerArray addObject:selectionLayerVC];
    [appDelegate.container setRightMenuViewController:selectionLayerVC];
    appDelegate.container.rightMenuPanEnabled=NO;
    [appDelegate.container toggleRightSideMenuCompletion:nil];
    
}
- (void)setOtherCityDetailsViaCityValue:(NSString*)paramCityValue AndSubValue:(NSString*)paramSubValue{
    if (NSNotFound != [paramCityValue rangeOfString:@"other" options:NSCaseInsensitiveSearch].location) {
        _isOtherCityType = YES;
        otherCity = paramSubValue;
        [self setItem:BasicDetailsTagOtherLocation InErrorCollectionWithActionAdd:NO];
    }else{
        _isOtherCityType = NO;
        otherCity = @"";
    }
    [selectedCity setValue:otherCity forKey:KEY_SUBVALUE];
}
- (NSArray*)constraintsOfChild:(UIView*)paramChildView inParent:(UIView*)paramParentView{
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:paramChildView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:paramParentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:[paramChildView frame].origin.x];
    
    NSInteger trailingConstant = [paramParentView frame].size.width - ([paramChildView frame].origin.x + [paramChildView frame].size.width);
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:paramChildView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:paramParentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:trailingConstant];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:paramChildView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:paramParentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:[paramChildView frame].origin.y];
    
    NSInteger bottomConstant = [paramParentView frame].size.height - ([paramChildView frame].origin.y + [paramChildView frame].size.height);
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:paramChildView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:paramParentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:bottomConstant];
    
    return @[leadingConstraint,trailingConstraint,topConstraint,bottomConstraint];
}
- (void)setItem:(BasicDetailsTag)paramBasicDetailsTag InErrorCollectionWithActionAdd:(BOOL)paramIsAdd{
    NSInteger rowForItem = [[dicOfRowsForCellsValue objectForKey:[NSString stringWithFormat:@"%d",paramBasicDetailsTag]] integerValue];
    if (paramIsAdd) {
        [errorCellArr addObject:[NSNumber numberWithInteger:rowForItem]];
    }else{
        [errorCellArr removeObject:[NSNumber numberWithInteger:rowForItem]];
    }
}
@end
