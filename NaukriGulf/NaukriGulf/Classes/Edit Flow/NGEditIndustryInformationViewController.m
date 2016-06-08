//
//  NGEditIndustryInformationViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/7/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditIndustryInformationViewController.h"
#import "DDIndustryType.h"
#import "DDNoticePeriod.h"
#import "DDWorkLevel.h"
#import "DDFArea.h"


@interface NGEditIndustryInformationViewController ()<ProfileEditCellDelegate>{
    
    NSString *otherIndustryTypeValue;
    NSString *otherFunctionDeptValue;
    NGTextField *otherIndustryTxtField;
    NGTextField *otherFunctionDeptTxtField;
    NGTextField *funcTxtField;
    NGTextField *industryTxtField;
    NGTextField *workLevelTxtField;

    BOOL  showIndustryOther ;
    BOOL  showFunctionDeptOther;
    BOOL isValueSelectorExist; //  if valueselector controller  is present or not
    NSString *errorTitle;
    NSMutableDictionary* dictAvailableToJoin;
    NSMutableDictionary* dictWorkLevel;
    NSMutableDictionary* dictIndustryType;
    NSMutableDictionary* dictFunctionalArea;
    
    BOOL isInitialParamDictUpdated;
}
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side

@end

@implementation NGEditIndustryInformationViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavBarWithTitle:@"Industry Information"];
    self.editTableView.scrollEnabled = NO;
    dictIndustryType = [NSMutableDictionary dictionary];
    dictFunctionalArea = [NSMutableDictionary dictionary];
    dictAvailableToJoin = [NSMutableDictionary dictionary];
    dictWorkLevel = [NSMutableDictionary dictionary];
    isValueSelectorExist = NO;
    
    isInitialParamDictUpdated = NO;
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
     self.isRequestInProcessing = NO;
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
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"edit_industryInformation_table"] forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
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
    
    NSArray *ddNameArr = [NSArray arrayWithObjects:self.modalClassObj.fArea,self.modalClassObj.industryType,self.modalClassObj.workLevel,self.modalClassObj.noticePeriod, nil];
    
    NSArray *ddTypeArr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:DDC_FAREA],[NSNumber numberWithInteger:DDC_INDUSTRY_TYPE],[NSNumber numberWithInteger:DDC_WORK_LEVEL],[NSNumber numberWithInteger:DDC_NOTICE_PERIOD], nil];
    
    for (NSInteger i = 0; i<ddNameArr.count; i++) {
        NSDictionary *ddName = [ddNameArr fetchObjectAtIndex:i];
        NSNumber *ddType = [ddTypeArr fetchObjectAtIndex:i];
        
        if (![[ddName objectForKey:KEY_VALUE]isEqualToString:@""]) {
            [self handleDDOnSelection:
             [NSDictionary dictionaryWithObjectsAndKeys:ddType,K_DROPDOWN_TYPE,
              [NSArray arrayWithObjects:[ddName objectForKey:KEY_VALUE], nil],
                                                    K_DROPDOWN_SELECTEDVALUES,
              [NSArray arrayWithObjects:[ddName objectForKey:KEY_ID], nil],
                                                        K_DROPDOWN_SELECTEDIDS,
                                       [ddName objectForKey:KEY_SUBVALUE],@"OtherValues",nil]];
        }
        
    }
    
    
    [self.editTableView reloadData];
}


/**
 *  method created for updating the textField  with response
 *
 *  @param responseParams NSDictionary class
 */
