//
//  NGJobDetails.m
//  NaukriGulf
//
//  Created by Arun Kumar on 04/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJobDetails.h"

@implementation NGJobDetails

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.appliedDate forKey:@"appliedDate"];
    [aCoder encodeObject:self.designation forKey:@"designation"];
    [aCoder encodeObject:self.jobDescription forKey:@"description"];
    [aCoder encodeObject:self.cmpnyName forKey:@"cmpnyName"];
    [aCoder encodeObject:self.keywords forKey:@"keywords"];

    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.jobID forKey:@"jobID"];
    [aCoder encodeObject:self.jdURL forKey:@"jdURL"];
    [aCoder encodeObject:self.latestPostDate forKey:@"latestPostDate"];
    [aCoder encodeObject:self.cmpnyID forKey:@"cmpnyID"];
    [aCoder encodeObject:self.minExp forKey:@"minExp"];
    [aCoder encodeObject:self.maxExp forKey:@"maxExp"];
    [aCoder encodeInteger:self.vacancy forKey:@"vacancy"];
    [aCoder encodeBool:self.isAlreadyRead forKey:@"isAlreadyRead"];
    [aCoder encodeBool:self.isAlreadyShortlisted forKey:@"isAlreadyShortlisted"];
    [aCoder encodeBool:self.isTopEmployer forKey:@"IsTopEmployer"];
    [aCoder encodeBool:self.isFeaturedEmployer forKey:@"IsFeaturedEmployer"];
    [aCoder encodeBool:self.isWebJob forKey:@"IsWebJob"];
    [aCoder encodeBool:self.isQuickWebJob forKey:@"IsQuickWebJob"];
    [aCoder encodeBool:self.isPremiumJob forKey:@"IsPremiumJob"];
    [aCoder encodeObject:self.logoURL forKey:@"logoURL"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self.appliedDate = [aDecoder decodeObjectForKey:@"appliedDate"];
    self.designation = [aDecoder decodeObjectForKey:@"designation"];
    self.jobDescription = [aDecoder decodeObjectForKey:@"description"];
    self.keywords = [aDecoder decodeObjectForKey:@"keywords"];
    self.cmpnyName = [aDecoder decodeObjectForKey:@"cmpnyName"];
    self.location = [aDecoder decodeObjectForKey:@"location"];
    self.jobID = [aDecoder decodeObjectForKey:@"jobID"];
    self.jdURL = [aDecoder decodeObjectForKey:@"jdURL"];
    self.latestPostDate = [aDecoder decodeObjectForKey:@"latestPostDate"];
    self.minExp = [aDecoder decodeObjectForKey:@"minExp"];
    self.maxExp = [aDecoder decodeObjectForKey:@"maxExp"];
    self.vacancy = [aDecoder decodeIntegerForKey:@"vacancy"];
    self.isAlreadyRead = [aDecoder decodeBoolForKey:@"isAlreadyRead"];
    self.isAlreadyShortlisted = [aDecoder decodeBoolForKey:@"isAlreadyShortlisted"];
    self.isTopEmployer = [aDecoder decodeBoolForKey:@"IsTopEmployer"];
    self.isFeaturedEmployer = [aDecoder decodeBoolForKey:@"IsFeaturedEmployer"];
    self.isWebJob = [aDecoder decodeBoolForKey:@"IsWebJob"];
    self.isQuickWebJob = [aDecoder decodeBoolForKey:@"IsQuickWebJob"];
    self.isPremiumJob = [aDecoder decodeBoolForKey:@"IsPremiumJob"];
    self.logoURL = [aDecoder decodeObjectForKey:@"logoURL"];

    return self;
}
-(id)initWithJDJobDetailObject:(NGJDJobDetails*)paramJDJobDetails{
    if (self && paramJDJobDetails) {
        [self fillRequiredFieldsFromJDJobDetailObject:paramJDJobDetails];
    }
    return self;
}
-(id)fillRequiredFieldsFromJDJobDetailObject:(NGJDJobDetails*)paramJDJobDetails{
    if (paramJDJobDetails) {
        self.appliedDate = @"";//not available in jd job detail object and api
        self.designation = paramJDJobDetails.designation;
        self.jobDescription = paramJDJobDetails.jobDescription;
        self.keywords = paramJDJobDetails.keywords;
        self.cmpnyName = paramJDJobDetails.companyName;
        self.location = paramJDJobDetails.location;
        self.jobID = paramJDJobDetails.jobId;
        self.jdURL = paramJDJobDetails.jdURL;
        self.latestPostDate = paramJDJobDetails.latestPostedDate;
        self.minExp = paramJDJobDetails.minExp;
        self.maxExp = paramJDJobDetails.maxExp;
        self.vacancy = paramJDJobDetails.vacancies;
        self.isAlreadyRead = paramJDJobDetails.isAlreadyAppliedAsBool;
        self.isAlreadyShortlisted = NO;//default will be NO
        self.isTopEmployer = paramJDJobDetails.isTopEmployer;
        self.isFeaturedEmployer = paramJDJobDetails.isFeaturedEmployer;
        self.isWebJob = paramJDJobDetails.isWebjobAsBool;
        self.isQuickWebJob = paramJDJobDetails.isQuickWebjobAsBool;
        self.isPremiumJob = paramJDJobDetails.isPremiumJob;
        self.logoURL = paramJDJobDetails.logoURL;
        
    }
    return self;
}
#pragma mark JSON Model Methods

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"Job.Designation": @"designation",
                                                       @"Job.IsFeaturedEmployer": @"isFeaturedEmployerStr",
                                                       @"Job.Company.Name": @"cmpnyName",
                                                       @"Job.Keywords": @"keywords",
                                                       @"Job.Experience.Min": @"minExp",
                                                       @"Job.IsQuickWebJob": @"isQuickWebJobStr",
                                                       @"Job.Location": @"location",
                                                       @"Job.IsApplied": @"isAlreadyAppliedStr",
                                                       @"Job.Description": @"jobDescription",
                                                       @"Job.IsWebJob": @"isWebJobStr",
                                                       @"Job.JobId": @"jobID",
                                                       @"Job.Vacancies": @"vacancy",
                                                       @"Job.Company.Id": @"cmpnyID",
                                                       @"Job.JdURL": @"jdURL",
                                                       @"Job.LatestPostedDate": @"latestPostDate",
                                                       @"Job.IsTopEmployer": @"isTopEmployerStr",
                                                       @"Job.IsPremium": @"isPremiumJobStr",
                                                       @"Job.Experience.Max": @"maxExp",
                                                       @"Job.ApplyDate": @"appliedDate",
                                                       @"Job.LogoUrl": @"logoURL",
                                                       @"Job.TELogoUrl": @"TELogoURL",
                                                       @"Job.IsTopEmployerLite": @"isTopEmployerLiteStr"
                                                       
                                                       }];
}

