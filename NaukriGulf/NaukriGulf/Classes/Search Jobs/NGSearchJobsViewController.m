//
//  NGSearchJobsViewController.m
//  Naukri
//
//  Created by Arun Kumar on 15/01/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGSearchJobsViewController.h"
#import "NGSearchSobExperianceTupple.h"
#import "NGRecentSearchTupple.h"
#import "NGSRPViewController.h"
#import "AutocompletionTableView.h"
#import "NGModifySearchSaveAlertButtonTupple.h"
#import "DDFArea.h"
#import "DDIndustryType.h"
#import "DDExpYear.h"
#import "DDLocation.h"
#import "NGBlockThisIPView.h"

enum{
    
    Textfield_Type_JobSkill = 100,
    Textfield_Type_Location_Other = 101,
    Textfield_Type_CreateJobAlertName
};

//Textfield tags for modify search
typedef enum{
    ModifySearchTextfieldTagSkills = 100,
    ModifySearchTextfieldTagLocation = 101,
    ModifySearchTextfieldTagExperience = 102,
    ModifySearchTextfieldTagDepartment = 103,
    ModifySearchTextfieldTagIndustry = 104
}ModifySearchTextfieldTag;

NSInteger const K_RECENT_SERACH_HEADER_HEIGHT = 41;
//NSInteger const K_KEYSKILL_TEXTFIELD_HEIGHT     = 20;
NSInteger const K_EXPERIENCE_SCROLLER_HEIGHT  = 110;
NSString* const K_SALARY_SEPERATOR1 = @" Lakhs per annum";
NSString* const K_SALARY_SEPERATOR2 = @" Lakh per annum";
NSString* const K_ALERT_SALARY_SEPERATOR = @" Lakhs pe";

static NSString* searchCellIndentifier = @"SearchJobsTupple";
static NSString *recentCellIdentifier = @"RecentSearchTupple";


@interface NGSearchJobsViewController () < UITextFieldDelegate,NGSearchJobParameterDelegate,AutocompletionTableViewDelegate,NGModifySearchSaveAlertButtonTuppleDelegate >{
    
    NSMutableArray* arrRecentSearches;
    UIView *suggestorBackgroundView;
    UIView *keySkillCellBAckGrndView;
    BOOL bExperienceSet;
    
    NSIndexPath *currentSelectedIndexPath;
    float tableViewExtraScrollingContentInsect;
    
    NSMutableArray* dropdownItems;
    NSString *currentUserSelectedLocation;
    NSString *currentUserSelectedKeyJobs;
    NSString *currentUserSelectedMinSalary;
    NSInteger currentUserSelectedExp;
    NSString *previouslySelectedExperience;
    
    BOOL bIsExperienceDelegateCalled;
    
    NSString *currentUserLocationOther;
    
    NSString *minSalarySelected;
    
    NSInteger noOfRowsInSectionZero;
    
    NGAppDelegate *appDelegate;
    
    NSLayoutConstraint *autoCompletionHeightConstraints;
    
    NSMutableDictionary *recentSearchKeyAndRow;
    
    //Modify Search variables
    NSString *modifySearch_UserSelectedSkills;
    NSString *modifySearch_UserSelectedLocation;
    NSString *modifySearch_UserSelectedExperience;
    NSString *modifySearch_UserSelectedDepartment;
    NSString *modifySearch_UserSelectedIndustry;
    
    NSArray *searchKeyWordSuggestorData;
    
    NSMutableDictionary* dictLocation;
    NSMutableDictionary* dictFarea;
    NSMutableDictionary* dictExperience;
    NSMutableDictionary* dictIndustryType;
    
    
    BOOL isBlockIPViewShowing;
    
    
}
@property (weak, nonatomic)  UITextField *txtFieldKeywords;
@property (weak, nonatomic)  UITextField *txtFldOtherLoc;
@property (weak, nonatomic) UITextField *alertNameKeywordLessCriteria;
@property (weak, nonatomic) UITextField *alertNameKeywordMoreCriteria;
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (weak, nonatomic) IBOutlet UITableView* tblSearchJobParametersAndResult;
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side


@end

@implementation NGSearchJobsViewController

@synthesize autoCompleter = _autoCompleter;
@synthesize classType = _classType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _classType = K_CLASS_SEARCH_JOBS;
        _comingVia = nil;
        _inputParams = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppTracer traceStartTime:TRACER_ID_SEARCH_JOBS];
    
    appDelegate = APPDELEGATE;
    
    dropdownItems=[[NSMutableArray alloc] init];
    
    dictExperience = [NSMutableDictionary dictionary];
    dictFarea = [NSMutableDictionary dictionary];
    dictIndustryType = [NSMutableDictionary dictionary];
    dictLocation = [NSMutableDictionary dictionary];
    
    if(_classType == K_CLASS_SEARCH_JOBS)
    {
        if([_comingVia isEqualToString:K_GA_MNJ_SCREEN]){
            [self addNavigationBarWithBackBtnWithTitle:K_SERACHJOBS_NAVIGATIONBAR_TITLE];
        }
        else{
            [self addNavigationBarWithTitleAndHamBurger:K_SERACHJOBS_NAVIGATIONBAR_TITLE];
        }
        [self addClearButtonAtRightOfNavigationBar];
        
        [self setDefaultValue];
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        modifySearch_UserSelectedSkills = @"";
        modifySearch_UserSelectedLocation = @"";
        modifySearch_UserSelectedExperience = @"";
        modifySearch_UserSelectedDepartment = @"";
        modifySearch_UserSelectedIndustry = @"";
        
        
        if ([_comingVia isEqualToString:K_GA_SEARCH_RESULT_PAGE]) {
            [self addNavigationBarWithBackBtnWithTitle:K_MODIFTY_SEARCH_NAVIGATIONBAR_TITLE];
        }
        
        modifySearch_UserSelectedSkills = [_inputParams objectForKey:@"Keywords"];
    }
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        
        self.automaticallyAdjustsScrollViewInsets= YES;
    }
    
    searchKeyWordSuggestorData = [self getSuggestors];
    
    //to remove seperators between cell and section header
    [_tblSearchJobParametersAndResult setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(prefillData)
                                                 name:DropDownServerUpdate object:nil];
    
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"recent_search_table" forUIElement:_tblSearchJobParametersAndResult withAccessibilityEnabled:NO];
    
    if([NGHelper sharedInstance].isUserLoggedIn && [self.comingVia isEqualToString:K_GA_MNJ_SCREEN])
        self.isSwipePopGestureEnabled = YES;
    else
        self.isSwipePopGestureEnabled = NO;
 
        self.isSwipePopDuringTransition = NO;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    [super viewWillAppear:animated];
    
    if(_classType == K_CLASS_SEARCH_JOBS) {
        
        [self prefillData];

        [self customizeNavigationTitleFont];
        
        bIsExperienceDelegateCalled = NO;
        
        [NGGoogleAnalytics sendScreenReport:K_GA_SEARCH_SCREEN];
        
        [NGAppStateHandler sharedInstance].appState = APP_STATE_JOB_SEARCH;
        
        //for experience , dequeing problem when came from recent search
        bExperienceSet = NO;
    }

}

