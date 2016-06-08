//
//  NGRecommendedJobsServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGRecommendedJobsServiceClient.h"
#import "NGRecommendedJobParser.h"

@implementation NGRecommendedJobsServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_RECOMMENDED_JOBS];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.apiId = SERVICE_TYPE_RECOMMENDED_JOBS;
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGRecommendedJobParser alloc]init];
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    self.apiRequestObj.requestParameters = params;
    
    if([params objectForKey:KEY_IS_API_HIT_FROM_WATCH])
        self.apiRequestObj.isAPIHitFromiWatch = YES;
    else
        self.apiRequestObj.isAPIHitFromiWatch = NO;

}



@end
