//
//  NGLayeredValueSelectionViewController.m
//  Naukri
//
//  Created by Arun Kumar on 8/27/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGLayeredValueSelectionViewController.h"
#import "NGValueSelectionRequestModal.h"
#import "NGCustomCell.h"
#import "NGValueSelectionResponseModal.h"

@interface NGLayeredValueSelectionViewController ()<LayeredValueSelectionDelegate>{
    
    IBOutlet UITableView* tblDisplay;
    IBOutlet UILabel* lblHeaderTitle;
    IBOutlet UIButton* btnClear;
    IBOutlet UIView* viewHeader;
    NSInteger iPreviouslySelectedRow;
    __weak IBOutlet NSLayoutConstraint *tableTopLC;
    NSMutableArray* arrDataForSearch; // have unique modals of displayData
    __weak IBOutlet NSLayoutConstraint *doneBtnBottomLayoutConstraint;

}

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *titleHeaderTopLayoutConstraint;
@property (nonatomic,strong) NSMutableArray* filteredValues;

@end

@implementation NGLayeredValueSelectionViewController

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

    _valueSelectionResponseModal.dropDownType = _dropdownType;
    viewHeader.backgroundColor = Clr_Status_Bar;
    
    if ([NGDecisionUtility isValidNonEmptyNotNullString:self.selectedId])
        iPreviouslySelectedRow = [self.selectedId integerValue];
    else
        iPreviouslySelectedRow = -1;
    
    
    if (_searchBar==nil && _showSearchBar){
        tableTopLC.constant = 44;
        _searchBar = [[NGSearchBar alloc] init];
        _searchBar.delegate = self;
        [_searchBar addSearchBarOnView:self.view];
    }
    
    _searchBar.bIsSearchModeOn = NO;
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSMutableArray* arrLocal = [NSMutableArray array];
    arrDataForSearch = [NSMutableArray array];
    for (NGValueSelectionRequestModal* obj in _displayData) {
        if (![arrLocal containsObject:obj.value]) {
            [arrLocal addObject:obj.value];
            [arrDataForSearch addObject:obj];
        }
    }
    arrLocal = nil;
    
    _titleHeaderTopLayoutConstraint.constant += 20;
    [viewHeader updateConstraints];
    
    UIView* viewToReturn = nil;
    
    viewToReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    
    [viewToReturn setBackgroundColor:[viewHeader backgroundColor]];
    [self.view addSubview:viewToReturn];
    [self.view setNeedsLayout];
    
    
    NGValueSelectionRequestModal* modal = [self.displayData objectAtIndex:0];
    if (modal.requestModalArr.count){
        btnClear.hidden = YES;
        _btnBottom.hidden = NO;
    }
    else{
        
        btnClear.hidden = NO;
        if (![_delegateOfLayerViewController isKindOfClass:[self class]]){
            _btnBottom.hidden = YES;
            doneBtnBottomLayoutConstraint.constant = -_btnBottom.frame.size.height;

        }
    }
    
    lblHeaderTitle.text = [self.arrTitles objectAtIndex:self.iLayerProgressStatus-1];
 
}
-(void)sideMenuStateDidChange:(NSNotification*)notif
{
    MFSideMenuState state = (MFSideMenuState)[[notif.userInfo valueForKey:@"eventType"] integerValue];
    if(state == MFSideMenuStateEventMenuWillClose)
    {
        [_searchBar.searchTextField resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_searchBar.bIsSearchModeOn){
        if (!_filteredValues.count) return 1;
        else  return [self.filteredValues count];

    }
    return self.displayData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [UITableViewCell getCellHeight:[self configCellForIndexPath:indexPath]];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (CGFloat)heightForCell{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configCellForIndexPath:indexPath];
}
- (NGCustomCell*)configCellForIndexPath:(NSIndexPath*)paramIndexPath{
    static NSString *cellIdentifier = @"ValueSelectionCell";

    NGCustomCell *cell = (NGCustomCell*)[tblDisplay dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[NGCustomCell alloc]initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
    
    cell.selectionImageView.hidden = NO;
    NGValueSelectionRequestModal* modal;
    NSString* value;

    
    if (_searchBar.bIsSearchModeOn){
        
        modal = [self.filteredValues fetchObjectAtIndex:paramIndexPath.row];
        value = modal.value;
        if (![NGDecisionUtility isValidNonEmptyNotNullString:value]){
            value = @"No Results Found";
            cell.selectionImageView.hidden = YES;

        }
        
    }
    else{
        modal = [self.displayData fetchObjectAtIndex:paramIndexPath.row];
        value = modal.value;
    }
    
    
    cell.labelText.text = value;
    if (modal.requestModalArr.count)
        cell.selectionImageView.image = [UIImage imageNamed:@"arrow"];
    
    else if([_valueSelectionResponseModal.selectedId isEqualToString:modal.identifier])
        cell.selectionImageView.image = [UIImage imageNamed:@"check"];
    else
        cell.selectionImageView.image = [UIImage imageNamed:@"uncheck"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NGValueSelectionRequestModal* modal;
    if (_searchBar.bIsSearchModeOn){
        modal = [_filteredValues fetchObjectAtIndex:indexPath.row];
        if (!_filteredValues.count)
            return;
    
    }
    else
        modal =  [_displayData fetchObjectAtIndex:indexPath.row];
    
    if (modal.requestModalArr.count) {
        
        //
        if (![modal.identifier isEqualToString:_valueSelectionResponseModal.selectedId]) {
            _valueSelectionResponseModal.selectedId = modal.identifier;
            _valueSelectionResponseModal.selectedValue = modal.value;
            _valueSelectionResponseModal.dropDownType = self.dropdownType;
            _valueSelectionResponseModal.valueSelectionResponseObj = nil;
        }
        
        NGLayeredValueSelectionViewController* _selectionLayerVC = [[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"layerSelection"];
        _selectionLayerVC.delegateOfLayerViewController = self;
        _selectionLayerVC.displayData = modal.requestModalArr;
        _selectionLayerVC.arrTitles = self.arrTitles;
        _selectionLayerVC.dropdownType = self.dropdownType;
        _selectionLayerVC.iLayerProgressStatus = self.iLayerProgressStatus +1;
        _selectionLayerVC.valueSelectionResponseModal = self.valueSelectionResponseModal.valueSelectionResponseObj;
        _selectionLayerVC.selectedId = self.valueSelectionResponseModal.valueSelectionResponseObj.selectedId;
        
        CGRect tempFrame = _selectionLayerVC.view.frame;
        tempFrame.origin.x = self.view.frame.origin.x + self.view.frame.size.width;
        _selectionLayerVC.view.frame = tempFrame;
        _selectionLayerVC.view.tag = 578;
        _selectionLayerVC.view.backgroundColor = Clr_DropDown_Base_Gray;
        [[NGHelper sharedInstance].valueSelectionLayerArray addObject:_selectionLayerVC];
        [self.view addSubview:_selectionLayerVC.view];
        [self addChildViewController:_selectionLayerVC];
                
        [NGUIUtility slideView:_selectionLayerVC.view
                                      toXPos:0 toYPos:0
                                    duration:0.25f delay:0.0f];
        
        
    }else{
        
        if (iPreviouslySelectedRow != [modal.identifier integerValue]) {
            
            if (iPreviouslySelectedRow != -1) {
                
                NSInteger previousRow =0;
                for (NGValueSelectionRequestModal* tmpModal in self.displayData){
                    
                    if ([tmpModal.identifier isEqualToString:
                         [NSString stringWithFormat:@"%ld",(long)iPreviouslySelectedRow]]) {
                        break;
                    }
                    else
                        previousRow++;
                    
                }
                
               NGCustomCell* cellPrevious = (NGCustomCell*)[tblDisplay cellForRowAtIndexPath:
                                                             [NSIndexPath indexPathForRow:previousRow
                                                                                inSection:0]];
                cellPrevious.selectionImageView.image = [UIImage imageNamed:@"uncheck"];
            }
            
           NGCustomCell* cellCurrent = (NGCustomCell*)[tblDisplay cellForRowAtIndexPath:indexPath];
            cellCurrent.selectionImageView.image = [UIImage imageNamed:@"check"];
            iPreviouslySelectedRow = [modal.identifier integerValue];
            
            if (![modal.identifier isEqualToString:_valueSelectionResponseModal.selectedId]) {
                _valueSelectionResponseModal.selectedId = modal.identifier;
                _valueSelectionResponseModal.selectedValue = modal.value;
                _valueSelectionResponseModal.dropDownType = self.dropdownType;
                _valueSelectionResponseModal.valueSelectionResponseObj = nil;
            }
            
            
        }else{
            
           NGCustomCell* cellCurrent = (NGCustomCell*)[tblDisplay cellForRowAtIndexPath:indexPath];
            cellCurrent.selectionImageView.image = [UIImage imageNamed:@"uncheck"];
            iPreviouslySelectedRow = -1;
            _valueSelectionResponseModal.selectedId = nil;
            _valueSelectionResponseModal.selectedValue = nil;
        }
    }
    
    if (![_delegateOfLayerViewController isKindOfClass:[self class]] && !modal.requestModalArr.count){
            [self onClickDoneOnFirstLayer];
            return;
    }
    
}


-(void)layerValueSelected:(NGValueSelectionResponseModal*)selectedModal{
    
    _valueSelectionResponseModal.valueSelectionResponseObj = selectedModal;
    
    [self onClickDoneOnFirstLayer];
    
    
    
}

-(void)hideBottomButton{
    self.btnBottom.hidden = YES;
}
- (void)dealloc
{
    
    if([self.filteredValues count])
        [self.filteredValues removeAllObjects];
    
    self.filteredValues = nil;
    
}
#pragma mark - Button Actions
-(IBAction)onDone:(id)sender{
    
    if ([NGHelper sharedInstance].valueSelectionLayerArray.count == 1){
        [self onClickDoneOnFirstLayer];
        
    }
    else if ([NGHelper sharedInstance].valueSelectionLayerArray.count == 2)
    {
        [self onClickDoneOnSecondLayer];

    }
    
    
}
-(void)onClickDoneOnFirstLayer{

    NGLayeredValueSelectionViewController *obj = [[NGHelper sharedInstance].valueSelectionLayerArray objectAtIndex:0];
    
    
    NGValueSelectionRequestModal* modal = [obj.displayData objectAtIndex:0];
    if (modal.requestModalArr.count && (obj.valueSelectionResponseModal.valueSelectionResponseObj.selectedId == nil))
        obj.valueSelectionResponseModal.selectedId = nil;
    
    if (obj.delegateOfLayerViewController && [obj.delegateOfLayerViewController respondsToSelector:@selector(layerValueSelected:)]) {
        [obj.delegateOfLayerViewController layerValueSelected:_valueSelectionResponseModal];
    }
    

    [[NGAppDelegate appDelegate].container toggleRightSideMenuCompletion:nil];
    


}
-(void)onClickDoneOnSecondLayer{
    
    
    NSInteger previousRow =0;
    for (NGValueSelectionRequestModal* tmpModal in self.displayData){
        
        if ([tmpModal.identifier isEqualToString:
             [NSString stringWithFormat:@"%ld",(long)iPreviouslySelectedRow]]) {
            break;
        }
        else
            previousRow++;
        
    }
    
    NGValueSelectionRequestModal* modal = nil;
    if (-1 != iPreviouslySelectedRow && previousRow<self.displayData.count) {
        modal = [self.displayData fetchObjectAtIndex:previousRow];
    }
    
    
    NGValueSelectionResponseModal* responseModal = [[NGValueSelectionResponseModal alloc] init];
    if (nil != modal) {
        responseModal.selectedId = modal.identifier;
        responseModal.selectedValue = modal.value;
        responseModal.dropDownType = self.dropdownType;
    }
    
    if ([responseModal.selectedId isEqualToString:_selectedId] && -1==iPreviouslySelectedRow)
        responseModal = nil;
    
    if (_delegateOfLayerViewController && [_delegateOfLayerViewController respondsToSelector:@selector(layerValueSelected:)])
        [_delegateOfLayerViewController layerValueSelected:responseModal];
    
    UIView* viewRemove = [self.view viewWithTag:578];
    [NGUIUtility slideView:viewRemove
                    toXPos:SCREEN_WIDTH toYPos:0 duration:0.25f delay:0.0f];
    [viewRemove removeFromSuperview];
    [self removeFromParentViewController];
    [[NGHelper sharedInstance].valueSelectionLayerArray removeLastObject];
    
    
    
    
}
-(IBAction)onClear:(id)sender{
    _selectedId = nil;
    iPreviouslySelectedRow = -1;
    _valueSelectionResponseModal.selectedId = nil;
    _valueSelectionResponseModal.selectedValue = nil;
  [tblDisplay reloadData];
    
}

-(void)filterContentForSearchText:(NSString*)searchText{
    
    if(!_filteredValues)
        _filteredValues = [NSMutableArray array];
    else
        [self.filteredValues removeAllObjects];
 
    
    NSString* strIncludingSpace = [NSString stringWithFormat:@" %@", searchText];
    NSString* strIncludingBrackets = [NSString stringWithFormat:@"(%@", searchText];
    NSString* strIncludingSpaceAndBrackets = [NSString stringWithFormat:@" (%@", searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.value beginswith[cd] %@ or self.value contains[cd] %@ or self.value contains[cd] %@ or self.value contains[cd] %@",
                              searchText, strIncludingSpace, strIncludingBrackets,strIncludingSpaceAndBrackets];
    
    _filteredValues = [NSMutableArray arrayWithArray:[arrDataForSearch filteredArrayUsingPredicate:predicate]];
   
    [tblDisplay reloadData];
    
}

-(void)didBeginSearch:(NSString*)searchStr{
    [self filterContentForSearchText:searchStr];
}
-(void)didEndSearch{
    
    [tblDisplay reloadData];
}
@end
