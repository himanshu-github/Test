//
//  NGResmanDLVisaViewController.m
//  NaukriGulf
//
//  Created by Maverick on 24/03/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanDLVisaViewController.h"
#import "NGEditProfileSegmentedCell.h"
#import "NGValueSelectionViewController.h"
#import "NGCalenderPickerView.h"
#import "NGResmanLastStepPersonalDetailViewController.h"
#import "NGResmanPreviousWorkExpViewController.h"
#import "DDWorkStatus.h"
#import "DDCountry.h"

typedef enum : NSUInteger {
   
    CellTypeGeneralDesc,
    CellTypeVisaStatus,
    CellTypeVisaValidity,
    CellTypeDL,
    CellTypeDLIssued
 }
CellType;


@interface NGResmanDLVisaViewController ()<NGCalenderDelegate,ProfileEditCellDelegate,ProfileEditCellSegmentDelegate,ValueSelectorDelegate>{
    
    NSMutableArray *fieldsArr;
    NGResmanDataModel *resmanModel;
    BOOL isVisaDateEnabled;
    NGCalenderPickerView *datePicker; // a Controller class for displaying Months and Years in right side of panel
    NSInteger selectedIndex;
}
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side


@end

@implementation NGResmanDLVisaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSaveButtonTitleAs:@"Next"];
    fieldsArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:CellTypeGeneralDesc],[NSNumber numberWithInteger:CellTypeVisaStatus],[NSNumber numberWithInteger:CellTypeDL], nil];

    selectedIndex = 0;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
    
}

-(void) setDefaultValues
{
    //visa type
    if(0 >= [[ValidatorManager sharedInstance] validateValue:[resmanModel.visaStatus objectForKey:KEY_ID] withType:ValidationTypeString].count)
    {
        [self handleDDOnSelection:@{
                                    @"DropDownType" : [NSNumber numberWithInteger:DDC_WORK_STATUS],
                                    @"SelectedIds" :  @[[resmanModel.visaStatus objectForKey:KEY_ID]],
                                    @"SelectedValues" : @[[resmanModel.visaStatus objectForKey:KEY_VALUE]]
                                    }];
        
        NSString* _id = [resmanModel.visaStatus objectForKey:KEY_ID];
        if (![_id isEqualToString:@"1"]){
            isVisaDateEnabled = YES;
            if (![fieldsArr containsObject:[NSNumber numberWithInt:CellTypeVisaValidity]]) {
                [fieldsArr insertObject:[NSNumber numberWithInt:CellTypeVisaValidity] atIndex:2];
            }
        }
        else
        {
            isVisaDateEnabled = NO;
        }
        
    }
    
    //visa expiration date
    if (nil != resmanModel.visaValidity && 0 < resmanModel.visaValidity.length)
    {
        [self handleDatePickersOnSelectionOfDate:resmanModel.visaValidity];
    }
    
    //does user have DL
    if (resmanModel.isHoldingDL)
    {
        selectedIndex = 1;
        if (![fieldsArr containsObject:[NSNumber numberWithInt:CellTypeDLIssued]]) {
            [fieldsArr addObject:[NSNumber numberWithInteger:CellTypeDLIssued]];
        }
    }
    else
    {
        selectedIndex = 2;
        resmanModel.dlIssuedBy = [NSMutableDictionary new];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Great Going!"];
    
    if (resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_VISA_DL_FRESHER];
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_VISA_DL_EXPERIENCED];
    }
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    if (!resmanModel) {
        resmanModel = [[NGResmanDataModel alloc] init];
    }
    
    //if user already filled this page's date then
    //fetch that data from user profile and sync it with
    //resman model
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    if (nil!=objModel && ![objModel isKindOfClass:[NSNull class]])
    {
        //visa type
        if ([NGDecisionUtility isValidDropDownItem:objModel.visaStatus])
        {
            resmanModel.visaStatus = [NSMutableDictionary dictionaryWithDictionary:[objModel.visaStatus copy]];
        }
        
        //visa expiration date
        if (nil != objModel.visaExpiryDate && 0 < objModel.visaExpiryDate.length)
        {
            resmanModel.visaValidity = [NGDateManager formatDateInMonthYear:objModel.visaExpiryDate];
        }
        
        //does user have DL
        if (nil != objModel.dlStr && 0 < objModel.dlStr.length)
        {
            if ([objModel.dlStr.lowercaseString isEqualToString:@"y"])
            {
                resmanModel.isHoldingDL = YES;
            }
            else
            {
                resmanModel.isHoldingDL = NO;
            }
        }
        
        //DL country
        if ([NGDecisionUtility isValidDropDownItem:objModel.dlCountry])
        {
            resmanModel.dlIssuedBy = [NSMutableDictionary dictionaryWithDictionary:[objModel.dlCountry copy]];
        }
    }
    objModel = nil;
    
    [self setDefaultValues];
    
    [NGDecisionUtility checkNetworkStatus];

}

