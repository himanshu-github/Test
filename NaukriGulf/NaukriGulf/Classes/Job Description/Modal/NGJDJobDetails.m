//
//  NGJDJobDetails.m
//  NaukriGulf
//
//  Created by Arun Kumar on 06/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJDJobDetails.h"

@implementation NGJDJobDetails

#pragma mark JSON Model Methods

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                    @"DesiredCandidate.Experience.MaxExperience": @"maxExp",
                                                    @"Contact.Website": @"contactWebsite",
                                                    @"DesiredCandidate.Nationality": @"nationality",
                                                    @"DesiredCandidate.Profile": @"dcProfile",
                                                    @"Compensation.MinCtc": @"minCtc",
                                                    @"Basic.Company.Id": @"companyId",
                                                    @"Other.IsApplied": @"isAlreadyApplied",
                                                    @"Contact.Email": @"contactEmail",
                                                    @"DesiredCandidate.Education": @"education",
                                                    @"Compensation.MaxCtc": @"maxCtc",
                                                    @"Designation": @"designation",
                                                    @"Contact.IsEmailHidden": @"isEmailHiddden",
                                                    @"Compensation.IsCtcHidden": @"isCtcHidden",
                                                    @"Contact.Designation": @"contactDesignation",
                                                    @"Other.IsWebJob": @"isWebjob",
                                                    @"DesiredCandidate.Category": @"category",
                                                    @"Company.Name": @"companyName",
                                                    @"IndustryType": @"industryType",
                                                    @"Location": @"location",
                                                    @"Other.Keywords": @"keywords",
                                                    @"Other.IsArchived": @"isArchivedjob",
                                                    @"JobId": @"jobId",
                                                    @"Company.Profile": @"companyProfile",
                                                    @"Compensation.Vacancies": @"vacancies",
                                                    @"FunctionalArea": @"functionalArea",
                                                    @"Other.IsQuickWebJob": @"isQuickWebjobStr",
                                                    @"Compensation.OtherBenefits": @"otherBenefits",
                                                    @"Compensation.LatestPostedDate": @"latestPostedDate",
                                                    @"Compensation.Country": @"country",
                                                    @"Description": @"jobDescription",
                                                    @"DesiredCandidate.Gender": @"gender",
                                                    @"Contact.Name": @"contactName",
                                                    @"Contact.Landline": @"landline",
                                                    @"Contact.Mobile": @"mobile",
                                                    @"DesiredCandidate.Experience.MinExperience": @"minExp",
                                                    @"LogoUrl":@"logoURL",
                                                    @"Other.ShowLogo":@"showLogo",
                                                    @"JdURL":@"jdURL",
                                                    @"TELogoUrl": @"TELogoURL",
                                                    @"Other.IsPremium": @"isPremiumJobStr",
                                                    @"Other.IsTopEmployer": @"isTopEmployerStr",
                                                    @"Other.IsTopEmployerLite": @"isTopEmployerLiteStr",
                                                    @"Other.IsFeaturedEmployer": @"isFeaturedEmployerStr",
                                                    @"Other.jobRedirection":@"isJobRedirection",
                                                    @"Other.Tag":@"jobRedirectionUrl"
                                                       }];
}


#pragma mark Setter Methods

-(void)setIsEmailHiddden:(NSString *)isEmailHiddden{
    _isEmailHiddden = isEmailHiddden;
    if ([isEmailHiddden class] == [NSNull class]) {
        _isEmailHiddden = @"";
    }
}

-(void)setContactWebsite:(NSString *)contactWebsite{
    _contactWebsite = contactWebsite;
    if ([contactWebsite class] == [NSNull class]) {
        _contactWebsite = @"";
    }
}

-(void)setContactEmail:(NSString *)contactEmail{
    _contactEmail = contactEmail;
    if ([contactEmail class] == [NSNull class]) {
        _contactEmail = @"";
    }
}

-(void)setContactDesignation:(NSString *)contactDesignation{
    _contactDesignation = contactDesignation;
    if ([contactDesignation class] == [NSNull class]) {
        _contactDesignation = @"";
    }
}

