//
//  NGFilterViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 20/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGFilterViewController.h"
#import "NGFilterOptionsCell.h"


#define SECOND_LAYER_TAG 500

@interface NGFilterViewController ()

{
    NGLoader *loader;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIView *resetView;
@property (weak, nonatomic) IBOutlet UIView *btnDoneContView;
-(IBAction)doneSelectingFilters:(id)sender;

@end

@implementation NGFilterViewController{
    
    NSMutableArray *filterItemsArray;
    NSString *selectedCategory;
    NSMutableDictionary *selectedDict;

}

#pragma mark -
#pragma mark UIViewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(self.view.frame.origin.x
                                     , self.view.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    _headerViewHeight.constant = _headerViewHeight.constant + 20;
    [self updateFiltersList];
    
    
    self.resultDict = [[NSMutableDictionary alloc] init];
    selectedDict = [[NSMutableDictionary alloc] init];
    self.paramsDict = [[NSMutableDictionary alloc]init];
    [UIAutomationHelper setAccessibiltyLabel:@"doneSelectingFilter_btn" forUIElement:_btnDone];

    [UIAutomationHelper setAccessibiltyLabel:@"filterTableView" forUIElement:self.filterTableView withAccessibilityEnabled:NO];
 
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}


#pragma mark -
#pragma mark handling Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Private Mehtods


/**
 *  Update the Clusters list
 */

-(void)updateFiltersList{
    [filterItemsArray removeAllObjects];
    
    NSString *filePath = [NGConfigUtility getAppConfigFilePath];
    
    if (filePath)
    {
        NSMutableDictionary *root=[[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        filterItemsArray=[[NSMutableArray alloc] initWithArray:[root valueForKey:@"FilterItemsArray"]];
        
    }
    
    NSString *locations = [self.paramsDict objectForKey:@"Location"];
    
    if (![locations isEqualToString:@""]) {
        [filterItemsArray removeObject:@"Jobs by Country"];
        [filterItemsArray removeObject:@"Jobs by City"];
    }
    
    NSInteger exp = [[self.paramsDict objectForKey:@"Experience"]integerValue];
    if (exp!=Const_Any_Exp_Tag) {
        [filterItemsArray removeObject:@"Jobs by Experience"];
    }
    
    NSArray *nameArr = [NSArray arrayWithObjects:@"Jobs by Title",@"Jobs by Freshness",@"Jobs by Monthly Salary",@"Jobs by Country",@"Jobs by Gender",@"Jobs by Experience",@"Jobs by Industry",@"Jobs by City",@"Jobs by Employers", nil];
    
    NSArray *nameAPIArr = [NSArray arrayWithObjects:@"titles",@"freshness",@"ctc",@"country",@"gender",@"experience",@"industryType",@"citysrp",@"companyType", nil];
   
    
    for (NSInteger i = 0; i<nameAPIArr.count; i++) {
        NSString *name = [nameArr fetchObjectAtIndex:i];
        NSString *nameAPI = [nameAPIArr fetchObjectAtIndex:i];
        id clusters = [self.clusterDict objectForKey:nameAPI];
        NSArray *clusterArr = (NSArray *)clusters;
        
        if (([clusters class]==[NSNull class] || clusterArr.count==0) && [filterItemsArray containsObject:name]) {
            [filterItemsArray removeObject:name];
        }
    }
    
}

-(void)resetAll{
    [self removeSecondLayer];
    self.filterTableView.userInteractionEnabled = YES;
    [selectedDict removeAllObjects];
    [self.filterTableView reloadData];
    
}

/**
 *  Removes second layer of clusters
 */

-(void)removeSecondLayer{
    UIView *viw = [self.view viewWithTag:SECOND_LAYER_TAG];
    [viw removeFromSuperview];
}

/**
 *  Returns the cluster information containing APIName & RequestName
 *
 *  @param clusterName clusterName
 *
 *  @return Dictionary with cluster information
 */

-(NSMutableDictionary *)getClusterInfoWithName:(NSString *)clusterName{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSArray *nameArr = [NSArray arrayWithObjects:@"Jobs by Title",@"Jobs by Freshness",@"Jobs by Monthly Salary",@"Jobs by Country",@"Jobs by Gender",@"Jobs by Experience",@"Jobs by Industry",@"Jobs by City",@"Jobs by Employers", nil];
    
    NSArray *nameAPIArr = [NSArray arrayWithObjects:@"titles",@"freshness",@"ctc",@"country",@"gender",@"experience",@"industryType",@"citysrp",@"companyType", nil];
    
    NSArray *nameRequestArr = [NSArray arrayWithObjects:@"JobTitles",@"Freshness",@"ClusterCTC",@"ClusterCountry",@"ClusterGender",@"ClusterExperience",@"ClusterInd",@"ClusterCity",@"CompanyType", nil];
    
    for (NSInteger i = 0; i< nameArr.count; i++) {
        if ([[nameArr fetchObjectAtIndex:i] isEqualToString:clusterName]) {
            [dict setObject:[nameAPIArr fetchObjectAtIndex:i] forKey:@"APIName"];
            [dict setObject:[nameRequestArr fetchObjectAtIndex:i] forKey:@"RequestName"];
        }
    }
    
    
    return dict;
}

-(NSInteger)getSelectedFiltersCountForCategory:(NSString *)category{
    NSInteger count = 0;
    
    NSDictionary *clusterInfoDict = [self getClusterInfoWithName:category];
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *arr = [NSMutableArray array];
    
    id obj = [self.clusterDict objectForKey:[clusterInfoDict objectForKey:@"APIName"]];
    if ([obj isKindOfClass:[NSMutableArray class]]) {
        tempArr = [self.clusterDict objectForKey:[clusterInfoDict objectForKey:@"APIName"]];
    }else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = obj;
        for (NSString *key in dict.allKeys) {
            [tempArr addObject:[dict objectForKey:key]];
        }
    }
    NSString* selectedCategory1 = [clusterInfoDict objectForKey:@"RequestName"];
    
    for (int i=0; i<tempArr.count; i++) {
        [arr addObject:tempArr[i]];
    }
    
    NSMutableArray *arrToGo = [[NSMutableArray alloc] init];
    if([self.resultDict objectForKey:selectedCategory1]){
        [arrToGo addObjectsFromArray:[self.resultDict objectForKey:selectedCategory1] ];
    }

    NSMutableArray *selectedVal = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in arr) {
        if ([arrToGo containsObject:[dict objectForKey:@"value"]]) {
            count++;
            [selectedVal addObject:[dict objectForKey:@"value"]];
        }
    }
    
    
    [self.resultDict setObject:selectedVal forKey:selectedCategory1];
    
    return count;
}

