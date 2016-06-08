//
//  NGMNJProfilePhotoServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJProfilePhotoServiceClient.h"

#import "NGMNJProfilePhotoParser.h"

@implementation NGMNJProfilePhotoServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_PROFILE_PHOTO];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_PROFILE_PHOTO;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;

    self.webAPICallerObj = [[NGPhotoDownloadApiCaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGMNJProfilePhotoParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    self.apiRequestObj.requestParameters = params;
}


@end
