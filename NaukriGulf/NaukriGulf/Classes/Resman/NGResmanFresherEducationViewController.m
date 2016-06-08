//
//  NGResmanFresherEducationViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 1/21/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanFresherEducationViewController.h"
#import "NGValueSelectionViewController.h"
#import "NGResmanLastStepPersonalDetailViewController.h"
#import "NGResmanKeySkillsViewController.h"
#import "DDHighestEducation.h"
#import "DDUGCourse.h"
#import "DDPGCourse.h"
#import "DDPPGCourse.h"
#import "DDUGSpec.h"
#import "DDPGSpec.h"
#import "DDPPGSpec.h"


#define  DISABLED_CELL_COLOR [UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1.0f]
typedef enum : NSUInteger {
    CellTypePageHeading=0,
    CellTypeHighestEducation,
    CellTypePPGCourse,
    CellTypePPGSpecialization,
    CellTypePGCourse,
    CellTypePGSpecialization,
    CellTypeUGCourse,
    CellTypeUGSpecialization,
} CellType;


typedef enum : NSUInteger {
    HighestEducationTypeNone,
    HighestEducationTypeUG,
    HighestEducationTypePG,
    HighestEducationTypePPG,
} HighestEducationType;

@interface NGResmanFresherEducationViewController ()<ProfileEditCellDelegate,ValueSelectorDelegate>{
    
    NSMutableArray *ddContentArr;
    BOOL isValueSelectorExist; // Check isValueSelectorExist on right side of panel
    BOOL heightReduced;
}

@property (nonatomic, strong) NSMutableArray *fieldsArr;

@property(strong,nonatomic) NGResmanDataModel *resmanModel;

@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side

@end

@implementation NGResmanFresherEducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    heightReduced = FALSE;
    isValueSelectorExist    =   NO;
    
    [self setSaveButtonTitleAs:@"Next"];
    
    self.fieldsArr = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInteger:CellTypePageHeading],[NSNumber numberWithInteger:CellTypeHighestEducation], nil];
    
    self.isSwipePopDuringTransition = NO;
    self.isSwipePopGestureEnabled = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    
    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 1/3"];
    
    _resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    if (!_resmanModel) {
        _resmanModel = [[NGResmanDataModel alloc] init];
    }
    
    //if user already filled this page's date then
    //fetch that data from user profile and sync it with
    //resman model
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    [objModel createEducationList];
    if (nil!=objModel && ![objModel isKindOfClass:[NSNull class]]) {
        
        NSUInteger highestEducationFlag = HighestEducationTypeNone;
        
        for (NGEducationDetailModel *educationItemDataObject in objModel.educationList) {
            
            NSUInteger iHEFlag = highestEducationFlag;
            
            if ([educationItemDataObject.type isEqualToString:@"ppg"]) {
                _resmanModel.ppgCourse = educationItemDataObject.course;
                _resmanModel.ppgSpec = educationItemDataObject.specialization;
                
                iHEFlag = HighestEducationTypePPG;
                
            }else if ([educationItemDataObject.type isEqualToString:@"pg"]) {
                _resmanModel.pgCourse = educationItemDataObject.course;
                _resmanModel.pgSpec = educationItemDataObject.specialization;
                
                iHEFlag = HighestEducationTypePG;
                
            }else if ([educationItemDataObject.type isEqualToString:@"ug"]) {
                _resmanModel.ugCourse = educationItemDataObject.course;
                _resmanModel.ugSpec = educationItemDataObject.specialization;
                
                iHEFlag = HighestEducationTypeUG;
            }else{
                //dummy
            }
            
            if (HighestEducationTypeNone!=iHEFlag && iHEFlag > highestEducationFlag) {
                highestEducationFlag = iHEFlag;
            }
            
        }
        
        if (HighestEducationTypeNone!=highestEducationFlag) {
            //set id and value
            NSString *idString = [NSString stringWithFormat:@"%lu",(unsigned long)highestEducationFlag];
            
            [_resmanModel.highestEducation setCustomObject:idString forKey:KEY_ID];
            
            DDHighestEducation *ddHEdu = (DDHighestEducation*)[NGDatabaseHelper searchForType:KEY_ID havingValue:idString andDDType:DDC_HIGHEST_EDUCTAION].firstObject;
            
            [_resmanModel.highestEducation setCustomObject:ddHEdu.valueName forKey:KEY_VALUE];
        }
        
    }
    objModel = nil;
    
    
    if ([[_resmanModel.highestEducation objectForKey:KEY_ID] isEqualToString:@""]){
        [self refreshEducationTypeContentOnHighestEducation:HighestEducationTypeNone resetValues:NO];
    }
    else{
        [self refreshEducationTypeContentOnHighestEducation:[[_resmanModel.highestEducation objectForKey:KEY_ID] integerValue] resetValues:NO];
    }
    
    if (_resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_EDUCATION_FRESHER];
        self.title = @"Step 1/3";
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_EDUCATION_EXPERIENCED];
        self.title = @"2 more steps!";
    }
    
    //changed as per discussion
    if (!_resmanModel.isFresher && !heightReduced) {
        
        [self reduceTableHeightBy:40];
        heightReduced = TRUE;
        [self addSkipButton];
        [self.view layoutIfNeeded];
        
    }

    [NGDecisionUtility checkNetworkStatus];

}

