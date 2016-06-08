//
//  NGCalenderPickerView.h
//  NaukriGulf
//
//  Created by Himanshu on 7/29/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGCustomPickerModel.h"

typedef NS_ENUM(NSInteger, NGCalenderType) {
    NGCalenderTypeDD,
    NGCalenderTypeMM,
    NGCalenderTypeYYYY,
    NGCalenderTypeDDMM,
    NGCalenderTypeMMYYYY,
    NGCalenderTypeDDMMYYYY,
    
};



@protocol NGCalenderDelegate <NSObject>
@optional
-(void)didSelectCalenderPickerWithValues:(NSDictionary *)responseParams success:(BOOL)successFlag andPickerType:(BOOL)isPickerTypeValue;//new delagte case




@end

@interface NGCalenderPickerView : UIViewController<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, weak) id<NGCalenderDelegate> delegate;
@property (nonatomic) NGCalenderType calType;
@property (nonatomic,strong) NSString* selectedValue;
@property (nonatomic,strong) NSNumber* minYear;
@property (nonatomic,strong) NSNumber* maxYear;

@property (nonatomic,strong) NSString* headerTitle;


@property (nonatomic,assign)BOOL isPickerTypeValue;

-(void)showDefaultValue:(NSString *)dateValue;
-(void)refreshData;
-(void)adjustDateInMiddle;




# pragma mark- Picker Value
/**
 *  This variable have all Column 1 Values.
 */
@property (nonatomic,strong) NSMutableArray *arrColumn1;

/**
 *  This variable have all Column 2 Values.
 */
@property (nonatomic,strong) NSMutableArray *arrColumn2;

/**
 *  This variable contains column 1 selected Value.
 */
@property (nonatomic,strong) NSString *selectedValueColumn1;

/**
 *  This variable contains column 2 selected Value.
 */
@property (nonatomic,strong) NSString *selectedValueColumn2;

/**
 *  This variable contains all requested parameters from controller class.
 */

@property(strong,nonatomic)NGCustomPickerModel *pickerModel;
-(void)displayDropdownData:(int)ddType;




@end
