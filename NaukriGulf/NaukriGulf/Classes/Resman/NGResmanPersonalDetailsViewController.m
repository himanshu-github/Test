//
//  NGResmanPersonalDetailsViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/24/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanPersonalDetailsViewController.h"
#import "NGEditProfileSegmentedCell.h"
#import "NGValueSelectionViewController.h"
#import "NGValueSelectionRequestModal.h"
#import "NGRegisterationHelper.h"
#import "NGAPIResponseModal.h"
#import "NGContactDetailMobileCell.h"
#import "NGValueSelectionResponseModal.h"
#import "NGLayeredValueSelectionViewController.h"
#import "NGTermsOfConditionCell.h"
#import "NGResmanCVUploadViewController.h"
#import "DDAlert.h"
#import "DDCountry.h"
#import "DDCity.h"
#import "DDNationality.h"

typedef enum {
    
    K_ROW_TYPE_GENDER = 0,
    K_ROW_TYPE_NAME,
    K_ROW_TYPE_MOBILE_NUMBER,
    K_ROW_TYPE_NATIONALITY,
    K_ROW_TYPE_CITY,
    K_ROW_TYPE_COUNTRY,
    K_ROW_TYPE_ALERT_SETTINGS,
    K_ROW_TYPE_TERMS_OF_SERVICE
    
}rowType;


#define SEGMENT_NOT_SELECTED -1
#define ALERT_LABEL_TAG 1789
#define MOBILE_COUNTRY_TEXTFIELD 1000
#define MOBILE_NUMBER_TEXTFIELD 1001
#define GENDER_MALE @"Male"
#define GENDER_FEMALE @"Female"

@interface NGResmanPersonalDetailsViewController ()<ProfileEditCellSegmentDelegate,ProfileEditCellDelegate,ContactDetailMobileCell,NGValueSelectionRequestModal,ValueSelectorDelegate,AutocompletionTableViewDelegate,TermsOfConditionDelegate>{
    
    NGResmanDataModel *resmanModel;
    NGValueSelectionViewController* valueSelector;
    
    NSInteger selectedIndexForGender;
    NSString *fullName;
    NSString *countryCode;
    NSString *mobileNumber;
    NSDictionary *nationality;
    NSString *city;
    NSString *country;
    NSMutableDictionary* dictCountry;
    NSMutableDictionary *alertSettings;
    NSMutableArray *nationalityArr;
  
    NSMutableArray *cityArr;
    
    NGTextField *countryTxtFld ;
    NGTextField *cityTxtFld;
   
    NSLayoutConstraint *autoCompletionHeightConstraints;
    UIView *suggestorBackgroundView;

    BOOL isOtherCity;
    
    NSString *cityCountryId;
    
    UIView *footerView;
    
    NSInteger yForAutoCompletionTable;
    NSMutableArray *arrCountriesData;
}

@property(nonatomic,strong)AutocompletionTableView *autoCompleter;

@end

@implementation NGResmanPersonalDetailsViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    selectedIndexForGender = SEGMENT_NOT_SELECTED;
    selectedIndexForGender = SEGMENT_NOT_SELECTED;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewDidAppear:animated];
    
    if (resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_LAST_STEP_FRESHER];
        
        [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageFresherPersonalDetailAndRegister];
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_LAST_STEP_EXPERIENCED];
        
        [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageExperiencePersonalDetailAndRegister];
    }
    
    self.isRequestInProcessing= FALSE;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    
    [self.scrollHelper listenToKeyboardEvent:YES];
    self.scrollHelper.headerHeight = 0;
    self.scrollHelper.rowHeight = 75;
    
    [self addNavigationBarWithBackAndRightButtonTitle:@"Register" WithTitle:@"Last Step"];
    [self setSaveButtonTitleAs:@"Register"];
    [NGDecisionUtility checkNetworkStatus];
    
    [self setdefaultValues];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillDisappear:animated];
    [self.scrollHelper listenToKeyboardEvent:NO];
}

