//
//  NGValueSelectionViewController2.m
//  Naukri
//
//  Created by Arun Kumar on 17/01/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGValueSelectionViewController.h"
#import "NGCustomCell2.h"
#import "DDNoticePeriod.h"
#import "Designation.h"
#import "FAMapped.h"
#import "CompanyName.h"
#import "IndustryAreaMapped.h"
#import "DropDown.h"
#import "NGResmanExpProfessionalDetailsViewController.h"

@interface NGValueSelectionViewController (){
    
    NSMutableArray *selectedIndexesArray;
    
    BOOL isErrorBannerVisibileToUser;
    
    IBOutlet NSLayoutConstraint *doneViewHeightConstraint;
    NSMutableArray* arrData;
    __weak IBOutlet NSLayoutConstraint *tableviewTopLC;
    NSMutableArray* arrDataForSearch; // have unique modals of arrData

}
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *titleHeaderTopLayoutConstraint;

@property (nonatomic,strong) NSMutableArray* filteredValues;

@end

@implementation NGValueSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideMenuStateDidChange:) name:MFSideMenuStateNotificationEvent object:nil];
    [self.clearButton setAccessibilityLabel:@"clear_btn"];
    self.contentTableView.tableHeaderView = nil;
    self.contentTableView.backgroundColor=[UIColor clearColor];
    
    self.selectedIds = [[NSMutableArray alloc]init];
    self.requestParams = [[NSMutableDictionary alloc]init];
    self.arrPreSelectedIds = [[NSMutableArray alloc] init];
    
    self.doneView.backgroundColor = UIColorFromRGB(0X0083ce);
    
    self.contentTableView.tableFooterView = [[UIView alloc] init];
    
    self.titleHeaderTopLayoutConstraint.constant += 20;
    
    UIView* viewToReturn = nil;
    viewToReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [viewToReturn setBackgroundColor:[_resetView backgroundColor]];
    [self.view addSubview:viewToReturn];
    [self.view setNeedsLayout];

    selectedIndexesArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(displayDropdownData)
                                        name:DropDownServerUpdate object:nil];
    
}

-(void)sideMenuStateDidChange:(NSNotification*)notif
{
    MFSideMenuState state = (MFSideMenuState)[[notif.userInfo valueForKey:@"eventType"] integerValue];
    if(state == MFSideMenuStateEventMenuWillClose)
    {
        [_searchBar.searchTextField resignFirstResponder];
    }
}
- (void)displayDropdownData{

    switch (self.dropdownType) {
        case DDC_FAREA:
        case DDC_INDUSTRY_TYPE:
        case DDC_COUNTRY:
        case DDC_NATIONALITY:
        case DDC_LOCATION:
        case DDC_PREFRENCE_LOCATION:
            _showSearchBar = YES;
            break;
            
        default:
            _showSearchBar = NO;
            break;
    }
    
    
    
    if (self.dropdownType == DDC_UGSPEC || self.dropdownType == DDC_PGSPEC || self.dropdownType == DDC_PPGSPEC){
        arrData = [NSMutableArray arrayWithArray: [NGDatabaseHelper sortEducationSpec:
                                                   DROPDOWN_VALUE_NAME onArray:
                                                   ((NSSet*)[_objDDBase valueForKey:@"specs"]).allObjects]];
    }
    else if (self.dropdownType == DDC_FAREA || self.dropdownType == DDC_INDUSTRY_TYPE){
        if(self.dropdownType == DDC_FAREA){
            arrData = [NSMutableArray arrayWithArray:[NGDatabaseHelper getAllDDData:self.dropdownType]];
            //add predictors from database
            [self addPredictorsInDropDownArrayWithPredictorType:DDC_FAREA];
   
        }
        if(self.dropdownType == DDC_INDUSTRY_TYPE){
            arrData = [NSMutableArray arrayWithArray:[NGDatabaseHelper getAllDDData:self.dropdownType]];
            //add predictors from database
            [self addPredictorsInDropDownArrayWithPredictorType:DDC_INDUSTRY_TYPE];
        }
    }
    else
    arrData = [NSMutableArray arrayWithArray:[NGDatabaseHelper getAllDDData:self.dropdownType]];

    //data for search
    NSMutableArray* arrLocal = [NSMutableArray array];
    arrDataForSearch = [NSMutableArray array];
    for (DDBase* obj in arrData) {
        if (![arrLocal containsObject:obj.valueName]) {
            [arrLocal addObject:obj.valueName];
            [arrDataForSearch addObject:obj];
        }
    }
    arrLocal = nil;

    
    
    
    
    
    
    
    [self refreshData];
    
}