-(void)handleDDOnSelection:(NSDictionary *)responseParams{
    
    NSInteger ddType = [[responseParams objectForKey:K_DROPDOWN_TYPE]integerValue];
    NSArray *arrSelectedIds = [responseParams objectForKey:K_DROPDOWN_SELECTEDIDS];
    NSArray* arrSelectedValues = [responseParams objectForKey:K_DROPDOWN_SELECTEDVALUES];
    
    switch (ddType) {
            
        case DDC_INDUSTRY_TYPE:{
            
            if (arrSelectedIds.count >0) {
                [dictIndustryType setCustomObject:[arrSelectedIds firstObject]  forKey:KEY_ID];
                [dictIndustryType setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            }else{
                [dictIndustryType setCustomObject:@""  forKey:KEY_ID];
                [dictIndustryType setCustomObject:@"" forKey:KEY_VALUE];
            }
            
            if ([[dictIndustryType objectForKey:KEY_VALUE] isEqualToString:@"Other"]) {
                showIndustryOther = TRUE;
                otherIndustryTypeValue = [responseParams objectForKey:@"OtherValues"];
                
            }else{
                showIndustryOther = FALSE;
                otherIndustryTypeValue= nil;
            }
            
            break;
        }
            
        case DDC_FAREA:{
            
            if (arrSelectedIds.count >0) {
                [dictFunctionalArea setCustomObject:[arrSelectedIds firstObject]  forKey:KEY_ID];
                [dictFunctionalArea setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            }else{
                [dictFunctionalArea setCustomObject:@""  forKey:KEY_ID];
                [dictFunctionalArea setCustomObject:@"" forKey:KEY_VALUE];
            }
            
            if ([[dictFunctionalArea objectForKey:KEY_VALUE] isEqualToString:@"Other"]) {
                
                showFunctionDeptOther = TRUE;
                otherFunctionDeptValue = [responseParams objectForKey:@"OtherValues"];
                
            }else{
                 showFunctionDeptOther = FALSE;
                 otherFunctionDeptValue = nil;
            }
            
            break;
        }
        case DDC_WORK_LEVEL:{
        
            if (arrSelectedIds.count >0) {
                [dictWorkLevel setCustomObject:[arrSelectedIds firstObject]  forKey:KEY_ID];
                [dictWorkLevel setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            }else{
                [dictWorkLevel setCustomObject:@""  forKey:KEY_ID];
                [dictWorkLevel setCustomObject:@"" forKey:KEY_VALUE];
            }
            
            break;
        }
        
        case DDC_NOTICE_PERIOD:{
            
            if (arrSelectedIds.count>0) {
                [dictAvailableToJoin setCustomObject:[arrSelectedIds firstObject]  forKey:KEY_ID];
                [dictAvailableToJoin setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            }else{
                [dictAvailableToJoin setCustomObject:@""  forKey:KEY_ID];
                [dictAvailableToJoin setCustomObject:@"" forKey:KEY_VALUE];
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
    cell.editModuleNumber = K_EDIT_INDUSTRY_INFORMATION;
    cell.delegate = self;
    
    NSInteger row = [self getRowForIndexpath:indexPath];
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    
    
    switch (row) {
            
        case ROW_TYPE_INDUSTRY_TYPE:{
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictIndustryType objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_INDUSTRY_INFORMATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            industryTxtField = (NGTextField*)cell.txtTitle;
            break;
        }
        case ROW_TYPE_OTHER_INDUSTRY:{
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:otherIndustryTypeValue forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_INDUSTRY_INFORMATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            otherIndustryTxtField = (NGTextField*)cell.txtTitle;
            break;
        }
        case ROW_TYPE_FUNC_DEPT:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictFunctionalArea objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_INDUSTRY_INFORMATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            funcTxtField =(NGTextField*) cell.txtTitle;
            break;
            
        }
        case ROW_TYPE_OTHER_FUNC_DEPT:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:otherFunctionDeptValue forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_INDUSTRY_INFORMATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            otherFunctionDeptTxtField = (NGTextField*)cell.txtTitle;
            break;
        }
            
        case ROW_TYPE_WORK_LEVEL:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictWorkLevel objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_INDUSTRY_INFORMATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            break;
        }
            
            
            
        case ROW_TYPE_AVAILIBILITY_JOIN:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictAvailableToJoin objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_INDUSTRY_INFORMATION] forKey:@"ControllerName"];
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
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];

    isValueSelectorExist = YES;
    //_valueSelector = nil;
    if (!_valueSelector) {

        _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
        _valueSelector.delegate = self;
        
    }
    [APPDELEGATE.container setRightMenuViewController:_valueSelector];
    APPDELEGATE.container.rightMenuPanEnabled = NO;
    

    switch (cellType) {
        
        case ROW_TYPE_INDUSTRY_TYPE:{
           
            if(0>=[vManager validateValue:[dictIndustryType objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[dictIndustryType objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_INDUSTRY_TYPE;
            [_valueSelector displayDropdownData];
        }
            break;
            
        case ROW_TYPE_FUNC_DEPT:
            
            if(0>=[vManager validateValue:[dictFunctionalArea objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[dictFunctionalArea objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_FAREA;
            [_valueSelector displayDropdownData];
            
            break;
            
        case ROW_TYPE_WORK_LEVEL:
            
            if(0>=[vManager validateValue:[dictWorkLevel objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [dictWorkLevel objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_WORK_LEVEL;
            [_valueSelector displayDropdownData];
            
            break;
            
        case ROW_TYPE_AVAILIBILITY_JOIN:
           
            if(0>=[vManager validateValue:[dictAvailableToJoin objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [dictAvailableToJoin objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_NOTICE_PERIOD;
            [_valueSelector displayDropdownData];
            
            break;
            
        default: return;
            break;
    }

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    
}


#pragma mark ValueSelector Delegate

-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
   
    
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
}


#pragma mark - row calculations

-(NSInteger)getNumberOfRows{
    
    if(showIndustryOther && showFunctionDeptOther){
        return 6;
    }else if (showIndustryOther || showFunctionDeptOther){
        return 5;
    }
    else return 4;
}

- (NSInteger)getRowForIndexpath:(NSIndexPath*)paramIndexPath{

    NSInteger row = paramIndexPath.row;
    
    if(showIndustryOther && showFunctionDeptOther){
        return row;
    }
    else if (showIndustryOther){
        
        if(row > 2) return  ++row ;
        else return row;
    }
    else if (showFunctionDeptOther){
        
        if (row > 0) {
            
            return  ++row;
        }
    }else {
        
        switch (row) {
            case 0 : return  row;
                break;
            case 1 : return  row+1;
                break;
            case 2  :
            case 3: return   row+2;
                break;
            }
    }
    return row;
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
    
    NSString *selectedId = [dictIndustryType objectForKey:KEY_ID];
    if (selectedId) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setCustomObject:selectedId forKey:@"id"];
        
        NSString *other = @"Other";
        
        if (showIndustryOther) {
            other = [otherIndustryTxtField getFilteredText];
        }
        
        [dict setCustomObject:other forKey:@"other"];
        [dict setCustomObject:other forKey:@"otherEN"];
        
        [params setCustomObject:dict forKey:@"industryType"];
    }
    
    
    selectedId = [dictFunctionalArea objectForKey:KEY_ID];
    if (selectedId) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setCustomObject:selectedId forKey:@"id"];
        
        NSString *other = @"Other";
        
        if (showFunctionDeptOther) {
            other = [otherFunctionDeptTxtField getFilteredText];
        }
        
        [dict setCustomObject:other forKey:@"other"];
        [dict setCustomObject:other forKey:@"otherEN"];
        
        [params setCustomObject:dict forKey:@"functionalArea"];
    }
    
    
    selectedId = [dictWorkLevel objectForKey:KEY_ID];
    if (selectedId)
        [params setCustomObject:selectedId forKey:@"workLevel"];
    else
        [params setCustomObject:@"" forKey:@"workLevel"];
    
    
    selectedId = [dictAvailableToJoin objectForKey:KEY_ID];
    if (selectedId)
        [params setCustomObject:selectedId forKey:@"noticePeriod"];
    else
        [params setCustomObject:@"" forKey:@"noticePeriod"];
    
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    
    return params;
}

-(void)onSave:(id)sender{
    
    [errorCellArr removeAllObjects];
    [self.view endEditing:YES];
    
    otherIndustryTxtField.validationType = VALIDATION_TYPE_EMPTY;
    otherFunctionDeptTxtField.validationType = VALIDATION_TYPE_EMPTY;
    funcTxtField.validationType = VALIDATION_TYPE_EMPTY;
    industryTxtField.validationType = VALIDATION_TYPE_EMPTY;

    
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
    else{
     
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EDIT_PROFILE withEventLabel:K_GA_EVENT_EDIT_PROFILE withEventValue:nil];
        if (!self.isRequestInProcessing) {
            [self setIsRequestInProcessing:YES];
            
            [self showAnimator];
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
     
            
            __weak NGEditIndustryInformationViewController *weakSelf = self;
            NSMutableDictionary *params =[self updateTheRequestParameterForSendingInitialValueOfChanges:[self getParametersInDictionary]];

            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf hideAnimator];
                    weakSelf.isRequestInProcessing = FALSE;
                    
                    if (responseInfo.isSuccess) {
                        [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                        [weakSelf.editDelegate editedIndustryInfoWithSuccess:YES];
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
    
    if (![industryTxtField checkValidation]) {
     
        [arr addObject:@"Industry type"];
         [errorCellArr addObject:[NSNumber numberWithInteger:0]];
    }
    if(showIndustryOther)
    {
        if (![otherIndustryTxtField checkValidation]) {
            [arr addObject:@"Other Industry Type"];
            [errorCellArr addObject:[NSNumber numberWithInteger:1]];
        }
    }
    
    
    if (![funcTxtField checkValidation]) {
        [arr addObject:@"Function Area/Department Type"];
        
        if (showIndustryOther) {
            [errorCellArr addObject:[NSNumber numberWithInteger:2]];;
        }else{
            [errorCellArr addObject:[NSNumber numberWithInteger:1]];;
        }
        
    }
    if(showFunctionDeptOther)
    {
        if (![otherFunctionDeptTxtField checkValidation]) {
            [arr addObject:@"Other Function Area/Department Type"];
            
            if (showIndustryOther) {
                [errorCellArr addObject:[NSNumber numberWithInteger:3]];;
            }else{
                [errorCellArr addObject:[NSNumber numberWithInteger:2]];;
            }
        }
    }
    
    
    return arr;
}

#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
    [self.editDelegate editedIndustryInfoWithSuccess:YES];
    [self hideAnimator];
    self.isRequestInProcessing = FALSE;
}
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [self hideAnimator];
    self.isRequestInProcessing = FALSE;
}


- (void)textField:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index {
   
    switch (textField.tag) {
        
        case ROW_TYPE_OTHER_FUNC_DEPT:
            otherFunctionDeptValue = textField.text;
            break;
        case ROW_TYPE_OTHER_INDUSTRY:otherIndustryTypeValue = textField.text;
            break;
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    switch (textField.tag) {
            
        case ROW_TYPE_OTHER_FUNC_DEPT:
            otherFunctionDeptValue = textField.text;
            break;
        case ROW_TYPE_OTHER_INDUSTRY:otherIndustryTypeValue = textField.text;
            break;
      default:
            break;
    }
}
-(void) dealloc {
    
    self.modalClassObj = nil;
}

@end
