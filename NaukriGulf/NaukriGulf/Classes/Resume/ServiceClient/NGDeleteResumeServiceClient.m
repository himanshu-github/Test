//
//  NGDeleteResumeServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGDeleteResumeServiceClient.h"
#import "NGDeleteResumeParser.h"

@implementation NGDeleteResumeServiceClient

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
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_DELETE;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGDeleteResumeParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    params = [self setProfilePageDeeplinkingSourceInParam:params];
    
     self.apiRequestObj.requestParameters = params;
}



@end