- (void)enableErrorBannerForUser:(NSNotification*)notification{
    isErrorBannerVisibileToUser = NO;
}
-(void)addNavigationTitleFont{
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
      [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:16.0], NSFontAttributeName,nil]];
    
    _resetView.backgroundColor = Clr_Status_Bar;
    
}

- (void)dealloc
{
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    isErrorBannerVisibileToUser = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneTapped:(id)sender {
    [self.searchDisplayController.searchBar resignFirstResponder];
    [self.searchDisplayController setActive:NO animated:YES];
    [self.delegate didSelectValues:[self getResponse] success:TRUE];
    
    isErrorBannerVisibileToUser = NO;
}

- (IBAction)resetTapped:(id)sender {
    [self.selectedIds removeAllObjects];
    [self.contentTableView reloadData];
}

-(void)refreshData{

    if (_showSearchBar && _searchBar==nil){
        tableviewTopLC.constant = 44;
        _searchBar = [[NGSearchBar alloc] init];
        _searchBar.delegate = self;
        [_searchBar addSearchBarOnView:self.view];
    }
    
    _searchBar.bIsSearchModeOn = NO;
    DDBase* obj = [arrData firstObject];
    
    
    if (obj.selectionLimit.integerValue !=1)
        [self customizeForMultiSelect];
    else
        [self customizeForSingleSelect];
    
    NSString *headerName = obj.headerName;
    self.valueTypeLbl.text = headerName;
    
    
    NSString *str = [headerName stringByCompressingWhitespaceTo:@""];
    [self.contentTableView setAccessibilityLabel:[NSString stringWithFormat:@"%@_tableview",str]];
    [self.selectedIds removeAllObjects];
    
    if (_arrPreSelectedIds && [self isValidArray:_arrPreSelectedIds]){
        [self.selectedIds addObjectsFromArray:_arrPreSelectedIds];

    }

    
    [self.contentTableView reloadData];
}

- (BOOL)isValidArray:(NSArray*)paramArray{
    if (0 < [paramArray count]) {
        NSString *tmpObject = [paramArray firstObject];
        if ([NGDecisionUtility isValidString:tmpObject]) {
            return YES;
        }
    }
    return NO;
}
-(void)customizeForSingleSelect{
    
    self.doneBtn.hidden = YES;
    self.doneView.hidden = YES;
    self.clearButton.hidden = YES;
    self.resetView.userInteractionEnabled = NO;
    self.contentTableView.allowsMultipleSelection = NO;
    [doneViewHeightConstraint setConstant:0.0f];
}

-(void)customizeForMultiSelect{
    self.doneBtn.hidden = NO;
    self.doneView.hidden = NO;
    self.clearButton.hidden = NO;
    self.resetView.userInteractionEnabled = YES;
    self.contentTableView.allowsMultipleSelection = YES;
    [doneViewHeightConstraint setConstant:58.0f];
}

-(NSDictionary*)getResponse{
    
    NSMutableArray* arrSelectedValues = [NSMutableArray arrayWithArray:
           [DDBase getValuesForSelectedIds:
            self.selectedIds inContents:arrData]];
    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.selectedIds,K_DROPDOWN_SELECTEDIDS,
                                  arrSelectedValues,K_DROPDOWN_SELECTEDVALUES ,
                                  [NSNumber numberWithInt:self.dropdownType],K_DROPDOWN_TYPE, nil];
    
    return responseDict;
}