-(void) setdefaultValues {
    
    fullName = resmanModel.name?resmanModel.name:nil;
    countryCode = resmanModel.countryCode?resmanModel.countryCode:nil;
    mobileNumber = resmanModel.mobileNum?resmanModel.mobileNum:nil;
    
    if (resmanModel.isOtherCity) {
        isOtherCity = TRUE;
    }
    if ([resmanModel.gender isEqualToString:GENDER_MALE]) {
        selectedIndexForGender = 1;
    }else if([resmanModel.gender isEqualToString:GENDER_FEMALE]){
        selectedIndexForGender= 2;
    }else{
        selectedIndexForGender = SEGMENT_NOT_SELECTED;
    }
    
    nationality = resmanModel.nationality?resmanModel.nationality:[NSMutableDictionary dictionary];
    
    city = resmanModel.city?[resmanModel.city objectForKey:KEY_VALUE]:nil;
    
    cityCountryId= resmanModel.city?[resmanModel.city objectForKey:KEY_ID]:nil;
    
    if (resmanModel.isOtherCity) {
      
        country = resmanModel.country?[resmanModel.country objectForKey:KEY_VALUE]:nil;
        
    }else{
        
        country = nil;
        resmanModel.country = nil;
    }
    
    
    if (nil!=resmanModel.alertSetting && 0<[resmanModel.alertSetting count]) {
        alertSettings = resmanModel.alertSetting? resmanModel.alertSetting:[NSMutableDictionary dictionary];
        if ([resmanModel.alertSetting objectForKey:KEY_VALUE] )
            [self prioritizeAlertText:resmanModel.alertSetting];
    }else{
        alertSettings = [[NSMutableDictionary alloc] init];
        [alertSettings setCustomObject:@"CS,CM,SMS,PS,PM" forKey:KEY_ID];
        [alertSettings setCustomObject:@"Career / Education information,SMS Contacts by Recruiters,Naukrigulf.com partner sites,Other promotions / Offers,Job Alerts and Similar Updates"  forKey:KEY_VALUE];
        [self prioritizeAlertText:alertSettings];
    }
    
    arrCountriesData = [NSMutableArray arrayWithArray:
                                        [NGDatabaseHelper getSortedDataWhereKey:DROPDOWN_SORTED_ID andClass:[DDCountry class]]];
    cityArr = [NSMutableArray array];
    for (DDBase* obj in arrCountriesData)
        [cityArr addObjectsFromArray:[NGDatabaseHelper sortCountryCityForSuggestor:DROPDOWN_VALUE_NAME
                                            onArray:((NSSet*)[obj valueForKey:@"cities"]).allObjects]];
    
    dictCountry = [NSMutableDictionary dictionary];
    if(resmanModel.isOtherCity)
        [self calculateCountryIdForOtherCity];
    else
        [self calculateCountryAndCityId];
    
    
}

-(void)prioritizeAlertText:(NSMutableDictionary*)alertDict{
    
    NSArray* arrValues = [[alertDict objectForKey:KEY_VALUE] componentsSeparatedByString:@","];
    arrValues = [self replaceAlertsSettingsText:arrValues];
    [alertSettings setCustomObject:[NSString getStringsFromArrayWithoutSpace:arrValues] forKey:KEY_VALUE];
    
}
-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }
    
    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
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

        case DDC_ALERT:{
          
            if (arrSelectedIds.count) {
                
                arrSelectedValues = [self replaceAlertsSettingsText:arrSelectedValues];
                [alertSettings setCustomObject:[NSString getStringsFromArrayWithoutSpace:arrSelectedValues] forKey:KEY_VALUE];
                [alertSettings setCustomObject:[NSString getStringsFromArrayWithoutSpace:arrSelectedIds] forKey:KEY_ID];
                
            }
            else
                [alertSettings removeAllObjects];
            
            break;
        }
          
        case  DDC_COUNTRY: {
            
           country = arrSelectedValues.count>0?[arrSelectedValues objectAtIndex:0]:nil;
            if (country){
                [self calculateCountryIdForOtherCity];
                [dictCountry setCustomObject:country forKey:KEY_VALUE];

            }
            else{
                cityCountryId = nil;
                [dictCountry setCustomObject:@"" forKey:KEY_VALUE];

            }
        }
            break;
            
        case DDC_NATIONALITY:{
    
            if (arrSelectedIds.count) {
                
                [nationality setValue:[NSString getStringsFromArrayWithoutSpace:arrSelectedIds]forKey:KEY_ID];
                [nationality setValue:[NSString getStringsFromArrayWithoutSpace:arrSelectedValues] forKey:KEY_VALUE] ;
                

            }else{
                
                [nationality setValue:@"" forKey:KEY_ID];
                [nationality setValue:@"" forKey:KEY_VALUE] ;
                
            }
        
        }
        
        default:
            break;
    }
    
    [self.editTableView reloadData];
    
}

