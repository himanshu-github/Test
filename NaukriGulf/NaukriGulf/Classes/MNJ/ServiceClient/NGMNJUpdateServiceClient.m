//
//  NGMNJUpdateServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJUpdateServiceClient.h"
#import "NGMNJUpdateCVParser.h"

@implementation NGMNJUpdateServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_UPDATE_RESUME;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;

    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGMNJUpdateCVParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    params = [self setProfilePageDeeplinkingSourceInParam:params];
    
    self.apiRequestObj.requestParameters = params;
}

@end