-(void) viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    [super viewDidAppear:animated];
    
    if (_classType == K_CLASS_SEARCH_JOBS) {
        
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
        
        [_tblSearchJobParametersAndResult reloadData];
        [self.tblSearchJobParametersAndResult scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        arrRecentSearches = nil;
        arrRecentSearches = [NGSavedData getRecentJobs];
        if (arrRecentSearches && 0<[arrRecentSearches count]) {
            recentSearchKeyAndRow = [NSMutableDictionary new];
            NSInteger arrCount = [arrRecentSearches count];
            for (NSInteger i=0; i < arrCount; i++) {
                //add info of this to dic so that when search count comes we can reload this cell again
                NSString *keyForSearch = [NSString stringWithFormat:@"%ld",(long)(arrCount-1-i)];
                
                [recentSearchKeyAndRow setObject:[NSNumber numberWithLong:i] forKey:keyForSearch];
                
                keyForSearch = nil;
            }
            [self makeRequestForRecentSearchJobsCount];
        }
        
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        [NGHelper sharedInstance].appState = APP_STATE_MODIFY_SSA;
        [NGGoogleAnalytics sendScreenReport:K_GA_MODIFY_ALERT_SCREEN];
    }
    
    [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_SEARCH withModel:nil]];

    [AppTracer traceEndTime:TRACER_ID_SEARCH_JOBS];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_classType == K_CLASS_MODIFY_SEARCH) {
        [NGHelper sharedInstance].appState = APP_STATE_MODIFY_SSA;
    }
    
    [AppTracer clearLoadTime:TRACER_ID_SEARCH_JOBS];
}
#pragma Mark -
#pragma Mark Other

-(void)setDefaultValue{
    
    currentUserSelectedKeyJobs      = @"";
    currentUserSelectedLocation     = @"";
    currentUserSelectedMinSalary    = @"";
    minSalarySelected = @"";
    currentUserSelectedExp          = Const_Any_Exp_Tag;
    previouslySelectedExperience    = [NSString stringWithFormat:@"%d", Const_Any_Exp_Tag];
}
-(void)prefillData{
    noOfRowsInSectionZero = 4;
    
    NSDictionary *dict = [NGSavedData getLastSearch];
    
    if (dict)
    {
        NSString *locations = [dict objectForKey:@"Location"];
        NSArray *locArr = [locations componentsSeparatedByString:@", "];
        
        NSString *otherLocStr = @"";
        NSString *locStr = @"";
        BOOL isOtherCityExistWithEmptyValue = NO;
        currentUserLocationOther = nil;
        
        NSMutableArray *selectedLocationsFromValueSelector = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i<locArr.count; i++) {
            NSString *location = [locArr fetchObjectAtIndex:i];
            
        
            NSArray* resultArr  = [NGDatabaseHelper searchForType:KEY_VALUE
                                    havingValue:location andClass:[DDLocation class]];
            
             if (!resultArr.count) {
                if (![location isEqualToString:@""]){
                    otherLocStr = [otherLocStr stringByAppendingFormat:@"%@, ",location];
                }
                
            }else{
                
                if ([location.lowercaseString isEqualToString:@"other"]) {
                    isOtherCityExistWithEmptyValue = YES;
                    currentUserLocationOther = @"";
                }
                
                locStr = [locStr stringByAppendingFormat:@"%@, ",location];
                [selectedLocationsFromValueSelector addObject:location];
                
            }
        }
        
        currentUserSelectedLocation = [self clearLocationStringFromString:locStr];
        
        
        if (![otherLocStr isEqualToString:@""]) {
            if (![selectedLocationsFromValueSelector containsObject:@"Other"]) {
                [selectedLocationsFromValueSelector addObject:@"Other" ];
            }
            currentUserLocationOther=[NSString removeCommaFromString:otherLocStr];
        }
        
        if ([NGDecisionUtility  isValidString:currentUserLocationOther] || isOtherCityExistWithEmptyValue) {
            noOfRowsInSectionZero = 5;
        }
        
        NSMutableDictionary* dictForLocations=[dropdownItems fetchObjectAtIndex:0];
        [dictForLocations setCustomObject:selectedLocationsFromValueSelector forKey:K_DROPDOWN_SELECTEDVALUES];
        
        selectedLocationsFromValueSelector = nil;
        dictForLocations = nil;
        
        //keywords
        currentUserSelectedKeyJobs = [dict objectForKey:@"Keywords"];
        
        //experience
        NSInteger exp = [[dict objectForKey:@"Experience"]integerValue];
        currentUserSelectedExp = exp; //Const_Any_Exp_Tag
        bExperienceSet = NO;
        
        
        
        {
        //setting prefilled data in dict of dropdown for location : In the case of spotlight navigation to SRP
            
            NSMutableArray *arrSelectedValues = [NSMutableArray array];
            NSMutableArray *arrSelectedIds = [NSMutableArray array];

            for (NSInteger i = 0; i<locArr.count; i++) {
                NSString *location = [locArr fetchObjectAtIndex:i];
                NSArray* resultArr  = [NGDatabaseHelper searchForType:KEY_VALUE
                                                          havingValue:location andClass:[DDLocation class]];
                if (resultArr.count) {
                    DDLocation *obj = [resultArr objectAtIndex:0];
                    [arrSelectedValues addObject:obj.valueName];
                    [arrSelectedIds addObject:[NSString stringWithFormat:@"%i",obj.valueID.intValue]];
                }else{
                }
            }
  
        [dictLocation setCustomObject:arrSelectedValues forKey:KEY_VALUE];
        [dictLocation setCustomObject:arrSelectedIds forKey:KEY_ID];
        }
        
    }
}
//Move to Base Controller
#pragma Mark -
#pragma Mark Word suggestor Creator

- (AutocompletionTableView *)autoCompleter
{
    
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:_txtFieldKeywords inViewController:self withOptions:options withDefaultStyle:NO];
        _autoCompleter.autoCompleteDelegate = self;
        _autoCompleter.suggestionsDictionary = searchKeyWordSuggestorData;//will be same for both search and modify search
        
        [self.view addSubview:_autoCompleter];
        
        [self addconstaint];
    }
    return _autoCompleter;
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

