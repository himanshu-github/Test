//
//  AutocompletionTableView.m
//
//  Created by Gushin Arseniy on 11.03.12.
//  Copyright (c) 2012 Arseniy Gushin. All rights reserved.
//

#import "AutocompletionTableView.h"

NSInteger const K_DEFAULT_CELL_HIEGHT   = 43;
NSInteger const K_4INCHVIEW_CELL_HIEGHT = 43.5;

@interface AutocompletionTableView ()
{
    BOOL ifkeywordselected;
    NSMutableArray* kwWordCount;
    CGFloat topPositionForSuggestorView;
}
@property (nonatomic, strong) NSArray *suggestionOptions; // of selected NSStrings
// will set automatically as user enters text
@property (nonatomic, strong) UIFont *cellLabelFont; // will copy style from assigned textfield
@property (nonatomic,strong) NSString* keywordsText;
@property (nonatomic,strong) NSString* existingText;

@end

@implementation AutocompletionTableView

@synthesize suggestionsDictionary = _suggestionsDictionary;
@synthesize suggestionOptions = _suggestionOptions;
@synthesize textField = _textField;
@synthesize cellLabelFont = _cellLabelFont;
@synthesize options = _options;
@synthesize textFieldFrame=_textFieldFrame;
@synthesize isShowOptions;

#pragma mark - Initialization

- (UITableView *)initWithTextField:(UITextField *)textField inViewController:(UIViewController *) parentViewController withOptions:(NSDictionary *)options withDefaultStyle:(BOOL)style;

{
    self.isErrorViewVisibleInSearch=FALSE;
    self.keywordsText=[[NSString alloc] init];
    self.existingText=[[NSString alloc] init];
    kwWordCount=[[NSMutableArray alloc] init];
    ifkeywordselected=FALSE;
    
    
    [self.options valueForKey:ACOHighlightSubstrWithBold];
    //set the options first
    self.options = options;
    
    
    // save the font info to reuse in cells
    self.cellLabelFont = textField.font;
    
    self.prevOptionsDictionary = [NSMutableDictionary dictionary];
    
    self = [super init];
    
    
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = YES;
    self.bounces = NO;
    
    // turn off standard correction
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // to get rid of "extra empty cell" on the bottom
    // when there's only one cell in the table
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self setTableFooterView:v];
    self.hidden = YES;
    self.defaultView = style;
    
    [self setSeparatorInset:UIEdgeInsetsZero];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(self.defaultView){
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollEnabled = YES;
    self.bounces = NO;
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:YES];
    
    return self;
}


#pragma mark - Logic staff