#pragma mark UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_searchBar.bIsSearchModeOn){
        if ([self.filteredValues count] == 0)
            return 1;
        else
            return [self.filteredValues count];
    }
    if (arrData)
        return arrData.count;
        
            
    return 0;
}

-(NGCustomCell2 *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self configureCell:indexPath forTableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];

    DDBase* obj;
    if (_searchBar.bIsSearchModeOn){
        if (!self.filteredValues.count) return;
        obj = [self.filteredValues fetchObjectAtIndex:indexPath.row];
    }
    else
        obj = [arrData fetchObjectAtIndex:indexPath.row];
    NSString *value = [obj selectedValueID:self.dropdownType];

    
    NGCustomCell2 *cell = (NGCustomCell2*)[tableView cellForRowAtIndexPath:indexPath];
    if (obj.selectionLimit.integerValue != 1){
    
        NSInteger selectionLimit = obj.selectionLimit.integerValue;
        if([self.selectedIds containsObject:value]){
            [self.selectedIds removeObject:value];
            cell.selectionImageView.image = [UIImage imageNamed:@"uncheck"];
            [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@", cell.labelText.text] value:@"0" forUIElement:cell.labelText];
        }
        else{
            if (selectionLimit<=0 || self.selectedIds.count<selectionLimit) {
                [self.selectedIds addObject:value];
                cell.selectionImageView.image = [UIImage imageNamed:@"check"];
                
                [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@", cell.labelText.text] value:@"1" forUIElement:cell.labelText];
            }else{
                
                [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:[NSString stringWithFormat:@"You have already selected %ld values.",(long)selectionLimit] animationTime:5 showAnimationDuration:0];
                
                [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:[NSString stringWithFormat:@"You have already selected %ld values.",(long)selectionLimit] animationTime:5 showAnimationDuration:0];
                
                isErrorBannerVisibileToUser = YES;
        }
            
        }
        
        
    }
    else{
        
        if([self.selectedIds containsObject:value]){
            [self.selectedIds removeAllObjects];
            cell.selectionImageView.image = [UIImage imageNamed:@"uncheck"];
            if([selectedIndexesArray count])
                [selectedIndexesArray removeObjectAtIndex:0];
            
        }else{
            
            [self.selectedIds removeAllObjects];
            [self.selectedIds addObject:value];
            
            NGCustomCell2 *lastCell = (NGCustomCell2*)[tableView
                                                       cellForRowAtIndexPath:self.lastIndexPath];
            lastCell.selectionImageView.image = [UIImage imageNamed:@"uncheck"];
            cell.selectionImageView.image = [UIImage imageNamed:@"check"];
            [selectedIndexesArray insertObject:[NSNumber numberWithLong:indexPath.row] atIndex:0];
        }
        
        self.lastIndexPath = indexPath;
        
        [self.contentTableView reloadData];
        
        [self.searchDisplayController.searchBar resignFirstResponder];
        [self.searchDisplayController setActive:NO animated:YES];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectValues:success:)])
            [self.delegate didSelectValues:[self getResponse] success:TRUE];
        
        
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectValues:success:withSelectedIndexes:)])
            [self.delegate didSelectValues:[self getResponse] success:YES withSelectedIndexes:selectedIndexesArray];
        
        return;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NSString *value;
    DDBase* obj;
    
    if (_searchBar.bIsSearchModeOn){
        obj = [_filteredValues fetchObjectAtIndex:indexPath.row];
        value = obj.valueName;
        if (![NGDecisionUtility isValidNonEmptyNotNullString:value]) {
            value = @"No Results Found";
        }
    }
    else{
        obj = [arrData fetchObjectAtIndex:indexPath.row];
        value = obj.valueName;
    }
    
    CGFloat labelSizeHeight = [value getDynamicHeightWithFont:[UIFont
                                                             fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0f] width:186.0f];
    
    if (![obj.descriptionText isEqualToString:@""]) {
        
        CGFloat descriptionSizeHeight = [obj.descriptionText getDynamicHeightWithFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0f] width:186.0f];
        return 35.0 + labelSizeHeight + descriptionSizeHeight;
    }
    return 35.0 + labelSizeHeight;
}