-(void) addconstaint {
    
    NSLayoutConstraint *autoCompletionLeftConstraints = [NSLayoutConstraint constraintWithItem:_autoCompleter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSInteger yForAutoCompletionTable = 64;
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

#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return  searchKeyWordSuggestorData;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText {
    if (_classType == K_CLASS_SEARCH_JOBS) {
        currentUserSelectedKeyJobs = selectedText;
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        modifySearch_UserSelectedSkills = selectedText;
    }else{
        //dummy
    }
}



-(void)showingTheOptions:(BOOL)status{
    
    [self hideSuggesterBackGrndView:!status];
}


-(NSArray *)getSuggestors
{
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedKeySkillsWithFrequency:K_KEYWORDS_SUGGESTOR_KEY];
    return suggestors;
    
}


#pragma mark
#pragma mark Experience Tuple delegate

-(void)userSelectedExperience:(NSInteger)selectedExperience{
    
    [_txtFieldKeywords resignFirstResponder];
    [_txtFldOtherLoc resignFirstResponder];
    
    currentUserSelectedExp = selectedExperience;
    previouslySelectedExperience = [NSString stringWithFormat:@"%ld",(long)currentUserSelectedExp];
    bIsExperienceDelegateCalled = YES;
}

#pragma mark
#pragma mark TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_classType == K_CLASS_SEARCH_JOBS) {
        return 2;
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        return 1;
    }else{
        //dummy
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(_classType == K_CLASS_SEARCH_JOBS) {
        
        if (section == 0)
            
            return noOfRowsInSectionZero;
        
        else if(section == 1)
        {
            return [arrRecentSearches count];
            
        }else{
            //dummy
        }
        
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        return 6;
    }else{
        //dummy
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classType == K_CLASS_SEARCH_JOBS) {
        return [self configureCell:indexPath];
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        return [self configureCellForModifySearchAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell*)configureCellForModifySearchAtIndexPath:(NSIndexPath*)paramIndexPath{
    
    switch (paramIndexPath.row) {
            
        case 0 :{
            NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:searchCellIndentifier];
            
            [cell configureCellForModifySearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:modifySearch_UserSelectedSkills,@"cellText", nil] andIndexPath:paramIndexPath];
            cell.txtParameter.delegate = self;
            cell.txtParameter.tag = ModifySearchTextfieldTagSkills;
            _txtFieldKeywords = cell.txtParameter;
            [self addAutoCompleterAtTextField:cell.txtParameter];
            [self customizeValidationErrorUIForIndexPath:paramIndexPath cell:cell];

            return cell;
            break;
        }
        case 1:{
            NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:searchCellIndentifier];
            
            [cell configureCellForModifySearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:modifySearch_UserSelectedLocation,@"cellText", nil] andIndexPath:paramIndexPath];
            cell.txtParameter.tag = ModifySearchTextfieldTagLocation;
            [self customizeValidationErrorUIForIndexPath:paramIndexPath cell:cell];

            return cell;
            break;
        }
            
        case 2:{
            NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:searchCellIndentifier];

            [cell configureCellForModifySearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:modifySearch_UserSelectedExperience,@"cellText", nil] andIndexPath:paramIndexPath];
            cell.txtParameter.tag = ModifySearchTextfieldTagExperience;
            [self customizeValidationErrorUIForIndexPath:paramIndexPath cell:cell];

            return cell;
            break;
        }
            
        case 3:{
            NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:searchCellIndentifier];
            
            [cell configureCellForModifySearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:modifySearch_UserSelectedDepartment,@"cellText", nil] andIndexPath:paramIndexPath];
            cell.txtParameter.tag = ModifySearchTextfieldTagDepartment;
            [self customizeValidationErrorUIForIndexPath:paramIndexPath cell:cell];

            return cell;
            break;
        }
            
        case 4:{
            NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:searchCellIndentifier];
            
            [cell configureCellForModifySearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:modifySearch_UserSelectedIndustry,@"cellText", nil] andIndexPath:paramIndexPath];
            cell.txtParameter.tag = ModifySearchTextfieldTagIndustry;
            [self customizeValidationErrorUIForIndexPath:paramIndexPath cell:cell];

            return cell;
            break;
        }
            
        case 5:{
            //create job alert button cell
            NSString* cellIndentifier = @"modifySearchSaveAlertButtonCell";
            NGModifySearchSaveAlertButtonTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:cellIndentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [UIAutomationHelper setAccessibiltyLabel:@"createAlert_btn" forUIElement:cell.createAlertButton];
            [cell setDelegate:self];
            
            return cell;
        }
    }
    return nil;
}
- (UITableViewCell*)configureCell:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell;
    
    if (indexPath.section ==0)
    {
        
        NSIndexPath *newIndexPath = [self indexPathToDisplayForIndexPath:indexPath];
        
        switch (newIndexPath.row) {
                
            case RowType_Skills :{
                
                NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:searchCellIndentifier];
                [cell configureCellForSearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:currentUserSelectedKeyJobs,@"cellText", nil] andIndex:RowType_Skills];
                cell.txtParameter.delegate                  = self;
                _txtFieldKeywords                       = cell.txtParameter;
                cell.txtParameter.tag = Textfield_Type_JobSkill;
                [self addAutoCompleterAtTextField:_txtFieldKeywords];
                [self customizeValidationErrorUIForIndexPath:newIndexPath cell:cell];

                return cell;
                break;
            }
            case RowType_Location:{
                NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:searchCellIndentifier];
                [cell configureCellForSearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:currentUserSelectedLocation,@"cellText", nil] andIndex:RowType_Location];
                
                return cell;
                break;
            }
                
            case RowType_Location_Other :{
                NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:searchCellIndentifier];
                [cell configureCellForSearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:currentUserLocationOther,@"cellText", nil] andIndex:RowType_Location_Other];
                cell.txtParameter.delegate                  = self;
                _txtFldOtherLoc = cell.txtParameter;
                cell.txtParameter.tag = Textfield_Type_Location_Other;
                self.autoCompleter.isMultiSelect = TRUE;
                [cell.txtParameter removeTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
                [self customizeValidationErrorUIForIndexPath:newIndexPath cell:cell];
                return cell;
                break;
            }
            case RowType_Experience:{
                static NSString* cellIndentifier = @"SearchJobsExperianceTupple";
                NGSearchSobExperianceTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:cellIndentifier];
                if(cell==nil)
                {
                    cell = [[NGSearchSobExperianceTupple alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                }
                cell.delegate = self;
                cell.bIsFirstTimeSelected = YES;
                [cell configureExperienceScrollview];
                
                BOOL isExperienceInRange = (currentUserSelectedExp >=0 && currentUserSelectedExp <=15) || (Const_Any_Exp_Tag==currentUserSelectedExp);
                
                if (isExperienceInRange && !bExperienceSet)
                {
                    bExperienceSet = YES;
                    cell.bIsFirstTimeSelected = NO;
                    [cell setExperience:[NSString stringWithFormat:@"%ld", (long)currentUserSelectedExp]
                   andPreviousExperince:previouslySelectedExperience];
                    previouslySelectedExperience = [NSString stringWithFormat:@"%ld",(long)currentUserSelectedExp];

                }
                return cell;
                break;
            }
            case RowType_SearchJobs:{
                if(_classType == K_CLASS_SEARCH_JOBS) {
                    static NSString* cellIndentifier = @"SearchJobsButtonTupple";
                    
                    NGSearchJobParametersTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:cellIndentifier];
                    [cell configureCellForSearchWithData:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"cellText", nil] andIndex:RowType_SearchJobs];
                    cell.delegate = self;
                    return cell;
                    break;
                }
            }
        }
    }
    
    else if(indexPath.section == 1)
    {
        NGRecentSearchTupple* cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:recentCellIdentifier];
        
        NSInteger arrRecentSearchesCount = [arrRecentSearches count];
        
        NSInteger index = arrRecentSearchesCount-1-(indexPath.row);
        [cell configureCellWithData:(NGRescentSearchTuple*)arrRecentSearches[index] AndIndex:index];
        [cell setTuppleType:RecentSearchTuppleType];
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classType == K_CLASS_SEARCH_JOBS)
        [self searchDidSelectTableViewCellForIndex:indexPath];
    else if (_classType == K_CLASS_MODIFY_SEARCH)
        [self modifySearchDidSelectTableViewCellForIndex:indexPath];
    
}
- (void)modifySearchDidSelectTableViewCellForIndex:(NSIndexPath*)indexPath{
    
    [self.view endEditing:YES];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];

    
    if ((indexPath.row==1))
    {
        //_valueSelector = nil;
        if (!_valueSelector){
            _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
            _valueSelector.delegate = self;
        }
        
    
        [appDelegate.container setRightMenuViewController:_valueSelector];
        appDelegate.container.rightMenuPanEnabled = NO;
        if(0>=[vManager validateValue:[dictLocation objectForKey:KEY_ID] withType:ValidationTypeArray].count)
            _valueSelector.arrPreSelectedIds = [dictLocation objectForKey:KEY_ID];
        
        _valueSelector.dropdownType = DDC_LOCATION;
        [_valueSelector displayDropdownData];
        [appDelegate.container toggleRightSideMenuCompletion:nil];
    }else if (indexPath.row == 2){
        
        //_valueSelector = nil;
        if (!_valueSelector)
        {
            _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
            _valueSelector.delegate = self;
        }
        
        
        [appDelegate.container setRightMenuViewController:_valueSelector];
        appDelegate.container.rightMenuPanEnabled = NO;
        if(0>=[vManager validateValue:[dictExperience objectForKey:KEY_ID] withType:ValidationTypeArray].count)
            _valueSelector.arrPreSelectedIds = [dictExperience objectForKey:KEY_ID];
        _valueSelector.dropdownType = DDC_EXP_YEARS;
        [_valueSelector displayDropdownData];
        [appDelegate.container toggleRightSideMenuCompletion:nil];
    }else if (indexPath.row == 3){
        
        //_valueSelector = nil;
        if (!_valueSelector)
        {
            _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
            _valueSelector.delegate = self;
        }
        
        
        [appDelegate.container setRightMenuViewController:_valueSelector];
        appDelegate.container.rightMenuPanEnabled = NO;
        if(0>=[vManager validateValue:[dictFarea objectForKey:KEY_ID] withType:ValidationTypeArray].count)
            _valueSelector.arrPreSelectedIds = [dictFarea objectForKey:KEY_ID];
        _valueSelector.dropdownType = DDC_FAREA;
        [_valueSelector displayDropdownData];
        
        [appDelegate.container toggleRightSideMenuCompletion:nil];
    }else if (indexPath.row == 4){
        //_valueSelector = nil;
        if (!_valueSelector)
        {
            _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
            _valueSelector.delegate = self;
        }
    
        [appDelegate.container setRightMenuViewController:_valueSelector];
        appDelegate.container.rightMenuPanEnabled = NO;
        if(0>=[vManager validateValue:[dictIndustryType objectForKey:KEY_ID] withType:ValidationTypeArray].count)
            _valueSelector.arrPreSelectedIds = [dictIndustryType objectForKey:KEY_ID];
        _valueSelector.dropdownType = DDC_INDUSTRY_TYPE;
        [_valueSelector displayDropdownData];
        [appDelegate.container toggleRightSideMenuCompletion:nil];
    }
    
}
- (void)searchDidSelectTableViewCellForIndex:(NSIndexPath*)indexPath{
    currentSelectedIndexPath = indexPath;
    ValidatorManager *vManager = [ValidatorManager sharedInstance];

    if (indexPath.section==0)
    {
        if ((indexPath.row==1))
        {
            //_valueSelector= nil;
            if (!_valueSelector)
            {
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                
                _valueSelector.delegate = self;
            }
            [appDelegate.container setRightMenuViewController:_valueSelector];
            
            appDelegate.container.rightMenuPanEnabled = NO;
             if(0>=[vManager validateValue:[dictLocation objectForKey:KEY_ID] withType:ValidationTypeArray].count)
                 _valueSelector.arrPreSelectedIds = [dictLocation objectForKey:KEY_ID];
            _valueSelector.dropdownType = DDC_LOCATION;
            [_valueSelector displayDropdownData];
            [appDelegate.container toggleRightSideMenuCompletion:nil];
        }
        if( 0 == indexPath.row){
            
            if(_autoCompleter.hidden){
                
                [self.txtFieldKeywords becomeFirstResponder];
            }
            else{
                
                [self hideKeyboardAndSuggester];
            }
        }
        
    }else  if (indexPath.section== 1){
        
        NSInteger rowSelected = [arrRecentSearches count]-1-(indexPath.row);
        if (0 <= rowSelected) {
            NGRescentSearchTuple* data = [arrRecentSearches fetchObjectAtIndex:rowSelected];
            //we will change UI only for index 2nd-nth recent searches,0th is already loaded on UI using prefilldata method
            bExperienceSet = NO;
            
            //just for exp slider correctness
            previouslySelectedExperience = [NSString stringWithFormat:@"%ld",(long)currentUserSelectedExp];
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_RECENT_SEARCH withEventLabel:K_GA_EVENT_SEARCH_JOB_LABEL withEventValue:nil];
            
            [self showSRPViewWithKeywords:data.keyword location:data.location AndExp:[data.experience integerValue]];
            
        }
    }else if(2 == indexPath.section){
        
        [self showJobsForSaveSearch:indexPath.row];
    }else{
        //dummy
    }
    
    if(0 != indexPath.row){
        
        [self.txtFieldKeywords resignFirstResponder];
        [_txtFldOtherLoc resignFirstResponder];
    }
    else if (0 != indexPath.section){
        
        [self.txtFieldKeywords resignFirstResponder];
        [_txtFldOtherLoc resignFirstResponder];
    }
}
#pragma Mark -
#pragma Adding TextFiled in key skill tuple for handling the AutoSuggestor  delegate

