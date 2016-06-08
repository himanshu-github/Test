//
//  CalenderViewController.m
//  Calender
//
//  Created by Arun Kumar on 10/08/13.
//  Copyright (c) 2013 Arun Kumar. All rights reserved.
//

#import "CalenderViewController.h"

@interface CalenderViewController (){
    NSString *defaultValue;
    NSString *defaultYear;
    NSString *defaultMonth;
    UITableView *yearsView;
    UITableView *monthsView;
    UITableView *daysView;
    NSInteger selectedYearIndex;
    UILabel *headerLbl;
    UIButton *doneBtn;
    UIView *headerBkGrndView;
    NSIndexPath * prevSelectedIndexPathDay;
    NSIndexPath * prevSelectedIndexPathMonth;
    NSIndexPath * prevSelectedIndexPathYear;
    NSString *PreSelectedDay;
    NSString *PreSelectedMonth;
    NSString *PreSelectedYear;
    NSInteger rowPathForDay;

}

@end

#define DAYS_VIEW_TAG 10
#define MONTHS_VIEW_TAG 20
#define YEARS_VIEW_TAG 30

@implementation CalenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = UIColorFromRGB(0Xe9e8e8);
    
    self.selectedMonth = @"";
    self.selectedDay = -1;
    self.selectedYear = -1;
    
    self.requestParams = [[NSMutableDictionary alloc]init];
    
    self.enabledDaysArr = [[NSMutableArray alloc]init];
    self.disabledDaysArr = [[NSMutableArray alloc]init];
    
  
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets= NO;
    }
}
- (void)dealloc
{
    self.view.backgroundColor = nil;
    if([self.daysArr count]){
        [self.daysArr removeAllObjects];
    }
    self.daysArr    =   nil;
    if([self.monthsArr count]){
        [self.monthsArr removeAllObjects];
    }
    self.monthsArr    =   nil;
    if([self.yearsArr count]){
        [self.yearsArr removeAllObjects];
    }
    self.yearsArr    =   nil;
    if([self.enabledDaysArr count]){
        [self.enabledDaysArr removeAllObjects];
    }
    self.enabledDaysArr    =   nil;
    if([self.disabledDaysArr count]){
        [self.disabledDaysArr removeAllObjects];
    }
    self.disabledDaysArr    =   nil;
    self.selectedMonth  =   nil;
    if([self.requestParams allKeys]){
        [self.requestParams removeAllObjects];
    }
    self.requestParams    =   nil;
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)refreshData{
    self.isDisplayDay = [[self.requestParams objectForKey:@"DisplayDay"]boolValue];
    self.isDisplayMonth = [[self.requestParams objectForKey:@"DisplayMonth"]boolValue];
    self.isDisplayYear = [[self.requestParams objectForKey:@"DisplayYear"]boolValue];
    
    [self createAllViews];
    headerLbl.text = [self.requestParams objectForKey:@"Header"];
    
    
    defaultValue = [self.requestParams objectForKey:@"SelectedDate"];
    
    [self showDefaultValue:defaultValue];
    
    [self reloadTableViewsData];
}