-(void)setContactName:(NSString *)contactName{
    _contactName = contactName;
    if ([contactName class] == [NSNull class]) {
        _contactName = @"";
    }
}

-(void)setCategory:(NSString *)category{
    _category = category;
    if ([category class] == [NSNull class]) {
        _category = @"";
    }
}

-(void)setGender:(NSString *)gender{
    _gender = gender;
    if ([gender class] == [NSNull class]) {
        _gender = @"";
    }
}

-(void)setNationality:(NSString *)nationality{
    _nationality = nationality;
    if ([nationality class] == [NSNull class]) {
        _nationality = @"";
    }
}

-(void)setEducation:(NSString *)education{
    _education = education;
    if ([education class] == [NSNull class]) {
        _education = @"";
    }
}

-(void)setDcProfile:(NSString *)dcProfile{
    _dcProfile = dcProfile;
    
    if ([dcProfile class] == [NSNull class]) {
        _dcProfile = @"";
    }else{
        _dcProfile = [NSString stripHTMLTagWithItsValue:dcProfile];
    }
    
    if (self.dcProfile.length > LABEL_CHAR_LIMIT) {
        self.shortDcProfile = [NSString stringWithFormat:@"%@... Read More \u25BE", [self.dcProfile substringWithRange:NSMakeRange(0, LABEL_CHAR_LIMIT)]];
    }
    else{
        self.shortDcProfile = self.dcProfile;
    }
}

-(void)setIsPremium:(NSString *)isPremium{
    _isPremium = isPremium;
    if ([isPremium class] == [NSNull class]) {
        _isPremium = @"";
    }
}

-(void)setIsAlreadyApplied:(NSString *)isAlreadyApplied{
    _isAlreadyApplied = isAlreadyApplied;
    if ([isAlreadyApplied class] == [NSNull class]) {
        _isAlreadyApplied = @"";
    }
}
-(BOOL)isAlreadyAppliedAsBool{
    if ([@"1" isEqualToString:_isAlreadyApplied] || [@"true" isEqualToString:_isAlreadyApplied.lowercaseString]) {
        return YES;
    }
    return NO;
}
-(void)setIsArchivedjob:(NSString *)isArchivedjob{
    _isArchivedjob = isArchivedjob;
    if ([isArchivedjob class] == [NSNull class]) {
        _isArchivedjob = @"";
    }
}

-(void)setIsWebjob:(NSString *)isWebjob{
    _isWebjob = isWebjob;
    if ([isWebjob class] == [NSNull class]) {
        _isWebjob = @"";
    }
}
-(BOOL)isWebjobAsBool{
    if ([@"1" isEqualToString:_isWebjob] || [@"true" isEqualToString:_isWebjob.lowercaseString]) {
        return YES;
    }
    return NO;
}

-(void)setLatestPostedDate:(NSString *)latestPostedDate{
    _latestPostedDate = latestPostedDate;
    
    if ([_latestPostedDate class] == [NSNull class]) {
        _latestPostedDate = @"";
        _formattedLatestPostedDate = @"";
    }else{
        _formattedLatestPostedDate = [NSString convertTimestampToDate:latestPostedDate];
        
        if ([_formattedLatestPostedDate class] == [NSNull class]) {
            _formattedLatestPostedDate = @"";
        }
    }
}

-(void)setOtherBenefits:(NSString *)otherBenefits{
    _otherBenefits = otherBenefits;
    if ([otherBenefits class] == [NSNull class]) {
        _otherBenefits = @"";
    }
}

-(void)setIsCtcHidden:(NSString *)isCtcHidden{
    _isCtcHidden = isCtcHidden;
    if ([isCtcHidden class] == [NSNull class]) {
        _isCtcHidden = @"";
    }
}

-(void)setMinCtc:(NSString *)minCtc{
    _minCtc = minCtc;
    if ([minCtc class] == [NSNull class]) {
        _minCtc = @"";
    }
}