-(void)addAutoCompleterAtTextField:(UITextField*)paramTextField{
    
    self.autoCompleter.isMultiSelect = TRUE;
    [paramTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}




//The event handling method
- (void)handleSingleTapOnSuggestorBackGrndView{
    
    [self hideKeyboardAndSuggester];
}

-(void)hideKeyboardAndSuggester{
    
    [self.txtFieldKeywords resignFirstResponder];
    [_txtFldOtherLoc resignFirstResponder];
    [self hideSuggesterBackGrndView:YES];
}
- (NSString*)getCommaSeperatedStringFor:(NSString*)stringToPass{
    
    NSString* strToReturn = @"";
    
    NSMutableArray* arrKeywords = [NSMutableArray arrayWithArray:[stringToPass componentsSeparatedByString:@","]];
    
    [arrKeywords removeLastObject];
    
    
    if ([arrKeywords count] == 1)
        strToReturn = [arrKeywords lastObject];
    else{
        
        for (int i = 0; i < [arrKeywords count]; i++) {
            
            if (i == [arrKeywords count]-1)
                strToReturn = [strToReturn stringByAppendingString:[NSString stringWithFormat:@"%@",[arrKeywords fetchObjectAtIndex:i]]];
            else
                strToReturn = [strToReturn stringByAppendingString:[NSString stringWithFormat:@"%@,",[arrKeywords fetchObjectAtIndex:i]]];
        }
    }
    
    return strToReturn;
}

#pragma mark ValueSelector Delegate

-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    
    [appDelegate.container toggleRightSideMenuCompletion:nil];
    
    if (successFlag)
    {
        [self handleDropDownSelection:responseParams];
        
        [_tblSearchJobParametersAndResult reloadData];
    }
    
    
}