-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    [super viewDidAppear:animated];
    [self setAutomationLabel];

}
-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:@"DLVisa_table" forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableview Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return fieldsArr.count;
}

-(NGCustomValidationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    return cell;
}

-(NGCustomValidationCell *)configureCell:(NSIndexPath *)indexPath{
    
     NGProfileEditCell *cell;
    CellType type = [[fieldsArr fetchObjectAtIndex:indexPath.row]integerValue];
    
    switch (type) {
        
        case CellTypeGeneralDesc:{
            
            NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:@""];
            if (cell == nil)
            {
                cell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
                txtLabel.textAlignment = NSTextAlignmentCenter;
                [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
                txtLabel.text =@"Your Visa and Driving License Details";
                txtLabel.textColor = [UIColor darkGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:txtLabel];
                return cell;
            }
            
            break;
        }
            
        case CellTypeVisaStatus:{
           
            cell = [self getEditProfileCellForIndexPath:indexPath];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[resmanModel.visaStatus objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_DLVISA_VC] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            return cell;

            break;
        }
            
        case  CellTypeVisaValidity:{
           
            cell = [self getEditProfileCellForIndexPath:indexPath];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:resmanModel.visaValidity forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_DLVISA_VC] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            return cell;
            break;
        }
           
            
        case CellTypeDL:{
           
            NSString* cellIndentifier = @"EditProfileSegmentedCell";
            
            NGEditProfileSegmentedCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            cell.delegate = self;
            NSMutableArray* arrTitles = [[NSMutableArray alloc] initWithObjects:
                                         @"Yes",@"No", nil];
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            cell.iSelectedButton = selectedIndex;
            [dictToPass setCustomObject:@"Driving license" forKey:K_KEY_EDIT_PLACEHOLDER];
            [dictToPass setCustomObject:arrTitles forKey:K_KEY_EDIT_TITLE];
            [cell configureEditProfileSegmentedCell:dictToPass];
            
            dictToPass = nil;
            return cell;
            break;
        }
            
        case CellTypeDLIssued:{
            
            cell = [self getEditProfileCellForIndexPath:indexPath];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[resmanModel.dlIssuedBy objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_DLVISA_VC] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            cell.editModuleNumber = k_RESMAN_DLVISA_VC;
            cell.delegate = self;
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            cell.otherDataStr = nil;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            
            return cell;
            break;
        }
        default:
            break;
    }
    
    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellType type = [[fieldsArr fetchObjectAtIndex:indexPath.row]integerValue];
   
    return type==CellTypeGeneralDesc?50:(type == CellTypeDL?95:75);
}

-(NGProfileEditCell*) getEditProfileCellForIndexPath : (NSIndexPath*) indexPath {
    
    NSString* cellIndentifier = @"EditProfileCell";
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = K_RESMAN_PAGE_PERSONAL_DETAILS;
    cell.delegate = self;
    
    return  cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellType type = [[fieldsArr fetchObjectAtIndex:indexPath.row]integerValue];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];

    switch (type) {
        
        case CellTypeVisaStatus:{

            //_valueSelector = nil;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            if(0>=[vManager validateValue:[resmanModel.visaStatus objectForKey:KEY_ID] withType:ValidationTypeString].count)
            _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                               [resmanModel.visaStatus objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            
            _valueSelector.dropdownType = DDC_WORK_STATUS;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];

            break;
        }
        case CellTypeVisaValidity:{
        
            if(!datePicker){
                datePicker = [[NGCalenderPickerView alloc]initWithNibName:nil bundle:nil];
            }
            [APPDELEGATE.container setRightMenuViewController:datePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            datePicker.delegate = self;
            datePicker.selectedValue = resmanModel.visaValidity?resmanModel.visaValidity:@"";
            datePicker.headerTitle = @"Visa Valid Till";
            datePicker.delegate = self;
            datePicker.calType = NGCalenderTypeMMYYYY;
            datePicker.minYear =[NSNumber numberWithInteger:2015];
            datePicker.maxYear =[NSNumber numberWithInteger:2025];
            [datePicker refreshData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
                if(datePicker.selectedValue.length == 0)
                    [datePicker adjustDateInMiddle];
                
            }];

        
            break;
        }
            
        case CellTypeDLIssued:{
            
            //single value selector
            //_valueSelector = nil;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
             if(0>=[vManager validateValue:[resmanModel.dlIssuedBy objectForKey:KEY_ID] withType:ValidationTypeString].count)
                 _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[resmanModel.dlIssuedBy objectForKey:KEY_ID]];
             else
                 _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                     @""];

            _valueSelector.dropdownType = DDC_COUNTRY;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
        }
            
        default:
            break;
    }
    
}

