//
//  NGRecommendedJobParser.m
//  NaukriGulf
//
//  Created by bazinga on 13/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGRecommendedJobParser.h"
#import "NGRecommendedJobDetailModel.h"

@implementation NGRecommendedJobParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSString *responseData = dataDict.responseData;
    
    
    NSDictionary *jobList = [responseData JSONValue];
    NSMutableDictionary *parsedJobs = [NSMutableDictionary dictionary];
    
    if (jobList.count > 0)
    {
        NSError* err = nil;
        NGRecommendedJobDetailModel *objModel = [[NGRecommendedJobDetailModel alloc]initWithDictionary:jobList error:&err];
        
        [parsedJobs setCustomObject:objModel forKey:KEY_JOBS_INFO];
        
    }
    dataDict.parsedResponseData = parsedJobs;
    return dataDict;
}

@end
