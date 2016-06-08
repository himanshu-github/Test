//
//  NGMNJProfileModalClass.m
//  NaukriGulf
//
//  Created by Arun Kumar on 05/11/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJProfileModalClass.h"
#import "DDLanguage.h"

#pragma mark Projects

@implementation NGProjectDetailModel

#pragma mark NSCoding Protocol

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.client forKey:@"client"];
    [aCoder encodeObject:self.designation forKey:@"designation"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeObject:self.endDate forKey:@"endDate"];
    [aCoder encodeObject:self.site forKey:@"site"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.client = [aDecoder decodeObjectForKey:@"client"];
    self.designation = [aDecoder decodeObjectForKey:@"designation"];
    self.location = [aDecoder decodeObjectForKey:@"location"];
    self.startDate = [aDecoder decodeObjectForKey:@"startDate"];
    self.endDate = [aDecoder decodeObjectForKey:@"endDate"];
    self.site = [aDecoder decodeObjectForKey:@"site"];
    
    return self;
}


#pragma mark JSON Model

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end


#pragma mark IT Skills

@implementation NGITSkillDetailModel

#pragma mark NSCoding Protocol

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.experience forKey:@"experience"];
    [aCoder encodeObject:self.lastUsed forKey:@"lastUsed"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.experience = [aDecoder decodeObjectForKey:@"experience"];
    self.lastUsed = [aDecoder decodeObjectForKey:@"lastUsed"];
    
    return self;
}


#pragma mark JSON Model

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


@end


#pragma mark Work Experience

@implementation NGWorkExpDetailModel

#pragma mark NSCoding Protocol

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.designation forKey:@"designation"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeObject:self.endDate forKey:@"endDate"];
    [aCoder encodeObject:self.organization forKey:@"organization"];
    [aCoder encodeObject:self.jobProfile forKey:@"jobProfile"];
    [aCoder encodeObject:self.workExpID forKey:@"workExpID"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self.designation = [aDecoder decodeObjectForKey:@"designation"];
    self.startDate = [aDecoder decodeObjectForKey:@"startDate"];
    self.endDate = [aDecoder decodeObjectForKey:@"endDate"];
    self.organization = [aDecoder decodeObjectForKey:@"organization"];
    self.jobProfile = [aDecoder decodeObjectForKey:@"jobProfile"];
    self.workExpID = [aDecoder decodeObjectForKey:@"workExpID"];
    
    return self;
}


#pragma mark JSON Model

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"workExpID"
                                                       }];
}

@end



#pragma mark Education

@implementation NGEducationDetailModel