-(NSArray*)replaceAlertsSettingsText:(NSArray*)arrToReplace{
    
    int i = -1;
    NSMutableArray* replacedArr = [NSMutableArray arrayWithArray:arrToReplace];
    for (NSString* strValue in arrToReplace) {
        
        i++;
        if ([strValue isEqualToString:@"Job Alerts and Similar Updates"]) {
            
            [replacedArr removeObjectAtIndex:i];
            [replacedArr insertObject:strValue atIndex:0];
        }
        
    }

    return replacedArr;
    
}
-(void) calculateCountryIdForOtherCity {
    [dictCountry removeAllObjects];
    NSString *countryId;
    for (int i = 0; i < arrCountriesData.count;i++) {
        
        DDBase* obj = [arrCountriesData fetchObjectAtIndex:i];
        if ([obj.valueName isEqualToString:country]) {
            countryId = obj.valueID.stringValue;
            if (city)
                cityCountryId = [NSString stringWithFormat:@"%@.1000",countryId];
            else
                cityCountryId = nil;
            break;
        }
    }
    [dictCountry setCustomObject:cityCountryId forKey:KEY_ID];
}

#pragma mark - table view delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isOtherCity) {
        return 8;
    }
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (nil == footerView) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 1.0f)];
        [footerView setBackgroundColor:UITABLEVIEW_SEPERATOR_COLOR];
        self.scrollHelper.tableViewFooter = footerView;
    }
    return footerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case K_ROW_TYPE_GENDER:
            return 95;
        default:
            break;
    }
    
    return 75;
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
        
        case K_ROW_TYPE_GENDER:{
            
            NSString* cellIndentifier = @"EditProfileSegmentedCell";
            
            NGEditProfileSegmentedCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            cell.delegate = self;
            
            [UIAutomationHelper setAccessibiltyLabel:@"gender_cell" forUIElement:cell withAccessibilityEnabled:NO];
            
            NSMutableArray* arrTitles = [[NSMutableArray alloc] initWithObjects:
                                         @"Male",@"Female", nil];
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            cell.iSelectedButton = selectedIndexForGender;
            cell.rowIndex = K_ROW_TYPE_GENDER;
            cell.iPreviouslySelectedButton = 1;
            [dictToPass setCustomObject:@"Your Gender" forKey:K_KEY_EDIT_PLACEHOLDER];
            [dictToPass setCustomObject:arrTitles forKey:K_KEY_EDIT_TITLE];
            [cell configureEditProfileSegmentedCell:dictToPass];
            dictToPass = nil;
            return cell;
            
        }
            
        case K_ROW_TYPE_NAME:{
           
            cell = [self getEditProfileCellForIndexPath:indexPath];
            [[cell.contentView viewWithTag:ALERT_LABEL_TAG] removeFromSuperview];
            [cell.txtTitle removeTarget:_autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:fullName forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_RESMAN_PAGE_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            cityTxtFld = nil;countryTxtFld = nil;
            break;
            
        }
            
        case K_ROW_TYPE_MOBILE_NUMBER:{
            
            NSString* cellIndentifier = @"EditContactDetailMobileCell";
            NGContactDetailMobileCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if(cell==nil)
                cell = [[NGContactDetailMobileCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:cellIndentifier];
            
            cell.delegate = self;
            NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:countryCode forKey:@"mobileCountryCode"];
            [dictToPass setCustomObject:mobileNumber forKey:@"mobileNumber"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_RESMAN_PAGE_PERSONAL_DETAILS] forKey:@"ControllerName"];
            [cell configureMobileCellWithData:dictToPass andIndexPath:indexPath];
            countryTxtFld = cell.countryCode;
            return cell;
            
            
        }
            
        case K_ROW_TYPE_NATIONALITY:{
            
            cell = [self getEditProfileCellForIndexPath:indexPath];
            [[cell.contentView viewWithTag:ALERT_LABEL_TAG] removeFromSuperview];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[nationality objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_RESMAN_PAGE_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = K_ROW_TYPE_NATIONALITY;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            break;
            
        }
            
        case K_ROW_TYPE_CITY:{
            
            cell = [self getEditProfileCellForIndexPath:indexPath];
            [[cell.contentView viewWithTag:ALERT_LABEL_TAG] removeFromSuperview];
            cityTxtFld = cell.txtTitle;
            [self addAutoCompleter];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:city forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_RESMAN_PAGE_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = K_ROW_TYPE_CITY;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            break;
        }
            
        case K_ROW_TYPE_COUNTRY:{
            
            cell = [self getEditProfileCellForIndexPath:indexPath];
            [[cell.contentView viewWithTag:ALERT_LABEL_TAG] removeFromSuperview];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:country forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_RESMAN_PAGE_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = K_ROW_TYPE_COUNTRY;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
      
            break;
        }
  
        case K_ROW_TYPE_ALERT_SETTINGS:{
            
            cell = [self getEditProfileCellForIndexPath:indexPath];
            [[cell.contentView viewWithTag:ALERT_LABEL_TAG] removeFromSuperview];
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[alertSettings objectForKey:KEY_VALUE] ? @"Yes":@"No" forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_RESMAN_PAGE_PERSONAL_DETAILS] forKey:@"ControllerName"];
            cell.index = K_ROW_TYPE_ALERT_SETTINGS;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            
            cell.txtTitle.textColor = [alertSettings objectForKey:KEY_VALUE]?[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:102.0/255 alpha:1.0]:[UIColor redColor];
            
            if ([alertSettings objectForKey:KEY_VALUE]) {
                UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(93,14,200,15)];
                alertLabel.numberOfLines = 0;
                alertLabel.text= [alertSettings objectForKey:KEY_VALUE];;
                alertLabel.font= [UIFont fontWithName:@"Helvetica" size:11];
                CGFloat colorCode = 122.0f/255.0f;
                alertLabel.textColor=[UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f];
                alertLabel.tag = ALERT_LABEL_TAG;
                [cell.contentView addSubview:alertLabel];
                
            }
            break;
        }
            
        case K_ROW_TYPE_TERMS_OF_SERVICE:{
            
            NSString* cellIndentifier = @"toc";
            NGTermsOfConditionCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.index = K_ROW_TYPE_TERMS_OF_SERVICE;
            cell.delegate = self;
            return  cell;
            
        }
            
            default:
            break;
    }
    

    
    
    return cell;
}

