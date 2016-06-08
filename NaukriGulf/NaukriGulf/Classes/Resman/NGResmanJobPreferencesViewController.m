//
//  NGResmanJobPreferencesViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/13/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanJobPreferencesViewController.h"
#import "NGResmanDLVisaViewController.h"
#import "NGValueSelectionViewController.h"
#import "DDPrefLocation.h"
#import "DDNoticePeriod.h"

enum{
    
    ROW_TYPE_PREFERRED_LOCATION,
    ROW_TYPE_AVAILIBILITY_TO_JOIN
};

@interface NGResmanJobPreferencesViewController ()<ProfileEditCellDelegate,ValueSelectorDelegate>{
    
    NGAppDelegate *appDelegate;
    NGResmanDataModel *resmanModel;
    NSMutableArray *cellsArr;
}
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side


@end

@implementation NGResmanJobPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSaveButtonTitleAs:@"Next"];
    appDelegate = (NGAppDelegate*)[NGAppDelegate appDelegate];
    cellsArr = [[NSMutableArray alloc] init];
    [self.editTableView setScrollEnabled:FALSE];
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    
    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Add More Details"];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    if (!resmanModel) {
        resmanModel = [[NGResmanDataModel alloc] init];
    }
    
    //if user already filled this page's date then
    //fetch that data from user profile and sync it with
    //resman model
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    if (nil!=objModel && ![objModel isKindOfClass:[NSNull class]]) {
        
        if ([NGDecisionUtility isValidDropDownItem:objModel.preferredWorkLocation]) {
            resmanModel.preferredLoc = [NSMutableDictionary dictionaryWithDictionary:[objModel.preferredWorkLocation copy]];
        }
        
        if ([NGDecisionUtility isValidDropDownItem:objModel.noticePeriod]) {
            resmanModel.availabilityToJoin = [NSMutableDictionary dictionaryWithDictionary:[objModel.noticePeriod copy]];
        }
    }
    objModel = nil;
    
    [NGDecisionUtility checkNetworkStatus];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    
    switch (indexPath.row) {
            
        case ROW_TYPE_PREFERRED_LOCATION:{
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.delegate = self;
            
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[resmanModel.preferredLoc objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_JOB_PREFERENCES_VC] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:indexPath.row];
            return cell;
            
        }
            
        case ROW_TYPE_AVAILIBILITY_TO_JOIN :{
            
            NSString* cellIndentifier = @"EditProfileCell";
            NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.delegate = self;
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[resmanModel.availabilityToJoin objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_JOB_PREFERENCES_VC] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:indexPath.row];
            return cell;
            
            
        }
            
            
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self.editTableView deselectRowAtIndexPath:indexPath animated:YES];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    //_valueSelector = nil;
    if(!_valueSelector)
        _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
    _valueSelector.delegate = self;
    
    [APPDELEGATE.container setRightMenuViewController:_valueSelector];
    APPDELEGATE.container.rightMenuPanEnabled = NO;
    
    
    switch (indexPath.row) {
            
        case ROW_TYPE_PREFERRED_LOCATION:{
            
            NSString *idString = [resmanModel.preferredLoc objectForKey:KEY_ID];
            if(0>=[vManager validateValue:idString withType:ValidationTypeString].count && 0<idString.length)
                
                
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithArray:[idString componentsSeparatedByString:@","]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_PREFRENCE_LOCATION;
            [_valueSelector displayDropdownData];
            break;
        }
            
            
        case ROW_TYPE_AVAILIBILITY_TO_JOIN:{
            if(0>=[vManager validateValue:[resmanModel.availabilityToJoin objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                   [resmanModel.availabilityToJoin objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_NOTICE_PERIOD;
            [_valueSelector displayDropdownData];
            break;
            
        }
            
    }
    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
}


-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    
    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }
    [self.editTableView reloadData];
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
            
            if (arrSelectedIds.count>0) {
                
                [resmanModel.preferredLoc setCustomObject:[NSString getStringsFromArray:arrSelectedValues] forKey:KEY_VALUE];
                NSString *idString = [arrSelectedIds componentsJoinedByString:@","];
                [resmanModel.preferredLoc setCustomObject:idString forKey:KEY_ID];
                
                
            }else{
                [resmanModel.preferredLoc setCustomObject:@"" forKey:KEY_VALUE];
                [resmanModel.preferredLoc setCustomObject:@"" forKey:KEY_ID];
            }
            
            
            break;
        }
            
        case DDC_NOTICE_PERIOD:{
            
            if (arrSelectedIds.count>0) {
                [resmanModel.availabilityToJoin setCustomObject:
                 [arrSelectedValues fetchObjectAtIndex:0] forKey:KEY_VALUE];
                [resmanModel.availabilityToJoin setCustomObject:
                 [arrSelectedIds fetchObjectAtIndex:0] forKey:KEY_ID];
                
            }else{
                [resmanModel.availabilityToJoin setCustomObject:@"" forKey:KEY_VALUE];
                [resmanModel.availabilityToJoin setCustomObject:@"" forKey:KEY_ID];
                
            }
            
            break;
        }
            
            
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
-(NSMutableDictionary*)getParametersInDictionary{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //PREFERRED WORK
    NSString *strIds = [resmanModel.preferredLoc objectForKey:KEY_ID];
    
    if (strIds.length>0) {
        [params setCustomObject:strIds forKey:@"preferredWorkLocation"];
    }else
        [params setCustomObject:@"0" forKey:@"preferredWorkLocation"];
    
    
    //AVAILABILITY TO JOIN
    strIds = [resmanModel.availabilityToJoin objectForKey:KEY_ID];
    if (strIds.length>0)
        [params setCustomObject:strIds forKey:@"noticePeriod"];
    else
        [params setCustomObject:@" " forKey:@"noticePeriod"];
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];

    return params;
    
}
- (void)saveButtonTapped:(id)sender{
    
    NSString *errorTitle;
    [self.view endEditing:YES];
    
    NSMutableArray* arrValidations = [self checkValidations];
    if (!errorTitle.length)
        errorTitle = @"Incomplete Details!";
    
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
        
    }
    else{
        
        [self showAnimator];
        
        [[DataManagerFactory getStaticContentManager]saveResmanFields:resmanModel];
        
        __weak NGResmanJobPreferencesViewController *weakSelf = self;
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
        
        NSMutableDictionary *params = [self getParametersInDictionary];

        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hideAnimator];
                
                if (responseInfo.isSuccess) {
                    
                    NGResmanDLVisaViewController *dlVisaVc = [[NGResmanDLVisaViewController alloc] initWithNibName:nil bundle:nil];
                    [(IENavigationController*)self.navigationController pushActionViewController:dlVisaVc Animated:YES];
                    
                }else{
                    
                    NSString *errorMsg = @"Some problem occurred at server";
                    
                    [NGUIUtility showAlertWithTitle:@"Error" withMessage:[NSArray arrayWithObject:errorMsg] withButtonsTitle:@"Ok" withDelegate:nil];
                }
                
            });
        }];
    }
}

-(NSMutableArray*) checkValidations{
    
    NSMutableArray *arr = [NSMutableArray array];
    [errorCellArr removeAllObjects];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if ((0 < [vManager validateValue:[resmanModel.availabilityToJoin objectForKey:KEY_VALUE] withType:ValidationTypeString].count) && (0 < [vManager validateValue:[resmanModel.availabilityToJoin objectForKey:KEY_ID] withType:ValidationTypeString].count)) {
        
        [arr addObject:@"Notice Period"];
        [errorCellArr addObject:[NSNumber numberWithInt:ROW_TYPE_AVAILIBILITY_TO_JOIN]];
    }
    
    if ((0 < [vManager validateValue:[resmanModel.preferredLoc objectForKey:KEY_VALUE] withType:ValidationTypeString].count) && (0 < [vManager validateValue:[resmanModel.preferredLoc objectForKey:KEY_ID] withType:ValidationTypeString].count)) {
        
        [arr addObject:@"Preferred Job Locations"];
        [errorCellArr addObject:[NSNumber numberWithInt:ROW_TYPE_PREFERRED_LOCATION]];
    }
    
    [self.editTableView reloadData];
    return arr;
}

@end