//
//  NGErrorLoggingClient.m
//  Naukri
//
//  Created by Swati Kaushik on 13/02/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGErrorLoggingClient.h"
#import "NGErrorLoggingParser.h"
#import "APIRequestModal.h"
@implementation NGErrorLoggingClient
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
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_ERROR_LOGGING];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURLWithServiceType:K_BASE_URL_NEW_MONK];
    self.apiRequestObj.apiId = SERVICE_TYPE_ERROR_LOGGING;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;

    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGNewMonkErrorDataFormatter alloc]init];
    self.dataParserObj = [[NGErrorLoggingParser alloc]init];
    
    
}
-(void)customizeRequestParams:(NSMutableDictionary *)params
{
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    self.apiRequestObj.requestParameters = params;
}

@end