#pragma mark - Custom picker Delegate
#pragma mark ValueSelector Delegate
/**
 *  @name Value Selector Delegate
 */
-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }
    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    if(isVisaDateEnabled && ![fieldsArr containsObject:[NSNumber numberWithInt:CellTypeVisaValidity]]){
        [fieldsArr insertObject:[NSNumber numberWithInt:CellTypeVisaValidity] atIndex:2];
    }else if (!isVisaDateEnabled){
        
        [fieldsArr removeObject:[NSNumber numberWithInt:CellTypeVisaValidity]];
    }
    [self.editTableView reloadData];
    
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
    [self.editTableView reloadData];
    
}

/**
 *   Method handle drop drown selction for DOB
 *
 */

-(void)handleDatePickersOnSelectionOfDate:(NSString *)date {
    
    if (![[date componentsSeparatedByString:@", "]containsObject:@"0"]) {
        resmanModel.visaValidity = date;
    }
    
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
        case DDC_WORK_STATUS:{
            
            if (arrSelectedIds.count>0) {
                
                isVisaDateEnabled = YES;
                [resmanModel.visaStatus setValue:[arrSelectedValues fetchObjectAtIndex:0]
                                                                                forKey:KEY_VALUE];
                [resmanModel.visaStatus setValue:[arrSelectedIds fetchObjectAtIndex:0]
                                                                                    forKey:KEY_ID];

                
                //compare Citizen Id i.e 1
                NSString* _id = (NSString*)[arrSelectedIds fetchObjectAtIndex:0];
                if (![_id isEqualToString:@"1"]) {
                  
                    isVisaDateEnabled = YES;
                    
                    if ([errorCellArr containsObject:[NSNumber numberWithInteger:CellTypeVisaValidity]]) {
                        [errorCellArr removeObject:[NSNumber numberWithInteger:CellTypeVisaValidity]];
                        [errorCellArr addObject:[NSNumber numberWithInteger:CellTypeDL]];
                    }
                    
                }else{
                    
                    isVisaDateEnabled = NO;
                    [errorCellArr removeObject:[NSNumber numberWithInteger:CellTypeVisaValidity]];
                    if ([errorCellArr containsObject:[NSNumber numberWithInteger:CellTypeDL]]) {
                        [errorCellArr removeObject:[NSNumber numberWithInteger:CellTypeDL]];
                        [errorCellArr addObject:[NSNumber numberWithInteger:CellTypeVisaValidity]];
                    }
                    
                    resmanModel.visaValidity = nil;
                    
                }
            }else{
                
                isVisaDateEnabled = NO;
                resmanModel.visaValidity = nil;
                [resmanModel.visaStatus  setValue:@"" forKey:KEY_VALUE];
                [resmanModel.visaStatus  setValue:@"" forKey:KEY_ID];
                
            }
            break;
        }
    
        case  DDC_COUNTRY:{
            
            if (arrSelectedIds.count>0){
                [resmanModel.dlIssuedBy setCustomObject:[arrSelectedValues fetchObjectAtIndex:0]
                                                 forKey:KEY_VALUE];
                [resmanModel.dlIssuedBy setCustomObject:[arrSelectedIds fetchObjectAtIndex:0]
                                                 forKey:KEY_ID];
            }else{
                
                [resmanModel.dlIssuedBy setCustomObject:@"" forKey:KEY_ID];
                [resmanModel.dlIssuedBy setCustomObject:@"" forKey:KEY_VALUE];
            }
            break;

        }
            
        case CellTypeVisaValidity:{

            if(!datePicker){
                datePicker = [[NGCalenderPickerView alloc]initWithNibName:nil bundle:nil];
            }
            [APPDELEGATE.container setRightMenuViewController:datePicker];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            datePicker.delegate = self;
            datePicker.selectedValue = resmanModel.visaValidity?resmanModel.visaValidity:@"";
            datePicker.headerTitle = @"Visa Valid Till";
            datePicker.delegate = self;
            datePicker.calType = NGCalenderTypeMMYYYY;
            datePicker.minYear =[NSNumber numberWithInteger:2015];
            datePicker.maxYear =[NSNumber numberWithInteger:2025];
            [datePicker refreshData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:^{
                
                if(datePicker.selectedValue.length == 0)
                    [datePicker adjustDateInMiddle];
                
            }];
            

            break;
            
            
            
        }
    }

}


