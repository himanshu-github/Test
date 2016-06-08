//
//  NGLoggedInApplyParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLoggedInApplyParser.h"

@implementation NGLoggedInApplyParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSMutableDictionary *jobsDict = [NSMutableDictionary dictionaryWithDictionary:[dataDict.responseData JSONValue]];
    
    NSString* totalSimJobsCount=[jobsDict  objectForKey:@"Type"];
    if([totalSimJobsCount isEqualToString:@"Similar Jobs"])
    {
        NSArray* jobsArraytemp=[jobsDict objectForKey:@"Jobs"];
        [NGSavedData setTotalSimJobsCount:[NSString stringWithFormat:@"%ld",(unsigned long)jobsArraytemp.count]];
        NSMutableArray* simJobs = [NSMutableArray array];
        for (int i = 0; i < [jobsArraytemp count]; i++)
        {
            NGJobDetails* jobItem = [[NGJobDetails alloc] init];
            NSDictionary* jobDict = [[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"];
            
            jobItem.jobID=[jobDict valueForKey:@"JobId"];
            if ([jobItem.jobID class] == [NSNull class])
                jobItem.jobID = @"";
            
            jobItem.jobDescription=[jobDict valueForKey:@"Description"];
            if ([jobItem.jobDescription class] == [NSNull class])
                jobItem.jobDescription = @"";
            
            jobItem.designation=[jobDict valueForKey:@"Designation"];
            if ([jobItem.designation class] == [NSNull class])
                jobItem.designation = @"";
            
            jobItem.jdURL=[jobDict valueForKey:@"JdURL"];
            if ([jobItem.jdURL class] == [NSNull class])
                jobItem.jdURL = @"";
            
            jobItem.location=[jobDict valueForKey:@"Location"];
            if ([jobItem.location class] == [NSNull class])
                jobItem.location = @"";
            
            jobItem.latestPostDate=[jobDict valueForKey:@"LatestPostedDate"];
            if ([jobItem.latestPostDate class] == [NSNull class])
                jobItem.latestPostDate = @"";
            
            
            
            jobItem.cmpnyID=[[jobDict valueForKey:@"Company"] valueForKey:@"Id"];
            if ([jobItem.cmpnyID class] == [NSNull class])
                jobItem.cmpnyID = @"";
            
            jobItem.cmpnyName=[[jobDict valueForKey:@"Company"] valueForKey:@"Name"];
            if ([jobItem.cmpnyName class] == [NSNull class])
                jobItem.cmpnyName = @"";
            
            jobItem.maxExp=[[jobDict valueForKey:@"Experience"] valueForKey:@"Max"];
            
            jobItem.minExp=[[jobDict valueForKey:@"Experience"] valueForKey:@"Min"];
            
            jobItem.vacancy=[[jobDict valueForKey:@"Vacancies"]integerValue];
            
            id isTopEmployer = [jobDict valueForKey:@"IsTopEmployer"];
            
            if ([isTopEmployer class] == [NSNull class]) {
                jobItem.isTopEmployer = FALSE;
            }else{
                jobItem.isTopEmployer = [isTopEmployer boolValue];
            }
            
            id isFeaturedEmployer = [jobDict valueForKey:@"IsFeaturedEmployer"];
            
            if ([isFeaturedEmployer class] == [NSNull class]) {
                jobItem.isFeaturedEmployer = FALSE;
            }else{
                jobItem.isFeaturedEmployer = [isFeaturedEmployer boolValue];
            }
            
            id isPremiumJob = [[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"IsPremiumJob"];
            
            if ([isPremiumJob class] == [NSNull class]) {
                jobItem.isPremiumJob = FALSE;
            }else{
                jobItem.isPremiumJob = [isFeaturedEmployer boolValue];
            }
            
            jobItem.isWebJob=[[jobDict valueForKey:@"IsWebJob"]boolValue];
            
            jobItem.isQuickWebJob=[[jobDict valueForKey:@"IsQuickWebJob"]boolValue];
            
            //Already applied
            jobItem.isAlreadyApplied=[[jobDict valueForKey:@"isApplied"]boolValue];
            
            
            if ([NGDecisionUtility isJobReadWithID:jobItem.jobID]) {
                jobItem.isAlreadyRead = YES;
            }else{
                jobItem.isAlreadyRead = NO;
            }
            
            [simJobs addObject:jobItem];
            
        }
        [jobsDict setCustomObject:simJobs forKey:@"Sim Jobs"];
    }
 
    dataDict.parsedResponseData = jobsDict;
    return dataDict;
}


@end