#pragma mark NSCoding Protocol

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.course forKey:@"course"];
    [aCoder encodeObject:self.specialization forKey:@"specialization"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.year forKey:@"year"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self.course = [aDecoder decodeObjectForKey:@"course"];
    self.specialization = [aDecoder decodeObjectForKey:@"specialization"];
    self.country = [aDecoder decodeObjectForKey:@"country"];
    self.year = [aDecoder decodeObjectForKey:@"year"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    
    return self;
}


#pragma mark JSON Model

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


@end


#pragma mark MNJ User Profile

@implementation NGMNJProfileModalClass

#pragma mark NSCoding Protocol

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.resID forKey:@"resID"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.dateOfBirth forKey:@"dateOfBirth"];
    [aCoder encodeObject:self.mphone forKey:@"mphone"];
    [aCoder encodeObject:self.rphone forKey:@"rphone"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.nationality forKey:@"nationality"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.keySkills forKey:@"keySkills"];
    [aCoder encodeObject:self.headline forKey:@"headline"];
    [aCoder encodeObject:self.workLevel forKey:@"workLevel"];
    [aCoder encodeObject:self.salary forKey:@"salary"];
    [aCoder encodeObject:self.fArea forKey:@"fArea"];
    [aCoder encodeObject:self.industryType forKey:@"industryType"];
    [aCoder encodeBool:self.isDrivingLicense forKey:@"isDrivingLicense"];
    [aCoder encodeObject:self.dlStr forKey:@"dlStr"];
    [aCoder encodeObject:self.dlCountry forKey:@"dlCountry"];
    [aCoder encodeObject:self.noticePeriod forKey:@"noticePeriod"];
    [aCoder encodeObject:self.visaStatus forKey:@"visaStatus"];
    [aCoder encodeObject:self.visaExpiryDate forKey:@"visaExpiryDate"];
    [aCoder encodeObject:self.employmentType forKey:@"employmentType"];
    [aCoder encodeObject:self.employmentStatus forKey:@"employmentStatus"];
    [aCoder encodeObject:self.preferredWorkLocation forKey:@"preferredWorkLocation"];
    [aCoder encodeObject:self.maritalStatus forKey:@"maritalStatus"];
    [aCoder encodeObject:self.languagesKnown forKey:@"languagesKnown"];
    [aCoder encodeObject:self.religion forKey:@"religion"];
    [aCoder encodeObject:self.totalExpYears forKey:@"totalExpYears"];
    [aCoder encodeObject:self.totalExpMonths forKey:@"totalExpMonths"];
    [aCoder encodeObject:self.projectsList forKey:@"projectsList"];
    [aCoder encodeObject:self.IT_SkillsList forKey:@"IT_SkillsList"];
    [aCoder encodeObject:self.workExpList forKey:@"workExpList"];
    [aCoder encodeObject:self.currentWorkExp forKey:@"currentWorkExp"];
    [aCoder encodeObject:self.photoMetaData forKey:@"photoMetaData"];
    [aCoder encodeObject:self.ugCourse forKey:@"ugCourse"];
    [aCoder encodeObject:self.ugSpecialization forKey:@"ugSpecialization"];
    [aCoder encodeObject:self.ugCountry forKey:@"ugCountry"];
    [aCoder encodeObject:self.ugYear forKey:@"ugYear"];
    [aCoder encodeObject:self.pgCourse forKey:@"pgCourse"];
    [aCoder encodeObject:self.pgSpecialization forKey:@"pgSpecialization"];
    [aCoder encodeObject:self.pgCountry forKey:@"pgCountry"];
    [aCoder encodeObject:self.pgYear forKey:@"pgYear"];
    [aCoder encodeObject:self.ppgCourse forKey:@"ppgCourse"];
    [aCoder encodeObject:self.ppgSpecialization forKey:@"ppgSpecialization"];
    [aCoder encodeObject:self.ppgCountry forKey:@"ppgCountry"];
    [aCoder encodeObject:self.ppgYear forKey:@"ppgYear"];
    [aCoder encodeObject:self.attachedCvFormat forKey:@"attachedCvFormat"];
    [aCoder encodeObject:self.attachedCvModDate forKey:@"attachedCvModDate"];
    [aCoder encodeObject:self.profileModifiedDate forKey:@"profileModifiedDate"];
    [aCoder encodeObject:self.currentDesignation forKey:@"currentDesignation"];
    [aCoder encodeObject:self.keySkillsList forKey:@"keySkillsList"];
    [aCoder encodeObject:self.educationList forKey:@"educationList"];
    [aCoder encodeObject:self.addCourseType forKey:@"addCourseType"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.resID = [aDecoder decodeObjectForKey:@"resID"];
    self.username = [aDecoder decodeObjectForKey:@"username"];
    self.gender = [aDecoder decodeObjectForKey:@"gender"];
    self.dateOfBirth = [aDecoder decodeObjectForKey:@"dateOfBirth"];
    self.mphone = [aDecoder decodeObjectForKey:@"mphone"];
    self.rphone = [aDecoder decodeObjectForKey:@"rphone"];
    self.city = [aDecoder decodeObjectForKey:@"city"];
    self.nationality = [aDecoder decodeObjectForKey:@"nationality"];
    self.country = [aDecoder decodeObjectForKey:@"country"];
    self.keySkills = [aDecoder decodeObjectForKey:@"keySkills"];
    self.headline = [aDecoder decodeObjectForKey:@"headline"];
    self.workLevel = [aDecoder decodeObjectForKey:@"workLevel"];
    self.salary = [aDecoder decodeObjectForKey:@"salary"];
    self.fArea = [aDecoder decodeObjectForKey:@"fArea"];
    self.industryType = [aDecoder decodeObjectForKey:@"industryType"];
    self.isDrivingLicense = [aDecoder decodeBoolForKey:@"isDrivingLicense"];
    self.dlStr = [aDecoder decodeObjectForKey:@"dlStr"];
    self.dlCountry = [aDecoder decodeObjectForKey:@"dlCountry"];
    self.noticePeriod = [aDecoder decodeObjectForKey:@"noticePeriod"];
    self.visaStatus = [aDecoder decodeObjectForKey:@"visaStatus"];
    self.visaExpiryDate = [aDecoder decodeObjectForKey:@"visaExpiryDate"];
    self.employmentType = [aDecoder decodeObjectForKey:@"employmentType"];
    self.employmentStatus = [aDecoder decodeObjectForKey:@"employmentStatus"];
    self.preferredWorkLocation = [aDecoder decodeObjectForKey:@"preferredWorkLocation"];
    self.maritalStatus = [aDecoder decodeObjectForKey:@"maritalStatus"];
    self.languagesKnown = [aDecoder decodeObjectForKey:@"languagesKnown"];
    self.religion = [aDecoder decodeObjectForKey:@"religion"];
    self.totalExpYears = [aDecoder decodeObjectForKey:@"totalExpYears"];
    self.totalExpMonths = [aDecoder decodeObjectForKey:@"totalExpMonths"];
    self.projectsList = [aDecoder decodeObjectForKey:@"projectsList"];
    self.IT_SkillsList = [aDecoder decodeObjectForKey:@"IT_SkillsList"];
    self.workExpList = [aDecoder decodeObjectForKey:@"workExpList"];
    self.currentWorkExp = [aDecoder decodeObjectForKey:@"currentWorkExp"];
    self.photoMetaData = [aDecoder decodeObjectForKey:@"photoMetaData"];
    self.ugCourse = [aDecoder decodeObjectForKey:@"ugCourse"];
    self.ugSpecialization = [aDecoder decodeObjectForKey:@"ugSpecialization"];
    self.ugCountry = [aDecoder decodeObjectForKey:@"ugCountry"];
    self.ugYear = [aDecoder decodeObjectForKey:@"ugYear"];
    self.pgCourse = [aDecoder decodeObjectForKey:@"pgCourse"];
    self.pgSpecialization = [aDecoder decodeObjectForKey:@"pgSpecialization"];
    self.pgCountry = [aDecoder decodeObjectForKey:@"pgCountry"];
    self.pgYear = [aDecoder decodeObjectForKey:@"pgYear"];
    self.ppgCourse = [aDecoder decodeObjectForKey:@"ppgCourse"];
    self.ppgSpecialization = [aDecoder decodeObjectForKey:@"ppgSpecialization"];
    self.ppgCountry = [aDecoder decodeObjectForKey:@"ppgCountry"];
    self.ppgYear = [aDecoder decodeObjectForKey:@"ppgYear"];
    self.attachedCvFormat = [aDecoder decodeObjectForKey:@"attachedCvFormat"];
    self.attachedCvModDate = [aDecoder decodeObjectForKey:@"attachedCvModDate"];
    self.profileModifiedDate = [aDecoder decodeObjectForKey:@"profileModifiedDate"];
    self.currentDesignation = [aDecoder decodeObjectForKey:@"currentDesignation"];
    self.keySkillsList = [aDecoder decodeObjectForKey:@"keySkillsList"];
    self.educationList = [aDecoder decodeObjectForKey:@"educationList"];
    self.addCourseType = [aDecoder decodeObjectForKey:@"addCourseType"];
    
    return self;
}