-(void)cellSegmentClicked:(NSInteger)selectedSegmentIndex ofRow:(NSInteger)rowNumber{
    
    selectedIndex = selectedSegmentIndex;
    if (selectedIndex == 1 && ![fieldsArr containsObject:[NSNumber numberWithInteger:CellTypeDLIssued]]) {
        
        [fieldsArr addObject:[NSNumber numberWithInteger:CellTypeDLIssued]];
    } else if(selectedIndex == 2){
        
        [resmanModel.dlIssuedBy setCustomObject:@"" forKey:KEY_VALUE];
        
        [resmanModel.dlIssuedBy setCustomObject:@"" forKey:KEY_ID];
        
//        NSMutableDictionary *dict = [ddContentArr fetchObjectAtIndex:1];
//        [dict setCustomObject:[NSArray array] forKey:@"SelectedValues"];
        
        [fieldsArr removeObject:[NSNumber numberWithInteger:CellTypeDLIssued]];
        [errorCellArr removeObject:[NSNumber numberWithInt:CellTypeDLIssued]];
    }
    
    [self.editTableView reloadData];
}


- (NSMutableArray*)checkAllValidations{
  
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if ([fieldsArr containsObject:[NSNumber numberWithInteger:CellTypeVisaStatus]] && 0 < [vManager validateValue:[resmanModel.visaStatus objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Visa Status"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypeVisaStatus]]]];
    }
    
    if ([fieldsArr containsObject:[NSNumber numberWithInteger:CellTypeVisaValidity]] && 0 < [vManager validateValue:resmanModel.visaValidity withType:ValidationTypeString].count){
        
        [arr addObject:@"Visa expiry date"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypeVisaValidity]]]];
    }
    
    if ([fieldsArr containsObject:[NSNumber numberWithInteger:CellTypeDL]] && selectedIndex == 0){
        
        [arr addObject:@"Driving License"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypeDL]]]];
    }
  
    if ([fieldsArr containsObject:[NSNumber numberWithInteger:CellTypeDLIssued]] && 0 < [vManager validateValue:[resmanModel.dlIssuedBy objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Country where your Driving License was issued"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypeDLIssued]]]];
    }
    
    [self.editTableView reloadData];
    
    return arr;
    
}

-(void) saveResmanFieldsInDatabase
{
    if (selectedIndex == 1)
    {
        resmanModel.isHoldingDL = YES;
    }
    else
    {
        resmanModel.isHoldingDL = NO;
    }
    [[DataManagerFactory getStaticContentManager] saveResmanFields:resmanModel];
}

-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
-(NSMutableDictionary*)getParametersInDictionary{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setCustomObject:[resmanModel.visaStatus objectForKey:KEY_ID] forKey:@"visaStatus"];
    
    if (isVisaDateEnabled) {
        
        [params setCustomObject:[NGDateManager getDateFromMonthYear:resmanModel.visaValidity] forKey:@"visaExpiryDate"];
    }else{
        [params setCustomObject:@"" forKey:@"visaExpiryDate"];
    }
    
    if (selectedIndex==1) {
        
        [params setCustomObject:@"y" forKey:@"drivingLicense"];
        [params setCustomObject:[resmanModel.dlIssuedBy objectForKey:KEY_ID] forKey:@"drivingLicenseCountry"];
        
    }else{
        
        [params setCustomObject:@"n" forKey:@"drivingLicense"];
        [params setCustomObject:@"" forKey:@"drivingLicenseCountry"];
        
    }
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    return params;

}
- (void)saveButtonTapped:(id)sender{
    
    NSMutableArray* arrValidations = [self checkAllValidations];
    
    NSString *errorTitle = @"Incomplete Details!";
    
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
        
        
        [self showAnimator];
        
        [self saveResmanFieldsInDatabase];
        
        
        __weak NGResmanDLVisaViewController *weakSelf = self;
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
        NSMutableDictionary *params = [self getParametersInDictionary];

        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hideAnimator];
                
                if (responseInfo.isSuccess) {
                    
                    if (resmanModel.isFresher) {
                        
                        NGResmanLastStepPersonalDetailViewController *lastPersonalVc = [[NGResmanLastStepPersonalDetailViewController alloc] initWithNibName:nil bundle:nil];
                        
                        [(IENavigationController*)self.navigationController pushActionViewController:lastPersonalVc Animated:YES];
                    }
                    else{
                        
                        NGResmanPreviousWorkExpViewController *prevExp = [[NGResmanPreviousWorkExpViewController alloc]initWithNibName:nil bundle:nil];
                        [(IENavigationController*)self.navigationController pushActionViewController:prevExp Animated:YES];
                    }
                    
                }else{
                    
                    NSString *errorMsg = @"Some problem occurred at server";
                    
                    [NGUIUtility showAlertWithTitle:@"Error" withMessage:[NSArray arrayWithObject:errorMsg] withButtonsTitle:@"Ok" withDelegate:nil];
                }
                
            });
        }];
    }
}

@end
