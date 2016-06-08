//
//  NGSecondLayer.m
//  NaukriGulf
//
//  Created by Arun Kumar on 24/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSecondLayer.h"
#import "NGSecondLayerCell.h"

@interface NGSecondLayer ()
{
    NSMutableArray* arrDataForSearch; // have unique modals of displayData
    
    __weak IBOutlet NSLayoutConstraint *tableViewTopConstrnt;
    
    

}

@property (nonatomic, retain) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIView *btnDoneContView;
@property (weak, nonatomic) IBOutlet UITableView *secondLyrTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightContraint;

@property (nonatomic,strong) NSMutableArray* filteredValues;



-(IBAction)closeSecondLayer:(id)sender;

@end

@implementation NGSecondLayer
{
    NSString *thisCat;
}

@synthesize view;

#pragma mark -
#pragma mark UIView Methods

- (id)initWithFrame:(CGRect)frame withHeaderText:(NSString *)headerText withData:(NSMutableArray *)arr withCatergory:(NSString *)category andSelectedRows:(NSMutableArray *)arrToCome
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self=[[[NSBundle mainBundle] loadNibNamed:@"SecondLayerController" owner:self options:nil] lastObject];
        [self setFrame:frame];
    }

   
    _headerViewHeightContraint.constant = _headerViewHeightContraint.constant + 20;
    self.headerLbl.text = headerText;
    [self.headerLbl setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:16]];
    [UIAutomationHelper setAccessibiltyLabel:@"refineHeader_lbl" value:_headerLbl.text forUIElement:_headerLbl];
    
    self.dataArr = arr;
    
    self.selectedRows=arrToCome;
    
    self.selectedValues = [[NSMutableArray alloc]initWithArray:arrToCome];
    
    thisCat = category;
   
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.view];
    [UIAutomationHelper setAccessibiltyLabel:@"doneSelectingFilter_btn" forUIElement:_btnDone];
    [UIAutomationHelper setAccessibiltyLabel:@"secondLyrTableView" forUIElement:self.secondLyrTableView withAccessibilityEnabled:NO];
}
-(void)showSearchBar{
    NSMutableArray* arrLocal = [NSMutableArray array];
    arrDataForSearch = [NSMutableArray array];
    
    for (NSDictionary* obj in self.dataArr) {
        if (![arrLocal containsObject:[obj objectForKey:@"value"]]) {
            [arrLocal addObject:[obj objectForKey:@"value"]];
            [arrDataForSearch addObject:obj];
        }
    }
    arrLocal = nil;
    
    if (_searchBar==nil){
        
        tableViewTopConstrnt.constant = 44;
        _searchBar = [[NGSearchBar alloc] init];
        _searchBar.delegate = self;
        [_searchBar addSearchBarOnClusteredView:self];
    }
    
    _searchBar.bIsSearchModeOn = NO;
}

