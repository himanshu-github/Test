//
//  NGCQServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCQServiceClient.h"

#import "NGCQParser.h"

@implementation NGCQServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_CUSTOM_QUESTION];
    self.apiRequestObj.apiId = SERVICE_TYPE_CUSTOM_QUESTION;
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGCQParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    [self customizeURLWithResourceParams:[params objectForKey:K_RESOURCE_PARAMS]];
   
}
-(void)customizeURLWithResourceParams:(NSMutableDictionary*)requestResourceParams
{
    if(requestResourceParams.allKeys.count>0)
    {
        NSString* apiUrl = self.apiRequestObj.apiUrl;
        apiUrl = [apiUrl stringByReplacingOccurrencesOfString:@"%@" withString:[requestResourceParams objectForKey:@"jobId"]];
        self.apiRequestObj.apiUrl = apiUrl;
        
        if([requestResourceParams objectForKey:KEY_IS_API_HIT_FROM_WATCH])
            self.apiRequestObj.isAPIHitFromiWatch = YES;
        else
            self.apiRequestObj.isAPIHitFromiWatch = NO;

    }
}



@end