- (BOOL) substringIsInDictionary:(NSString *)subString
{
    if (_autoCompleteDelegate && [_autoCompleteDelegate respondsToSelector:@selector(autoCompletion:suggestionsFor:)]) {
        self.suggestionsDictionary = [_autoCompleteDelegate autoCompletion:self suggestionsFor:subString];
    }
    
    //
    
    
    //if there is more than one suggestors textfield on the single page then clean the prevoius cached response of suggestors to avoid wrong data show on different suggestor
    if(self.prevOptionsDictionary.count>0){
        if([[self.prevOptionsDictionary objectForKey:@"textFieldType"] integerValue] != _textField.tag){
            [self.prevOptionsDictionary removeAllObjects];
        }
    }
        
 
    //First search with starting characters or containing substring as initial
    NSString* strIncludingSpace = [NSString stringWithFormat:@" %@", subString];
    NSPredicate *startPredicate = [NSPredicate predicateWithFormat:@"self beginswith[cd] %@ or self contains[cd] %@",subString, strIncludingSpace];
    
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    if(self.prevOptionsDictionary.count>0){
        if([subString hasPrefix:[self.prevOptionsDictionary objectForKey:@"key"]]){
            tmpArray = [self.prevOptionsDictionary objectForKey:@"value"];
            tmpArray = [NSMutableArray arrayWithArray:[tmpArray filteredArrayUsingPredicate:startPredicate]];
            
        }
        else{
            tmpArray = [NSMutableArray arrayWithArray:[self.suggestionsDictionary filteredArrayUsingPredicate:startPredicate]];
            [self.prevOptionsDictionary removeAllObjects];
            [self.prevOptionsDictionary setObject:tmpArray forKey:@"value"];
            [self.prevOptionsDictionary setObject:subString forKey:@"key"];
            [self.prevOptionsDictionary setObject:[NSString stringWithFormat:@"%li",(long)_textField.tag] forKey:@"textFieldType"];

        }
    }
    else{
        tmpArray = [NSMutableArray arrayWithArray:[self.suggestionsDictionary filteredArrayUsingPredicate:startPredicate]];
        self.prevOptionsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:tmpArray,@"value",subString,@"key",[NSString stringWithFormat:@"%li",(long)_textField.tag], @"textFieldType",nil];
    }

    
    if (tmpArray.count>0)
        self.suggestionOptions = tmpArray;

    //for any suggestor except email suggestor ,  show the suggestor when user enters atleast two charactes
    if(_isEmailAddressSuggestor && tmpArray.count>0){
            return YES;
    }
    if (tmpArray.count>0 && subString.length>1 ){
        return YES;
    }

    return NO;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (IS_IPHONE5)
        return K_4INCHVIEW_CELL_HIEGHT;
    else
        return K_DEFAULT_CELL_HIEGHT;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    float newFrameHeight = 0.0f;
    NSInteger keySuggestorCountVar = [self keySuggestorCount];
    
    if (self.suggestionOptions.count>=keySuggestorCountVar)
    {
        newFrameHeight = keySuggestorCountVar;
    }else{
        newFrameHeight = _suggestionOptions.count;
    }
   
    rowCount = _suggestionOptions.count<15?_suggestionOptions.count:15;
    
    if(self.delegate && [_autoCompleteDelegate respondsToSelector:@selector(updateAutoCompletionTableViewConstraintWithNewFrame:)]){
        
        CGRect newFrame = self.frame;
        newFrame.size.height = newFrameHeight * K_DEFAULT_CELL_HIEGHT;
        
        [_autoCompleteDelegate updateAutoCompletionTableViewConstraintWithNewFrame:newFrame];
    }
    
    return rowCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    if ([self.options valueForKey:ACOUseSourceFont])
    {
        cell.textLabel.font = [self.options valueForKey:ACOUseSourceFont];
    } else
    {
        cell.textLabel.font = self.cellLabelFont;
    }
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    cell.textLabel.text = [self.suggestionOptions fetchObjectAtIndex:indexPath.row];
    if(!self.defaultView){
        cell.textLabel.backgroundColor = UIColorFromRGB(0xE4E1E2);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.textLabel.textColor =UIColorFromRGB(0x3E3C3D);
        cell.contentView.backgroundColor = UIColorFromRGB(0xE4E1E2);
        
        
    }
    else{
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
        cell.accessoryView = imageView;
    }
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"autocompletionCell_lbl_%ld",(long)indexPath.row] value:cell.textLabel.text forUIElement:cell.textLabel];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"autocompletionCell_%ld",(long)indexPath.row] forUIElement:cell withAccessibilityEnabled:NO];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEmailAddressSuggestor) {
        NSString *curString = [_textField text];
        NSUInteger atTheRateSymbolLocation = [curString rangeOfString:@"@" options:NSCaseInsensitiveSearch].location;
        
        if (NSNotFound != atTheRateSymbolLocation) {
            @try {
                curString = [curString substringToIndex:atTheRateSymbolLocation];
                curString = [NSString stringWithFormat:@"%@%@",curString,[self suggestKeywords:indexPath]];
                [_textField setText:curString];
            }
            @catch (NSException *exception) {
            }
        }
    }else{
        [_textField setText:[self suggestKeywords:indexPath]];
    }
    
    if (_autoCompleteDelegate && [_autoCompleteDelegate respondsToSelector:@selector(autoCompletion:didSelectAutoCompleteSuggestionWithIndex:withSelectedtext:)]) {
        [_autoCompleteDelegate autoCompletion:self didSelectAutoCompleteSuggestionWithIndex:indexPath.row withSelectedtext:_textField.text];
    }
    
    [self hideOptionsView];
}