-(void)viewDidAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    if (YES == _resmanModel.isFresher)
        [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageFresherEducationDetails];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*)checkAllValidations{
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (0 < [vManager validateValue:[_resmanModel.highestEducation objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Highest Education level"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[self.fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypeHighestEducation]]]];
    }
    
    if ([self.fieldsArr containsObject:[NSNumber numberWithInteger:CellTypeUGCourse]] && 0 < [vManager validateValue:[_resmanModel.ugCourse objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Basic Course"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[self.fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypeUGCourse]]]];
    }
    
    if ([self.fieldsArr containsObject:[NSNumber numberWithInteger:CellTypeUGSpecialization]] && 0 < [vManager validateValue:[_resmanModel.ugSpec objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Basic specialization"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[self.fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypeUGSpecialization]]]];
    }
    
    if ([self.fieldsArr containsObject:[NSNumber numberWithInteger:CellTypePGCourse]] && 0 < [vManager validateValue:[_resmanModel.pgCourse objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Masters Course"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[self.fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypePGCourse]]]];
    }
    
    if ([self.fieldsArr containsObject:[NSNumber numberWithInteger:CellTypePGSpecialization]] && 0 < [vManager validateValue:[_resmanModel.pgSpec objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
            [arr addObject:@"Masters Specialization"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[self.fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypePGSpecialization]]]];
    }
    
    if ([self.fieldsArr containsObject:[NSNumber numberWithInteger:CellTypePPGCourse]] && 0 < [vManager validateValue:[_resmanModel.ppgCourse objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Doctorate Course"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[self.fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypePPGCourse]]]];
    }
    
    if ([self.fieldsArr containsObject:[NSNumber numberWithInteger:CellTypePPGSpecialization]] && 0 < [vManager validateValue:[_resmanModel.ppgSpec objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
            [arr addObject:@"Doctorate Specialization"];
        [errorCellArr addObject:[NSNumber numberWithInteger:[self.fieldsArr indexOfObject:[NSNumber numberWithInt:CellTypePPGSpecialization]]]];
    }
    
    
    [self.editTableView reloadData];
    
    return arr;
}

-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
-(NSMutableDictionary*)getParametersInDictionary{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString* strHighestEduID = [_resmanModel.highestEducation objectForKey:KEY_ID];
    if ([strHighestEduID isEqualToString:@"1"])
        params = [self getDictForBasicEdu];
    else if ([strHighestEduID isEqualToString:@"2"])
        params = [self getDictForMasterEdu];
    else if ([strHighestEduID isEqualToString:@"3"])
        params = [self getDictForDoctEdu];

    return params;
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
        
        [[DataManagerFactory getStaticContentManager]saveResmanFields:_resmanModel];
        
        if (!_resmanModel.isFresher) {
            
            [self showAnimator];
            //make api call
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
            
            
        
            __weak NGResmanFresherEducationViewController *weakSelf = self;
            NSMutableDictionary *params = [self getParametersInDictionary];

            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf hideAnimator];
                    weakSelf.isRequestInProcessing = FALSE;
                    
                    if (responseInfo.isSuccess) {
                        
                        NGResmanLastStepPersonalDetailViewController *lastPersonalVc = [[NGResmanLastStepPersonalDetailViewController alloc] initWithNibName:nil bundle:nil];
                        [(IENavigationController*)self.navigationController pushActionViewController:lastPersonalVc Animated:YES];
                        return;

                        
                    }
                    
                });
            }];
            
        }
        else{
            
            NGResmanKeySkillsViewController *vc = [[NGResmanKeySkillsViewController alloc] init];
            [(IENavigationController*)self.navigationController pushActionViewController:vc Animated:YES];
        }
    }
}

-(NSMutableDictionary*) getDictForBasicEdu{
    
    NSMutableDictionary *eduDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *basicCourseParams =[[NSMutableDictionary alloc] init];
    
    [basicCourseParams setCustomObject:[_resmanModel.ugCourse objectForKey:KEY_ID] forKey:@"id"];
    [eduDict setCustomObject:basicCourseParams forKey:@"regUgCourse"];
    
    NSMutableDictionary *basicSpecParams =[[NSMutableDictionary alloc] init];
    
    [basicSpecParams setCustomObject:[NSString stringWithFormat:@"%@.%@",[_resmanModel.ugCourse objectForKey:KEY_ID],[_resmanModel.ugSpec objectForKey:KEY_ID]] forKey:@"id"];
  
    [eduDict setCustomObject:basicSpecParams forKey:@"regUgSpec"];
    
    return eduDict;

    
}

-(NSMutableDictionary*) getDictForMasterEdu{
    
    NSMutableDictionary *eduDict = [self getDictForBasicEdu];
    
    NSMutableDictionary *masterCourseParams =[[NSMutableDictionary alloc] init];
    
    [masterCourseParams setCustomObject:[_resmanModel.pgCourse objectForKey:KEY_ID] forKey:@"id"];
    [eduDict setCustomObject:masterCourseParams forKey:@"regPgCourse"];
    
    NSMutableDictionary *masterSpecParams =[[NSMutableDictionary alloc] init];
    
    [masterSpecParams setCustomObject:[NSString stringWithFormat:@"%@.%@",[_resmanModel.pgCourse objectForKey:KEY_ID],[_resmanModel.pgSpec objectForKey:KEY_ID]] forKey:@"id"];
    
    [eduDict setCustomObject:masterSpecParams forKey:@"regPgSpec"];
    
    return eduDict;
 
 
}


-(NSMutableDictionary*) getDictForDoctEdu{
    
    NSMutableDictionary *eduDict = [self getDictForMasterEdu];
    NSMutableDictionary *doctCourseParams =[[NSMutableDictionary alloc] init];
    
    [doctCourseParams setCustomObject:[_resmanModel.ppgCourse objectForKey:KEY_ID] forKey:@"id"];
    [eduDict setCustomObject:doctCourseParams forKey:@"regPpgCourse"];
    
    NSMutableDictionary *doctSpecParams =[[NSMutableDictionary alloc] init];
    
    [doctSpecParams setCustomObject:[NSString stringWithFormat:@"%@.%@",[_resmanModel.ppgCourse objectForKey:KEY_ID],[_resmanModel.ppgSpec objectForKey:KEY_ID]] forKey:@"id"];
    [eduDict setCustomObject:doctSpecParams forKey:@"regPpgSpec"];
    
    return eduDict;
}



/**
 *  Method updates the specializationTextfield withrespect to courseTextfield
 *
 *  @param courseName NSString consist of selected Course Name
 */
-(void)configureSpecializationDDWithCourseName:(NSString *)courseName ddCourseType:(NSInteger)ddCourseType courseTypeName:(NSString *)courseTypeName specType:(NSInteger)specType{
    
//    NSArray* arr = [NGDatabaseHelper searchForValue:courseName andDDType:(int)ddCourseType];
    
     NSArray* arr = [NGDatabaseHelper searchForType:KEY_VALUE havingValue:courseName
                                          andDDType:(int)ddCourseType];
    if (arr.count != 0) {
        
        DDBase* obj = [arr objectAtIndex:0];
        NSSet* specSet = [obj valueForKey:@"specs"];
        
        NSMutableArray *finalArr = [[NSMutableArray alloc]init];
        for (DDBase* obj in specSet)
            [finalArr addObject:obj];
        
        NSMutableDictionary *dict = [ddContentArr fetchObjectAtIndex:specType];
        [dict setCustomObject:arr forKey:KEY_DATAARRAY];
        [dict setCustomObject:finalArr forKey:K_DROPDOWN_CONTENT_ARRAY_SECTION1];
        
    }
}

-(void)refreshEducationTypeContentOnHighestEducation:(NSInteger)highestEducationID resetValues:(BOOL)isReset{
    
    
    [self.fieldsArr removeAllObjects];
    
    if (isReset) {
        [_resmanModel.ppgCourse setCustomObject:@"" forKey:KEY_ID];
        [_resmanModel.ppgCourse setCustomObject:@"" forKey:KEY_VALUE];
        [_resmanModel.ppgSpec setCustomObject:@"" forKey:KEY_ID];
        [_resmanModel.ppgSpec setCustomObject:@"" forKey:KEY_VALUE];
        [_resmanModel.pgCourse setCustomObject:@"" forKey:KEY_ID];
        [_resmanModel.pgCourse setCustomObject:@"" forKey:KEY_VALUE];
        [_resmanModel.pgSpec setCustomObject:@"" forKey:KEY_ID];
        [_resmanModel.pgSpec setCustomObject:@"" forKey:KEY_VALUE];
        [_resmanModel.ugCourse setCustomObject:@"" forKey:KEY_ID];
        [_resmanModel.ugCourse setCustomObject:@"" forKey:KEY_VALUE];
        [_resmanModel.ugSpec setCustomObject:@"" forKey:KEY_ID];
        [_resmanModel.ugSpec setCustomObject:@"" forKey:KEY_VALUE];
        
        [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:DDC_UGCOURSE],@"DropDownType",[NSArray array], @"SelectedValues",nil]];
        [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:DDC_PGCOURSE],@"DropDownType",[NSArray array], @"SelectedValues",nil]];
        [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:DDC_PPGCOURSE],@"DropDownType",[NSArray array], @"SelectedValues",nil]];
    }
    
    [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypePageHeading]];
    
    [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypeHighestEducation]];
    
    if (highestEducationID == HighestEducationTypeNone) {
        return;
    }
    
    switch (highestEducationID) {
        case HighestEducationTypePPG:{
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypePPGCourse]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypePPGSpecialization]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypePGCourse]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypePGSpecialization]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypeUGCourse]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypeUGSpecialization]];
            break;
        }
            
        case HighestEducationTypePG:{
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypePGCourse]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypePGSpecialization]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypeUGCourse]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypeUGSpecialization]];
            break;
        }
            
        case HighestEducationTypeUG:{
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypeUGCourse]];
            [self.fieldsArr addObject:[NSNumber numberWithInteger:CellTypeUGSpecialization]];
            break;
        }
            
        default:
            break;
    }
    
    [self.editTableView reloadData];
}


