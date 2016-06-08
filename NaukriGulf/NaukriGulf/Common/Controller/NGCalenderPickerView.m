//
//  NGCalenderPickerView.m
//  NaukriGulf
//
//  Created by Himanshu on 7/29/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGCalenderPickerView.h"
#import "NGInfiniteTableView.h"


#import "DDExpYear.h"
#import "DDExpMonth.h"

NSInteger const K_COLUMN_1_PADDING = 100;
NSInteger const K_COLUMN_1_TAG = 20;
NSInteger const K_COLUMN_2_TAG = 30;
NSInteger const K_TABLEVIEW_LABEL_TAG = 786;
NSInteger const K_PICKER_FRAME_HEIGHT_PADDING = 130;


NSInteger const K_TABLEVIEW_FRAME_PADDING = 45;
NSInteger const K_CELL_HEIGHT = 44.0f;

@interface NGCalenderPickerView (){
    NSString *defaultValue;
    NSString *defaultYear;
    NSString *defaultMonth;
    
    NGInfiniteTableView *yearsView;
    NGInfiniteTableView *monthsView;
    NGInfiniteTableView *daysView;
    
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
    
    
    //for value picker
    NSInteger freezeValue;
    BOOL bIsTableDisabled;
    int dropdownType;
    NGInfiniteTableView *tblColumn1;
    NGInfiniteTableView *tblColumn2;
    
    
    
    
}

@property (nonatomic,strong) NSMutableArray *daysArr;
@property (nonatomic,strong) NSMutableArray *monthsArr;
@property (nonatomic,strong) NSMutableArray *yearsArr;

@property (nonatomic) NSInteger selectedDay;
@property (nonatomic,strong) NSString *selectedMonth;
@property (nonatomic) NSInteger selectedYear;

@property (nonatomic) BOOL isDisplayDay;
@property (nonatomic) BOOL isDisplayMonth;
@property (nonatomic) BOOL isDisplayYear;

@property (nonatomic,strong) NSMutableArray *enabledDaysArr;
@property (nonatomic,strong) NSMutableArray *disabledDaysArr;






@end

#define DAYS_VIEW_TAG 10
#define MONTHS_VIEW_TAG 20
#define YEARS_VIEW_TAG 30

@implementation NGCalenderPickerView

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(_isPickerTypeValue)
    {
        //value picker

    self.view.backgroundColor = Clr_Grey_SearchJob;
    self.selectedValueColumn1 = @"";
    self.selectedValueColumn2 = @"";
    }
    else{
    //calender
        self.view.backgroundColor = UIColorFromRGB(0Xe9e8e8);
        _minYear = [NSNumber numberWithBool:NO];
        _maxYear = [NSNumber numberWithBool:NO];
        
        self.selectedMonth = @"";
        self.selectedDay = -1;
        self.selectedYear = -1;
        
        
        self.enabledDaysArr = [[NSMutableArray alloc]init];
        self.disabledDaysArr = [[NSMutableArray alloc]init];
        
        
        
        if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
            self.automaticallyAdjustsScrollViewInsets= NO;
        }

    
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
   
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    
    
    
    if([self.arrColumn1 count])
        [self.arrColumn1 removeAllObjects];
    self.arrColumn1    =   nil;
    
    if([self.arrColumn2 count])
        [self.arrColumn2 removeAllObjects];
    self.arrColumn2    =   nil;
    
    self.selectedValueColumn1  =   nil;
    self.selectedValueColumn2  =   nil;
    
   
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Methods

