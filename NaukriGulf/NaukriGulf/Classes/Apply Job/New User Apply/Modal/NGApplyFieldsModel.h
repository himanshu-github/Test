//
//  NGApplyFieldsModel.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/27/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGApplyFieldsModel : NSObject

//NOTE: for dic keys use KEY_ID, KEY_SUBVALUE, VALUE_LABEL and KEY_VALUE constants

//page - 1
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *emailId;
@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSMutableDictionary *workEx;//this have two inner dic year and month
//year
//KEY_YEAR_DICTIONARY
//VALUE_YEAR_DICTIONARY
//month
//KEY_MONTH_DICTIONARY
//VALUE_MONTH_DICTIONARY


//Page - 2
@property (strong, nonatomic) NSString *currentDesignation;
@property (strong, nonatomic) NSMutableDictionary *gradCourse;
@property (strong, nonatomic) NSMutableDictionary *gradspecialisation;
@property (strong, nonatomic) NSMutableDictionary *pgCourse;
@property (strong, nonatomic) NSMutableDictionary *pgSpecialisation;
@property (strong, nonatomic) NSMutableDictionary *doctCourse;
@property (strong, nonatomic) NSMutableDictionary *doctspecialisation;
@property (strong, nonatomic) NSMutableDictionary *country;
@property (strong, nonatomic) NSMutableDictionary *city;
@property (strong, nonatomic) NSMutableDictionary *nationality;
@property (assign, nonatomic) BOOL isFresher;


- (NSString*)getFinalExperience;

- (NSMutableDictionary*)dictionaryOfObjectData;


@end
