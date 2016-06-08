//
//  NGJDParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJDParser.h"



@implementation NGJDParser

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    
    NSDictionary *jobDetail = [responseData JSONValue];
    
    NGJDJobDetails *jobObj = [[NGJDJobDetails alloc]init];
    
    if ([jobDetail objectForKey:@"root"]){
        jobDetail = [[jobDetail objectForKey:@"root"] valueForKey:@"Job"];
        
        jobObj.jobId = [[jobDetail valueForKey:@"Basic"] valueForKey:@"JobId"];
        if ([jobObj.jobId class] == [NSNull class]) {
            jobObj.jobId = @"";
        }
        
        jobObj.industryType = [[jobDetail valueForKey:@"Basic"] valueForKey:@"IndustryType"];
        if ([jobObj.industryType class] == [NSNull class]) {
            jobObj.industryType = @"";
        }
        
        jobObj.functionalArea = [[jobDetail valueForKey:@"Basic"] valueForKey:@"FunctionalArea"];
        if ([jobObj.functionalArea class] == [NSNull class]) {
            jobObj.functionalArea = @"";
        }
        
        jobObj.location = [[jobDetail valueForKey:@"Basic"] valueForKey:@"Location"];
        if ([jobObj.location class] == [NSNull class]) {
            jobObj.location = @"";
        }
        
        jobObj.jobDescription = [[jobDetail valueForKey:@"Basic"] valueForKey:@"Description"];
        if ([jobObj.jobDescription class] == [NSNull class]) {
            jobObj.jobDescription = @"";
        }
        
        jobObj.designation = [[jobDetail valueForKey:@"Basic"] valueForKey:@"Designation"];
        if ([jobObj.designation class] == [NSNull class]) {
            jobObj.designation = @"";
        }
        
        jobObj.companyId = [[[jobDetail valueForKey:@"Basic"] valueForKey:@"Company"] valueForKey:@"Id"];
        if ([jobObj.companyId class] == [NSNull class]) {
            jobObj.companyId = @"";
        }
        jobObj.companyName = [[[jobDetail valueForKey:@"Basic"] valueForKey:@"Company"] valueForKey:@"Name"];
        if ([jobObj.companyName class] == [NSNull class]) {
            jobObj.companyName = @"";
        }
        
        jobObj.companyProfile = [[[jobDetail valueForKey:@"Basic"] valueForKey:@"Company"] valueForKey:@"Profile"];
        if ([jobObj.companyProfile class] == [NSNull class]) {
            jobObj.companyProfile = @"";
        }
        
        jobObj.minCtc = [[[jobDetail valueForKey:@"Basic"] valueForKey:@"Compensation"] valueForKey:@"MinCtc"];
        if ([jobObj.minCtc class] == [NSNull class]) {
            jobObj.minCtc = @"";
        }
        
        jobObj.maxCtc = [[[jobDetail valueForKey:@"Basic"] valueForKey:@"Compensation"] valueForKey:@"MaxCtc"];
        if ([jobObj.maxCtc class] == [NSNull class]) {
            jobObj.maxCtc = @"";
        }
        
        jobObj.isCtcHidden = [[[jobDetail valueForKey:@"Basic"] valueForKey:@"Compensation"] valueForKey:@"IsCtcHidden"];
        if ([jobObj.isCtcHidden class] == [NSNull class]) {
            jobObj.isCtcHidden = @"";
        }
        
        jobObj.otherBenefits = [[[jobDetail valueForKey:@"Basic"] valueForKey:@"Compensation"] valueForKey:@"OtherBenefits"];
        if ([jobObj.otherBenefits class] == [NSNull class]) {
            jobObj.otherBenefits = @"";
        }
        
       
        if([[[[jobDetail valueForKey:@"Basic"] valueForKey:@"Compensation"] valueForKey:@"Vacancies"] class]!=[NSNull class])
        jobObj.vacancies = [[[[jobDetail valueForKey:@"Basic"] valueForKey:@"Compensation"] valueForKey:@"Vacancies"]integerValue];
        
        
        jobObj.latestPostedDate = [[[jobDetail valueForKey:@"Basic"] valueForKey:@"Compensation"] valueForKey:@"LatestPostedDate"];
        jobObj.latestPostedDate = [NSString convertTimestampToDate:jobObj.latestPostedDate];
        
        
        if ([jobObj.latestPostedDate class] == [NSNull class]) {
            jobObj.latestPostedDate = @"";
        }
        
        jobObj.isWebjob = [[jobDetail valueForKey:@"Other"] valueForKey:@"IsWebJob"];
        if ([jobObj.isWebjob class] == [NSNull class]) {
            jobObj.isWebjob = @"";
        }
        
        
        
        jobObj.isAlreadyApplied = [[jobDetail valueForKey:@"Other"] valueForKey:@"IsApplied"];
        if ([jobObj.isAlreadyApplied class] == [NSNull class]) {
            jobObj.isAlreadyApplied = @"";
        }
        
        jobObj.isQuickWebjob = [[jobDetail valueForKey:@"Other"] valueForKey:@"IsQuickWebJob"];
        
        jobObj.isPremium = [[jobDetail valueForKey:@"Other"] valueForKey:@"IsPremium"];
        if ([jobObj.isPremium class] == [NSNull class]) {
            jobObj.isPremium = @"";
        }
        
        jobObj.dcProfile = [[jobDetail valueForKey:@"DesiredCandidate"] valueForKey:@"Profile"];
        if ([jobObj.dcProfile class] == [NSNull class]) {
            jobObj.dcProfile = @"";
        }
        
        jobObj.minExp = [[[jobDetail valueForKey:@"DesiredCandidate"] valueForKey:@"Experience"] valueForKey:@"MinExperience"];
        
        jobObj.maxExp = [[[jobDetail valueForKey:@"DesiredCandidate"] valueForKey:@"Experience"] valueForKey:@"MaxExperience"];
        
        jobObj.education = [[jobDetail valueForKey:@"DesiredCandidate"] valueForKey:@"Education"];
        if ([jobObj.education class] == [NSNull class]) {
            jobObj.education = @"";
        }
        
        jobObj.nationality = [[jobDetail valueForKey:@"DesiredCandidate"] valueForKey:@"Nationality"];
        if ([jobObj.nationality class] == [NSNull class]) {
            jobObj.nationality = @"";
        }
        
        jobObj.gender = [[jobDetail valueForKey:@"DesiredCandidate"] valueForKey:@"Gender"];
        if ([jobObj.gender class] == [NSNull class]) {
            jobObj.gender = @"";
        }
        
        jobObj.category = [[jobDetail valueForKey:@"DesiredCandidate"] valueForKey:@"category"];
        if ([jobObj.category class] == [NSNull class]) {
            jobObj.category = @"";
        }
        
        jobObj.contactName = [[jobDetail valueForKey:@"Contact"] valueForKey:@"Name"];
        if ([jobObj.contactName class] == [NSNull class]) {
            jobObj.contactName = @"";
        }
        
        jobObj.contactDesignation = [[jobDetail valueForKey:@"Contact"] valueForKey:@"Designation"];
        if ([jobObj.contactDesignation class] == [NSNull class]) {
            jobObj.contactDesignation = @"";
        }
        
        jobObj.contactEmail = [[jobDetail valueForKey:@"Contact"] valueForKey:@"Email"];
        if ([jobObj.contactEmail class] == [NSNull class]) {
            jobObj.contactEmail = @"";
        }
        
        jobObj.contactWebsite = [[jobDetail valueForKey:@"Contact"] valueForKey:@"Website"];
        if ([jobObj.contactWebsite class] == [NSNull class]) {
            jobObj.contactWebsite = @"";
        }
        
        jobObj.isEmailHiddden = [[jobDetail valueForKey:@"Contact"] valueForKey:@"IsEmailHidden"];
        if ([jobObj.isEmailHiddden class] == [NSNull class]) {
            jobObj.isEmailHiddden = @"";
        }
        
        jobObj.isJobRedirection = [[jobDetail valueForKey:@"Other"] valueForKey:@"jobRedirection"];
        if ([jobObj.isJobRedirection class] == [NSNull class]) {
            jobObj.isJobRedirection = @"";
        }
        
        jobObj.jobRedirectionUrl = [[jobDetail valueForKey:@"Other"] valueForKey:@"Tag"];
        if ([jobObj.jobRedirectionUrl class] == [NSNull class]) {
            jobObj.jobRedirectionUrl = @"";
        }
   
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:jobObj,KEY_JD, nil];
}

-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSString *responseData = dataDict.responseData;
    
    
    NSDictionary *jobDetail = [responseData JSONValue];
    
    
    if (jobDetail && ![jobDetail objectForKey:@"error"]){
        NSError* err = nil;
        NGJDJobDetails *objModel = [[NGJDJobDetails alloc]initWithDictionary:[jobDetail objectForKey:@"Job"]  error:&err];
        
        dataDict.parsedResponseData = objModel;
        
        NGStaticContentManager *dataFetcher = [DataManagerFactory getStaticContentManager ];
        [dataFetcher storeViewedJobToLocal:objModel];
    }
    
    return dataDict;
}




@end