-(NGProfileEditCell*) getEditProfileCellForIndexPath : (NSIndexPath*) indexPath {
    
    NSString* cellIndentifier = @"EditProfileCell";
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = K_RESMAN_PAGE_PERSONAL_DETAILS;
    cell.delegate = self;
    return  cell;
    
}


-(NSInteger) getRowNumberFor:(NSInteger) row {

    if (isOtherCity) {
        return row;
    }else{
        
        if (row >= K_ROW_TYPE_COUNTRY) {
            row++;
        }
    }
    
    return row;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.editTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NGProfileEditCell *cell  = (NGProfileEditCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [self getRowNumberFor:indexPath.row];
    [self.view endEditing:YES];
    
    switch (row) {
            
        case  K_ROW_TYPE_NATIONALITY:
            [self showDropDownFor:K_ROW_TYPE_NATIONALITY];
            break;
            
        case K_ROW_TYPE_COUNTRY:{
            
            if(isOtherCity)
                [self showDropDownFor:K_ROW_TYPE_COUNTRY];
            else
                [self showDropDownFor:K_ROW_TYPE_ALERT_SETTINGS];
            
        }
            break;
        
            
        case  K_ROW_TYPE_ALERT_SETTINGS :
            
            [self showDropDownFor:K_ROW_TYPE_ALERT_SETTINGS];
            break;
        
            
        default:
            break;
    }
    
    
    
}

-(void) showDropDownFor:(rowType) type{
    
    valueSelector = nil;
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    if (!valueSelector)
    {
        valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
        valueSelector.delegate = self;
    }
    
    [APPDELEGATE.container setRightMenuViewController:valueSelector];
    APPDELEGATE.container.rightMenuPanEnabled = NO;
    switch (type) {
            
        case K_ROW_TYPE_COUNTRY:{
            valueSelector.dropdownType = DDC_COUNTRY;
            if(0>=[vManager validateValue:[dictCountry objectForKey:KEY_ID] withType:ValidationTypeString].count){
                NSString *citiCountryIds = [dictCountry objectForKey:KEY_ID];
                NSArray *citiCountryArr = [citiCountryIds componentsSeparatedByString:@"."];
                if(citiCountryArr.count>0)
                    valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[citiCountryArr fetchObjectAtIndex:0]];
                else
                    valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                       @""];
                
                
            }
            else
                valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            [valueSelector displayDropdownData];
        }
            break;
            
        case K_ROW_TYPE_ALERT_SETTINGS:{
            if(0>=[vManager validateValue:[alertSettings objectForKey:KEY_ID] withType:ValidationTypeString].count){
                
                NSMutableArray* arrIds = [NSMutableArray arrayWithArray:[(NSString*)[alertSettings objectForKey:KEY_ID] componentsSeparatedByString:@","]];
                valueSelector.arrPreSelectedIds = arrIds;
            }
            valueSelector.dropdownType = DDC_ALERT;
            [valueSelector displayDropdownData];
        }
            break;
            
        case K_ROW_TYPE_NATIONALITY:{
            if(0>=[vManager validateValue:[nationality objectForKey:KEY_ID] withType:ValidationTypeString].count)
                valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[nationality objectForKey:KEY_ID]];
            valueSelector.dropdownType = DDC_NATIONALITY;
            [valueSelector displayDropdownData];
        }
        default:
            break;
    }
    
    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    
}


