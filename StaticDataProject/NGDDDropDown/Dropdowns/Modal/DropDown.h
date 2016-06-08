//
//  NGDropDownCoreData.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DropDown : NSManagedObject

@property (nonatomic, retain) NSNumber * dropdownID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * serviceName;
@property (nonatomic, retain) NSString * dependentClassName;
@property (nonatomic, retain) NSString * parentName;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) id serverData;


+(void) createDropDownData;
+(void) updateDropDownData;
+(DropDown *) dropDownObjectonServiceName:(NSString *)serviceName;
+(DropDown *) dropDownObjectonClassName:(NSString *)className;
-(void) saveServerData:(NSArray *)dataArray time:(NSString *)time;

@end
