//
//  NGAppliedJobsServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGAppliedJobsServiceClient.h"

#import "NGAppliedJobsParser.h"

@implementation NGAppliedJobsServiceClient

-(id)init{
    if (self==[super init]) {
        [self initialize];
    }
    
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_APPLIED_JOBS];
    self.apiRequestObj.apiId = SERVICE_TYPE_APPLIED_JOBS;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGAppliedJobsParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{

    self.apiRequestObj.authorisationHeaderNeeded = YES;
    self.apiRequestObj.requestParameters = params;
}



@end
