//
//  NGMNJProfileModalClass.h
//  NaukriGulf
//
//  Created by Arun Kumar on 05/11/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
///////////////////  Projects ////////////////

@protocol NGProjectDetailModel 

@end

/**
 *  The class behaves as a model class for Project Tuple.
 */
@interface NGProjectDetailModel : JSONModel <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *client;
@property (strong, nonatomic) NSString *designation;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *site;

@end


///////////////////  IT Skills ////////////////
/**
 *  The class behaves as a model class for IT Skill Tuple.
 */
@protocol NGITSkillDetailModel

@end

@interface NGITSkillDetailModel : JSONModel <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *experience;
@property (strong, nonatomic) NSString *lastUsed;

@end


///////////////////  Work Experience ////////////////

@protocol NGWorkExpDetailModel

@end

/**
 *  The class behaves as a model class for Work Experience Tuple Detail.
 */
@interface NGWorkExpDetailModel : JSONModel <NSCoding>

@property (strong, nonatomic) NSString *designation;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *jobProfile;
@property (strong, nonatomic) NSString *workExpID;

@end



///////////////////  Education ////////////////

@protocol NGEducationDetailModel

@end

/**
 *  The class behaves as a model class for Education Detail.
 */
@interface NGEducationDetailModel : JSONModel <NSCoding>

@property (strong, nonatomic) NSDictionary *course;
@property (strong, nonatomic) NSDictionary *specialization;
@property (strong, nonatomic) NSDictionary *country;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *type;

@end



/////////////////// MNJ User Profile ////////////////

/**
 *  The class behaves as a model class for User's Profile API. The model object gets create while parsing the User's Profile API response.
 */
@interface NGMNJProfileModalClass : JSONModel <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *resID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *dateOfBirth;
@property (strong, nonatomic) NSString *mphone;
@property (strong, nonatomic) NSString *rphone;

@property (strong, nonatomic) NSDictionary *city;
@property (strong, nonatomic) NSDictionary *nationality;
@property (strong, nonatomic) NSDictionary *country;
@property (strong, nonatomic) NSString *keySkills;
@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSDictionary *workLevel;
@property (strong, nonatomic) NSString *salary;
@property (strong, nonatomic) NSDictionary *currency;
@property (strong, nonatomic) NSDictionary *salary_range;
@property (strong, nonatomic) NSDictionary *fArea;
@property (strong, nonatomic) NSDictionary *industryType;

@property (nonatomic) BOOL isDrivingLicense;
@property (strong, nonatomic) NSString *dlStr;
@property (strong, nonatomic) NSDictionary *dlCountry;

@property (strong, nonatomic) NSDictionary *noticePeriod;

@property (strong, nonatomic) NSDictionary *visaStatus;
@property (strong, nonatomic) NSString *visaExpiryDate;

@property (strong, nonatomic) NSDictionary *employmentType;
@property (strong, nonatomic) NSDictionary *employmentStatus;

@property (strong, nonatomic) NSDictionary *preferredWorkLocation;
@property (strong, nonatomic) NSDictionary *maritalStatus;
@property (strong, nonatomic) NSDictionary *languagesKnown;
@property (strong, nonatomic) NSDictionary *religion;
@property (strong, nonatomic) NSDictionary *totalExpYears;
@property (strong, nonatomic) NSDictionary *totalExpMonths;

@property (strong, nonatomic) NSMutableArray<NGProjectDetailModel>   *projectsList;
@property (strong, nonatomic) NSMutableArray<NGITSkillDetailModel>   *IT_SkillsList;
@property (strong, nonatomic) NSMutableArray<NGWorkExpDetailModel>   *workExpList;
@property (strong, nonatomic) NSMutableArray<NGWorkExpDetailModel>   *currentWorkExp;
@property (strong, nonatomic) NSMutableArray<NGEducationDetailModel> *educationList;

@property (strong, nonatomic) NSDictionary *photoMetaData;

@property (strong, nonatomic) NSDictionary *ugCourse;
@property (strong, nonatomic) NSDictionary *ugSpecialization;
@property (strong, nonatomic) NSDictionary *ugCountry;
@property (strong, nonatomic) NSString *ugYear;

@property (strong, nonatomic) NSDictionary *pgCourse;
@property (strong, nonatomic) NSDictionary *pgSpecialization;
@property (strong, nonatomic) NSDictionary *pgCountry;
@property (strong, nonatomic) NSString *pgYear;

@property (strong, nonatomic) NSDictionary *ppgCourse;
@property (strong, nonatomic) NSDictionary *ppgSpecialization;
@property (strong, nonatomic) NSDictionary *ppgCountry;
@property (strong, nonatomic) NSString *ppgYear;

@property (strong, nonatomic) NSString *attachedCvFormat;
@property (strong, nonatomic) NSString *attachedCvModDate;

@property (strong, nonatomic) NSString *profileModifiedDate;
@property (strong, nonatomic) NSString *lastModTimeStamp;

/// Utility Variables

@property (strong, nonatomic) NSString *currentDesignation;
@property (strong, nonatomic) NSArray *keySkillsList;
@property (strong, nonatomic) NSString *addCourseType;

-(void)createEducationList;

@end
