//
//  NGResmanDataModel.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/14/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGResmanDataModel : NSObject
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) id preferredLoc;
@property (nonatomic, retain) id availabilityToJoin;
@property (nonatomic, retain) id totalExp;
@property (nonatomic, retain) NSString * designation;
@property (nonatomic, retain) NSString * company;
@property (nonatomic,readwrite) BOOL isFresher;
@property (nonatomic, retain) NSString *currentSalary;
@property (nonatomic, retain) id industry;
@property (nonatomic, retain) id functionalArea;
@property (nonatomic, retain) id highestEducation;
@property (nonatomic, retain) id ppgCourse;
@property (nonatomic, retain) id ppgSpec;
@property (nonatomic, retain) id pgCourse;
@property (nonatomic, retain) id pgSpec;
@property (nonatomic, retain) id ugCourse;
@property (nonatomic, retain) id ugSpec;
@property (nonatomic, retain) NSString * prevDesignation;
@property (nonatomic, retain) NSString * previousCompany;
@property (nonatomic, retain) NSString *keySkills;
@property (nonatomic, retain) id visaStatus;
@property (nonatomic, retain) NSString *visaValidity;
@property (nonatomic, readwrite) BOOL isHoldingDL;
@property (nonatomic, retain) id dlIssuedBy;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * mobileNum;
@property (nonatomic, retain) NSString* countryCode;
@property (nonatomic, retain) id nationality;
@property (nonatomic, retain) id city;
@property (nonatomic, retain) id alertSetting;
@property (nonatomic, retain) id country;
@property (nonatomic, readwrite) BOOL isOtherCity;
@property (nonatomic, readwrite) BOOL isCVUploaded;
@property (nonatomic, retain) NSString * cvHeadline;
@property (nonatomic,retain) id currency;
@property (nonatomic, retain) NSString *dob;
@property(nonatomic,retain) NSString *alternateEmail;
@property(nonatomic,retain) id religion;
@property(nonatomic,retain) NSString *otherReligion;
@property(nonatomic,retain) id maritalStatus;
@property(nonatomic,retain) id languages;
@property(nonatomic,readwrite) BOOL isDlPresent;

@end
