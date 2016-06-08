//
//  NGProfileSectionModalClass.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 8/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
typedef enum {
    
    CSTypeProfilePhoto =0,
    CSTypeBasicDetails,
    CSTypeContactDetails,
    CSTypeCVHeadline,
    CSTypeKeySkills,
    CSTypeIndustryInformation,
    CSTypeWorkExperience,
    CSTypeEducation,
    CSTypePersonalDetails,
    CSTypeDesiredJob,
    CSTypeResume


}CSType;

@interface NGProfileSectionModalClass : JSONModel

@property (assign, nonatomic) CSType profileSectionType;
@property (strong, nonatomic) NSString *title;
@property (strong,nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *descriptionStr;
@property (assign, nonatomic) BOOL isComplete;
@property (assign , nonatomic)NSInteger tapIndex;
@property (assign, nonatomic) NSString *apiName;

@end