#pragma mark JSON Model

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"project": @"projectsList",
                                                       @"skill": @"IT_SkillsList",
                                                       @"workExperience": @"workExpList",
                                                       @"currentWorkExperience": @"currentWorkExp",
                                                       @"pgSpec": @"pgSpecialization",
                                                       @"ppgSpec": @"ppgSpecialization",
                                                       @"totalExperienceMonths": @"totalExpMonths",
                                                       @"ugSpec": @"ugSpecialization",
                                                       @"drivingLicense": @"dlStr",
                                                       @"resId": @"resID",
                                                       @"photoMetadata": @"photoMetaData",
                                                       @"totalExperienceYears": @"totalExpYears",
                                                       @"functionalArea": @"fArea",
                                                       @"drivingLicenseCountry": @"dlCountry",                                                       
                                                       @"ctc": @"salary_range",
                                                       @"modDate": @"profileModifiedDate",
                                                       @"headline": @"headline"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark Setter Methods
-(void)setKeySkills:(NSString *)keySkills{
    _keySkills = keySkills;
    _keySkillsList = [keySkills componentsSeparatedByString:@","];
    
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    
    for (NSString *str in _keySkillsList) {
        NSString *trimmedString = [str trimCharctersInSet :
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (![trimmedString isEqualToString:@""]) {
            [tempArr addObject:trimmedString];
        }
    }
    
    _keySkillsList = tempArr;
    
}
-(void)setCurrentWorkExp:(NSMutableArray<NGWorkExpDetailModel> *)currentWorkExp{
    _currentWorkExp = currentWorkExp;
    
    if (_currentWorkExp.count>0) {
        NGWorkExpDetailModel *obj = [_currentWorkExp fetchObjectAtIndex:0];
        self.currentDesignation = obj.designation;
        obj = nil;
    }    
}

-(void)setMphone:(NSString *)mphone{
    if (mphone) {
        _mphone = mphone;
    }else{
        _mphone = @"";
    }
}

-(void)setRphone:(NSString *)rphone{
    if (rphone) {
        _rphone = rphone;
    }else{
        _rphone = @"";
    }
}


-(void)setPreferredWorkLocation:(NSDictionary *)preferredWorkLocation{

    _preferredWorkLocation = preferredWorkLocation;
}

-(void)setWorkExpList:(NSMutableArray<NGWorkExpDetailModel> *)workExpList{
    
    NSMutableArray *arrayToSort = [NSMutableArray array];
    NSMutableArray<NGWorkExpDetailModel> *finalArr = (NSMutableArray<NGWorkExpDetailModel> *) [NSMutableArray array];
    NSMutableArray *firstArr = [NSMutableArray array];
    NSMutableArray *lastArr = [NSMutableArray array];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    for (NGWorkExpDetailModel *obj in workExpList) {
        NSString *startDate = obj.startDate;
        NSString *endDate = obj.endDate;
        
        if ([endDate isEqualToString:@"Present"]) {
            [firstArr addObject:obj];
        }else if(0>=[vManager validateValue:startDate withType:ValidationTypeDate].count && 0>=[vManager validateValue:endDate withType:ValidationTypeDate].count){
            
            [arrayToSort addObject:obj];
            
        }else{
            [lastArr addObject:obj];
        }
    }
    
    
    NSArray *sortedArr;
    
    if (arrayToSort.count>0) {
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"startDate"
                                            ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        sortedArr = [arrayToSort
                     sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    
    if (firstArr.count>0) {
        [finalArr addObjectsFromArray:firstArr];
    }
    
    if (sortedArr) {
        [finalArr addObjectsFromArray:sortedArr];
    }
    
    if (lastArr.count>0) {
        [finalArr addObjectsFromArray:lastArr];
    }
    
    
    _workExpList = finalArr;
    firstArr = nil;
    lastArr = nil;
    arrayToSort = nil;
}

-(void)setLanguagesKnown:(NSDictionary *)languagesKnown{
    NSMutableDictionary *languageDict = [NSMutableDictionary dictionaryWithDictionary:languagesKnown];
    
    NSMutableArray *languagesArr = [NSMutableArray array];
    if ([[languagesKnown objectForKey:@"label"] isKindOfClass:[NSString class]]) {
        NSString *languages = [languagesKnown objectForKey:@"label"];
        NSArray *languagesIDArr = [languages componentsSeparatedByString:@","];
        
        if (languagesIDArr.count>0 && languages && ![languages isEqualToString:@""]) {
            
            NSArray *arr = [NSMutableArray arrayWithArray:[NGDatabaseHelper getAllClassData:[DDLanguage class]]];

            for (NSString *lStr in languagesIDArr) {
                if (![lStr isEqualToString:@""]) {
                    [languagesArr addObject:[NSString getLabelForID:lStr inList:arr]];
                }
                
            }
        }
        [languageDict setCustomObject:languagesArr forKey:@"label"];
    }
    
    
    _languagesKnown = languageDict;
}


#pragma mark Utility Methods

-(void)createEducationList{
    if (self.educationList) {
        [self.educationList removeAllObjects];
         self.educationList = nil;
    }
    
    self.educationList = (NSMutableArray<NGEducationDetailModel> *) [NSMutableArray array];
    self.addCourseType = @"";
    
    NSString *courseID = [self.ppgCourse objectForKey:@"id"];
    
    if (courseID.length>0 && courseID) {
        NGEducationDetailModel *obj = [[NGEducationDetailModel alloc]init];
        obj.type = @"ppg";
        obj.course = self.ppgCourse;
        obj.specialization = self.ppgSpecialization;
        obj.country = self.ppgCountry;
        obj.year = self.ppgYear;
        
        [self.educationList addObject:obj];
    }else{
        self.addCourseType = @"ppg";
    }
    
    courseID = [self.pgCourse objectForKey:@"id"];
    
    if (courseID.length>0 && courseID) {
        NGEducationDetailModel *obj = [[NGEducationDetailModel alloc]init];
        obj.type = @"pg";
        obj.course = self.pgCourse;
        obj.specialization = self.pgSpecialization;
        obj.country = self.pgCountry;
        obj.year = self.pgYear;
        
        [self.educationList addObject:obj];
    }else{
        self.addCourseType = @"pg";
    }
    
    
    courseID = [self.ugCourse objectForKey:@"id"];
    
    if (courseID.length>0 && courseID) {
        NGEducationDetailModel *obj = [[NGEducationDetailModel alloc]init];
        obj.type = @"ug";
        obj.course = self.ugCourse;
        obj.specialization = self.ugSpecialization;
        obj.country = self.ugCountry;
        obj.year = self.ugYear;
        
        [self.educationList addObject:obj];
    }else{
        self.addCourseType = @"ug";
    }
}

@end