#pragma mark table View delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filterItemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    static NSString *CellNib = @"CustomFilterCell";
    
    
    NGFilterOptionsCell *cell = (NGFilterOptionsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (NGFilterOptionsCell *)[nib fetchObjectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = UIColorFromRGB(0X0071BC);
        cell.selectedBackgroundView =  customColorView;
        
    }
    
    [cell.labelText setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:14.0f]];
     cell.labelText.textColor=[UIColor whiteColor];
     cell.labelText.text= [filterItemsArray fetchObjectAtIndex:indexPath.row];
     
    
    NSInteger row = indexPath.row;
    
    NSString *clusterName = [filterItemsArray fetchObjectAtIndex:row];
    
    NSDictionary *clusterInfoDict = [self getClusterInfoWithName:clusterName];    
    NSInteger filterCount = 0;
    
    if ([self.resultDict objectForKey:[clusterInfoDict objectForKey:@"RequestName"]]) {
        filterCount = [self getSelectedFiltersCountForCategory:clusterName];
    }    
        
    if (filterCount > 0) {
        //The Filters COunt
        cell.filterNumbersBtn.hidden = NO;
        [cell.filterNumbersBtn setTitle:[NSString stringWithFormat:@"%ld",(long)filterCount] forState:UIControlStateNormal];
        [cell.filterNumbersBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    else{
        cell.filterNumbersBtn.hidden = YES;
    }    
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"filterCellText_Lbl_%ld",(long)row] value:cell.labelText.text forUIElement:cell.labelText];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"filterCellCount_Btn_%ld",(long)row] value:cell.filterNumbersBtn.titleLabel.text forUIElement:cell.filterNumbersBtn];
    [cell setAccessibilityLabel:[NSString stringWithFormat:@"filterCell_%ld",(long)row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
    
    self.filterTableView.userInteractionEnabled = NO;
    
    NSMutableArray *arr = [[NSMutableArray alloc] init] ;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    NSInteger row = indexPath.row;
    
    NSString *clusterName = [filterItemsArray fetchObjectAtIndex:row];
    
    NSDictionary *clusterInfoDict = [self getClusterInfoWithName:clusterName];
    
    id obj = [self.clusterDict objectForKey:[clusterInfoDict objectForKey:@"APIName"]];
    if ([obj isKindOfClass:[NSMutableArray class]]) {
        tempArr = [self.clusterDict objectForKey:[clusterInfoDict objectForKey:@"APIName"]];
    }else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = obj;
        for (NSString *key in dict.allKeys) {
            [tempArr addObject:[dict objectForKey:key]];
        }
    }
    selectedCategory = [clusterInfoDict objectForKey:@"RequestName"];
        
    for (int i=0; i<tempArr.count; i++) {        
        [arr addObject:tempArr[i]];
    }
    
    NSMutableArray *arrToGo = [[NSMutableArray alloc] init];
    if([self.resultDict objectForKey:selectedCategory]){
        [arrToGo addObjectsFromArray:[self.resultDict objectForKey:selectedCategory] ];
    }
    
    
    
    NGSecondLayer *viw = [[NGSecondLayer alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH,SCREEN_HEIGHT) withHeaderText:[filterItemsArray fetchObjectAtIndex:indexPath.row] withData:arr withCatergory:selectedCategory andSelectedRows:arrToGo];
    viw.delegate = self;
    viw.tag = SECOND_LAYER_TAG;
    if ([[clusterInfoDict objectForKey:@"APIName"]isEqualToString:@"industryType"]||[[clusterInfoDict objectForKey:@"APIName"]isEqualToString:@"country"]||[[clusterInfoDict objectForKey:@"APIName"]isEqualToString:@"titles"])
        [viw showSearchBar];

    [self.view addSubview:viw];
    [NGUIUtility slideView:viw toXPos:0 toYPos:0 duration:0.25f delay:0.0f];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}


