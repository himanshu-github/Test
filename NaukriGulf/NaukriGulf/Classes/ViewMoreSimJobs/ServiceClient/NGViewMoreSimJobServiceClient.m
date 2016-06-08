//
//  NGViewMoreSimJobServiceClient.m
//  NaukriGulf
//
//  Created by Himanshu on 10/1/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGViewMoreSimJobServiceClient.h"
#import "NGViewMoreSimJobParserClient.h"

@implementation NGViewMoreSimJobServiceClient

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
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGViewMoreSimJobParserClient alloc]init];
    
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

