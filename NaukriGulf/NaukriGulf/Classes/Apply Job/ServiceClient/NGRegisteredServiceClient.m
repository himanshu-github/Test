//
//  NGRegisteredServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 27/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGRegisteredServiceClient.h"
#import "NGRegisteredEmailParser.h"

@implementation NGRegisteredServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_CHECK_REGISTERED_USER];
    self.apiRequestObj.apiId = SERVICE_TYPE_CHECK_REGISTERED_USER;
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGRegisteredEmailParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.requestParameters = params;
}

@end
