//
//  NGSettingsClient.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGSettingsClient.h"
#import "NGSettingsParser.h"

@implementation NGSettingsClient

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
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_SETTINGS];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_SETTINGS;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGSettingsParser alloc]init];
    if([NGHelper sharedInstance].isUserLoggedIn) {
        
        self.apiRequestObj.authorisationHeaderNeeded = TRUE;
        
    }
    
}


-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.requestParameters = params;
}
@end