#pragma mark ValueSelector Delegate
/**
 *  @name Value Selector Delegate
 */
-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }
    [APPDELEGATE.container toggleRightSideMenuCompletion:^{
    }];
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
            
        case DDC_HIGHEST_EDUCTAION:{
            
            if (arrSelectedIds.count>0) {
                
                [self refreshEducationTypeContentOnHighestEducation:[[arrSelectedIds firstObject]integerValue] resetValues:YES];
                [_resmanModel.highestEducation setValue:[arrSelectedValues fetchObjectAtIndex:0] forKey:KEY_VALUE];
                [_resmanModel.highestEducation setValue:[arrSelectedIds fetchObjectAtIndex:0] forKey:KEY_ID];
                
            }else{
                
                [self refreshEducationTypeContentOnHighestEducation:HighestEducationTypeNone resetValues:YES];
                
                [_resmanModel.highestEducation setValue:@"" forKey:KEY_ID];
                [_resmanModel.highestEducation setValue:@"" forKey:KEY_VALUE];
                
            }
            
            break;
        }
            
        case DDC_UGCOURSE:{
            
            if (arrSelectedIds.count>0) {
                [_resmanModel.ugCourse setCustomObject:[arrSelectedValues fetchObjectAtIndex:0] forKey:KEY_VALUE] ;
                [_resmanModel.ugCourse setCustomObject:[arrSelectedIds fetchObjectAtIndex:0]
                                                forKey:KEY_ID] ;
                [self enableCell:CellTypeUGSpecialization];
                
                [self configureSpecializationDDWithCourseName:
                 [arrSelectedValues fetchObjectAtIndex:0] ddCourseType:DDC_UGCOURSE courseTypeName:@"Basic" specType:CellTypeUGSpecialization];
            }else{
                [_resmanModel.ugCourse setCustomObject:@"" forKey:KEY_VALUE] ;
                [_resmanModel.ugCourse setCustomObject:@"" forKey:KEY_ID] ;

                [self disableCell:CellTypeUGSpecialization];
                
            }
        
            [_resmanModel.ugSpec setCustomObject:[NSArray array] forKey:KEY_VALUE];
            [_resmanModel.ugSpec setCustomObject:[NSArray array] forKey:KEY_ID];
            
            [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInteger:DDC_UGSPEC],K_DROPDOWN_TYPE,
                                       [NSArray array], K_DROPDOWN_SELECTEDVALUES,nil]];
            
            
            break;
        }
            
        case DDC_UGSPEC:{
            if (arrSelectedIds.count>0) {
                [_resmanModel.ugSpec setCustomObject:[arrSelectedValues fetchObjectAtIndex:0]
                                              forKey:KEY_VALUE];
                [_resmanModel.ugSpec setCustomObject:[arrSelectedIds fetchObjectAtIndex:0]
                                              forKey:KEY_ID];
                
            }else{
                [_resmanModel.ugSpec setCustomObject:@"" forKey:KEY_VALUE];
                [_resmanModel.ugSpec setCustomObject:@"" forKey:KEY_ID];
            }
            
            break;
        }
            
        case DDC_PGCOURSE:{
            
            if (arrSelectedIds.count>0) {
                [_resmanModel.pgCourse setCustomObject:[arrSelectedValues fetchObjectAtIndex:0]
                                                forKey:KEY_VALUE];
                [_resmanModel.pgCourse setCustomObject:[arrSelectedIds fetchObjectAtIndex:0]
                                                forKey:KEY_ID];
                [self configureSpecializationDDWithCourseName:[arrSelectedValues fetchObjectAtIndex:0] ddCourseType:DDC_PGCOURSE courseTypeName:@"Masters" specType:CellTypePGSpecialization];
                [self enableCell:CellTypePGSpecialization];
                
            }else{
                [_resmanModel.pgCourse setCustomObject:@"" forKey:KEY_VALUE] ;
                [_resmanModel.pgCourse setCustomObject:@"" forKey:KEY_ID];
                [self disableCell:CellTypePGSpecialization];
                
            }
            
            
            [_resmanModel.pgSpec setCustomObject:[NSArray array] forKey:K_DROPDOWN_SELECTEDVALUES];
            [_resmanModel.pgSpec setCustomObject:[NSArray array] forKey:K_DROPDOWN_SELECTEDIDS];
            [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInteger:DDC_PGSPEC],K_DROPDOWN_TYPE,
                                       [NSArray array], K_DROPDOWN_SELECTEDVALUES,nil]];
            
            
            break;
        }
            
        case DDC_PGSPEC:{
            if (arrSelectedIds.count>0) {
                [_resmanModel.pgSpec setCustomObject:[arrSelectedValues fetchObjectAtIndex:0]
                                              forKey:KEY_VALUE];
                [_resmanModel.pgSpec setCustomObject:[arrSelectedIds fetchObjectAtIndex:0]
                                              forKey:KEY_ID];
                
            }else{
                [_resmanModel.pgSpec setCustomObject:@"" forKey:KEY_VALUE];
                [_resmanModel.pgSpec setCustomObject:@"" forKey:KEY_ID] ;

            }
            
            break;
        }
            
        case DDC_PPGCOURSE:{
            
            if (arrSelectedIds.count>0) {
                [_resmanModel.ppgCourse setCustomObject:[arrSelectedValues fetchObjectAtIndex:0]
                                                 forKey:KEY_VALUE] ;
                [_resmanModel.ppgCourse setCustomObject:[arrSelectedIds fetchObjectAtIndex:0]
                                                 forKey:KEY_ID];
                [self enableCell:CellTypePPGSpecialization];
                [self configureSpecializationDDWithCourseName:[arrSelectedValues fetchObjectAtIndex:0] ddCourseType:DDC_PPGCOURSE courseTypeName:@"Doctorate" specType:CellTypePPGSpecialization];
            }else{
                
                [_resmanModel.ppgCourse setCustomObject:@"" forKey:KEY_VALUE] ;
                [_resmanModel.ppgCourse setCustomObject:@"" forKey:KEY_ID] ;
                [self disableCell:CellTypePPGSpecialization];
            }
            
            
            [_resmanModel.ppgSpec setCustomObject:[NSArray array] forKey:KEY_VALUE];
            [_resmanModel.ppgSpec setCustomObject:[NSArray array] forKey:KEY_ID];
            [self handleDDOnSelection:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInteger:DDC_PPGSPEC],K_DROPDOWN_TYPE,
                                       [NSArray array], K_DROPDOWN_SELECTEDVALUES,nil]];
            
            
            break;
        }
            
        case DDC_PPGSPEC:{
            if (arrSelectedIds.count>0) {
                [_resmanModel.ppgSpec setCustomObject:[arrSelectedValues fetchObjectAtIndex:0]
                                                                                forKey:KEY_VALUE];
                [_resmanModel.ppgSpec setCustomObject:[arrSelectedIds fetchObjectAtIndex:0]
                                                                                forKey:KEY_ID];
                
            }else{
                [_resmanModel.ppgSpec setCustomObject:@"" forKey:KEY_VALUE];
                [_resmanModel.ppgSpec setCustomObject:@"" forKey:KEY_ID] ;

            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark UITableview Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.fieldsArr.count;
}

-(NGCustomValidationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    return cell;
}

-(NGCustomValidationCell *)configureCell:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:@""];
        if (cell == nil)
        {
            cell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            txtLabel.textAlignment = NSTextAlignmentCenter;
            [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
            txtLabel.text =@"Your Education Details";
            txtLabel.textColor = [UIColor darkGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:txtLabel];
            return cell;
        }
    }
    static NSString* cellIndentifier = @"EditProfileCell";
    
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = k_RESMAN_PAGE_EDUCATION;
    cell.delegate = self;
    
    [cell.txtTitle setTextColor:[UIColor darkTextColor]];
    [cell.lblOtherTitle setTextColor:[UIColor darkGrayColor]];
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    cell.otherDataStr = nil;
    
    CellType type = [[self.fieldsArr fetchObjectAtIndex:indexPath.row]integerValue];
    
    switch (type) {
        case CellTypeHighestEducation:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[_resmanModel.highestEducation objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EDUCATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            
            break;
        }
            
        case CellTypePPGCourse:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[_resmanModel.ppgCourse objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EDUCATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            break;
        }
            
        case CellTypePPGSpecialization:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[_resmanModel.ppgSpec objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[_resmanModel.ppgCourse objectForKey:KEY_VALUE] forKey:@"ppgCourse"];

            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EDUCATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            break;
        }
            
        case CellTypePGCourse:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[_resmanModel.pgCourse objectForKey:KEY_VALUE] forKey:@"data"];
            
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EDUCATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            
            break;
        }
            
        case CellTypePGSpecialization:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[_resmanModel.pgSpec objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[_resmanModel.pgCourse objectForKey:KEY_VALUE] forKey:@"pgCourse"];

            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EDUCATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            break;
        }
            
        case CellTypeUGCourse:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[_resmanModel.ugCourse objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EDUCATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            
            break;
        }
            
        case CellTypeUGSpecialization:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[_resmanModel.ugSpec objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[_resmanModel.ugCourse objectForKey:KEY_VALUE] forKey:@"ugCourse"];

            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EDUCATION] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:type];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    isValueSelectorExist = YES;
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
    _valueSelector.delegate = self;
    [APPDELEGATE.container setRightMenuViewController:_valueSelector];
    APPDELEGATE.container.rightMenuPanEnabled = NO;

    
    if (indexPath.row != 0) {
        
        CellType type = [[self.fieldsArr fetchObjectAtIndex:indexPath.row]integerValue];
        NSString *accessibilityValue = @"education";
        
        switch (type) {
                
            case CellTypeHighestEducation:{
                
                accessibilityValue = @"HighestEducation";
                if(0>=[vManager validateValue:[_resmanModel.highestEducation objectForKey:KEY_ID]
                                     withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                       [_resmanModel.highestEducation
                                                        objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                _valueSelector.dropdownType = DDC_HIGHEST_EDUCTAION;
                [_valueSelector displayDropdownData];

            }
                break;
                
            case CellTypePPGCourse:{
                accessibilityValue = @"PPGCourse";
                if(0>=[vManager validateValue:[_resmanModel.ppgCourse objectForKey:KEY_ID]
                                     withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                       [_resmanModel.ppgCourse objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                _valueSelector.dropdownType = DDC_PPGCOURSE;
                [_valueSelector displayDropdownData];
            }
                break;
                
            case CellTypePPGSpecialization:{
                accessibilityValue = @"PPGSpecialization";
                if(0>=[vManager validateValue:[_resmanModel.ppgSpec objectForKey:KEY_ID]
                                     withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                       [_resmanModel.ppgSpec objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                
                DDBase* obj = [[NGDatabaseHelper searchForType:KEY_VALUE havingValue:
                                            [_resmanModel.ppgCourse objectForKey:KEY_VALUE]
                                        andClass:[DDPPGCourse class]] fetchObjectAtIndex:0];
                _valueSelector.objDDBase = obj;
                _valueSelector.dropdownType = DDC_PPGSPEC;
                [_valueSelector displayDropdownData];
            }

                break;
                
            case CellTypePGCourse:{
                accessibilityValue = @"PGCourse";
                if(0>=[vManager validateValue:[_resmanModel.pgCourse objectForKey:KEY_ID] withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                       [_resmanModel.pgCourse objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

               
                _valueSelector.dropdownType = DDC_PGCOURSE;
                [_valueSelector displayDropdownData];

            }

                break;
                
            case CellTypePGSpecialization:{
                
                accessibilityValue = @"PGSpecialization";
                if(0>=[vManager validateValue:[_resmanModel.pgSpec objectForKey:KEY_ID] withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                       [_resmanModel.pgSpec objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                
                DDBase* obj = [[NGDatabaseHelper searchForType:KEY_VALUE havingValue:
                                            [_resmanModel.pgCourse objectForKey:KEY_VALUE]
                                                      andClass:[DDPGCourse class]] fetchObjectAtIndex:0];
                _valueSelector.objDDBase = obj;
                _valueSelector.dropdownType = DDC_PGSPEC;
                [_valueSelector displayDropdownData];
                
            }

                
                break;
                
            case CellTypeUGCourse:{
                
                accessibilityValue = @"UGCourse";
                if(0>=[vManager validateValue:[_resmanModel.ugCourse objectForKey:KEY_ID]
                                                    withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                       [_resmanModel.ugCourse objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                
                _valueSelector.dropdownType = DDC_UGCOURSE;
                [_valueSelector displayDropdownData];

            }

                break;
                
            case CellTypeUGSpecialization:{
                accessibilityValue = @"UGSpecialization";
                if(0>=[vManager validateValue:[_resmanModel.ugSpec objectForKey:KEY_ID]
                                     withType:ValidationTypeString].count)
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                       [_resmanModel.ugSpec objectForKey:KEY_ID]];
                else
                    _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                        @""];

                
                DDBase* obj = [[NGDatabaseHelper searchForType:KEY_VALUE havingValue:
                                [_resmanModel.ugCourse objectForKey:KEY_VALUE]
                                                andClass:[DDUGCourse class]] fetchObjectAtIndex:0];
                _valueSelector.objDDBase = obj;
                _valueSelector.dropdownType = DDC_UGSPEC;
                [_valueSelector displayDropdownData];
            }
                
                break;
                
            default:
                break;
                
        }

        [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
        [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:
                                        @"%@_selection_tableview",accessibilityValue] forUIElement:_valueSelector.contentTableView withAccessibilityEnabled:NO];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 50;
    }
    return 75;
}

-(void) skipButtonPressed:(id) sender {
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_SKIP_EDUCATION_EXPERIENCED withEventLabel:K_GA_RESMAN_EVENT_SKIP_EDUCATION_EXPERIENCED withEventValue:nil];
    
    [NGUIUtility showAlertWithTitle:nil withMessage:[NSArray arrayWithObjects:@"Education details are of great importance for Employers. Are you sure you want to skip?", nil]
                withButtonsTitle:@"No,Yes" withDelegate:self];

}


-(void)customAlertbuttonClicked:(NSInteger)index{
    
    if (index == 1){
       
        NGResmanLastStepPersonalDetailViewController *lastPersonalVc = [[NGResmanLastStepPersonalDetailViewController alloc] initWithNibName:nil bundle:nil];
        [(IENavigationController*)self.navigationController pushActionViewController:lastPersonalVc Animated:YES];
    }
}



-(void) enableCell : (CellType) cellType{
    
    [self setColor:[UIColor blackColor] forCell:cellType];
}


-(void) disableCell : (CellType) cellType{
    [self setColor:DISABLED_CELL_COLOR forCell:cellType];
}

-(void) setColor:(UIColor*) color forCell :(CellType) cellType{
    
     NGProfileEditCell *cell;
    
    switch (cellType) {
        case CellTypeUGSpecialization:{
            
            cell = (NGProfileEditCell*)[self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.fieldsArr indexOfObject:[NSNumber numberWithInteger:CellTypeUGSpecialization]] inSection:0]];
            
        }
            break;
        case CellTypePGSpecialization:{
            cell = (NGProfileEditCell*)[self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.fieldsArr indexOfObject:[NSNumber numberWithInteger:CellTypePGSpecialization]] inSection:0]];
          
        }
            break;
        case  CellTypePPGSpecialization:{
            
            cell = (NGProfileEditCell*)[self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.fieldsArr indexOfObject:[NSNumber numberWithInteger:CellTypePPGSpecialization]] inSection:0]];
            
        }
            break;
        default:
            break;
    }
    
    cell.lblPlaceHolder.textColor = color;
    if ([color isEqual:[UIColor blackColor]]) {
        
        cell.userInteractionEnabled = TRUE;
    }else{
        
        cell.userInteractionEnabled = FALSE;
    }
}
@end
