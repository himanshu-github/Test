//
//  NGCustomPickerModel.h
//  Naukri
//
//  Created by Shikha Sharma on 6/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGCustomPickerModel : NSObject

@property(nonatomic,strong) NSString *selectedValueColumn1;
@property(nonatomic,strong) NSString *selectedValueColumn2;
@property(nonatomic,strong) NSString *pickerHeader;
@property(nonatomic,strong) NSString *pickerTotalColoumn;
@property(nonatomic,strong) NSArray *pickerArrayColoumnOne;
@property(nonatomic,strong) NSArray *pickerArrayColoumnTwo;
@property(nonatomic,strong) NSString *pickerLabelColoumnOne;
@property(nonatomic,strong) NSString *pickerLabelColoumnTwo;
@property(nonatomic,strong) NSNumber *pickerDisableValue;
@property(nonatomic,strong) NSString *pickerDropDownType;
@end