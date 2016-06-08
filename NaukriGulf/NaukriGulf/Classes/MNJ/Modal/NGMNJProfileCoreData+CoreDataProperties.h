//
//  NGMNJProfileCoreData+CoreDataProperties.h
//  NaukriGulf
//
//  Created by Nveen Bandlamoodi on 14/04/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NGMNJProfileCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface NGMNJProfileCoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *absoluteSalary;
@property (nullable, nonatomic, retain) NSString *addCourseType;
@property (nullable, nonatomic, retain) NSString *attachedCvFormat;
@property (nullable, nonatomic, retain) NSString *attachedCvModDate;
@property (nullable, nonatomic, retain) id city;
@property (nullable, nonatomic, retain) id country;
@property (nullable, nonatomic, retain) id currency;
@property (nullable, nonatomic, retain) NSString *currentDesignation;
@property (nullable, nonatomic, retain) NSString *dateOfBirth;
@property (nullable, nonatomic, retain) id dlCountry;
@property (nullable, nonatomic, retain) NSString *dlStr;
@property (nullable, nonatomic, retain) id employmentStatus;
@property (nullable, nonatomic, retain) id employmentType;
@property (nullable, nonatomic, retain) id fArea;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *headline;
@property (nullable, nonatomic, retain) id industryType;
@property (nullable, nonatomic, retain) NSNumber *isDrivingLicense;
@property (nullable, nonatomic, retain) NSString *keySkills;
@property (nullable, nonatomic, retain) id keySkillsList;
@property (nullable, nonatomic, retain) id languagesKnown;
@property (nullable, nonatomic, retain) NSString *lastModTimeStamp;
@property (nullable, nonatomic, retain) id maritalStatus;
@property (nullable, nonatomic, retain) NSString *mphone;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) id nationality;
@property (nullable, nonatomic, retain) id noticePeriod;
@property (nullable, nonatomic, retain) id pgCountry;
@property (nullable, nonatomic, retain) id pgCourse;
@property (nullable, nonatomic, retain) id pgSpecialization;
@property (nullable, nonatomic, retain) NSString *pgYear;
@property (nullable, nonatomic, retain) id photoMetaData;
@property (nullable, nonatomic, retain) id ppgCountry;
@property (nullable, nonatomic, retain) id ppgCourse;
@property (nullable, nonatomic, retain) id ppgSpecialization;
@property (nullable, nonatomic, retain) NSString *ppgYear;
@property (nullable, nonatomic, retain) id preferredWorkLocation;
@property (nullable, nonatomic, retain) NSString *profileModifiedDate;
@property (nullable, nonatomic, retain) id religion;
@property (nullable, nonatomic, retain) NSString *resID;
@property (nullable, nonatomic, retain) NSString *rphone;
@property (nullable, nonatomic, retain) id salary;
@property (nullable, nonatomic, retain) id totalExpMonths;
@property (nullable, nonatomic, retain) id totalExpYears;
@property (nullable, nonatomic, retain) id ugCountry;
@property (nullable, nonatomic, retain) id ugCourse;
@property (nullable, nonatomic, retain) id ugSpecialization;
@property (nullable, nonatomic, retain) NSString *ugYear;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *visaExpiryDate;
@property (nullable, nonatomic, retain) id visaStatus;
@property (nullable, nonatomic, retain) id workLevel;
@property (nullable, nonatomic, retain) NSSet<NGEducationDetailCoreData *> *educationList;
@property (nullable, nonatomic, retain) NSSet<NGITSkillDetailCoreData *> *itSkillList;
@property (nullable, nonatomic, retain) NSSet<NGProjectDetailCoreData *> *projectList;
@property (nullable, nonatomic, retain) NSSet<NGWorkExpDetailCoreData *> *workExpList;

@end

@interface NGMNJProfileCoreData (CoreDataGeneratedAccessors)

- (void)addEducationListObject:(NGEducationDetailCoreData *)value;
- (void)removeEducationListObject:(NGEducationDetailCoreData *)value;
- (void)addEducationList:(NSSet<NGEducationDetailCoreData *> *)values;
- (void)removeEducationList:(NSSet<NGEducationDetailCoreData *> *)values;

- (void)addItSkillListObject:(NGITSkillDetailCoreData *)value;
- (void)removeItSkillListObject:(NGITSkillDetailCoreData *)value;
- (void)addItSkillList:(NSSet<NGITSkillDetailCoreData *> *)values;
- (void)removeItSkillList:(NSSet<NGITSkillDetailCoreData *> *)values;

- (void)addProjectListObject:(NGProjectDetailCoreData *)value;
- (void)removeProjectListObject:(NGProjectDetailCoreData *)value;
- (void)addProjectList:(NSSet<NGProjectDetailCoreData *> *)values;
- (void)removeProjectList:(NSSet<NGProjectDetailCoreData *> *)values;

- (void)addWorkExpListObject:(NGWorkExpDetailCoreData *)value;
- (void)removeWorkExpListObject:(NGWorkExpDetailCoreData *)value;
- (void)addWorkExpList:(NSSet<NGWorkExpDetailCoreData *> *)values;
- (void)removeWorkExpList:(NSSet<NGWorkExpDetailCoreData *> *)values;

@end

NS_ASSUME_NONNULL_END
