//
//  NGAppliedJobsParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGAppliedJobsParser.h"
#import "NGAppliedJobDetailModel.h"
@implementation NGAppliedJobsParser


-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSString *responseData = dataDict.responseData;
    NSDictionary *jobList = [responseData JSONValue];
    NSMutableDictionary *parsedJobs = [NSMutableDictionary dictionary];
    
    if (jobList.count > 0)
    {
        NSError* err = nil;
        NGAppliedJobDetailModel *objModel = [[NGAppliedJobDetailModel alloc]initWithDictionary:jobList error:&err];
        
        [parsedJobs setCustomObject:objModel forKey:KEY_JOBS_INFO];
        
    }
   dataDict.parsedResponseData = parsedJobs;
    return dataDict;
}


@end