#pragma mark Button tap Functions

/**
 *  Reset is tapped.
 *
 *  @param sender sender
 */


-(IBAction)gotoReset:(id)sender
{
    [self.resultDict removeAllObjects];
    [selectedDict removeAllObjects];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setCustomObject:[self.paramsDict objectForKey:@"Offset"] forKey:@"Offset"];
    [params setCustomObject:[NSNumber numberWithInteger: [NGConfigUtility getJobDownloadLimit]] forKey:@"Limit"];
    [params setCustomObject:[self.paramsDict objectForKey:@"Keywords"] forKey:@"Keywords"];
    [params setCustomObject:[self.paramsDict objectForKey:@"Location"] forKey:@"Location"];
    [params setCustomObject:[self.paramsDict objectForKey:@"Experience"] forKey:@"Experience"];
    
    self.paramsDict = params;
    
    [self.filterTableView reloadData];
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    [self.filterDelegate doneFiltering:self.resultDict withRowsSelected:selectedDict];
}



- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.parentViewController;
}


#pragma mark IBAction methods

-(IBAction)doneSelectingFilters:(id)sender{
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    [self.filterDelegate doneFiltering:self.resultDict withRowsSelected:selectedDict];
}
#pragma mark SecondLayerDelegate Functions
-(void) didSelectOptions:(NSMutableArray *)arr ofCategory:(NSString *)name withSelectedRows:(NSMutableArray *)selectedRows
{
    BOOL refreshCluster = NO;
    if(![self compareArr:arr WithArray:[self.resultDict objectForKey:name]])
        refreshCluster = YES;

    NSMutableArray *finalArr = [[NSMutableArray alloc]init];
    [finalArr addObjectsFromArray:arr];
    [finalArr removeDuplicateObjects];
    [self.resultDict setCustomObject:finalArr forKey:name];
    [selectedDict setCustomObject:selectedRows forKey:name];
    if (finalArr.count==0)
    {
        [self.resultDict removeObjectForKey:name];
        [selectedDict removeObjectForKey:name];
        [self.paramsDict removeObjectForKey:name];

    }
    if(refreshCluster)
    {
        if([self.resultDict objectForKey:name])
            [self.paramsDict setCustomObject:[self.resultDict objectForKey:name] forKey:name];
        
        [self refreshCluster];
    }
    
    [self.filterTableView reloadData];
    self.filterTableView.userInteractionEnabled = YES;
}
-(BOOL)compareArr:(NSArray*)array1 WithArray:(NSArray*)array2{
    if(array1.count != array2.count)
    {
        return NO;
    }
    for (NSString* str in array1) {
        if(![array2 containsObject:str])
        {
            return NO;
        }
    }
    return YES;
}
-(void)refreshCluster{
    if (!loader) {
        loader  = [[NGLoader alloc]init];
    }
    [loader showAnimation:self.view];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.paramsDict];
    [dict setCustomObject:@"ios" forKey:@"requestsource"];
    [dict setCustomObject:@"1" forKey:@"clusterOnly"];
    [self downloadJobsWithParams:dict];
    
}
- (void)receivedServerResponse:(NGAPIResponseModal*)responseData{
    if (responseData.isSuccess) {
        NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
        NGJobDetailModel *objModel = [responseDataDict objectForKey:KEY_JOBS_INFO];
        NSMutableDictionary *clusterDict = objModel.clusters;
        self.clusterDict = clusterDict;
        [self updateFiltersList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetAll];
        });
    }else{
        //for error case
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.filterTableView reloadData];
        if (loader) {
            [loader hideAnimatior:self.view];
        }
    });
}
-(void)dealloc{
    self.filterTableView.delegate = nil;
    self.filterTableView.dataSource = nil;
    self.filterTableView = nil;
}

@end
