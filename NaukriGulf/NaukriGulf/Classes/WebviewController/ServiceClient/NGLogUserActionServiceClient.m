//
//  NGLogUserActionServiceClient.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 01/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGLogUserActionServiceClient.h"
#import "WebDataFormatter.h"
#import "NGLogUserActionDataParser.h"

@implementation NGLogUserActionServiceClient

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_LOG_USER_ACTION];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_LOG_USER_ACTION;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = YES;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGLogUserActionDataParser alloc]init];
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    params = [self setJDPageDeeplinkingSourceInParam:params];
    
    self.apiRequestObj.requestParameters = params;
}

@end
