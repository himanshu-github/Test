    //
//  NGUnRegApplyViewController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 28/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGUnRegApplyViewController.h"
#import "NGContactDetailMobileCell.h"
#import "NGEditProfileSegmentedCell.h"
#import "NGCalenderPickerView.h"

#import "DDExpYear.h"
#import "DDExpMonth.h"

@interface NGUnRegApplyViewController ()<ProfileEditCellDelegate,ContactDetailMobileCell,ProfileEditCellSegmentDelegate,NGCalenderDelegate>{
    
    NGAppDelegate *appDelegate;
    
    NGCalenderPickerView *valuePicker;
    BOOL isPickerExist;
    
    NGCustomPickerModel *pickerModel;
    
    NSMutableDictionary *allExperiencePickerParams;
    
    BOOL isEmailRegistered;
    
    NSString *countryCode;
    NSString *mobileNumber;
    
    BOOL isViewAlreadyUplifted;
    BOOL isNeedToDownliftView;
}

@end

@implementation NGUnRegApplyViewController

- (void)viewDidLoad {
    
    [AppTracer traceStartTime:TRACER_ID_UNREG_APPLY_BASIC_DETAILS];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _applyModelObj = [[[NGStaticContentManager alloc] init] getApplyFields];
    if (_applyModelObj) {
        NSArray *contactNumberArray = [_applyModelObj.mobileNumber componentsSeparatedByString:@"+"];
        mobileNumber = [contactNumberArray fetchObjectAtIndex:0];
        countryCode = [contactNumberArray fetchObjectAtIndex:1];
        ValidatorManager *vManager = [ValidatorManager sharedInstance];
        if (0<[vManager validateValue:mobileNumber withType:ValidationTypeString].count) {
            mobileNumber = @"";
        }
        if (0<[vManager validateValue:countryCode withType:ValidationTypeString].count) {
            countryCode = @"0";
        }

        contactNumberArray = nil;
    }else{
        _applyModelObj = [[NGApplyFieldsModel alloc] init];
    }
    
    allExperiencePickerParams = [[NSMutableDictionary alloc]init];
    isEmailRegistered = NO;
    
    
    appDelegate = APPDELEGATE;
    [self addNavigationBarWithBackAndPageNumber:@"1/2" withTitle:@"Apply"];
    self.editTableView.scrollEnabled = NO;
    [self setSaveButtonTitleAs:@"Continue"];
           
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AppTracer traceEndTime:TRACER_ID_UNREG_APPLY_BASIC_DETAILS];
     [NGGoogleAnalytics sendScreenReport:K_GA_APPLAY_FORM1_UNREG_SCREEN];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSArray *contactDetail = [_applyModelObj.mobileNumber componentsSeparatedByString:@"+"];
    if (2 == [contactDetail count]) {
        countryCode = [contactDetail fetchObjectAtIndex:0];
        mobileNumber = [contactDetail fetchObjectAtIndex:1];
    }else if (1 == [contactDetail count]){
        countryCode = [contactDetail fetchObjectAtIndex:0];
        mobileNumber = @"";
    }else{
        countryCode = @"";
        mobileNumber = @"";
    }
    [NGDecisionUtility checkNetworkStatus];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [AppTracer clearLoadTime:TRACER_ID_UNREG_APPLY_BASIC_DETAILS];
}

