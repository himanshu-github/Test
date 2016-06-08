//
//  NGDownloadResumeClient.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 12/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGDownloadResumeClient.h"
#import "NGDownloadResumeDataParser.h"

@implementation NGDownloadResumeClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_DOWNLOAD_RESUME];
    self.apiRequestObj.baseUrl = [ NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_DOWNLOAD_RESUME;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = YES;
    
    self.webAPICallerObj = [[NGPhotoDownloadApiCaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGDownloadResumeDataParser alloc]init];
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    params = [self setProfilePageDeeplinkingSourceInParam:params];
    
    self.apiRequestObj.requestParameters = params;
}
@end
