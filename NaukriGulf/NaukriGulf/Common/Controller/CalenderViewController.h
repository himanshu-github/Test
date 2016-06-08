//
//  CalenderViewController.h
//  Calender
//
//  Created by Arun Kumar on 10/08/13.
//  Copyright (c) 2013 Arun Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalenderDelegate <NSObject>

-(void)didSelectDate:(NSDictionary *)responseParams success:(BOOL)successFlag;

@end

@interface CalenderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<CalenderDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *daysArr;
@property (nonatomic,strong) NSMutableArray *monthsArr;
@property (nonatomic,strong) NSMutableArray *yearsArr;

@property (nonatomic) NSInteger selectedDay;
@property (nonatomic,strong) NSString *selectedMonth;
@property (nonatomic) NSInteger selectedYear;

@property (nonatomic) BOOL isDisplayDay;
@property (nonatomic) BOOL isDisplayMonth;
@property (nonatomic) BOOL isDisplayYear;


@property (strong, nonatomic) NSMutableDictionary *requestParams;

@property (nonatomic,strong) NSMutableArray *enabledDaysArr;
@property (nonatomic,strong) NSMutableArray *disabledDaysArr;

-(void)showDefaultValue:(NSString *)dateValue;
-(void)refreshData;

@end
