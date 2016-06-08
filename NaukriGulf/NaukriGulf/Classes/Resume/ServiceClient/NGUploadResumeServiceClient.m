//
//  NGUploadResumeServiceClient.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 16/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGUploadResumeServiceClient.h"
#import "NGGeneralDataParser.h"

@implementation NGUploadResumeServiceClient

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
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_UPLOAD_RESUME];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_UPLOAD_RESUME;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGGeneralDataParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    params = [self setProfilePageDeeplinkingSourceInParam:params];
    
    self.apiRequestObj.requestParameters = params;
}

@end