-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    
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
        
        
    }else {
        
        [self saveResmanFieldsInDatabase];
        
        [self showAnimator];
        
        self.isRequestInProcessing = TRUE;
        __block NGResmanPersonalDetailsViewController *myselfVc = self;
        NGRegisterationHelper *registerHelper = [[NGRegisterationHelper alloc] init];
        [registerHelper registerUserWithCompletionHandler:^(NGAPIResponseModal *responseInfo){
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               
                               [myselfVc hideAnimator];
                               
                               if (responseInfo.isSuccess) {
                                   
                                   if ([[NGHelper sharedInstance] isResmanViaMailer]) {
                                       
                                       [NGHelper sharedInstance].isResmanViaMailer = NO;
                                       [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_UNREG_MAILERS withEventAction:K_GA_REGISTRATION_FROM_MAILERS withEventLabel:K_GA_REGISTRATION_FROM_MAILERS withEventValue:nil];
                                   }
                                   if ([[NGHelper sharedInstance] isResmanViaUnregApply]) {
                                       
                                       [NGHelper sharedInstance].isResmanViaUnregApply = NO;
                                           [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_UNREG withEventAction:K_GA_RESMAN_COMPLETION_POST_UNREG withEventLabel:K_GA_RESMAN_COMPLETION_POST_UNREG withEventValue:nil];
                                       
                                   }
                                   if ([[NGHelper sharedInstance] isResmanViaApply]) {
                                      
                                       [NGHelper sharedInstance].isResmanViaApply = FALSE;
                                        
                                       [[NGApplyJobHandler sharedManager] jobHandlerWithJobDescriptionPageApply:[NGApplyJobHandler sharedManager].loginObjForThisClass];
                                    
                                      
                                       return ;
                                   }

                                    NGResmanCVUploadViewController *cvHeadlineVc = [[NGResmanCVUploadViewController alloc] init];
                                   
                                   [(IENavigationController*)self.navigationController pushActionViewController:cvHeadlineVc Animated:YES];

                                  
                               }
                               else{
                                   
    
                                   NSString *errorMsg = @"Some problem occurred at server";
                                   
                                   
                                   errorMsg = [[[[[responseInfo.parsedResponseData objectForKey:KEY_ERROR] objectForKey:@"validationErrorDetails"] firstObject] objectForKey:@"useremail"] objectForKey:@"message"];
                                   
                                   
                                   if(nil != errorMsg){
                                       [NGUIUtility showAlertWithTitle:@"Error" withMessage:[NSArray arrayWithObject:errorMsg] withButtonsTitle:@"Ok" withDelegate:nil];
                                   }
                                   
                                   self.isRequestInProcessing = FALSE;
                                   
                               }
                               
                               
                               
                           });


        }];
        
    }
}


