//
//  NGJDServiceClient.m
//  NaukriGulf
//
//  Created by bazinga on 03/06/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGJDServiceClient.h"

#import "NGJDParser.h"

@implementation NGJDServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_JD];
    self.apiRequestObj.apiId = SERVICE_TYPE_JD;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGJDParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    [self customizeURLWithResourceParams:[params objectForKey:K_RESOURCE_PARAMS]];
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    [params setCustomObject:[self setJDPageDeeplinkingSourceInParam:[params objectForKey:K_ATTRIBUTE_PARAMS]] forKey:K_ATTRIBUTE_PARAMS];

    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:[params objectForKey:K_ATTRIBUTE_PARAMS]];
    
    
    self.apiRequestObj.requestParameters = finalParams;
}

-(void)customizeURLWithResourceParams:(NSMutableDictionary*)requestResourceParams
{
    
    
    if(requestResourceParams.allKeys.count>0)
    {
        NSString* url = self.apiRequestObj.apiUrl;
    
        url = [url stringByReplacingOccurrencesOfString:@"%@" withString:[requestResourceParams objectForKey:@"jobId"]];
        self.apiRequestObj.apiUrl = url;
        
    }
    if([requestResourceParams objectForKey:KEY_IS_API_HIT_FROM_WATCH])
        self.apiRequestObj.isAPIHitFromiWatch = YES;
    else
        self.apiRequestObj.isAPIHitFromiWatch = NO;
    

}

@end
