//
//  NGEditDesiredJobsViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/20/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditDesiredJobsViewController.h"
#import "NGValueSelectionViewController.h"
#import "DDPrefLocation.h"
#import "DDEmploymentStatus.h"
#import "DDJobType.h"


@interface NGEditDesiredJobsViewController ()<ValueSelectorDelegate>{
    
    NSString *employmentStatus;
    NSString *employmentType;
    BOOL isValueSelectorExist;
    
    NSMutableDictionary* dictPreferredLocation;
    NSMutableDictionary* dictEmploymentStatus;
    NSMutableDictionary* dictEmploymentType;
    
   BOOL isInitialParamDictUpdated;
}

@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side

@end

@implementation NGEditDesiredJobsViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavBarWithTitle:@"Desired Job"];
    self.editTableView.scrollEnabled = NO;
    dictPreferredLocation = [NSMutableDictionary dictionary];
    dictEmploymentStatus = [NSMutableDictionary dictionary];
    dictEmploymentType = [NSMutableDictionary dictionary];
    
    isInitialParamDictUpdated = NO;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
}
-(void) viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    [super viewWillAppear:animated];
    self.isRequestInProcessing = NO;
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
    
    [UIAutomationHelper setAccessibiltyLabel:@"editDesiredJob_table" forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
    
}
-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
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
    cell.editModuleNumber = K_EDIT_DESIRED_JOB;
    cell.delegate = self;
    
    NSInteger row = indexPath.row;
    
    switch (row) {
            
        case ROW_TYPE_PREFERRED_LOCATION:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictPreferredLocation objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_DESIRED_JOB] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            break;
        }
        case ROW_TYPE_EMPLOYMENT_STATUS:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictEmploymentStatus objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_DESIRED_JOB] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];
            break;
        }
        case ROW_TYPE_EMPLOYMENT_TYPE:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[dictEmploymentType objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",K_EDIT_DESIRED_JOB] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:row];

            break;
            
        }
            
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.view endEditing:YES];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    isValueSelectorExist = YES;
    if(!_valueSelector)
    _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
        _valueSelector.delegate = self;
   
    [APPDELEGATE.container setRightMenuViewController:_valueSelector];
    APPDELEGATE.container.rightMenuPanEnabled = NO;
    
    int ddType = 0;
    switch (indexPath.row) {
            
        case ROW_TYPE_PREFERRED_LOCATION:{
            
            ddType = DDC_PREFRENCE_LOCATION;
            if(0>=[vManager validateValue:[dictPreferredLocation objectForKey:KEY_ID] withType:ValidationTypeArray].count)
                _valueSelector.arrPreSelectedIds = [dictPreferredLocation objectForKey:KEY_ID];
            
        }
            break;
            
        case ROW_TYPE_EMPLOYMENT_STATUS:{
            
            ddType = DDC_EMPLOYMENT_STATUS;
            if(0>=[vManager validateValue:[dictEmploymentStatus objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [dictEmploymentStatus objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

        }
            break;
            
        case ROW_TYPE_EMPLOYMENT_TYPE:{
            ddType = DDC_JOBTYPE;
            if(0>=[vManager validateValue:[dictEmploymentType objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [dictEmploymentType objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            
        }
            break;
            
            
        default:
            break;
    }
    
    _valueSelector.dropdownType = ddType;
    [_valueSelector displayDropdownData];

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
            
        case DDC_PREFRENCE_LOCATION:{
            
            if (arrSelectedIds) {
                
                [dictPreferredLocation setCustomObject:[NSString getStringsFromArray:arrSelectedValues] forKey:KEY_VALUE];
                [dictPreferredLocation setCustomObject:[arrSelectedIds copy] forKey:KEY_ID];

                
            }
            break;
        }
            
            
        case DDC_JOBTYPE:{
            
            if (arrSelectedIds.count>0) {
                
                [dictEmploymentType setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
                [dictEmploymentType setCustomObject:[arrSelectedIds firstObject] forKey:KEY_ID];
                
            }else{
                [dictEmploymentType setCustomObject:@"" forKey:KEY_VALUE];
                [dictEmploymentType setCustomObject:@"" forKey:KEY_ID];
            }
        
            break;
        }
            
        case DDC_EMPLOYMENT_STATUS:{
            
            if (arrSelectedIds.count>0) {
                
            [dictEmploymentStatus setCustomObject:[arrSelectedValues firstObject] forKey:KEY_VALUE];
            [dictEmploymentStatus setCustomObject:[arrSelectedIds firstObject] forKey:KEY_ID];
                
            }else{
                [dictEmploymentStatus setCustomObject:@"" forKey:KEY_VALUE];
                [dictEmploymentStatus setCustomObject:@"" forKey:KEY_ID];
            }
            break;
        }
            
        default:
            break;
    }
    
    [self.editTableView reloadData];

}

/**
*  @name Public Method
*/
/**
 *  Public Method initiated on view appear and updates the textfield Values with NGMNJProfileModalClass object
 *
 *  @param obj a JsonModelObject contains predefined value for textField
 */
-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj{
    
    self.modalClassObj = obj;
    
    NSArray *ddNameArr = [NSArray arrayWithObjects:self.modalClassObj.employmentType,self.modalClassObj.employmentStatus, nil];
    
    NSArray *ddTypeArr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:DDC_JOBTYPE],[NSNumber numberWithInteger:DDC_EMPLOYMENT_STATUS], nil];
    
    for (NSInteger i = 0; i<ddNameArr.count; i++) {
        NSDictionary *ddName = [ddNameArr fetchObjectAtIndex:i];
        NSNumber *ddType = [ddTypeArr fetchObjectAtIndex:i];
        
        if (![[ddName objectForKey:KEY_VALUE]isEqualToString:@""]) {
            [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                                       ddType,K_DROPDOWN_TYPE,
                                       [NSArray arrayWithObjects:[ddName objectForKey:KEY_ID], nil], K_DROPDOWN_SELECTEDIDS,
                                       [NSArray arrayWithObjects:[ddName objectForKey:KEY_VALUE], nil], K_DROPDOWN_SELECTEDVALUES,
                                       nil]];
        }
        
    }
    
    if(0>=[[ValidatorManager sharedInstance] validateValue:[_modalClassObj.preferredWorkLocation objectForKey:KEY_VALUE] withType:ValidationTypeString].count){
        
        NSArray *arrValues = [[self.modalClassObj.preferredWorkLocation objectForKey:KEY_VALUE] componentsSeparatedByString:@","];
        
        NSMutableArray *arrSelectedValues = [NSMutableArray array];
        
        for (NSString *str in arrValues) {
            
            NSString *trimmedString = [str trimCharctersInSet :
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (![trimmedString isEqualToString:@""])
                [arrSelectedValues addObject:trimmedString];
            
        }
        
        
        NSArray *arrIds = [[self.modalClassObj.preferredWorkLocation objectForKey:KEY_ID] componentsSeparatedByString:@","];
        
        NSMutableArray *arrSelectedIds = [NSMutableArray array];
        
        for (NSString *str in arrIds) {
            
            NSString *trimmedString = [str trimCharctersInSet :
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (![trimmedString isEqualToString:@""])
                [arrSelectedIds addObject:trimmedString];
            
        }
        
        [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:DDC_PREFRENCE_LOCATION],K_DROPDOWN_TYPE,
                                   arrSelectedValues ,K_DROPDOWN_SELECTEDVALUES,
                                   arrSelectedIds, K_DROPDOWN_SELECTEDIDS,
                                   nil]];
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
    
    //EMPLOYMENT STATUS
    
    NSString* selectedId = [dictEmploymentStatus objectForKey:KEY_ID];
    if (selectedId)
        [params setCustomObject:selectedId forKey:@"employmentStatus"];
    else
        [params setCustomObject:@"0" forKey:@"employmentStatus"];
    
    //EMPLOYMENT TYPE
    selectedId = [dictEmploymentType objectForKey:KEY_ID];
    
    if (selectedId)
        [params setCustomObject:selectedId
                         forKey:@"employmentType"];
    else
        [params setCustomObject:@"0" forKey:@"employmentType"];
    
    
    NSArray* arrSelectedIds = [dictPreferredLocation objectForKey:KEY_ID];
    if (arrSelectedIds && arrSelectedIds.count>0) {
        NSMutableArray *finalArr = [NSMutableArray arrayWithArray:arrSelectedIds];
        [finalArr removeDuplicateObjects];
        [params setCustomObject:[NSString getStringsFromArrayWithoutSpace:finalArr] forKey:@"preferredWorkLocation"];
    }else
        [params setCustomObject:@"0" forKey:@"preferredWorkLocation"];
    
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    return params;
}
-(void)onSave:(id)sender{
    
    [self.view endEditing:YES];

        if (!self.isRequestInProcessing) {
            [self setIsRequestInProcessing:YES];
            
            [self showAnimator];
            

            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EDIT_PROFILE withEventLabel:K_GA_EVENT_EDIT_PROFILE withEventValue:nil];
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
            
    
      
            
            __weak NGEditDesiredJobsViewController *weakSelf = self;
            NSMutableDictionary *params =[self updateTheRequestParameterForSendingInitialValueOfChanges:[self getParametersInDictionary]];

            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf hideAnimator];
                    weakSelf.isRequestInProcessing = FALSE;
                    
                    if (responseInfo.isSuccess) {
                        [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                        [weakSelf.editDelegate editedDesiredJobWithSuccess:YES];
                    }
                    
                });
                
            }];
            
        }
}

#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
    [self.editDelegate editedDesiredJobWithSuccess:YES];
    [self hideAnimator];
    self.isRequestInProcessing = NO;
}
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [self hideAnimator];
    self.isRequestInProcessing = NO;
}


-(void) dealloc {
    
    self.modalClassObj = nil;
    
}

@end