-(void) showMessage: (NSString *) msg{

    [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:msg animationTime:1000 showAnimationDuration:1000];

}
-(void) saveResmanFieldsInDatabase{
    
     if (selectedIndexForGender == 1) {
        resmanModel.gender = GENDER_MALE;
    }else if(selectedIndexForGender == 2){
        resmanModel.gender = GENDER_FEMALE;
    }
    
    resmanModel.name = fullName;
    resmanModel.countryCode = countryCode;
    resmanModel.mobileNum = mobileNumber;
    resmanModel.nationality = nationality;
    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
    [cityDict setCustomObject:city forKey:KEY_VALUE];
    [cityDict setCustomObject:cityCountryId forKey:KEY_ID];
    
    resmanModel.city = cityDict;
    
    NSMutableDictionary *countryDict = [[NSMutableDictionary alloc] init];
    [countryDict setCustomObject:country forKey:KEY_VALUE];
    [countryDict setCustomObject:[[cityCountryId componentsSeparatedByString:@"."] objectAtIndex:0] forKey:KEY_ID];
    
    resmanModel.country = countryDict;
    resmanModel.alertSetting = alertSettings;
    resmanModel.isOtherCity = isOtherCity;
    [[DataManagerFactory getStaticContentManager]saveResmanFields:resmanModel];
}

-(NSMutableArray*) checkAllValidations {
    
    NSMutableArray *arr = [NSMutableArray array];
    [errorCellArr removeAllObjects];
  
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (selectedIndexForGender == SEGMENT_NOT_SELECTED) {
        [arr addObject:@"Gender"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_GENDER]];
    }

    if (0 < [vManager validateValue:fullName withType:ValidationTypeString].count){
        [arr addObject:@"Full Name"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_NAME]];
    }
    
    if (0 < [vManager validateValue:countryCode withType:ValidationTypeString].count) {
        [arr addObject:@"Country Code"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MOBILE_NUMBER]];
    }
    
    if (0 < [vManager validateValue:mobileNumber withType:ValidationTypeString].count) {
        
        [arr addObject:@"Mobile Number"];
        if (![errorCellArr containsObject:[NSNumber numberWithInt:K_ROW_TYPE_MOBILE_NUMBER]]) {
            [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MOBILE_NUMBER]];
        }
    }
    
    if (0 < [vManager validateValue:[nationality objectForKey:KEY_VALUE] withType:ValidationTypeString].count) {
        [arr addObject:@"Nationality"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_NATIONALITY]];
    }

    
    if (0 < [vManager validateValue:city withType:ValidationTypeString].count) {
        [arr addObject:@"City"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_CITY]];
    }

    if (isOtherCity  && (0 < [vManager validateValue:country withType:ValidationTypeString].count)) {
        [arr addObject:@"Country"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_COUNTRY]];
    }
    
    
    if (![NGDecisionUtility isValidNumber:countryCode]){
        
        if (![arr containsObject:@"Country Code"]) {
         
            [arr addObject:@"Country Code"];
            
            [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MOBILE_NUMBER]];

        }

    }
    
    if (![arr containsObject:@"Mobile Number"] &&  ![NGDecisionUtility isValidNumber:mobileNumber]) {
        
        [arr addObject:@"Mobile Number"];
        [errorCellArr addObject:[NSNumber numberWithInt:K_ROW_TYPE_MOBILE_NUMBER]];

    }
    
    if (arr.count) {
        [self.editTableView reloadData];
    }
    return arr;
}