-(void)handleDropDownSelection:(NSDictionary *)responseParams{

    
    NSInteger ddType = [[responseParams objectForKey:K_DROPDOWN_TYPE]integerValue];
    NSArray *arrSelectedIds = [responseParams objectForKey:K_DROPDOWN_SELECTEDIDS];
    NSArray* arrSelectedValues = [responseParams objectForKey:K_DROPDOWN_SELECTEDVALUES];
    
    NGSearchJobParametersTupple* cell;
    
    switch (ddType) {
            
        case DDC_LOCATION:
            
        {
            cell = (NGSearchJobParametersTupple*)[self.tblSearchJobParametersAndResult cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

            [dictLocation setCustomObject:arrSelectedValues forKey:KEY_VALUE];
            [dictLocation setCustomObject:[arrSelectedIds copy] forKey:KEY_ID];
            
            NSString *selectedValue = [NSString getStringsFromArray:arrSelectedValues];

            
            if (_classType == K_CLASS_SEARCH_JOBS) {
                
                cell.txtParameter.text= selectedValue;
                currentUserSelectedLocation = cell.txtParameter.text;
                if ([currentUserSelectedLocation.lowercaseString rangeOfString:@"other"].location != NSNotFound) {
                    //create textfield for other location
                    noOfRowsInSectionZero = noOfRowsInSectionZero<5?++noOfRowsInSectionZero:noOfRowsInSectionZero;
                    [_tblSearchJobParametersAndResult reloadData];
                    
                }else{
                    
                    currentUserLocationOther = @"";
                    noOfRowsInSectionZero = noOfRowsInSectionZero>4?--noOfRowsInSectionZero:noOfRowsInSectionZero;
                    
                }
            }else if (_classType == K_CLASS_MODIFY_SEARCH){
                
                modifySearch_UserSelectedLocation = selectedValue;
                [self setItem:ModifySearchTextfieldTagLocation InErrorCollectionWithActionAdd:NO];
                
            }
            
        }
            
            break;
            
        case DDC_EXP_YEARS:{

            
            [dictExperience setCustomObject:arrSelectedValues forKey:KEY_VALUE];
            [dictExperience setCustomObject:[arrSelectedIds copy] forKey:KEY_ID];

            NSString *selectedValue = [NSString getStringsFromArray:arrSelectedValues];
            
            if (_classType == K_CLASS_MODIFY_SEARCH){
                modifySearch_UserSelectedExperience = selectedValue;
                
                [self setItem:ModifySearchTextfieldTagExperience InErrorCollectionWithActionAdd:NO];
            }
        }
            break;
            
        case DDC_FAREA:{

            
            [dictFarea setCustomObject:arrSelectedValues forKey:KEY_VALUE];
            [dictFarea setCustomObject:[arrSelectedIds copy] forKey:KEY_ID];

            NSString *selectedValue = [NSString getStringsFromArray:arrSelectedValues];

            
            if (_classType == K_CLASS_MODIFY_SEARCH){
                modifySearch_UserSelectedDepartment = selectedValue;
                [self setItem:ModifySearchTextfieldTagDepartment InErrorCollectionWithActionAdd:NO];
            }
            
        }break;
            
        case DDC_INDUSTRY_TYPE:{


            [dictIndustryType setCustomObject:arrSelectedValues forKey:KEY_VALUE];
            [dictIndustryType setCustomObject:[arrSelectedIds copy] forKey:KEY_ID];
            NSString *selectedValue = [NSString getStringsFromArray:arrSelectedValues];

            
            if (_classType == K_CLASS_MODIFY_SEARCH){
                
                modifySearch_UserSelectedIndustry = selectedValue;
                [self setItem:ModifySearchTextfieldTagIndustry InErrorCollectionWithActionAdd:NO];
            }
        }
            break;
        default:
            break;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //recent searches 110 or 90
    if(_classType == K_CLASS_SEARCH_JOBS){
        
        float fHeight = 73;
        
        if(indexPath.section == 0){
            
            NSIndexPath *newIndexPath = [self indexPathToDisplayForIndexPath:indexPath];
            
            if (RowType_Experience == newIndexPath.row) {
                fHeight = K_EXPERIENCE_SCROLLER_HEIGHT + 10;//33 for space between exp bar and search button
            }
            
        }else if (indexPath.section == 1)
        {
            NSInteger index = [arrRecentSearches count]-1-(indexPath.row);
            NGRescentSearchTuple* obj = (NGRescentSearchTuple*)[arrRecentSearches fetchObjectAtIndex:index];
            NGRecentSearchTupple *tupple = [self.tblSearchJobParametersAndResult
                                            dequeueReusableCellWithIdentifier:recentCellIdentifier];
            
            [tupple configureCellWithData:obj AndIndex:index];
            fHeight = ceil([UITableViewCell getCellHeight:tupple]);
        }
        return fHeight;
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        float fHeight = 73;
        
        
        if(IS_IPHONE6_PLUS)
            fHeight += 35;
        else if(IS_IPHONE6)
            fHeight += 20;
        if(indexPath.row == 5){
            fHeight = 140;
        }
        return fHeight;
        
    }else{
        //dummy
    }
    return 0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    float fHeight;
    if (section == 0 ||  (section == 1 && [arrRecentSearches count] == 0))
        fHeight = 0;
    else
        fHeight = K_RECENT_SERACH_HEADER_HEIGHT;
    
    return fHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 0.5)];
    [footer setBackgroundColor:[UIColor clearColor]];
    return footer;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* viewToReturn = nil;
    NGSearchJobParametersTupple* cell = nil;
    if ((section == 1 && [arrRecentSearches count]>0) || (section == 2)) {
        viewToReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, K_RECENT_SERACH_HEADER_HEIGHT)];
        NSString* cellIndentifier = @"RecentSearchHeader";
        cell = [self.tblSearchJobParametersAndResult dequeueReusableCellWithIdentifier:cellIndentifier];
        
        CGRect frameTemp = viewToReturn.frame;
        
        UILabel* lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                     frameTemp.origin.y+frameTemp.size.height, frameTemp.size.width, 0.5)];
        [lblLine setBackgroundColor:Clr_Grey_SearchJob];
        [lblLine setText:@""];
        [cell.contentView addSubview:lblLine];
        
        UILabel* lblLineTwo = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        frameTemp.origin.y, frameTemp.size.width, 1)];
        [lblLineTwo setBackgroundColor:[tableView separatorColor]];
        [lblLineTwo setText:@""];
        [cell.contentView addSubview:lblLineTwo];
        
        switch (section) {
            case 1:{
                
                cell.headerTitleLabel.text = @"Recent Searches";
                cell.userInteractionEnabled = NO;
            }
                break;
            default:
                break;
        }
        
    }
    return cell.contentView;
}