-(NGCustomCell2 *)configureCell:(NSIndexPath *)indexPath forTableView:(UITableView *)tableview{
    static NSString *cellIdentifier = @"ValueSelectionCell";
    
    NGCustomCell2 *cell = (NGCustomCell2*)[self.contentTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[NGCustomCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionImageView.hidden = NO;

    DDBase* myObj;
    
    if (_searchBar.bIsSearchModeOn)
        myObj = [_filteredValues fetchObjectAtIndex:indexPath.row];
    else
        myObj = [arrData fetchObjectAtIndex:indexPath.row];

    NSString *value = myObj.valueName;
    if (![NGDecisionUtility isValidNonEmptyNotNullString:value]) {
        value = @"No Results Found";
        cell.selectionImageView.hidden = YES;
    }
    cell.labelText.text = @"";
    cell.lblDescription.text = @"";
    cell.labelText.text = value;
    [cell setCellWithTitle:cell.labelText.text];
    

    if ([myObj.descriptionText isEqualToString:@""])
        [cell.lblDescription removeFromSuperview];
    else{
        cell.lblDescription.text = myObj.descriptionText;
        
        CGFloat colorCode = 122.0f/255.0f;
        cell.lblDescription.textColor = [UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f];
        [cell setCellWithDescription:cell.lblDescription.text];
        
    }
    
    NSString* strIdToCheck = [myObj selectedValueID:self.dropdownType];
   
    if([self.selectedIds containsObject:strIdToCheck]){

        cell.selectionImageView.image = [UIImage imageNamed:@"check"];
        [selectedIndexesArray insertObject:[NSNumber numberWithLong:indexPath.row] atIndex:0];
        
        [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@", cell.labelText.text] value:@"1" forUIElement:cell.labelText];
    }
    else{
        cell.selectionImageView.image = [UIImage imageNamed:@"uncheck"];
        [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@", cell.labelText.text] value:@"0" forUIElement:cell.labelText];
    }
    
    cell.labelText.textColor=UIColorFromRGB(0X515050);
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([[self.requestParams valueForKey:K_DROPDOWN_NO_OF_SECTIONS] integerValue]>1)
    {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 8, tableView.frame.size.width, 40)];
        
        [label setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15]];
        label.textColor=UIColorFromRGB(0Xbebdbd);
        label.backgroundColor = UIColorFromRGB(0Xe9e8e8);
        
        
        NSString *string =[[self.requestParams valueForKey:K_DROPDOWN_SECTION_HEADERS] fetchObjectAtIndex:section];
        if(!string){
            
            string = [NSString stringWithFormat:@"Other"];
            
        }
        [label setText:string];
        [view addSubview:label];
        
        view.backgroundColor = UIColorFromRGB(0Xe9e8e8);
        
        return view;
    }
    
    else
    {
        return self.contentTableView.tableHeaderView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if([[self.requestParams valueForKey:K_DROPDOWN_NO_OF_SECTIONS] integerValue]>1)
    {
        return 54;
    }
    else
        return UITableViewAutomaticDimension;
    
}

#pragma mark - UISearchDisplayController Delegate Methods



-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchDisplayController setActive:NO animated:YES];
}