-(void)cellSegmentClicked:(NSInteger)selectedSegmentIndex ofRow:(NSInteger)rowNumber{
    selectedIndexForGender = selectedSegmentIndex;
   //2 female , 1 for gender
}

-(void)textFieldDidStartEditing:(UITextField *)textfield havingIndex:(NSInteger)index{
    
    if(textfield.tag == K_ROW_TYPE_CITY){
        
        self.scrollHelper.rowType = NGScrollRowTypeSuggestorInsetOffset;
        if (IS_IPHONE4) {
            self.scrollHelper.shiftVal = (95+75*(K_ROW_TYPE_CITY - 1))-20;
        }else{
            self.scrollHelper.shiftVal = (95+75*(K_ROW_TYPE_CITY - 1));
        }
        
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:K_ROW_TYPE_CITY inSection:0];

        self.autoCompleter.isErrorViewVisibleInSearch= NO;
        
        [self.autoCompleter setTopPositionForSuggestorView:yForAutoCompletionTable];
        
        [self addSuggestorBackGroundView:yForAutoCompletionTable];
        
    }else if (textfield.tag == K_ROW_TYPE_NAME){
        self.scrollHelper.rowType = NGScrollRowTypeNormal;
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:K_ROW_TYPE_NAME inSection:0];
    }
}


-(void) textFieldDidStartEditing:(NSInteger)index{

    if (index == K_ROW_TYPE_MOBILE_NUMBER) {
        self.scrollHelper.rowType = NGScrollRowTypeNormal;
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:K_ROW_TYPE_MOBILE_NUMBER inSection:0];

    }
}

- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{

    if(textField.tag == K_ROW_TYPE_NAME){
        
        [countryTxtFld becomeFirstResponder];
    }
}

- (void)textFieldDelegate:(UITextField *)textfield havingIndex:(NSInteger)index{
    
    if (K_ROW_TYPE_CITY == textfield.tag){
        
        city = textfield.text;
        
        
   }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    switch (textField.tag) {
        case MOBILE_COUNTRY_TEXTFIELD:
            if (textField.text.length >= 5  && range.length == 0)
                return NO;
            return YES;
            break;
        case MOBILE_NUMBER_TEXTFIELD:
            if (textField.text.length >= 12 && range.length == 0)
                return NO;
            return YES;
            break;
            
        default: break;
    }
    
    return YES;
}


-(void) textFieldDidEndEditing:(UITextField *)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    
    
    switch (textField.tag) {
            
        case K_ROW_TYPE_NAME:
            fullName = textField.text;
            fullName = [NSString stripTags:fullName];
            break;
        case K_ROW_TYPE_CITY:{
            [self hideSuggestorView];
            city = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            city = [NSString stripTags:city];
            BOOL isCityPresent = NO;
            if (city.length >0) {
            
                for (DDCity* obj in cityArr)
                    if ([obj.valueName isEqualToString:city]) {
                        isCityPresent = YES;
                        break;
                    }
            }
            
            if (!isCityPresent) {
                isOtherCity = YES;
                cityCountryId = nil;
                country = nil;
                [self calculateCountryIdForOtherCity];
                
            }else{
                
                if ([errorCellArr containsObject:[NSNumber numberWithInt:K_ROW_TYPE_COUNTRY]])
                    [errorCellArr removeObject:[NSNumber numberWithInt:K_ROW_TYPE_COUNTRY]];
                
                isOtherCity = NO;
                [self calculateCountryAndCityId];
            }
            [self.editTableView reloadData];
            [self.editTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
            [dictCountry setCustomObject:[NSArray arrayWithObject:@""] forKey:KEY_VALUE];
            
        }
            break;
        case MOBILE_COUNTRY_TEXTFIELD:
            countryCode = textField.text;

            
            break;
        case MOBILE_NUMBER_TEXTFIELD:
            mobileNumber = textField.text;
            break;
            
        default:
            break;
    }
    
    
}