-(NSString*)suggestKeywords:(NSIndexPath*)indexPath
{
    
    NSString* str;
    NSMutableArray* arrTemp=[[NSMutableArray alloc] init];
    
    NSArray* trimmedArray=[[NSArray alloc]initWithArray:[_textField.text componentsSeparatedByString:@","]];
    
    for (NSString *string in trimmedArray) {
        NSString *trimmedString = [string trimCharctersInSet :[NSCharacterSet whitespaceCharacterSet]];
        [arrTemp addObject:trimmedString];
    }
    NSMutableArray* arr=[[NSMutableArray alloc] initWithArray:arrTemp];
    
    NSString* tmp=[self.suggestionOptions fetchObjectAtIndex:indexPath.row];
    
    [arr replaceObjectAtIndex:arr.count-1 withObject:tmp];
    
    
    str=[[NSString alloc] initWithString:[arr fetchObjectAtIndex:0]];
    
    for (int i=1; i<arr.count; i++)
    {
        
        str=  [str stringByAppendingString:@", "];
        str=  [str stringByAppendingString:[arr fetchObjectAtIndex:i]];
        
    }
    
    if(self.isMultiSelect)
        return (NSString*)[str stringByAppendingString:@", "];
    else
        return (NSString*)str;
    
}

-(void)setTopPositionForSuggestorView:(CGFloat)frame
{
    topPositionForSuggestorView=frame;
}

#pragma mark - UITextField delegate
- (void)textFieldValueChanged:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    ifkeywordselected=FALSE;
    _textField = (UITextField*)textField;
    NSString *curString = textField.text;
    
    if(_isEmailAddressSuggestor){
        
        NSUInteger atTheRateSymbolLocation = [curString rangeOfString:@"@" options:NSCaseInsensitiveSearch].location;
        
        if (NSNotFound != atTheRateSymbolLocation) {
            @try {
                curString = [curString substringFromIndex:atTheRateSymbolLocation];
            }
            @catch (NSException *exception) {
                [self hideOptionsView];
                return;
            }
            
        }else{
            [self hideOptionsView];
            return;
        }
    }
    
    
    
    curString = [curString trimCharctersInSet :[NSCharacterSet whitespaceCharacterSet]];
    
    NSCharacterSet * specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"\n_%^&*()[]{}'\"<>:;|\\/?+=\t~`£¥$€"];
    
    curString = [curString trimCharctersInSet :specialCharactersSet];
    
    NSRange range = [textField.text rangeOfString:@","];
    
    if (range.location!=NSNotFound)
    {
        
        //If Suggestors are allowed only once. (eg- Designation)
        
        if(!self.isMultiSelect)
        {
            [self hideOptionsView];
            return;
            
        }
        kwWordCount=(NSMutableArray*)[textField.text componentsSeparatedByString:@","];
        curString=[kwWordCount lastObject];
        
        if ((curString.length>0) && ([curString characterAtIndex:0]==' '))
        {
            curString=[curString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        
    }
    
    //TextField is empty
    
    if (![curString length])
    {
        [self hideOptionsView];
        return;
    }
    //SuggetionArray has Textfield matching data
    else if ([self substringIsInDictionary:curString]){
        [self showOptionsView];
        [self reloadData];
        [self setContentOffset:CGPointZero];
    } else {
        [self hideOptionsView];
    }
}

#pragma mark - Options view control
- (void)showOptionsView
{
    self.hidden = NO;
    isShowOptions = YES;
    if(_autoCompleteDelegate && [_autoCompleteDelegate respondsToSelector:@selector(showingTheOptions:)]){
        [_autoCompleteDelegate showingTheOptions:YES];
    }
}

- (void) hideOptionsView
{
    
    self.hidden = YES;
    isShowOptions = NO;
    if(_autoCompleteDelegate && [_autoCompleteDelegate respondsToSelector:@selector(showingTheOptions:)]){
        [_autoCompleteDelegate showingTheOptions:NO];
    }
}
- (NSInteger)keySuggestorCount{
    if (IS_IPHONE4) {
        return 3;
    }else{
        return KEYWORD_SUGGESTER_COUNT;
    }
    //for other or new dimensions add more cases
}
-(void)clearAutoCompletionTable{
    self.suggestionOptions = nil;
    [self reloadData];
}
@end
