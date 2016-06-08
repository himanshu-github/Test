//
//  NGSimJobsServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 20/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSimJobsServiceClient.h"
#import "NGSimJobsParser.h"
#import "NGAllJobsParser.h"

@implementation NGSimJobsServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_SIM_JOBS_PAGINATION];
    self.apiRequestObj.apiId = SERVICE_TYPE_SIM_JOBS_PAGINATION;
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];

    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGSimJobsParser alloc]init];

    
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    [self customizeURLWithResourceParams:[params objectForKey:K_RESOURCE_PARAMS]];
    self.apiRequestObj.requestParameters = [params objectForKey:K_ATTRIBUTE_PARAMS];
    
    
    
}


-(void)customizeURLWithResourceParams:(NSMutableDictionary*)requestResourceParams
{
    if(requestResourceParams.allKeys.count>0)
    {
        
        NSString* apiUrl = self.apiRequestObj.apiUrl;
        apiUrl = [apiUrl stringByReplacingOccurrencesOfString:@"%@" withString:[requestResourceParams objectForKey:@"jobId"]];
        self.apiRequestObj.apiUrl = apiUrl;
    }
}
@end
