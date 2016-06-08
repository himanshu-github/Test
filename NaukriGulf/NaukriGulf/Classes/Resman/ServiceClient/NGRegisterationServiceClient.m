//
//  NGRegisterationServiceClient.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/27/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGRegisterationServiceClient.h"

#import "NGRegistrationParser.h"

@implementation NGRegisterationServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_USER_REGISTERATION];
    
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURLWithServiceType:K_BASE_URL_JOB_SEARCH];
    
    self.apiRequestObj.apiId = SERVICE_TYPE_USER_REGISTERATION;
        
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    
    self.dataParserObj = [[NGRegistrationParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = NO;
    self.apiRequestObj.requestParameters = params;

}

@end