#pragma mark Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText{
    
    if(!_filteredValues)
        _filteredValues = [NSMutableArray array];
    else
        [self.filteredValues removeAllObjects];
    
    [UIAutomationHelper setAccessibiltyLabel:@"DDSearch" value:searchText forUIElement:_searchBar.searchTextField];

    NSString* strIncludingSpace = [NSString stringWithFormat:@" %@", searchText];
    NSString* strIncludingBrackets = [NSString stringWithFormat:@"(%@", searchText];
    NSString* strIncludingSpaceAndBrackets = [NSString stringWithFormat:@" (%@", searchText];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"valueName beginswith[cd] %@ or valueName contains[cd] %@ or valueName contains[cd] %@ or valueName contains[cd] %@",
                              searchText, strIncludingSpace, strIncludingBrackets,strIncludingSpaceAndBrackets];
    _filteredValues = [NSMutableArray arrayWithArray:[arrDataForSearch filteredArrayUsingPredicate:predicate]];
    [_contentTableView reloadData];

}

-(void)didBeginSearch:(NSString*)searchStr{
  
    searchStr = [searchStr stringByTrimmingLeadingWhitespace];
    [self filterContentForSearchText:searchStr];
}
-(void)didEndSearch{
    
    [_contentTableView reloadData];
}
#pragma mark- Adding predictors
-(void)addPredictorsInDropDownArrayWithPredictorType:(int) dropdownType{

    switch (dropdownType) {
        case DDC_FAREA:
        {
        
            if([_delegate isKindOfClass:[NGResmanExpProfessionalDetailsViewController class]]){
                NGResmanDataModel*  resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
                if(resmanModel){
                    if(resmanModel.designation.length>0){
                        NSArray* ddobjArr = [NGDatabaseHelper searchForType:KEY_VALUE havingValue:resmanModel.designation andClass:[DDBase classForDDType:DDC_DESIGNATION]];
                        if(ddobjArr.count>0){
                            Designation *designationObj = [ddobjArr fetchObjectAtIndex:0];
                            NSArray *faMappedObjArr = [designationObj.famappings allObjects];
                            
                            //sort logic
                            NSArray *sortedFA_ID_Arr = [designationObj.sortedFA_ID componentsSeparatedByString:@","];
                            for (int i =0; i<sortedFA_ID_Arr.count; i++){
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"valueID == %i",[sortedFA_ID_Arr[i] intValue]];
                                NSArray* filteredArr = [faMappedObjArr filteredArrayUsingPredicate:predicate];
                                if(filteredArr.count == 1)
                                    [arrData insertObject:[filteredArr objectAtIndex:0] atIndex:i];
                            }
                            
                        }
                    }
                }
            }
            
        }
            break;
        case DDC_INDUSTRY_TYPE:
        {
            
            if([_delegate isKindOfClass:[NGResmanExpProfessionalDetailsViewController class]]){
                
                NGResmanDataModel*  resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
                if(resmanModel){
                    if(resmanModel.company.length>0){
                        NSArray* ddobjArr = [NGDatabaseHelper searchForType:KEY_VALUE havingValue:resmanModel.company andClass:[DDBase classForDDType:DDC_COMPANY]];
                        if(ddobjArr.count>0){
                            CompanyName *compObj = [ddobjArr fetchObjectAtIndex:0];
                            NSArray *iaMappedObjArr = [compObj.iamappings allObjects];
                            
                            //sort logic
                            NSArray *sortedIA_ID_Arr = [compObj.sortedIA_ID componentsSeparatedByString:@","];
                            for (int i =0; i<sortedIA_ID_Arr.count; i++){
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"valueID == %i",[sortedIA_ID_Arr[i] intValue]];
                                NSArray* filteredArr = [iaMappedObjArr filteredArrayUsingPredicate:predicate];
                                if(filteredArr.count == 1)
                                    [arrData insertObject:[filteredArr objectAtIndex:0] atIndex:i];
                            }
                            
                        }
                    }
                }
            }

        }
            break;
            
        default:
            break;
    }
    
}
@end