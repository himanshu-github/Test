//
//  NGAllJobsServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGAllJobsServiceClient.h"

#import "NGAllJobsParser.h"

@implementation NGAllJobsServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_ALL_JOBS];
    self.apiRequestObj.apiId = SERVICE_TYPE_ALL_JOBS;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGAllJobsParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.authorisationHeaderNeeded = YES;
 
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSInteger exp = [[params objectForKey:@"Experience"]integerValue];
    if (exp<0 || exp==Const_Any_Exp_Tag) {
        [finalParams setCustomObject:@"" forKey:@"Experience"];
    }
    
    self.apiRequestObj.requestParameters = finalParams;
}

@end
