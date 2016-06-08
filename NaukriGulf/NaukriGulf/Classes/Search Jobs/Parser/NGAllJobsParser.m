//
//  NGAllJobsParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGAllJobsParser.h"

@implementation NGAllJobsParser


-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSString *responseData = dataDict.responseData;
    
    
    NSDictionary *jobList = [responseData JSONValue];
    NSMutableDictionary *parsedJobs = [NSMutableDictionary dictionary];
    
    if (jobList.count > 0)
    {
        NSError* err = nil;
        NGJobDetailModel *objModel = [[NGJobDetailModel alloc]initWithDictionary:jobList error:&err];
        
        [parsedJobs setCustomObject:objModel forKey:KEY_JOBS_INFO];
        
    }
      dataDict.parsedResponseData = parsedJobs;
    return dataDict;
}


@end