#pragma mark Tableview Delegate functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchBar.bIsSearchModeOn){
        if (!_filteredValues.count) return 1;
        else  return [self.filteredValues count];
        
    }
    return [self.dataArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configureCell:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSDictionary *tempDict ;
    if (_searchBar.bIsSearchModeOn){
    
        tempDict = [self.filteredValues fetchObjectAtIndex:indexPath.row];
        
    }
    else{
        tempDict = [self.dataArr fetchObjectAtIndex:indexPath.row];

    }
    
    if([self.selectedValues containsObject:[tempDict objectForKey:@"value"]])
    {
        [self.selectedValues removeObject:[tempDict objectForKey:@"value"]];
        
    }
    else
    {
        [self.selectedValues addObject:[tempDict objectForKey:@"value"]];
        
    }
    
    if([self.selectedRows containsObject:[NSNumber numberWithLong:indexPath.row]])
    {
        [self.selectedRows removeObject:[NSNumber numberWithLong:indexPath.row]];
        [tableView reloadData];
        
    }
    else
    {
        [self.selectedRows addObject:[NSNumber numberWithLong:indexPath.row]];
        [tableView reloadData];
        
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view1 = [[UIView alloc] init];
    
    return view1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 0;
    
    NGSecondLayerCell *cell = [self configureCell:indexPath];
    float h = cell.textLbl.frame.size.height;
    height = h + 36;
    
    return height;
}

#pragma mark - Search Bar delgates
-(void)filterContentForSearchText:(NSString*)searchText{
    
    if(!_filteredValues)
        _filteredValues = [NSMutableArray array];
    else
        [self.filteredValues removeAllObjects];
    
    
    
    NSString* strIncludingSpace = [NSString stringWithFormat:@" %@", searchText];
    NSString* strIncludingBrackets = [NSString stringWithFormat:@"(%@", searchText];
    NSString* strIncludingSpaceAndBrackets = [NSString stringWithFormat:@" (%@", searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.label beginswith[cd] %@ or self.label contains[cd] %@ or self.label contains[cd] %@ or self.label contains[cd] %@",
                              searchText, strIncludingSpace, strIncludingBrackets,strIncludingSpaceAndBrackets];
    _filteredValues = [NSMutableArray arrayWithArray:[arrDataForSearch filteredArrayUsingPredicate:predicate]];
    
    [_secondLyrTableView reloadData];
    
}

-(void)didBeginSearch:(NSString*)searchStr{
    [self filterContentForSearchText:searchStr];
}
-(void)didEndSearch{
    [_secondLyrTableView reloadData];
}

#pragma mark -
#pragma mark Private Methods

/**
 *  Configuring the cell
 *
 *  @param indexPath indexPath
 *
 *  @return CustomCell
 */

-(NGSecondLayerCell *)configureCell:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    static NSString *CellNib = @"SecondLayerCell";
    
    NSInteger row = [indexPath row];
    
    NGSecondLayerCell *cell = (NGSecondLayerCell*)[self.secondLyrTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (NGSecondLayerCell *)[nib fetchObjectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.checkMarkImg.hidden = NO;
    cell.countBtn.hidden = NO;

    NSDictionary *tempDict ;
    NSString * val ;
    
    if (_searchBar.bIsSearchModeOn){
        
        tempDict  = [self.filteredValues fetchObjectAtIndex:indexPath.row];
        val = [tempDict objectForKey:@"label"];
        if (![NGDecisionUtility isValidNonEmptyNotNullString:val]){
            val = @"No Results Found";
            cell.checkMarkImg.hidden = YES;
            cell.countBtn.hidden = YES;
        }
        
    }
    else{
       tempDict = [self.dataArr fetchObjectAtIndex:indexPath.row];
       val = [tempDict objectForKey:@"label"];
    }
    cell.textLbl.textColor=[UIColor whiteColor];
    cell.textLbl.text= val;
    
    
    CGSize tmpLabelSize = [cell.textLbl getDynamicSize];
    [cell updateConstraintsWithSize:tmpLabelSize];
    
    
    float labelSizeHeight = [cell.textLbl.text getDynamicHeightWithFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0f] width:tmpLabelSize.width];
    [cell updateConstraintsWithSize:CGSizeMake(tmpLabelSize.width, labelSizeHeight)];
    
    //The Count
    NSNumber *cnt = [tempDict valueForKey:@"count"];
    [cell.countBtn setTitle:[NSString stringWithFormat:@"%@",cnt] forState:UIControlStateNormal];
    
    BOOL isCheckBoxSelected = NO;//used for setting
    if([self.selectedValues containsObject:[tempDict objectForKey:@"value"]])
    {
        cell.checkMarkImg.image=[UIImage imageNamed:@"check_box"];
        isCheckBoxSelected = YES;
    }
    else
    {
        cell.checkMarkImg.image=[UIImage imageNamed:@"uncheck_box"];
    }
    
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"SecondLayerCellText_Lbl_%ld",(long)row] value:cell.textLbl.text forUIElement:cell.textLbl];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"SecondLayerCellCount_Btn_%ld",(long)row] value:cell.countBtn.titleLabel.text forUIElement:cell.countBtn];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"SecondLayerCellOption_Img_%ld",(long)row] value:[NSString stringWithFormat:@"%d",isCheckBoxSelected] forUIElement:cell.checkMarkImg];
    
    [cell setAccessibilityLabel:[NSString stringWithFormat:@"SecondLayerCell_%ld",(long)row]];
 
    return cell;
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)closeSecondLayer:(id)sender{
    
    [NGUIUtility slideView:self toXPos:SCREEN_WIDTH toYPos:0 duration:0.25f delay:0.0f];      

    [self.delegate didSelectOptions:self.selectedValues ofCategory:thisCat withSelectedRows:self.selectedRows];
    
}

-(void)dealloc{
    self.secondLyrTableView.delegate = nil;
    self.secondLyrTableView.dataSource = nil;
    self.secondLyrTableView = nil;
}

@end