#pragma mark -
#pragma mark TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)replacestring
{
    if (textField == self.txtFieldKeywords || ModifySearchTextfieldTagSkills==textField.tag)
    {
        if (textField.text.length >= 250 && range.length == 0)
            return NO;
        else if (![textField.text length]){
            if([replacestring isEqualToString:@" "]){
                return NO;
            }
        }
        else if([replacestring isEqualToString:@" "] || [replacestring isEqualToString:@","]){
            NSString *firstPartString = textField.text;
            if([firstPartString length]){
                NSString * newString = [firstPartString substringWithRange:NSMakeRange([firstPartString length]-1, 1)];
                if([newString isEqualToString:@","]){
                    return NO;
                }
                else if ([newString isEqualToString:@" "]){
                    return NO;
                }
                
            }
            
        }
        return YES;
    }
    
    else
        return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag == Textfield_Type_JobSkill || ModifySearchTextfieldTagSkills==textField.tag)
    {
        self.autoCompleter.isErrorViewVisibleInSearch= NO;
        
        CGFloat paddingSuggectionView = K_AUTOSUGGESTOR_HEIGHT_IOS7;
        
        [self.autoCompleter setTopPositionForSuggestorView:textField.frame.origin.y+paddingSuggectionView];
        
        [self addSuggestorBackGroundView:textField.frame.origin.y+paddingSuggectionView];
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_classType == K_CLASS_SEARCH_JOBS) {
        if (textField.tag == Textfield_Type_JobSkill){
            
            currentUserSelectedKeyJobs = textField.text;
        }else if (textField.tag == Textfield_Type_Location_Other){
            currentUserLocationOther = textField.text;
        }else{
            //dummy
        }
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        if (ModifySearchTextfieldTagSkills == textField.tag) {
            modifySearch_UserSelectedSkills = textField.text;
        }
    }else{
        //dummy
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_classType == K_CLASS_SEARCH_JOBS) {
        [_tblSearchJobParametersAndResult scrollsToTop];
        if ((textField.tag == Textfield_Type_JobSkill || textField.tag == Textfield_Type_Location_Other) && _classType == K_CLASS_SEARCH_JOBS){
            
            [textField resignFirstResponder];
            [_txtFldOtherLoc resignFirstResponder];
            [self hideSuggesterBackGrndView:YES];
        }
        return YES;
    }else if (_classType == K_CLASS_MODIFY_SEARCH){
        [textField resignFirstResponder];
        [self hideSuggesterBackGrndView:YES];
    }else{
        //dummy
    }
    return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

-(void)hideSuggesterBackGrndView:(BOOL)status{
    
    [suggestorBackgroundView setHidden:status];
    [_autoCompleter setHidden:status];
    [_tblSearchJobParametersAndResult setScrollEnabled:status];
}
-(void)addSuggestorBackGroundView :(float)yPos{
    
    if (!suggestorBackgroundView) {
        
        CGRect tempFrame = self.view.frame;
        tempFrame.origin.y = yPos+44;
        suggestorBackgroundView = [[UIView alloc] initWithFrame:tempFrame];
        suggestorBackgroundView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:suggestorBackgroundView belowSubview:_autoCompleter];
        [self.view bringSubviewToFront:_autoCompleter];
        [self hideSuggesterBackGrndView:YES];
        [self addTapGestureToSuggestorBackGroundView];
        
    }
}
/* hiding the Suggestor view when user click on outside of it.
 */

-(void)addTapGestureToSuggestorBackGroundView{
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnSuggestorBackGrndView)];
    [suggestorBackgroundView addGestureRecognizer:singleFingerTap];
    
}

#pragma mark
#pragma mark Search parameter Tuple textview delgate

- (void)textFieldValue:(NSString *)textFieldValue{
    
}


#pragma mark
#pragma mark Delegates_JobSearchTupple

- (void)searchJobButtonClicked:(UIButton *)sender
{
    [self.txtFieldKeywords resignFirstResponder];
    [_txtFldOtherLoc resignFirstResponder];
    [self performSearching];
}