-(void)setMaxCtc:(NSString *)maxCtc{
    _maxCtc = maxCtc;
    if ([maxCtc class] == [NSNull class]) {
        _maxCtc = @"";
    }
}

-(void)setCompanyName:(NSString *)companyName{
    _companyName = companyName;
    if ([companyName class] == [NSNull class]) {
        _companyName = @"";
    }
}

-(void)setCompanyProfile:(NSString *)companyProfile{
    if ([companyProfile class] == [NSNull class]) {
        _companyProfile = @"";
    }else{
        _companyProfile = [NSString stripHTMLTagWithItsValue:companyProfile];
    }
    
    if (self.companyProfile.length > LABEL_CHAR_LIMIT) {
        self.shortCompanyProfile = [NSString stringWithFormat:@"%@... Read More \u25BE", [self.companyProfile substringWithRange:NSMakeRange(0, LABEL_CHAR_LIMIT)]];
    }
    else{
        self.shortCompanyProfile = self.companyProfile;
    }
}

-(void)setCompanyId:(NSString *)companyId{
    _companyId = companyId;
    if ([companyId class] == [NSNull class]) {
        _companyId = @"";
    }
}

-(void)setFunctionalArea:(NSString *)functionalArea{
    _functionalArea = functionalArea;
    if ([functionalArea class] == [NSNull class]) {
        _functionalArea = @"";
    }
}

-(void)setLocation:(NSString *)location{
    _location = location;
    if ([location class] == [NSNull class]) {
        _location = @"";
    }
}

-(void)setKeywords:(NSString *)keywords{
    
    
    _keywords = [keywords stringByReplacingOccurrencesOfString:@"\r\n" withString:@", "];
    
    
    if ([keywords class] == [NSNull class]) {
        _keywords = @"";
    }
}

-(void)setJobDescription:(NSString *)jobDescription{
    if ([jobDescription class] == [NSNull class]) {
        _jobDescription = @"";
    }else{
        _jobDescription = [NSString stripHTMLTagWithItsValue:jobDescription];
    }
    
    if (self.jobDescription.length > LABEL_CHAR_LIMIT) {
        self.shortJobDescription = [NSString stringWithFormat:@"%@... Read More \u25BE", [self.jobDescription substringWithRange:NSMakeRange(0, LABEL_CHAR_LIMIT)]];
    }
    else{
        self.shortJobDescription = self.jobDescription;
    }
}

-(void)setDesignation:(NSString *)designation{
    _designation = designation;
    if ([designation class] == [NSNull class]) {
        _designation = @"";
    }
}

-(void)setJobId:(NSString *)jobId{
    _jobId = jobId;
    if ([jobId class] == [NSNull class]) {
        _jobId = @"";
    }
}

-(void)setIndustryType:(NSString *)industryType{
    _industryType = industryType;
    if ([industryType class] == [NSNull class]) {
        _industryType = @"";
    }
}

-(void)setLogoURL:(NSString *)logoURL{
    _logoURL = logoURL;
    
    if (_logoURL && _logoURL.length>0) {
        _logoURL = [_logoURL stringByAppendingString:@"&source=mjd"];
    }
    
}
-(void)setJdURL:(NSString *)paramJdURL{
    _jdURL = paramJdURL;
    if ([paramJdURL class] == [NSNull class]) {
        _jdURL = @"";
    }
}

