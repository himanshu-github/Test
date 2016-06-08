//
//  NGApplyFieldsCoreData.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/28/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NGApplyFieldsCoreData : NSManagedObject

@property (nonatomic, retain) NSString * currentCompany;
@property (nonatomic, retain) NSString * currentDesignation;
@property (nonatomic, retain) NSString * emailId;
@property (nonatomic, retain) id gradCourse;
@property (nonatomic, retain) id gradspecialisation;
@property (nonatomic, retain) NSString * mobileNumebr;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id pgCourse;
@property (nonatomic, retain) id pgSpecialisation;
@property (nonatomic, retain) id workEx;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) id doctCourse;
@property (nonatomic, retain) id doctSpecialization;
@property (nonatomic, retain) id country;
@property (nonatomic, retain) id city;
@property (nonatomic, retain) id nationality;
@property (nonatomic, retain) NSNumber * fresher;
+(void)updateUnregApplyCoreDataFields:(NSDictionary*)dictUpdatedValues;

@end