- (NSMutableArray*)checkAllModifySearchValidations{
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    //Error situations cases
    //Keyword given but contains special characters
    //Both keyword and location are empty
    BOOL isSkillsValid = [NGDecisionUtility isValidString:modifySearch_UserSelectedSkills];
    BOOL isLocationValid = [NGDecisionUtility isValidString:modifySearch_UserSelectedLocation];
    
    if (!isSkillsValid && !isLocationValid) {
        [arr addObject:@"Enter at least one keyword or location to save."];
        [self setItem:ModifySearchTextfieldTagSkills InErrorCollectionWithActionAdd:YES];
    }else if(isSkillsValid && [NGDecisionUtility doesStringContainSpecialCharsForKeywords:modifySearch_UserSelectedSkills]){
        [arr addObject:K_ERROR_MESSAGE_SPECIAL_CHARACTER];
        [self setItem:ModifySearchTextfieldTagSkills InErrorCollectionWithActionAdd:YES];
    }else{
        //dummy
    }
    
    if([arr count]>3){
        for (int i =3; i< [arr count]; i++)[arr removeObjectAtIndex:i];
    }
    
    [_tblSearchJobParametersAndResult reloadData];
    
    return arr;
}
- (void)setItem:(ModifySearchTextfieldTag)paramBasicDetailsTag InErrorCollectionWithActionAdd:(BOOL)paramIsAdd{
    NSInteger rowForItem = (NSInteger)paramBasicDetailsTag - 100;
    if (paramIsAdd) {
        [errorCellArr addObject:[NSNumber numberWithInteger:rowForItem]];
    }else{
        [errorCellArr removeObject:[NSNumber numberWithInteger:rowForItem]];
    }
}
- (void)saveAlertButtonClicked:(UIButton *)sender{
    [self.view endEditing:YES];
    
    NSMutableArray* arrValidations = [self checkAllModifySearchValidations];
    
    NSString * errorMessage = @"";
    
    if([arrValidations count] >0){
        
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
    }else{
        
        if(!self.isRequestInProcessing){
            [self showAnimator];
            
            NSMutableDictionary* params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"frm_ios",@"ssaloc", nil];
            //email id
            [params setValue:[_inputParams objectForKey:@"EmailID"] forKey:@"emailId"];
            
            //keyskills
            [params setValue:modifySearch_UserSelectedSkills forKey:@"keyword"];
            
            //locations
            [params setValue:modifySearch_UserSelectedLocation forKey:@"location"];
            
            
            //work experience
           NSString* strId = [[dictExperience objectForKey:KEY_ID] firstObject];
            if ([strId isEqualToString:@"31"])
                strId = @"30plus";
            [params setValue:strId forKey:@"workExpYr"];
            
            //department / functional area
            NSArray* arr = [dictFarea objectForKey:KEY_ID];
            if (arr)
                [params setValue:[arr firstObject] forKey:@"farea"];
            
            
            //industry
            arr = [dictIndustryType objectForKey:KEY_ID];
            if (arr)
                [params setValue:[arr firstObject] forKey:@"industry"];
            
            
            __weak NGSearchJobsViewController *mySelfWeak = self;
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SSA];
            [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [mySelfWeak hideAnimator];
                    
                    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_MODIFIED_SAVE_ALERT withEventLabel:K_GA_EVENT_MODIFIED_SAVE_ALERT withEventValue:nil];
                    
                    if (responseData.isSuccess) {
                        if (mySelfWeak.classType == K_CLASS_MODIFY_SEARCH){
                            
                            [self performSelector:@selector(showBanner) withObject:nil afterDelay:1.0];
                            
                            [mySelfWeak.navigationController popViewControllerAnimated:YES];
                            
                            mySelfWeak.isRequestInProcessing = NO;
                        }else{
                            //dummy
                        }
                    }else{
                        mySelfWeak.isRequestInProcessing = NO;
                        
                        if (mySelfWeak.classType == K_CLASS_MODIFY_SEARCH) {
                            
                            if ([responseData responseCode] == K_RESPONSE_ERROR) {
                                @try{
                                    NSDictionary *errorDic = [[responseData parsedResponseData] objectForKey:@"error"];
                                    NSString *errorTitle = [errorDic objectForKey:@"message"];
                                    NSArray *errorArray = (NSArray*)[errorDic objectForKey:@"validationErrorDetails"];
                                    NSString *errorMessage = [[[errorArray firstObject] objectForKey:@"emailId"] objectForKey:@"message"];
                                    if (errorMessage) {
                                        [NGUIUtility showAlertWithTitle:errorTitle withMessage:@[@"Email Id is incorrect"] withButtonsTitle:@"Ok" withDelegate:nil];
                                    }
                                }@catch(NSException *ex){
                                    [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[@"Some error occurred at server"] withButtonsTitle:@"Ok" withDelegate:nil];
                                }
                            }
                        }
                    }
                });
            }];
        }
    }
}

-(void) showBanner {
    
    [NGMessgeDisplayHandler showSuccessBannerFromBottomWindow:nil title:@"Your Job Alert has been created." subTitle:@"We will email you matching Jobs" animationTime:2 showAnimationDuration:0.5];
    
}

-(void)performSearching{
    
    if (([currentUserSelectedKeyJobs isEqualToString:@""] ||
         (currentUserSelectedKeyJobs == nil))&&
        ([currentUserSelectedLocation isEqualToString:@""] || currentUserSelectedLocation == nil)) {
        
        [NGUIUtility showAlertWithTitle:@"Enter Search Criteria" withMessage:[NSArray arrayWithObjects:@"Enter at least one keyword or location to search.", nil] withButtonsTitle:@"OK" withDelegate:nil] ;
        
    }
    else
    {
        NSString *keywords = currentUserSelectedKeyJobs;
        
        keywords = [NSString stripTags:keywords];
        keywords=[keywords formatIdentificationNumber:keywords];
        keywords=[NSString removeCommaFromString:keywords];
        
        NSString *locations = currentUserSelectedLocation;
        
        BOOL isOtherLocationExists = [currentUserSelectedLocation.lowercaseString rangeOfString:@"other"].location != NSNotFound;
        
        
        if (isOtherLocationExists) {
            if (currentUserLocationOther && 0 < [currentUserLocationOther length]) {
                locations = [locations stringByAppendingString:[NSString stringWithFormat:@", %@",currentUserLocationOther]];
            }
        }
        
        if (!locations) {
            locations = @"";
        }
        
        NSInteger exp = currentUserSelectedExp;
        
        if ((([keywords isEqualToString:@""])) && ([locations isEqualToString:@""]))
            
        {
            [NGUIUtility showAlertWithTitle:@"Enter Search Criteria" withMessage:[NSArray arrayWithObjects:@"Enter at least one keyword or location to search", nil] withButtonsTitle:@"OK" withDelegate:nil] ;
        }
        
        else
        {
            //Code for recent searches
            NGRescentSearchTuple *searchTuple = [[NGRescentSearchTuple alloc] init];
            searchTuple.keyword = [keywords trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            searchTuple.location = [locations trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            searchTuple.location = [self clearLocationStringFromString:searchTuple.location];
            searchTuple.experience =[NSNumber numberWithInteger:exp];
            
            [NGSavedData saveSearchedJobCriteria:searchTuple];
            
            [self showSRPViewWithKeywords:keywords location:locations AndExp:exp];
            
        }
    }
}
- (NSString*)clearLocationStringFromString:(NSString*)loc{
    NSInteger locLength = [loc length];
    if (loc && 2<locLength && [[loc substringFromIndex:locLength-2] isEqualToString:@", "]) {
        return [loc substringToIndex:locLength-2];
    }
    return loc;
}
/**
 *  Handles/format special characters passed in the string.
 *
 *  @param string string that need to be formated
 *
 *  @return string after formation of special characters
 */

#pragma mark - ShakeEvent

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self searchJobButtonClicked:nil];
    }
}