-(void)refreshData{
    
    switch (_calType) {
        case NGCalenderTypeDD:
            self.isDisplayDay = YES;
            self.isDisplayMonth = NO;
            self.isDisplayYear = NO;
            break;
        case NGCalenderTypeMM:
            self.isDisplayDay = NO;
            self.isDisplayMonth = YES;
            self.isDisplayYear = NO;
            break;
        case NGCalenderTypeYYYY:
            self.isDisplayDay = NO;
            self.isDisplayMonth = NO;
            self.isDisplayYear = YES;
            break;
        case NGCalenderTypeDDMM:
            self.isDisplayDay = YES;
            self.isDisplayMonth = YES;
            self.isDisplayYear = NO;
            break;
        case NGCalenderTypeMMYYYY:
            self.isDisplayDay = NO;
            self.isDisplayMonth = YES;
            self.isDisplayYear = YES;
            break;
        case NGCalenderTypeDDMMYYYY:
            self.isDisplayDay = YES;
            self.isDisplayMonth = YES;
            self.isDisplayYear = YES;
            break;
        default:
            break;
    }
    
    [self createAllViews];
    
    
    
    
    if(_isPickerTypeValue)
    {
        headerLbl.text = _pickerModel.pickerHeader;
        freezeValue = [self.pickerModel.pickerDisableValue intValue];
        [self showDefaultValue:[NSString stringWithFormat:@"%@,%@",
                                self.selectedValueColumn1,
                                self.selectedValueColumn2]];
    }
    else
    {
        headerLbl.text = _headerTitle;
        [self showDefaultValue:_selectedValue];
        [self reloadTableViewsData];
        
    }
    
    
}
-(void)showDefaultValue:(NSString *)dateValue{
    
    
    
    if(_isPickerTypeValue)
    {
        if([dateValue isEqualToString:@","])
            return;
        defaultValue = dateValue;
        
        
        NSArray *dateValuesArray = [dateValue componentsSeparatedByString:@","];
        
        if(dateValuesArray.count){
            
            if(_calType == NGCalenderTypeMMYYYY){
                
                NSString *value1 = [dateValuesArray fetchObjectAtIndex:0];
                [self showDefaultColumn1:value1];
                NSString *value2= [dateValuesArray fetchObjectAtIndex:dateValuesArray.count-1];
                [self showDefaultColumn2:value2];
            }
        }
        
        
    }
    else{
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
}
-(void)createAllViews{
    if(!_isPickerTypeValue)
    {
        headerBkGrndView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)] ;
        
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
        doneBtn.frame = CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60);
        doneBtn.backgroundColor = UIColorFromRGB(0X0083ce);
        [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doneBtn];
    }
    else{
        
        
        int OriginY = 0;
        int viewHeight = 60;
        int labelOriginY = 18;
        int labelHeight = 45;
        
        
        UIView* viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, SCREEN_WIDTH, viewHeight)];
        [viewBG setBackgroundColor:Clr_Status_Bar];
        [self.view addSubview:viewBG];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(6, labelOriginY, SCREEN_WIDTH, labelHeight)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.textColor = [UIColor whiteColor];
        lbl.text = self.pickerModel.pickerHeader;
        [lbl setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_REGULAR size:15.0f]];
        [viewBG addSubview:lbl];
        
        [self displayColumn1];
        [self displayColumn2];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, self.view.frame.size.height-60, SCREEN_WIDTH, 60);
        [btn setTitle:@"Done" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:Clr_Blue_SearchJob];
        [self.view addSubview:btn];
        
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
-(void)doneTapped:(id)sender{
    
    if(_isPickerTypeValue)
    {
        
        if([self.delegate respondsToSelector:@selector(didSelectCalenderPickerWithValues:success:andPickerType:)])
            [self.delegate didSelectCalenderPickerWithValues:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              self.selectedValueColumn1, K_KEY_PICKER_SELECTED_VALUE_1,
                                                              self.selectedValueColumn2, K_KEY_PICKER_SELECTED_VALUE_2,
                                                              self.pickerModel.pickerDropDownType, K_DROPDOWN_TYPE,
                                                              nil] success:TRUE andPickerType:_isPickerTypeValue];
   
    }
    else{
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
                
                if([self.delegate respondsToSelector:@selector(didSelectCalenderPickerWithValues:success:andPickerType:)])
                    [self.delegate didSelectCalenderPickerWithValues:[NSDictionary dictionaryWithObject:@"" forKey:@"selectedDate"] success:FALSE andPickerType:_isPickerTypeValue];
                
                return;
            }
        }
        
        if([self.delegate respondsToSelector:@selector(didSelectCalenderPickerWithValues:success:andPickerType:)])
            [self.delegate didSelectCalenderPickerWithValues:[NSDictionary dictionaryWithObject:date forKey:@"selectedDate"] success:TRUE andPickerType:_isPickerTypeValue];
        
        
        
    }
    
}
-(void)adjustDateInMiddle{

    
    if(_isPickerTypeValue)
    {
        NSIndexPath *jumpPath1 = [NSIndexPath indexPathForRow:_arrColumn1.count inSection:0];
        [tblColumn1 scrollToRowAtIndexPath:jumpPath1 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

        NSIndexPath *jumpPath2 = [NSIndexPath indexPathForRow:_arrColumn2.count inSection:0];
        [tblColumn2 scrollToRowAtIndexPath:jumpPath2 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

    }
    else
    {
    
        
        NSIndexPath *jumpPath1 = [NSIndexPath indexPathForRow:self.daysArr.count inSection:0];
        [daysView scrollToRowAtIndexPath:jumpPath1 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
        NSIndexPath *jumpPath2 = [NSIndexPath indexPathForRow:self.monthsArr.count inSection:0];
        [monthsView scrollToRowAtIndexPath:jumpPath2 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
        NSIndexPath *jumpPath3 = [NSIndexPath indexPathForRow:self.yearsArr.count inSection:0];
        [yearsView scrollToRowAtIndexPath:jumpPath3 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

    
    }
    

}
#pragma mark - Calender Picker Methods
- (void)reloadTableViewsData{
    [daysView reloadData];
    [monthsView reloadData];
    [yearsView reloadData];
}
-(void)showDefaultYear:(int)year{
    
    _selectedYear = year;
    
    NSUInteger indexofYear = [self.yearsArr indexOfObject:[NSNumber numberWithInt:year]];
    
    if((indexofYear*K_CELL_HEIGHT)>yearsView.bounds.size.height/2.0)
    {
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:indexofYear inSection:0];
        
        prevSelectedIndexPathYear = jumpPath;
        
        selectedYearIndex = indexofYear;
        [yearsView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [yearsView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        
        
        
    }
    else{
        
        
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:(indexofYear+self.yearsArr.count) inSection:0];
        
        prevSelectedIndexPathYear = jumpPath;
        
        selectedYearIndex = indexofYear;
        [yearsView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [yearsView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        
    }
    
    
    
    
    
}
-(void)showDefaultMonth:(NSString *)month{
    
    _selectedMonth = month;
    
    NSUInteger indexofMonth = [self.monthsArr indexOfObject:month];
    
    if((indexofMonth*K_CELL_HEIGHT)>monthsView.bounds.size.height/2.0)
    {
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:indexofMonth inSection:0];
        
        [monthsView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [monthsView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        prevSelectedIndexPathMonth = jumpPath;
    }else
    {
        
        
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:(indexofMonth+self.monthsArr.count) inSection:0];
        
        [monthsView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [monthsView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        prevSelectedIndexPathMonth = jumpPath;
        
    }
    
}
-(void)showDefaultDay:(int)day{
    
    _selectedDay = day;
    
    NSUInteger indexofDay = [self.daysArr indexOfObject:[NSNumber numberWithInteger:day]];
    if((indexofDay*K_CELL_HEIGHT)>daysView.bounds.size.height/2.0)
    {
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:indexofDay inSection:0];
        [daysView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [daysView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        prevSelectedIndexPathDay = jumpPath;
    }else{
        
        
        
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:(indexofDay+self.daysArr.count) inSection:0];
        [daysView scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [daysView selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        prevSelectedIndexPathDay = jumpPath;
        
        
    }
    
}

-(void)displayAllDays{
    if (self.isDisplayDay) {
        daysView = [[NGInfiniteTableView alloc]initWithFrame:[self getRectForDays] style:UITableViewStylePlain];
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
        monthsView = [[NGInfiniteTableView alloc]initWithFrame:[self getRectForMonths] style:UITableViewStylePlain];
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
        yearsView = [[NGInfiniteTableView alloc]initWithFrame:[self getRectForYears] style:UITableViewStylePlain];
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
        
        if ([_minYear boolValue]) {
            minYear = [_minYear integerValue];
        }
        
        NSInteger maxYear = [[NGDateManager getCurrentDateComponents]year];
        
        if ([_maxYear boolValue]) {
            maxYear = [_maxYear integerValue];
        }
        
        for (NSInteger i = minYear; i<=maxYear; i++) {
            [self.yearsArr addObject:[NSNumber numberWithInteger:i]];
        }
        
        [self.view addSubview:yearsView];
        
        
        [yearsView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[self tableView:yearsView numberOfRowsInSection:0]/2 inSection:0]  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
}
-(CGRect)getRectForDays{
    CGRect frame;
    CGFloat yOrigin = 45;
    CGFloat minusFromTableHeight;
    yOrigin += 20;
    
    
    
    float xOffset = 0;
    
    if(IS_IPHONE4||IS_IPHONE5)
        xOffset =0;
    else if (IS_IPHONE6)
        xOffset = 55;
    else if (IS_IPHONE6_PLUS)
        xOffset = 94;

    
    if (self.isDisplayYear && self.isDisplayMonth) {
        frame = CGRectMake(72+xOffset, yOrigin, 41, SCREEN_HEIGHT);
    }else if (self.isDisplayYear || self.isDisplayMonth) {
        frame = CGRectMake(72+xOffset, yOrigin, 124, SCREEN_HEIGHT);
    }else{
        frame = CGRectMake(72+xOffset, yOrigin, 248, SCREEN_HEIGHT);
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
    
    
    float xOffset = 0;
    
    if(IS_IPHONE4||IS_IPHONE5)
        xOffset =0;
    else if (IS_IPHONE6)
        xOffset = 55;
    else if (IS_IPHONE6_PLUS)
        xOffset = 94;

    
    if (self.isDisplayYear && self.isDisplayDay) {
        frame = CGRectMake(112+xOffset, yOrigin, 140, SCREEN_HEIGHT);
    }else if (self.isDisplayYear) {
        frame = CGRectMake(72+xOffset, yOrigin, 124, SCREEN_HEIGHT);
    }else if (self.isDisplayDay) {
        frame = CGRectMake(196+xOffset, yOrigin, 124, SCREEN_HEIGHT);
    }else{
        frame = CGRectMake(72+xOffset, yOrigin, 248, SCREEN_HEIGHT);
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
    
    
    float xOffset = 0;
    
    if(IS_IPHONE4||IS_IPHONE5)
        xOffset =0;
    else if (IS_IPHONE6)
        xOffset = 55;
    else if (IS_IPHONE6_PLUS)
        xOffset = 94;

    
    
    if (self.isDisplayMonth && self.isDisplayDay) {
        frame = CGRectMake(252+xOffset, yOrigin, 68, SCREEN_HEIGHT);
    }else if (self.isDisplayMonth || self.isDisplayDay) {
        frame = CGRectMake(196+xOffset, yOrigin, 124, SCREEN_HEIGHT);
    }else{
        frame = CGRectMake(72+xOffset, yOrigin, 248, SCREEN_HEIGHT);
    }
    
    minusFromTableHeight = yOrigin + 60;//60 doneBtn height
    frame.size.height -= minusFromTableHeight;
    
    return frame;
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

#pragma mark - Value Picker Methods

-(void)displayDropdownData:(int)ddType{
    
    NGCustomPickerModel* pickerModel = [[NGCustomPickerModel alloc] init];
    switch (ddType) {
            
        case DD_EDIT_EXPERIENCE:{
            pickerModel.pickerHeader = @"Experience";
            pickerModel.pickerTotalColoumn = [NSString stringWithFormat:@"%d", 2];;
            pickerModel.pickerArrayColoumnOne = [NSMutableArray arrayWithArray:[NGDatabaseHelper getSortedDataWhereKey:DROPDOWN_VALUE_ID andClass:[DDExpYear class]]];
            pickerModel.pickerArrayColoumnTwo = [NSMutableArray arrayWithArray:[NGDatabaseHelper getSortedDataWhereKey:DROPDOWN_VALUE_ID andClass:[DDExpMonth class]]];
            pickerModel.pickerLabelColoumnOne = @"Years";
            pickerModel.pickerLabelColoumnTwo = @"Months";
            pickerModel.pickerDisableValue = [NSNumber numberWithInt:31];
            pickerModel.pickerDropDownType = [NSString stringWithFormat:@"%d", ddType];
            pickerModel.selectedValueColumn1 = _selectedValueColumn1;
            pickerModel.selectedValueColumn2 = _selectedValueColumn2;
            
        }
            break;
            
        default:
            break;
    }
    _pickerModel = pickerModel;
    
    
}



-(void)showDefaultColumn1:(NSString *)value{
    
    int counter = 0;
    for (DDBase* obj in _arrColumn1){
        counter++;
        if ([obj.valueName isEqualToString:value]){
            counter--;
            break;
        }
        
    }
    if(counter==32)
        counter = counter-1;
    NSUInteger indexofValue = counter;
    
    
    if((indexofValue*K_CELL_HEIGHT)>tblColumn1.bounds.size.height/2.0)
    {
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:indexofValue inSection:0];
        
        [tblColumn1 scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [tblColumn1 selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:tblColumn1 didSelectRowAtIndexPath:jumpPath];
        
    }
    else{
        
        
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:(indexofValue+self.arrColumn1.count) inSection:0];
        
        [tblColumn1 scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [tblColumn1 selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:tblColumn1 didSelectRowAtIndexPath:jumpPath];
        
    }
    
}
-(void)showDefaultColumn2:(NSString *)value{
    
    int counter = 0;
    for (DDBase* obj in _arrColumn2){
        counter++;
        if ([obj.valueName isEqualToString:value]){
            counter--;
            break;
        }
    }
    NSUInteger indexofValue = counter;
    if((indexofValue*K_CELL_HEIGHT)>tblColumn2.bounds.size.height/2.0)
    {
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:indexofValue inSection:0];
        
        [tblColumn2 scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [tblColumn2 selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:tblColumn2 didSelectRowAtIndexPath:jumpPath];
        
    }
    else{
        
        
        NSIndexPath *jumpPath = [NSIndexPath indexPathForRow:(indexofValue+self.arrColumn2.count) inSection:0];
        
        [tblColumn2 scrollToRowAtIndexPath:jumpPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [tblColumn2 selectRowAtIndexPath:jumpPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:tblColumn2 didSelectRowAtIndexPath:jumpPath];
        
    }
    
    
    
}


-(void)displayColumn1{
    
    if (_calType == NGCalenderTypeMMYYYY)
    {
        
        tblColumn1 = [[NGInfiniteTableView alloc]initWithFrame:[self getRectForColumn1] style:UITableViewStylePlain];
        
        [tblColumn1 setAccessibilityLabel:[NSString stringWithFormat:@"%@_tableview",
                                           self.pickerModel.pickerLabelColoumnOne]];
        tblColumn1.delegate = self;
        tblColumn1.dataSource = self;
        tblColumn1.tag = K_COLUMN_1_TAG;
        tblColumn1.allowsMultipleSelection = NO;
        tblColumn1.showsVerticalScrollIndicator = NO;
        [tblColumn1 setBackgroundColor:Clr_Grey_SearchJob];
        tblColumn1.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.arrColumn1 = [[NSMutableArray alloc] init];
        self.arrColumn1 = (NSMutableArray*)self.pickerModel.pickerArrayColoumnOne;
        [self.view addSubview:tblColumn1];
        
        
        [tblColumn1 scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:
                                             [self tableView:tblColumn1 numberOfRowsInSection:0]/2 inSection:0]
                          atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
}

-(void)displayColumn2{
    
    if (_calType == NGCalenderTypeMMYYYY) {
        
        tblColumn2 = [[NGInfiniteTableView alloc]initWithFrame:[self getRectForColumn2] style:UITableViewStylePlain];
        
        [tblColumn2 setAccessibilityLabel:[NSString stringWithFormat:@"%@_tableview",
                                           self.pickerModel.pickerLabelColoumnTwo]];
        
        tblColumn2.delegate = self;
        tblColumn2.dataSource = self;
        tblColumn2.tag = K_COLUMN_2_TAG;
        tblColumn2.allowsMultipleSelection = NO;
        
        tblColumn2.showsVerticalScrollIndicator = NO;
        [tblColumn2 setBackgroundColor:Clr_Grey_SearchJob];
        tblColumn2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.arrColumn2 = [[NSMutableArray alloc]init];
        self.arrColumn2 = (NSMutableArray*)self.pickerModel.pickerArrayColoumnTwo;
        [self.view addSubview:tblColumn2];
        
        [tblColumn2 scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[self tableView:tblColumn2
                                                                   numberOfRowsInSection:0]/2 inSection:0]
                          atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}
-(CGRect)getRectForColumn1{
    
    CGRect frame;
    int OriginY = K_TABLEVIEW_FRAME_PADDING + 20;
    
    
    float xOffset = 0;
    
    if(IS_IPHONE4||IS_IPHONE5)
        xOffset =0;
    else if (IS_IPHONE6)
        xOffset = 55;
    else if (IS_IPHONE6_PLUS)
        xOffset = 94;
    
    
    
    
    
    if (_calType == NGCalenderTypeMMYYYY)
        frame = CGRectMake(K_COLUMN_1_PADDING+xOffset, OriginY, (SCREEN_WIDTH/3),
                           SCREEN_HEIGHT-60);
    else
        frame = CGRectMake(K_COLUMN_1_PADDING+xOffset, OriginY, SCREEN_WIDTH,
                           SCREEN_HEIGHT-60);
    
    return frame;
}

-(CGRect)getRectForColumn2{
    
    int OriginY = K_TABLEVIEW_FRAME_PADDING + 20;
    
    CGRect frame;
    CGRect frameTemp = tblColumn1.frame;
    
    frame = CGRectMake(frameTemp.origin.x + frameTemp.size.width,
                       OriginY, (SCREEN_WIDTH/3),
                       SCREEN_HEIGHT-60);
    
    return frame;
}


- (BOOL)isValueApplicableForFreeze:(NSString*)paramValue{
    return [@"30+" isEqualToString:paramValue];
}




#pragma mark UITableviw Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger tableType = tableView.tag;
    
    if(!_isPickerTypeValue)
    {
    
    switch (tableType) {
        case DAYS_VIEW_TAG:
            return self.daysArr.count;
            break;
            
        case MONTHS_VIEW_TAG:
            return self.monthsArr.count;
            break;
            
        case YEARS_VIEW_TAG:
            return self.yearsArr.count;
            break;
            
        default:
            break;
    }
    }
    else{
 
        switch (tableType) {
                
            case K_COLUMN_1_TAG:
                return self.arrColumn1.count;
                
                break;
                
            case K_COLUMN_2_TAG:
                return self.arrColumn2.count;
                
                break;
                
            default:
                break;
        }
    
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return K_CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger tableType = tableView.tag;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if(_isPickerTypeValue)
    {
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = [UIColor clearColor];
        [self setAccessibilityLabel:[NSString stringWithFormat:@"dropdownCell_%ld",(long)indexPath.row]];
        CGFloat colorCode = 120.0f/255.0f;
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.backgroundColor = [UIColor clearColor];
            
            UIView *v = [[UIView alloc] init] ;
            v.backgroundColor=Clr_Blue_SearchJob;
            cell.selectedBackgroundView = v;
            
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0,
                                                                    tableView.frame.size.width,
                                                                    cell.contentView.frame.size.height)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textAlignment = NSTextAlignmentLeft;
            lbl.tag = K_TABLEVIEW_LABEL_TAG;
            lbl.textColor = [UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f];
            [lbl setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:14.0f]];
            [cell.contentView addSubview:lbl];
            
        }
        
        UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:K_TABLEVIEW_LABEL_TAG];
        lbl.textColor = [UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        
        switch (tableType) {
                
            case K_COLUMN_1_TAG:{
                
                DDBase* obj = [self.arrColumn1 fetchObjectAtIndex:indexPath.row];
                
                NSString *rowName = obj.valueName;
                lbl.text = [NSString stringWithFormat:@"%@",rowName];
                [lbl setBackgroundColor:[UIColor clearColor]];
                
                if([lbl.text isEqualToString:self.selectedValueColumn1]){
                    
                    [lbl setTextColor:[UIColor whiteColor]];
                    NSString* appendString = _pickerModel.pickerLabelColoumnOne;
                    
                    NSInteger valueOfColumn1 = [lbl.text integerValue];
                    if (valueOfColumn1 < 2) {
                        appendString = [appendString substringToIndex:appendString.length-1];
                    }
                    
                    [lbl setText:[NSString stringWithFormat:@"%@ %@",_selectedValueColumn1,appendString]];
                    [cell.contentView setBackgroundColor:Clr_Blue_SearchJob];
                }
                
                break;
            }
            case K_COLUMN_2_TAG:{
                
                DDBase* obj = [self.arrColumn2 fetchObjectAtIndex:indexPath.row];
                
                NSString *rowName = obj.valueName;
                lbl.text = [NSString stringWithFormat:@"%@",rowName];
                if([lbl.text isEqualToString:self.selectedValueColumn2]){
                    
                    [lbl setTextColor:[UIColor whiteColor]];
                    
                    NSString* appendString = _pickerModel.pickerLabelColoumnTwo;
                    
                    NSInteger valueOfColumn2 = [lbl.text integerValue];
                    if (valueOfColumn2 < 2) {
                        appendString = [appendString substringToIndex:appendString.length-1];
                    }
                    
                    [lbl setText:[NSString stringWithFormat:@"%@ %@",_selectedValueColumn2,appendString]];
                    [cell.contentView setBackgroundColor:Clr_Blue_SearchJob];
                }
                
                if (bIsTableDisabled) {
                    
                    [lbl setTextColor:[UIColor lightGrayColor]];
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.enabled = NO;
                    cell.detailTextLabel.enabled = NO;
                }
                break;
            }
                
            default:
                break;
        }

    }
    else
    {
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
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSInteger tableType = tableView.tag;
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    if(_isPickerTypeValue)
    {
    switch (tableType) {
            
        case K_COLUMN_1_TAG:{
            
            NSInteger valueOfColumn1 = [_selectedValueColumn1 integerValue];
            NSInteger iIndex = indexPath.row%self.arrColumn1.count;
            DDBase* obj = [self.arrColumn1 fetchObjectAtIndex:
                           iIndex];
            
            NSString* selectedValue = obj.valueID.stringValue;
            if ([selectedValue isEqualToString:@"31"])
                selectedValue = @"30+";
            self.selectedValueColumn1 = selectedValue;
            [tblColumn1 reloadData];
            
            
            
            BOOL isNeedToFreezeValue = [self isValueApplicableForFreeze:_selectedValueColumn1];
            
            if (valueOfColumn1 >= freezeValue || isNeedToFreezeValue){
                
                bIsTableDisabled = YES;
                self.selectedValueColumn2 = @"0";
                [tblColumn2 reloadData];
                
                [tblColumn2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(0+self.arrColumn2.count) inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                
            }else if ((valueOfColumn1 < freezeValue) && bIsTableDisabled){
                
                bIsTableDisabled = NO;
                [tblColumn2 reloadData];
            }
            
            break;
        }
        case K_COLUMN_2_TAG:{
                        
            DDBase* obj = [self.arrColumn2 fetchObjectAtIndex:indexPath.row%self.arrColumn2.count];
            
            
            self.selectedValueColumn2 = obj.valueID.stringValue;
            [tblColumn2 reloadData];
            
            break;
        }
        default:
            break;
    }

    
    }
    else{
    
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
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isPickerTypeValue)
    {
    NSInteger tableType = tableView.tag;
    UILabel* lbl = (UILabel*)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:K_TABLEVIEW_LABEL_TAG];
    lbl.textColor = Clr_DarkBrown_SearchJob;
    
    switch (tableType) {
            
        case K_COLUMN_1_TAG:{
            
            NSString* appendedString = self.pickerModel.pickerLabelColoumnOne;
            NSRange replaceRange = [lbl.text rangeOfString:[NSString stringWithFormat:@" %@",appendedString]];
            if (replaceRange.location != NSNotFound)
                [lbl setText:[lbl.text stringByReplacingCharactersInRange:replaceRange withString:@""]];
            UITableViewCell *cell = [tblColumn1 cellForRowAtIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [tblColumn1 reloadData];
            break;
        }
            
        case K_COLUMN_2_TAG:{
            
            NSString* appendedString = self.pickerModel.pickerLabelColoumnTwo;
            NSRange replaceRange = [lbl.text rangeOfString:[NSString stringWithFormat:@" %@",appendedString]];
            if (replaceRange.location != NSNotFound)
                [lbl setText:[lbl.text stringByReplacingCharactersInRange:replaceRange withString:@""]];
            UITableViewCell *cell = [tblColumn2 cellForRowAtIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [tblColumn2 reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [tblColumn2 reloadData];
            break;
            
        }
        default:
            break;
    }
    
    }
}

@end