/**
 *  Adding items in dropdown(s).
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = K_CONTACT_DEATILS_ROW_HEIGHT;
    if (ROW_TYPE_GENDER == [indexPath row]) {
        cellHeight = 95;
    }
    
    return cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    
    
    NSInteger row = [indexPath row];
    
    switch (row) {
            
        case ROW_TYPE_NAME:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_UNREG_APPLY;
            cell.delegate = self;
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:_applyModelObj.name forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY] forKey:@"ControllerName"];
            cell.index = ROW_TYPE_NAME;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            return cell;
            break;
        }
        case ROW_TYPE_EMAIL:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_UNREG_APPLY;
            cell.delegate = self;
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:_applyModelObj.emailId forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY] forKey:@"ControllerName"];
            cell.index = ROW_TYPE_EMAIL;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            return cell;
            break;
        }
        case ROW_TYPE_MOBILE_NO:{
            NSString* cellIndentifier = @"EditContactDetailMobileCell";
            NGContactDetailMobileCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];

            cell.delegate = self;
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:countryCode forKey:@"mobileCountryCode"];
            [dictToPass setCustomObject:mobileNumber forKey:@"mobileNumber"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY] forKey:@"ControllerName"];
            [cell configureMobileCellWithData:dictToPass andIndexPath:indexPath];
            
            return cell;
            break;
            
        }
        case ROW_TYPE_GENDER:{
            NSString* cellIndentifier = @"EditProfileSegmentedCell";
            NGEditProfileSegmentedCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            
            cell.delegate = self;
            NSMutableArray* arrTitles = [[NSMutableArray alloc] initWithObjects:
                                         @"Male",@"Female", nil];
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            if (_applyModelObj.gender) {
                
                if ([@"Female" isEqualToString:_applyModelObj.gender]) {
                    cell.iSelectedButton = 2;
                }else{
                    _applyModelObj.gender = @"Male";
                    cell.iSelectedButton = 1;
                }
            }else{
                _applyModelObj.gender = @"Male";
                cell.iSelectedButton = 1;
            }
            [dictToPass setCustomObject:@"Gender" forKey:K_KEY_EDIT_PLACEHOLDER];
            [dictToPass setCustomObject:arrTitles forKey:K_KEY_EDIT_TITLE];
            [cell configureEditProfileSegmentedCell:dictToPass];
            dictToPass = nil;
            return cell;
            break;
        }
            
            
        case ROW_TYPE_WORK_EXP:{
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.editModuleNumber = K_EDIT_UNREG_APPLY;
            cell.delegate = self;
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[_applyModelObj getFinalExperience] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_UNREG_APPLY] forKey:@"ControllerName"];
            cell.index = ROW_TYPE_WORK_EXP;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            return cell;
            break;
        }
            
        default:
            break;
    }

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //We need to hide keyboard, hence we required this
    [self.view endEditing:YES];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (ROW_TYPE_WORK_EXP == [indexPath row]) {
        
        //experience
        isPickerExist = YES;
        if(!valuePicker){
            valuePicker = [[NGCalenderPickerView alloc] initWithNibName:nil bundle:nil];
            valuePicker.delegate = self;
            
        }
        
        [APPDELEGATE.container setRightMenuViewController:valuePicker];
        APPDELEGATE.container.rightMenuPanEnabled = NO;
    
        NSMutableDictionary *selectedExpOfYears = [_applyModelObj.workEx objectForKey:KEY_YEAR_DICTIONARY];
        NSMutableDictionary *selectedExpOfMonths = [_applyModelObj.workEx objectForKey:KEY_MONTH_DICTIONARY];
        
        
        valuePicker.calType = NGCalenderTypeMMYYYY;
        valuePicker.isPickerTypeValue = YES;
       
        valuePicker.selectedValueColumn1 = (0>=[vManager validateValue:[selectedExpOfYears objectForKey:KEY_ID] withType:ValidationTypeString].count)?[selectedExpOfYears objectForKey:KEY_ID]:@"0";
        
        valuePicker.selectedValueColumn2 = (0>=[vManager validateValue:[selectedExpOfMonths objectForKey:KEY_ID] withType:ValidationTypeString].count)?[selectedExpOfMonths objectForKey:KEY_ID]:@"0";
        
        [valuePicker displayDropdownData:DD_EDIT_EXPERIENCE];
        [valuePicker refreshData];
        

        [APPDELEGATE.container toggleRightSideMenuCompletion:^{
            
            
            
        }];
    }
    
    vManager = nil;
    
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

/**
 *  Method updates the ddContentArr objects with selected value from drop down list / TextFields
 *
 *  @param responseParams  NSDictionary class conatining objects  for particular Keys
 */