-(void)setTELogoURL:(NSString *)TELogoURLParam{
    _TELogoURL = TELogoURLParam;
    
    if (_TELogoURL && _TELogoURL.length>0) {
        _TELogoURL = [_TELogoURL stringByAppendingString:@"&source=mjd"];
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

-(void)setIsPremiumJobStr:(NSString *)isPremiumJobStrParam{
    _isPremiumJobStr = isPremiumJobStrParam;
    if ([@"1" isEqualToString:_isPremiumJobStr] || [@"true" isEqualToString:_isPremiumJobStr.lowercaseString]) {
        self.isPremiumJob = YES;
    }else{
        self.isPremiumJob = NO;
    }
}
-(void)setIsTopEmployerStr:(NSString *)isTopEmployerStrParam{
    _isTopEmployerStr = isTopEmployerStrParam;
    if ([@"1" isEqualToString:_isTopEmployerStr] || [@"true" isEqualToString:_isTopEmployerStr.lowercaseString]) {
        self.isTopEmployer = YES;
    }else{
        self.isTopEmployer = NO;
    }
}

-(void)setIsTopEmployerLiteStr:(NSString *)isTopEmployerLiteStrParam{
    _isTopEmployerLiteStr = isTopEmployerLiteStrParam;
    if ([@"1" isEqualToString:_isTopEmployerLiteStr] || [@"true" isEqualToString:_isTopEmployerLiteStr.lowercaseString]) {
        self.isTopEmployerLite = YES;
    }else{
        self.isTopEmployerLite = NO;
    }
}

-(void)setIsFeaturedEmployerStr:(NSString *)isFeaturedEmployerStrParam{
    _isFeaturedEmployerStr = isFeaturedEmployerStrParam;
    if ([@"1" isEqualToString:_isFeaturedEmployerStr] || [@"true" isEqualToString:_isFeaturedEmployerStr.lowercaseString]) {
        self.isFeaturedEmployer = YES;
    }else{
        self.isFeaturedEmployer = NO;
    }
}

-(void)setIsQuickWebjobStr:(NSString *)isQuickWebjobStrParam{
    _isQuickWebjob = isQuickWebjobStrParam;
    if ([@"1" isEqualToString:_isQuickWebjob] || [@"true" isEqualToString:_isQuickWebjob.lowercaseString]) {
        self.isQuickWebjobAsBool = YES;
    }else{
        self.isQuickWebjobAsBool = NO;
    }
}

#pragma mark Getter Methods

-(NSString *)formattedExperience{
    if ([self.minExp isEqualToString:self.maxExp]) {
        self.formattedExperience = [NSString stringWithFormat:@"%@ Years",self.maxExp];
    }else{
        self.formattedExperience = [NGDecisionUtility isValidString:self.minExp]?[NSString stringWithFormat:@"%@ - %@ Years",self.minExp,self.maxExp]:[NSString stringWithFormat:@"%@ Years",self.maxExp];
    }
    
    return _formattedExperience;
}

-(NSString *)formattedSalary{
    self.formattedSalary = [NSString stringWithFormat:@"%@ - %@",self.minCtc,self.maxCtc];
    if (self.minCtc.length==0 && self.maxCtc.length==0)
    {
        self.formattedSalary = K_NOT_MENTIONED;
        
    }
    
    return _formattedSalary;
}

-(NSString *)formattedVacancies{
    NSString *positionStr = self.vacancies>1?@"Vacancies":@"Vacancy";
    
    self.formattedVacancies = [NSString stringWithFormat:@"%ld %@",(long)self.vacancies,positionStr];
    
    return _formattedVacancies;
}

-(NSString *)formattedContactNameDes{
    NSString *name = self.contactName;
    NSString *cDesignation = self.contactDesignation;
    
    if ([cDesignation isEqualToString:@""] && ![name isEqualToString:@""])
    {
        self.formattedContactNameDes = [NSString stringWithFormat:@"%@",name];
    }
    else if ([name isEqualToString:@""] && ![cDesignation isEqualToString:@""])
    {
        self.formattedContactNameDes = [NSString stringWithFormat:@"%@",cDesignation];
    }
    else if (![name isEqualToString:@""] && ![cDesignation isEqualToString:@""])
    {
        self.formattedContactNameDes = K_NOT_MENTIONED;
    }
    else if ([name isEqualToString:@""] && [cDesignation isEqualToString:@""])
    {
        self.formattedContactNameDes = @"";
    }
    else
    {
        self.formattedContactNameDes = [NSString stringWithFormat:@"%@ - %@",name,cDesignation];
    }
    
    return _formattedContactNameDes;
}



@end