#pragma mark getter Methods

-(BOOL)isAlreadyRead{
    if ([NGDecisionUtility isJobReadWithID:self.jobID]) {
        self.isAlreadyRead = YES;
    }else{
        self.isAlreadyRead = NO;
    }
    
    return _isAlreadyRead;
}

-(void)setLogoURL:(NSString *)logoURL{
    _logoURL = logoURL;
    
    if (_logoURL && _logoURL.length>0) {
        _logoURL = [_logoURL stringByAppendingString:@"&source=msrp"];
    }
    
}

-(void)setTELogoURL:(NSString *)TELogoURL{
    _TELogoURL = TELogoURL;
    
    if (_TELogoURL && _TELogoURL.length>0) {
        _TELogoURL = [_TELogoURL stringByAppendingString:@"&source=msrp"];
    }
    
}

-(void)setIsTopEmployerStr:(NSString *)isTopEmployerStr{
    _isTopEmployerStr = isTopEmployerStr;
    if ([_isTopEmployerStr isEqualToString:@"1"] || [@"true" isEqualToString:_isTopEmployerStr.lowercaseString]) {
        self.isTopEmployer = YES;
    }else{
        self.isTopEmployer = NO;
    }
}

-(void)setIsTopEmployerLiteStr:(NSString *)isTopEmployerLiteStr{
    _isTopEmployerLiteStr = isTopEmployerLiteStr;
    if ([_isTopEmployerLiteStr isEqualToString:@"1"]  || [@"true" isEqualToString:_isTopEmployerLiteStr.lowercaseString]) {
        self.isTopEmployerLite = YES;
    }else{
        self.isTopEmployerLite = NO;
    }
}

-(void)setIsFeaturedEmployerStr:(NSString *)isFeaturedEmployerStr{
    _isFeaturedEmployerStr = isFeaturedEmployerStr;
    if ([_isFeaturedEmployerStr isEqualToString:@"1"] || [@"true" isEqualToString:_isFeaturedEmployerStr.lowercaseString]) {
        self.isFeaturedEmployer = YES;
    }else{
        self.isFeaturedEmployer = NO;
    }
}

-(void)setIsWebJobStr:(NSString *)isWebJobStr{
    _isWebJobStr = isWebJobStr;
    if ([_isWebJobStr isEqualToString:@"1"] || [@"true" isEqualToString:_isWebJobStr.lowercaseString]) {
        self.isWebJob = YES;
    }else{
        self.isWebJob = NO;
    }
}

-(void)setIsQuickWebJobStr:(NSString *)isQuickWebJobStr{
    _isQuickWebJobStr = isQuickWebJobStr;
    if ([_isQuickWebJobStr isEqualToString:@"1"] || [@"true" isEqualToString:_isQuickWebJobStr.lowercaseString]) {
        self.isQuickWebJob = YES;
    }else{
        self.isQuickWebJob = NO;
    }
}

-(void)setIsAlreadyAppliedStr:(NSString *)isAlreadyAppliedStr{
    _isAlreadyAppliedStr = isAlreadyAppliedStr;
    if ([_isAlreadyAppliedStr isEqualToString:@"1"] || [@"true" isEqualToString:_isAlreadyAppliedStr.lowercaseString]) {
        self.isAlreadyApplied = YES;
    }else{
        self.isAlreadyApplied = NO;
    }
}

-(void)setIsPremiumJobStr:(NSString *)isPremiumJobStr{
    _isPremiumJobStr = isPremiumJobStr;
    if ([_isPremiumJobStr isEqualToString:@"1"] || [@"true" isEqualToString:_isPremiumJobStr.lowercaseString]) {
        self.isPremiumJob = YES;
    }else{
        self.isPremiumJob = NO;
    }
}

-(NSString *)getLogoUrl{
    NSString *url = @"";
    
    if (_TELogoURL && _TELogoURL.length>0) {
        url = _TELogoURL;
    }else if (_logoURL && _logoURL.length>0) {
        url = _logoURL;
    }
    
    return url;
}

@end

@implementation NGJobDetailModel

#pragma mark JSON Model Methods

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"TotalJobsCount": @"totoalJobsCount",
                                                       @"TotalVacanciesCount": @"totoalVacancyCount",
                                                       @"Clusters": @"clusters",
                                                       @"Jobs": @"jobList",
                                                       @"xz": @"xzMIS",
                                                       @"srchId": @"srchID_MIS"
                                                       }];
}

@end
