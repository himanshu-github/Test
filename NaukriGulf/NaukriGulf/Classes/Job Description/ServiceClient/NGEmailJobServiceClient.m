//
//  NGEmailJobServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEmailJobServiceClient.h"

#import "NGEmailJobParser.h"

@implementation NGEmailJobServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_EMAIL_JOB];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.apiId = SERVICE_TYPE_EMAIL_JOB;
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGEmailJobParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
   
    params = [self setJDPageDeeplinkingSourceInParam:params];
    [self customizeURLWithResourceParams:params];
    self.apiRequestObj.requestParameters = params;
}

-(void)customizeURLWithResourceParams:(NSMutableDictionary*)requestResourceParams
{
    if(requestResourceParams.allKeys.count>0)
    {
        NSString* url = self.apiRequestObj.apiUrl;
        
        url = [url stringByReplacingOccurrencesOfString:@"%@" withString:[requestResourceParams objectForKey:@"jobId"]];
        self.apiRequestObj.apiUrl = url;
        
    }
}


@end