#pragma mark - Alert Delegate
-(void)showSRPViewWithKeywords:(NSString*)paramKeywords location:(NSString*)paramLocation AndExp:(NSInteger)paramExp{
    NGSRPViewController *navgationController_ = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"SRPView"];
    
    if (![NGDecisionUtility isValidString:paramLocation]) {
        paramLocation = @"";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:0] forKey:@"Offset"];
    [params setObject:[NSNumber numberWithInteger:[NGConfigUtility getJobDownloadLimit]] forKey:@"Limit"];
    [params setObject:paramKeywords forKey:@"Keywords"];
    [params setObject:paramLocation forKey:@"Location"];
    [params setObject:[NSNumber numberWithInteger:paramExp] forKey:@"Experience"];
    
    
    navgationController_.paramsDict = params;
    navgationController_.startTime = [NSDate date];
    
    [(IENavigationController*)self.navigationController  pushActionViewController:navgationController_ Animated:YES ];
    
    params = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSArray* serviceArr = @[[NSNumber numberWithInt:SERVICE_TYPE_RECENT_SEARCH_COUNT]];
    [[NGOperationQueueManager sharedManager] cancelOperation:serviceArr];
}

#pragma mark Memory management

- (void)dealloc
{
    [self refreshMemory];
    if (errorCellArr) {
        [errorCellArr removeAllObjects];
        errorCellArr = nil;
    }
}

-(void) refreshMemory {
    if(_autoCompleter){
        MakeObjectNil(_autoCompleter);
    }
    MakeObjectNil(arrRecentSearches);
    MakeObjectNil(dropdownItems);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    
    [self hideAnimator];
    self.isRequestInProcessing = NO;
    
    if (_classType == K_CLASS_MODIFY_SEARCH) {
        
        if ([responseData responseCode] == K_RESPONSE_ERROR) {
            @try{
                NSDictionary *errorDic = [[responseData parsedResponseData] objectForKey:@"error"];
                NSString *errorTitle = [errorDic objectForKey:@"message"];
                NSArray *errorArray = (NSArray*)[errorDic objectForKey:@"validationErrorDetails"];
                NSString *errorMessage = [[[errorArray firstObject] objectForKey:@"emailId"] objectForKey:@"message"];
                if (errorMessage) {
                    [NGUIUtility showAlertWithTitle:errorTitle withMessage:@[@"Email Id is incorrect"] withButtonsTitle:@"Ok" withDelegate:nil];
                }
            }@catch(NSException *ex){
                [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[@"Some error occurred at server"] withButtonsTitle:@"Ok" withDelegate:nil];
            }
        }
    }
}

-(void) popNavigationViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSIndexPath*)indexPathToDisplayForIndexPath:(NSIndexPath*)paramIndexPath{
    if (0 == paramIndexPath.section) {
        if (4==noOfRowsInSectionZero && paramIndexPath.row > 1) {
            return ([NSIndexPath indexPathForRow:(paramIndexPath.row+1) inSection:paramIndexPath.section]);
            
        }
    }
    return paramIndexPath;
}
- (void)ClearButtonClicked{
    
    [self hideKeyboardAndSuggester];
    dictLocation = nil;
    dictLocation = [NSMutableDictionary dictionary];
    currentUserSelectedKeyJobs = @"";
    self.txtFieldKeywords.text = @"";
    currentUserSelectedLocation = @"";
    currentUserLocationOther = @"";
    noOfRowsInSectionZero = 4;//reset to default
    previouslySelectedExperience = [NSString stringWithFormat:@"%ld",(long)currentUserSelectedExp];
    currentUserSelectedExp = Const_Any_Exp_Tag;
    bExperienceSet = NO;
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_REFRESH_FORM withEventLabel:K_GA_EVENT_REFRESH_FORM withEventValue:nil];
    
    NSMutableDictionary* dictForLocations=[dropdownItems fetchObjectAtIndex:0];
    [dictForLocations setCustomObject:@[] forKey:K_DROPDOWN_SELECTEDVALUES];
    
    [_tblSearchJobParametersAndResult reloadData];
}
- (void)makeRequestForRecentSearchJobsCount{
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_RECENT_SEARCH_COUNT];
    __weak NGSearchJobsViewController *mySelfWeak = self;
    __weak NSMutableDictionary *recentSearchKeyAndRowWeak = recentSearchKeyAndRow;
    __weak NSMutableArray *arrRecentSearchesWeak = arrRecentSearches;
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:arrRecentSearches,@"recentsearcharrkey", nil]] handler:^(NGAPIResponseModal *responseData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [mySelfWeak hideAnimator];
        });
        
        if (responseData.isSuccess) {
            if (mySelfWeak.classType == K_CLASS_SEARCH_JOBS) {
                NSInteger apiTypeKey = responseData.serviceType;
                
                switch (apiTypeKey) {
                        
                    case SERVICE_TYPE_RECENT_SEARCH_COUNT:{
                        if (recentSearchKeyAndRowWeak) {
                            
                            NSMutableArray * responseDataArray = (NSMutableArray *)responseData.parsedResponseData;
                            for (NGRecentSearchReponseModal *object in responseDataArray)
                            {
                                NSNumber *objId = object.searchId;
                                
                                NSString *keyForIndex = [NSString stringWithFormat:@"%ld",(long)[objId integerValue]];
                                NSNumber *indexForRecentSearchData = [recentSearchKeyAndRowWeak objectForKey:keyForIndex];
                                
                                if (indexForRecentSearchData) {
                                    NGRescentSearchTuple *tmpData = [arrRecentSearchesWeak fetchObjectAtIndex:[indexForRecentSearchData integerValue]];
                                    [tmpData setSearchJobCount:[object numberOfJobs]];
                                }
                            }
                            
                            if (0 < [recentSearchKeyAndRowWeak count]) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [mySelfWeak.tblSearchJobParametersAndResult reloadData];
                                });
                            }
                            
                        }
                        
                        
                    }break;
                        
                    default:
                        break;
                }
            }
        }else{
            self.isRequestInProcessing = NO;
        }
        
    }];
    
}

@end
