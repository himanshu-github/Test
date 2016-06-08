//
//  NGUnregApplyParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGUnregApplyParser.h"

@implementation NGUnregApplyParser
-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSMutableDictionary *jobsDict = [NSMutableDictionary dictionaryWithDictionary:[dataDict.responseData JSONValue]];
    
    if([[jobsDict  objectForKey:@"Type"] isEqualToString:@"Similar Jobs"])
    {
        NSArray* jobsArraytemp=[jobsDict objectForKey:@"Jobs"];
        [NGSavedData setTotalSimJobsCount:[NSString stringWithFormat:@"%lu",(unsigned long)jobsArraytemp.count]];
        NSMutableArray* simJobs = [NSMutableArray array];
        for (NSInteger i = 0; i < [jobsArraytemp count]; i++)
        {
            NGJobDetails* jobItem = [[NGJobDetails alloc] init];
            
            jobItem.jobID=[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"JobId"];
            if ([jobItem.jobID class] == [NSNull class])
                jobItem.jobID = @"";
            
            jobItem.jobDescription=[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"Description"];
            if ([jobItem.jobDescription class] == [NSNull class])
                jobItem.jobDescription = @"";
            
            jobItem.designation=[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"Designation"];
            if ([jobItem.designation class] == [NSNull class])
                jobItem.designation = @"";
            
            jobItem.jdURL=[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"JdURL"];
            if ([jobItem.jdURL class] == [NSNull class])
                jobItem.jdURL = @"";
            
            jobItem.location=[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"Location"];
            if ([jobItem.location class] == [NSNull class])
                jobItem.location = @"";
            
            jobItem.latestPostDate=[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"LatestPostedDate"];
            if ([jobItem.latestPostDate class] == [NSNull class])
                jobItem.latestPostDate = @"";
            
            
            
            jobItem.cmpnyID=[[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"Company"] valueForKey:@"Id"];
            if ([jobItem.cmpnyID class] == [NSNull class])
                jobItem.cmpnyID = @"";
            
            jobItem.cmpnyName=[[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"Company"] valueForKey:@"Name"];
            if ([jobItem.cmpnyName class] == [NSNull class])
                jobItem.cmpnyName = @"";
            
            jobItem.maxExp=[[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"Experience"] valueForKey:@"Max"];
            
            jobItem.minExp=[[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"Experience"] valueForKey:@"Min"];
            
            jobItem.vacancy=[[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"Vacancies"]integerValue];
            
            id isTopEmployer = [[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"IsTopEmployer"];
            
            if ([isTopEmployer class] == [NSNull class]) {
                jobItem.isTopEmployer = FALSE;
            }else{
                jobItem.isTopEmployer = [isTopEmployer boolValue];
            }
            
            id isFeaturedEmployer = [[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"IsFeaturedEmployer"];
            
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
            
            jobItem.isWebJob=[[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"IsWebJob"]boolValue];
            
            jobItem.isQuickWebJob=[[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"IsQuickWebJob"]boolValue];
            
            //Already applied
            jobItem.isAlreadyApplied=[[[[jobsArraytemp fetchObjectAtIndex:i] valueForKey:@"Job"] valueForKey:@"isApplied"]boolValue];
            
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