-(void)handleDDOnSelection:(NSDictionary *)responseParams {
    
    NSInteger ddType = [[responseParams objectForKey:K_DROPDOWN_TYPE]integerValue];
    switch (ddType) {
            
        case DD_EDIT_EXPERIENCE:{
            //year
            NSString *tmpSelectedExpYrs = [responseParams objectForKey:K_KEY_PICKER_SELECTED_VALUE_1];
            NSArray *selectedValues = @[tmpSelectedExpYrs];
            
            if (selectedValues.count>0) {
                NSMutableDictionary *selectedExpOfYears = [_applyModelObj.workEx objectForKey:KEY_YEAR_DICTIONARY];
                
                if (nil == selectedExpOfYears) {
                    selectedExpOfYears = [NSMutableDictionary new];
                }
                [selectedExpOfYears setValue:tmpSelectedExpYrs forKey:KEY_VALUE];
                [selectedExpOfYears setValue:tmpSelectedExpYrs forKey:KEY_ID];
                
                [_applyModelObj.workEx setValue:selectedExpOfYears forKey:KEY_YEAR_DICTIONARY];
            }
            
            //month
            selectedValues = nil;
            if(![tmpSelectedExpYrs isEqualToString:@"30+"]){
            
            NSString *tmpSelectedExpMonths = [responseParams objectForKey:K_KEY_PICKER_SELECTED_VALUE_2];
            selectedValues = @[tmpSelectedExpMonths];
          
            if (selectedValues.count>0) {
                
                NSMutableDictionary *selectedExpOfMonths = [_applyModelObj.workEx objectForKey:KEY_MONTH_DICTIONARY];
                if (nil == selectedExpOfMonths)
                    selectedExpOfMonths = [NSMutableDictionary new];
                
                [selectedExpOfMonths setValue:tmpSelectedExpMonths forKey:KEY_VALUE];
                [selectedExpOfMonths setValue:tmpSelectedExpMonths forKey:KEY_ID];
                
                [_applyModelObj.workEx setValue:selectedExpOfMonths forKey:KEY_MONTH_DICTIONARY];
              }
            
        }
            
            else{
                
                NSMutableDictionary *selectedExpOfMonths = [_applyModelObj.workEx objectForKey:KEY_MONTH_DICTIONARY];
                if (nil == selectedExpOfMonths) {
                    selectedExpOfMonths = [NSMutableDictionary new];
                }
                [selectedExpOfMonths setValue:@"" forKey:KEY_VALUE];
                [selectedExpOfMonths setValue:@"" forKey:KEY_ID];
                
                [_applyModelObj.workEx setValue:selectedExpOfMonths forKey:KEY_MONTH_DICTIONARY];
  }
            //this line is just to call manual setter of workEx
            //so that we can set isFresher on the basis of user's year exp
            _applyModelObj.workEx = _applyModelObj.workEx;
            
           
            selectedValues = nil;
        }break;
            
        default:
            break;
    }
}
-(void)cellSegmentClicked:(NSInteger)selectedSegmentIndex ofRow:(NSInteger)rowNumber{
    if (1 == selectedSegmentIndex) {
        _applyModelObj.gender = @"Male";
    }else if (2 == selectedSegmentIndex){
        _applyModelObj.gender = @"Female";
    }else{
        _applyModelObj.gender = @"";
    }
    
}
#pragma mark - Textfield delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (UnRegApplyContactCellTextTagCountryCode == [textField tag]){
        if (textField.text.length >= 5 && range.length == 0)
            return NO;
        if(string.length==0)
            return YES;
        NSString *combinedString = [NSString stringWithFormat:@"%@%@",textField.text,string];//paste condition
        if(combinedString.length>5)
            return NO;
        return YES;
    
    }else if (UnRegApplyContactCellTextTagMobileNumber == [textField tag]){

        if (textField.text.length >= 12 && range.length == 0)
            return NO;
        if(string.length==0)
            return YES;
        
        NSString *combinedString = [NSString stringWithFormat:@"%@%@",textField.text,string];//paste condition
        if(combinedString.length>12)
            return NO;
        
        
        return YES;
    
    }else{
        return YES;
    }

}
//
- (BOOL)textFieldShouldStartEditing:(NSInteger)index{
    if (ROW_TYPE_MOBILE_NO == index) {
        isNeedToDownliftView = NO;
        if (IS_IPHONE4 && !isViewAlreadyUplifted) {
            isViewAlreadyUplifted = YES;
            //up left view so that user can see textfield
            [NGUIUtility slideView:self.view toXPos:0 toYPos:self.view.frame.origin.y-K_CONTACT_DEATILS_ROW_HEIGHT duration:0.25f delay:0.0f];
        }
    }else{
        isNeedToDownliftView = YES;//this var will ensure that view does not lift up/down for two textfields of same row
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    if (ROW_TYPE_NAME == index) {
        _applyModelObj.name = textFieldValue;
    }else if (ROW_TYPE_EMAIL == index) {
        _applyModelObj.emailId = textFieldValue;
    }else if (UnRegApplyContactCellTextTagCountryCode == [textField tag]){
        countryCode = textFieldValue;
    }else if (UnRegApplyContactCellTextTagMobileNumber == [textField tag]){
        mobileNumber = textFieldValue;
    }else{
        //dummy
    }
    
    //if iphone is 3.5 inches, down lift view
    if (IS_IPHONE4 && isNeedToDownliftView && ROW_TYPE_MOBILE_NO == index) {
        isViewAlreadyUplifted = NO;
        [NGUIUtility slideView:self.view toXPos:0 toYPos:self.view.frame.origin.y+K_CONTACT_DEATILS_ROW_HEIGHT duration:0.25f delay:0.0f];
    }
}
- (void)keyboardToolBarButtonPressed:(id)sender{
    isNeedToDownliftView = YES;
}
- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{
    if (ROW_TYPE_NAME == index) {
        _applyModelObj.name = [textField text];
    }else if (ROW_TYPE_EMAIL == index) {
        _applyModelObj.emailId = [textField text];
    }else if (UnRegApplyContactCellTextTagCountryCode == [textField tag]){
        countryCode = [textField text];
    }else if (UnRegApplyContactCellTextTagMobileNumber == [textField tag]){
        mobileNumber = [textField text];
    }else{
        //dummy
    }
}
-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    
    [self.view endEditing:YES];
    
    NSMutableArray* arrValidations = [self checkAllValidations];
    
    NSString * errorMessage = @"";
    
    if([arrValidations count] >0){
        
        for (NSInteger i = 0; i< [arrValidations count]; i++) {
            
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
        
        msgHeader = nil;
    }else{
        
            //contact country code and mobile number into one with seperator +
            NSString *contactNumber = [NSString stringWithFormat:@"%@+%@",countryCode,mobileNumber];
            _applyModelObj.mobileNumber = contactNumber;
            
            if (_applyModelObj){
      
                [self displayNextPage];
            }
        
    }
}
/**
 *  Method check the validation on all fields and return the result in Yes or NO
 *
 *  @return if yes, validation is applied for particular key
 */

- (NSMutableArray*)checkAllValidations{
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    NSArray *validationErrorArr = [[ValidatorManager sharedInstance]validateValue:_applyModelObj.name withType:ValidationTypeName];
    
    //name
    if ([validationErrorArr containsObject:[NSNumber numberWithInteger:ValidationErrorTypeEmpty]]) {
        [arr addObject:ERROR_MESSAGE_EMPTY_NAME];
        [self setItem:ROW_TYPE_NAME InErrorCollectionWithActionAdd:YES];
    }else if ([validationErrorArr containsObject:[NSNumber numberWithInteger:ValidationErrorTypeSpecialCharOrNumeric]]){
        [arr addObject:K_ERROR_MESSAGE_SPECIAL_CHARACTER];
        [self setItem:ROW_TYPE_NAME InErrorCollectionWithActionAdd:YES];
    }else{
        //dummy
    }
    
    //email id
    validationErrorArr = [[ValidatorManager sharedInstance]validateValue:_applyModelObj.emailId withType:ValidationTypeEmail];
    if (validationErrorArr.count>0){
        [arr addObject:ERROR_MESSAGE_VALID_EMAIL];
        [self setItem:ROW_TYPE_EMAIL InErrorCollectionWithActionAdd:YES];
    }else{
        //dummy
    }
    
    //contact number
    if (0<[vManager validateValue:countryCode withType:ValidationTypeString].count || 0<[vManager validateValue:countryCode withType:ValidationTypeNumber].count) {
        [arr addObject:@"Invalid Country code"];
        [self setItem:ROW_TYPE_MOBILE_NO InErrorCollectionWithActionAdd:YES];
    }else if(0<[vManager validateValue:mobileNumber withType:ValidationTypeString].count || 0<[vManager validateValue:mobileNumber withType:ValidationTypeNumber].count){
        [arr addObject:@"Invalid Mobile number"];
        [self setItem:ROW_TYPE_MOBILE_NO InErrorCollectionWithActionAdd:YES];
    }else {
        //dummy
    }
    
    //gender
    if (0<[vManager validateValue:_applyModelObj.gender withType:ValidationTypeString].count) {
        [arr addObject:ERROR_MESSAGE_EMPTY_GENDER];
        [self setItem:ROW_TYPE_GENDER InErrorCollectionWithActionAdd:YES];
    }
    
    //experience
    NSMutableDictionary *selectedExpOfYears = [_applyModelObj.workEx objectForKey:KEY_YEAR_DICTIONARY];
    NSMutableDictionary *selectedExpOfMonths = [_applyModelObj.workEx objectForKey:KEY_MONTH_DICTIONARY];
    
    if (0<[vManager validateValue:[selectedExpOfYears objectForKey:KEY_VALUE] withType:ValidationTypeString].count && 0<[vManager validateValue:[selectedExpOfMonths objectForKey:KEY_VALUE] withType:ValidationTypeString].count){
        
        [arr addObject:@"Experience cannot be blank"];
        [self setItem:ROW_TYPE_WORK_EXP InErrorCollectionWithActionAdd:YES];
    }
    
    
    if([arr count]>3){
        for (NSInteger i =3; i< [arr count]; i++)[arr removeObjectAtIndex:i];
    }
    
    [self.editTableView reloadData];
    
    return arr;
}
-(void)saveUnRegInfoForApply {
    //Saving Information for UnReg Apply
    [[[NGStaticContentManager alloc] init] saveApplyFields:_applyModelObj];
}
- (void)displayNextPage {
    NGJobsHandlerObject *obj =  [[NGJobsHandlerObject alloc]init];
    obj.Controller =  self;
    obj.jobObj = self.jobObj;
    obj.viewLoadingStartTime =  nil;
    obj.applyModelEmail = _applyModelObj.emailId;
    obj.unregApplyModal = _applyModelObj;
    obj.openJDLocation = _openJDLocation;
    [[NGApplyJobHandler sharedManager] jobHandlerWithExperiencedUserApply:obj];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setItem:(UnRegApplyRowType)paramUnRegApplyRowType InErrorCollectionWithActionAdd:(BOOL)paramIsAdd{
    NSInteger rowForItem = (NSInteger)paramUnRegApplyRowType;
    if (paramIsAdd) {
        [errorCellArr addObject:[NSNumber numberWithInteger:rowForItem]];
    }else{
        [errorCellArr removeObject:[NSNumber numberWithInteger:rowForItem]];
    }
}
@end