- (void)reloadTableViewsData{
    [daysView reloadData];
    [monthsView reloadData];
    [yearsView reloadData];
}
-(void)showDefaultValue:(NSString *)dateValue{

    defaultValue = dateValue;
    
    NSArray *dateValuesArray = [dateValue componentsSeparatedByString:@","];
    
        if(dateValuesArray.count){
            
            if(self.isDisplayDay){
            
                NSString *dateAndMonthstr = [dateValuesArray fetchObjectAtIndex:0];
                NSArray *dayAndMonthArray = [dateAndMonthstr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
                if(dayAndMonthArray.count > 1){
                    NSString *day = [dayAndMonthArray fetchObjectAtIndex:1];
                    PreSelectedDay = day;
                    [self showDefaultDay:[day intValue]];
                }
                NSString *month = [dayAndMonthArray fetchObjectAtIndex:0];
                PreSelectedMonth = month;
                [self showDefaultMonth:month];
                NSString *year = [dateValuesArray fetchObjectAtIndex:dateValuesArray.count-1];
                PreSelectedYear = year;
                [self showDefaultYear:[year intValue]];
                [self updateDays];
            }
            else if(self.isDisplayMonth){
            
                NSString *month = [dateValuesArray fetchObjectAtIndex:0];
                PreSelectedMonth = month;
                [self showDefaultMonth:month];
                NSString *year = [dateValuesArray fetchObjectAtIndex:dateValuesArray.count-1];
                PreSelectedYear = year;
                [self showDefaultYear:[year intValue]];
            
            }else if(self.isDisplayYear){
                NSString *year = [dateValuesArray fetchObjectAtIndex:0];
                PreSelectedYear = year;
                [self showDefaultYear:[year intValue]];
                
            }
            
            _selectedDay = [PreSelectedDay integerValue];
            _selectedMonth = PreSelectedMonth;
            _selectedYear = [PreSelectedYear integerValue];
            
        }
}

-(void)showDefaultYear:(int)year{

    _selectedYear = year;
    
    NSUInteger indexofMonth = [self.yearsArr indexOfObject:[NSNumber numberWithInt:year]];
    indexofMonth += self.yearsArr.count*50;
    NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:indexofMonth inSection:0];

    prevSelectedIndexPathYear = jumpPath;

    selectedYearIndex = indexofMonth;
    [yearsView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [yearsView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
   
}
-(void)showDefaultMonth:(NSString *)month{

    _selectedMonth = month;
    
    NSUInteger indexofMonth = [self.monthsArr indexOfObject:month];
    indexofMonth += self.monthsArr.count*50;
    NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:indexofMonth inSection:0];
    [monthsView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [monthsView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    prevSelectedIndexPathMonth = jumpPath;

}
-(void)showDefaultDay:(int)day{
    
    _selectedDay = day;
    
    NSUInteger indexofMonth = [self.daysArr indexOfObject:[NSNumber numberWithInteger:day]];
    indexofMonth += self.daysArr.count*50;
    NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:indexofMonth inSection:0];
    [daysView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [daysView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    prevSelectedIndexPathDay = jumpPath;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createAllViews{
    
    headerBkGrndView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)] ;
    
    //20 pixel status bar for ios7
    UIView* viewToReturn = nil;
    viewToReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [viewToReturn setBackgroundColor:Clr_Status_Bar];
    [self.view addSubview:viewToReturn];
    [self.view setNeedsLayout];
    
    
    headerBkGrndView.backgroundColor = Clr_Status_Bar;
    if(!headerLbl){
        headerLbl = [[UILabel alloc]initWithFrame:CGRectMake(6 , 0, 250, 44)];
    }
    headerLbl.backgroundColor = [UIColor clearColor];
    [headerBkGrndView addSubview:headerLbl];
    headerLbl.textAlignment = NSTextAlignmentLeft;
    headerLbl.textColor = [UIColor whiteColor];
    [headerLbl setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:17.0f]];
    [self.view addSubview:headerBkGrndView];

    [self displayAllDays];
    [self displayAllMonths];
    [self displayAllYears];
    
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(0, SCREEN_HEIGHT-60, 320, 60);
    doneBtn.backgroundColor = UIColorFromRGB(0X0083ce);
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
}

-(void)displayAllDays{
    if (self.isDisplayDay) {
        daysView = [[UITableView alloc]initWithFrame:[self getRectForDays] style:UITableViewStylePlain];
        daysView.delegate = self;
        daysView.dataSource = self;
        daysView.tag = DAYS_VIEW_TAG;
        daysView.allowsMultipleSelection = NO;
        daysView.showsVerticalScrollIndicator = NO;
        
        daysView.backgroundColor= UIColorFromRGB(0Xe9e8e8);
        daysView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.daysArr = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 1; i<=31; i++) {
            [self.daysArr addObject:[NSNumber numberWithInteger:i]];
        }
        
        [self.view addSubview:daysView];

        
        [daysView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[self tableView:daysView numberOfRowsInSection:0]/2 inSection:0]  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    }
    
}

-(void)displayAllMonths{
    if (self.isDisplayMonth) {
        monthsView = [[UITableView alloc]initWithFrame:[self getRectForMonths] style:UITableViewStylePlain];
        monthsView.delegate = self;
        monthsView.dataSource = self;
        monthsView.tag = MONTHS_VIEW_TAG;
        monthsView.allowsMultipleSelection = NO;
        monthsView.showsVerticalScrollIndicator = NO;
        monthsView.backgroundColor=UIColorFromRGB(0Xe9e8e8);
        monthsView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        CGRect rect = monthsView.frame;
        rect.size.width = 1;
        
        
        UIView *v = [[UIView alloc] initWithFrame:rect] ;
    	v.backgroundColor = UIColorFromRGB(0Xe9e8e8);
    	[self.view addSubview:v];
        
        self.monthsArr = [[NSMutableArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
        
        [self.view addSubview:monthsView];

        
        [monthsView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[self tableView:monthsView numberOfRowsInSection:0]/2 inSection:0]  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
}

-(void)displayAllYears{
    if (self.isDisplayYear) {
        yearsView = [[UITableView alloc]initWithFrame:[self getRectForYears] style:UITableViewStylePlain];
        yearsView.delegate = self;
        yearsView.dataSource = self;
        yearsView.tag = YEARS_VIEW_TAG;
        yearsView.allowsMultipleSelection = NO;
        yearsView.showsVerticalScrollIndicator = NO;
        yearsView.backgroundColor=UIColorFromRGB(0Xe9e8e8);
        yearsView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        CGRect rect = yearsView.frame;
        rect.size.width = 1;
        
        UIView *v = [[UIView alloc] initWithFrame:rect] ;
    	v.backgroundColor = UIColorFromRGB(0Xe9e8e8);
    	[self.view addSubview:v];
        
        self.yearsArr = [[NSMutableArray alloc]init];
        
        NSInteger minYear = 1920;
        
        if ([self.requestParams objectForKey:@"MinYear"]) {
            minYear = [[self.requestParams objectForKey:@"MinYear"]integerValue];
        }
        
        NSInteger maxYear = [[NGDateManager getCurrentDateComponents]year];
        
        if ([self.requestParams objectForKey:@"MaxYear"]) {
            maxYear = [[self.requestParams objectForKey:@"MaxYear"]integerValue];
        }
        
        for (NSInteger i = minYear; i<=maxYear; i++) {
            [self.yearsArr addObject:[NSNumber numberWithInteger:i]];
        }
        
        [self.view addSubview:yearsView];

    
        [yearsView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[self tableView:yearsView numberOfRowsInSection:0]/2 inSection:0]  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
}


-(void)updateDays{
    BOOL isLeapYear;
    NSArray *month30 = [NSArray arrayWithObjects:@"April",@"June",@"September",@"November", nil];
    
    NSArray *month31 = [NSArray arrayWithObjects:@"January",@"March",@"May",@"July",@"August",@"October",@"December", nil];
    
    NSInteger days = 30;
    
    if ([month30 containsObject:self.selectedMonth]) {
        days = 30;
    }else if ([month31 containsObject:self.selectedMonth]) {
        days = 31;
    }else{
        
        isLeapYear = self.selectedYear%4==0?YES:NO;
        
        days = isLeapYear?29:28;
        
        if (!isLeapYear && [@"February" isEqualToString:_selectedMonth] && 29==_selectedDay) {
            _selectedDay = 28;
                   
            NSIndexPath *tmpIndexPath =[NSIndexPath indexPathForRow:[daysView indexPathForSelectedRow].row-1 inSection:0];
            [daysView scrollToRowAtIndexPath:tmpIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
        }
        
    }
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
    
    NSMutableArray *tempDaysArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<100; i++) {
        [tempDaysArr addObjectsFromArray:self.daysArr];
    }
    
    [self.enabledDaysArr removeAllObjects];
    [self.disabledDaysArr removeAllObjects];
    
    {
        for (NSInteger i = days+1; i<=self.daysArr.count; i++) {
            NSArray *indexArr = [self getIndexesofObject:[NSNumber numberWithInteger:i] inArray:tempDaysArr];
            
            
            for (NSNumber *index in indexArr) {
                [indexes addIndex:[index integerValue]];
                [arr addObject:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
                UITableViewCell *cell = [daysView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
                
                if (cell) {
                    cell.userInteractionEnabled = NO;
                    if (cell.isSelected) {
                        
                        [daysView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:0] animated:YES];
                    }
                    UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:1];
                    lbl.textColor = [UIColor grayColor];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    
                    NSInteger disabledDay = [[lbl text] integerValue];
                    
                    if (_selectedDay == disabledDay) {
                        _selectedDay = -1;
                    }
                }
                
                [self.disabledDaysArr addObject:index];
                
            }
            
            
        }
       
        
        [arr removeAllObjects];
        
    }
    
    {
        
        for (NSInteger i = 28; i<=days; i++) {
            
            if (self.selectedDay == i) {
                continue;
            }
            
            NSArray *indexArr = [self getIndexesofObject:[NSNumber numberWithInteger:i] inArray:tempDaysArr];
            
            for (NSNumber *index in indexArr) {
                UITableViewCell *cell = [daysView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
                if (cell) {
                    cell.userInteractionEnabled = YES;
                    UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:1];
                    lbl.textColor = [UIColor grayColor];
                    [cell setBackgroundColor:[UIColor clearColor]];

                }
                
                [self.enabledDaysArr addObject:index];
            }           
            
        }
        
    }
    

    
}

-(NSArray *)getIndexesofObject:(NSNumber*)object inArray:(NSArray*)array{
    NSIndexSet *set = [array indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isEqualToNumber:object];
    }];
    
    NSUInteger size = set.count;
    
    NSUInteger *buf = malloc(sizeof(*buf) * size);
    [set getIndexes:buf maxCount:size inIndexRange:NULL];
    
    NSMutableArray *array1 = [NSMutableArray array];
    
    NSUInteger i;
    for (i = 0; i < size; i++) {
        [array1 addObject:[NSNumber numberWithUnsignedInteger:buf[i]]];
    }
    
    free(buf);
    
    return array1;
}

-(CGRect)getRectForDays{
    CGRect frame;
    CGFloat yOrigin = 45;
    CGFloat minusFromTableHeight;
    yOrigin += 20;
    
    
    if (self.isDisplayYear && self.isDisplayMonth) {
        frame = CGRectMake(72, yOrigin, 41, SCREEN_HEIGHT);
    }else if (self.isDisplayYear || self.isDisplayMonth) {
        frame = CGRectMake(72, yOrigin, 124, SCREEN_HEIGHT);
    }else{
        frame = CGRectMake(72, yOrigin, 248, SCREEN_HEIGHT);
    }
    
    minusFromTableHeight = yOrigin + 60;//60 doneBtn height
    frame.size.height -= minusFromTableHeight;
    
    return frame;
}

-(CGRect)getRectForMonths{
    CGRect frame;
    CGFloat yOrigin = 45;
    CGFloat minusFromTableHeight;
    yOrigin += 20;
    
    
    if (self.isDisplayYear && self.isDisplayDay) {
        frame = CGRectMake(112, yOrigin, 140, SCREEN_HEIGHT);
    }else if (self.isDisplayYear) {
        frame = CGRectMake(72, yOrigin, 124, SCREEN_HEIGHT);
    }else if (self.isDisplayDay) {
        frame = CGRectMake(196, yOrigin, 124, SCREEN_HEIGHT);
    }else{
        frame = CGRectMake(72, yOrigin, 248, SCREEN_HEIGHT);
    }
    
    minusFromTableHeight = yOrigin + 60;//60 doneBtn height
    frame.size.height -= minusFromTableHeight;
    
    return frame;
}

-(CGRect)getRectForYears{
    CGRect frame;
    CGFloat yOrigin = 45;
    CGFloat minusFromTableHeight;
        yOrigin += 20;

    if (self.isDisplayMonth && self.isDisplayDay) {
        frame = CGRectMake(252, yOrigin, 68, SCREEN_HEIGHT);
    }else if (self.isDisplayMonth || self.isDisplayDay) {
        frame = CGRectMake(196, yOrigin, 124, SCREEN_HEIGHT);
    }else{
        frame = CGRectMake(72, yOrigin, 248, SCREEN_HEIGHT);
    }
    
    minusFromTableHeight = yOrigin + 60;//60 doneBtn height
    frame.size.height -= minusFromTableHeight;

    return frame;
}
-(IBAction)clearButtonClicked{
    
    
}
-(void)doneTapped:(id)sender{
    NSString *date = @"";
    
    BOOL flag[3];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if (self.isDisplayMonth) {
        [arr addObject:[NSNumber numberWithInteger:0]];
        if (![self.selectedMonth isEqualToString:@""]) {
            date = [date stringByAppendingFormat:@"%@",self.selectedMonth];
            flag[0] = TRUE;
        }else{
            flag[0] = FALSE;
        }
    }
    
    if (self.isDisplayDay) {
        [arr addObject:[NSNumber numberWithInteger:1]];
        if (self.selectedDay!=-1) {
            date = [date stringByAppendingFormat:@" %ld",(long)self.selectedDay];
            flag[1] = TRUE;
        }else{
            flag[1] = FALSE;
        }
    }
    
    if (self.isDisplayYear) {
        [arr addObject:[NSNumber numberWithInteger:2]];
        if (self.selectedYear!=-1) {
            if (!self.isDisplayDay && !self.isDisplayMonth) {
                date = [date stringByAppendingFormat:@"%ld",(long)self.selectedYear];
            }else{
                date = [date stringByAppendingFormat:@", %ld",(long)self.selectedYear];
            }
            flag[2] = TRUE;
        }else{
            flag[2] = FALSE;
        }
    }
    
    for (NSNumber *n in arr) {
        if (!flag[[n integerValue]]) {
            [self.delegate didSelectDate:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"Date",[self.requestParams objectForKey:@"ID"],@"ID", nil] success:FALSE];
            
            return;
        }
    }
    
    [self.delegate didSelectDate:[NSDictionary dictionaryWithObjectsAndKeys:date,@"Date",[self.requestParams objectForKey:@"ID"],@"ID", nil] success:TRUE];
}

#pragma mark UITableviw Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger tableType = tableView.tag;
    
    switch (tableType) {
        case DAYS_VIEW_TAG:
            return self.daysArr.count*100;
            break;
            
        case MONTHS_VIEW_TAG:
            return self.monthsArr.count*100;
            break;
            
        case YEARS_VIEW_TAG:
            return self.yearsArr.count*100;
            break;
            
        default:
            break;
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger tableType = tableView.tag;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CGFloat colorCode = 120.0f/255.0f;
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UIView *v = [[UIView alloc] init] ;
        v.backgroundColor= Clr_Blue_SearchJob;
    	cell.selectedBackgroundView = v;
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, cell.contentView.frame.size.height)];
        lbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = 1;
        lbl.textColor = [UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f];
        [lbl setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0f]];
    }
    
    UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:1];
    lbl.textColor = [UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f];
    
    lbl.backgroundColor = [UIColor clearColor];
    cell.userInteractionEnabled = YES;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    switch (tableType) {
        case DAYS_VIEW_TAG:{
            
            
            NSInteger days = [[self.daysArr fetchObjectAtIndex:indexPath.row%self.daysArr.count]integerValue];
            lbl.text = [NSString stringWithFormat:@"%ld",(long)days];
            if([lbl.text isEqualToString:[[NSString stringWithFormat:@"%ld",(long)self.selectedDay] trimCharctersInSet :[NSCharacterSet whitespaceCharacterSet]]]){
               
                lbl.textColor = [UIColor whiteColor];
                [lbl setBackgroundColor:Clr_Blue_SearchJob];
            }
            
            if ([self.disabledDaysArr containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
                lbl.textColor = [UIColor grayColor];
                cell.userInteractionEnabled = NO;
            }
            
            [cell setNeedsDisplay];
            break;
        }
        case MONTHS_VIEW_TAG:{
            NSString *month = [self.monthsArr fetchObjectAtIndex:indexPath.row%self.monthsArr.count];
            lbl.text = [NSString stringWithFormat:@"%@",month];
            if([lbl.text isEqualToString:[self.selectedMonth trimCharctersInSet :[NSCharacterSet whitespaceCharacterSet]]]){
                
                lbl.textColor = [UIColor whiteColor];
                [lbl setBackgroundColor:Clr_Blue_SearchJob];
                [cell setNeedsDisplay];
            }

            break;
        }
        case YEARS_VIEW_TAG:{
            if(prevSelectedIndexPathYear == indexPath){
                lbl.textColor = [UIColor whiteColor];
            }

            
            NSInteger years = [[self.yearsArr fetchObjectAtIndex:indexPath.row%self.yearsArr.count]integerValue];
            lbl.text = [NSString stringWithFormat:@"%ld",(long)years];
            if([lbl.text isEqualToString:[[NSString stringWithFormat:@"%ld",(long)self.selectedYear] trimCharctersInSet :[NSCharacterSet whitespaceCharacterSet]]]){
                
                lbl.textColor = [UIColor whiteColor];
                [lbl setBackgroundColor:Clr_Blue_SearchJob];
            }

            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSInteger tableType = tableView.tag;
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    switch (tableType) {
            
        case DAYS_VIEW_TAG:{
            PreSelectedDay = [NSString stringWithFormat:@"%ld",(long)self.selectedDay];
            self.selectedDay = [[self.daysArr fetchObjectAtIndex:indexPath.row%self.daysArr.count]
                                integerValue];
            rowPathForDay = indexPath.row;

            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel *tempLbl = (UILabel *)[cell.contentView viewWithTag:1];
            
            tempLbl.textColor = [UIColor whiteColor];

            if(prevSelectedIndexPathDay && prevSelectedIndexPathDay.row != indexPath.row){
                cell = [tableView cellForRowAtIndexPath:prevSelectedIndexPathDay];
                UILabel *tempLbl = (UILabel *)[cell.contentView viewWithTag:1];
                tempLbl.textColor = UIColorFromRGB(0X515050);
                 tempLbl.backgroundColor = UIColorFromRGB(0Xe9e8e8);
            }
            prevSelectedIndexPathDay = indexPath;
            [daysView reloadData];
            [monthsView reloadData];
            [yearsView reloadData];
            break;
        }
            
        case MONTHS_VIEW_TAG:{
            PreSelectedMonth = self.selectedMonth;
            self.selectedMonth = [self.monthsArr fetchObjectAtIndex:indexPath.row%self.monthsArr.count];
            
            [self updateDays];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel *tempLbl = (UILabel *)[cell.contentView viewWithTag:1];
            tempLbl.textColor = [UIColor whiteColor];
            if(prevSelectedIndexPathMonth && prevSelectedIndexPathMonth.row != indexPath.row){
                cell = [tableView cellForRowAtIndexPath:prevSelectedIndexPathMonth];
                UILabel *tempLbl = (UILabel *)[cell.contentView viewWithTag:1];
                tempLbl.textColor = UIColorFromRGB(0X515050);
                tempLbl.backgroundColor = UIColorFromRGB(0Xe9e8e8);
            }
            prevSelectedIndexPathMonth = indexPath;
            [daysView reloadData];
            [monthsView reloadData];
            [yearsView reloadData];
            break;
        }
        case YEARS_VIEW_TAG:{
            PreSelectedYear = [NSString stringWithFormat:@"%ld",(long)self.selectedYear];
            self.selectedYear = [[self.yearsArr fetchObjectAtIndex:indexPath.row%self.yearsArr.count]integerValue];
            [self updateDays];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel *tempLbl = (UILabel *)[cell.contentView viewWithTag:1];
            tempLbl.textColor = [UIColor whiteColor];
            if(prevSelectedIndexPathYear && prevSelectedIndexPathYear.row != indexPath.row){
                cell = [tableView cellForRowAtIndexPath:prevSelectedIndexPathYear];
                UILabel *tempLbl = (UILabel *)[cell.contentView viewWithTag:1];
                tempLbl.textColor = UIColorFromRGB(0X515050);
                tempLbl.backgroundColor = UIColorFromRGB(0Xe9e8e8);
            }
            prevSelectedIndexPathYear = indexPath;
            [daysView reloadData];
            [monthsView reloadData];
            [yearsView reloadData];
            break;
        }
        default:
            break;
    }
}

@end
