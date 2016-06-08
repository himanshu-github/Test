//
//  NGUserActiveStateClient.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 02/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGUserActiveStateClient.h"
#import "WebDataFormatter.h"
#import "NGUserActiveStateDataParser.h"

@implementation NGUserActiveStateClient

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
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_USER_ACTIVE_STATE];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_USER_ACTIVE_STATE;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = YES;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGUserActiveStateDataParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.requestParameters = params;
    self.apiRequestObj.authorisationHeaderNeeded = YES;
}

@end