-(void)calculateCountryAndCityId {
    
    BOOL found = FALSE;
    NSString *countryId;
    NSString *cityId;
    NSArray *arr;
    
    
    for (int i = 0; i < arrCountriesData.count;i++) {
        
        DDBase* obj = [arrCountriesData fetchObjectAtIndex:i];
        arr = ((NSSet*)[obj valueForKey:@"cities"]).allObjects;
        
        for (NSInteger j = 0; j<arr.count; j++) {
            DDBase* obj2 = [arr fetchObjectAtIndex:j];
            
            if ([obj2.valueName isEqualToString:city]) {
                
                cityId = obj2.valueID.stringValue;
                countryId = obj.valueID.stringValue;
                country = obj.valueName;
                cityCountryId = [NSString stringWithFormat:@"%@.%@",countryId,cityId];
                found = TRUE;
                break;
            };
        }
        
        if (found) {
            break;
        }
    }
}

#pragma mark - suggestours

- (AutocompletionTableView *)getautoCompleter
{
    
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:cityTxtFld inViewController:self withOptions:options withDefaultStyle:NO];
        _autoCompleter.autoCompleteDelegate = self;
        _autoCompleter.suggestionsDictionary = [self getSuggestors];
        
        
        [self.view addSubview:_autoCompleter];
        
        [self addconstaint];
        
    }
    return _autoCompleter;
}



-(void) addconstaint {
    
    NSLayoutConstraint *autoCompletionLeftConstraints = [NSLayoutConstraint constraintWithItem:_autoCompleter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    yForAutoCompletionTable = 44 + 23;
    
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
    NSMutableSet* suggestors = [NSMutableSet set];
    for (DDBase* obj in cityArr)
    {
        [suggestors addObject:obj.valueName];
    }
    
    return [suggestors allObjects];
}
#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    
    return  [self getSuggestors];
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText {
    
    city = [selectedText stringByReplacingOccurrencesOfString:@", " withString:@""];
    cityTxtFld.text = city;
}

-(void)showingTheOptions:(BOOL)status{
    
    [self hideSuggesterBackGrndView:status];
}

- (void)handleSingleTapOnSuggestorBackGrndView{
    
    [self hideSuggestorView];
}

-(void)hideSuggestorView{
    
    [cityTxtFld resignFirstResponder];
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
        tempFrame.origin.y = yPos;
        suggestorBackgroundView = [[UIView alloc] initWithFrame:tempFrame];
        suggestorBackgroundView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:suggestorBackgroundView belowSubview:_autoCompleter];
        [self.view bringSubviewToFront:_autoCompleter];
        [self hideSuggesterBackGrndView:NO];
        [suggestorBackgroundView setHidden:YES];
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

#pragma Mark -
#pragma Adding TextFiled in key skill tuple for handling the AutoSuggestor  delegate

-(void)addAutoCompleter{
    
    _autoCompleter = [self getautoCompleter];
    _autoCompleter.isMultiSelect = false;
    [cityTxtFld setClearButtonMode:UITextFieldViewModeWhileEditing];
    [cityTxtFld addTarget:_autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void) tocClicked {
    
    [self.view endEditing:YES];
    NGWebViewController *webView = (NGWebViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.isCloseBtnHidden = NO;
    [webView setNavigationTitle:@"Terms & Conditions" withUrl:TOC_URL];
    [(IENavigationController*)self.navigationController pushActionViewController:webView Animated:YES];
}

@end
