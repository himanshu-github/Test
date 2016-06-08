//
//  NGMNJDeletePhotoServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 31/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJDeletePhotoServiceClient.h"
#import "NGMNJUploadPhotoParser.h"

@implementation NGMNJDeletePhotoServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_DELETE_PHOTO];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_DELETE_PHOTO;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_DELETE;
    self.apiRequestObj.isBackgroundTask = NO;

    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGMNJUploadPhotoParser alloc]init];
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    params = [self setProfilePageDeeplinkingSourceInParam:params];
    
    self.apiRequestObj.requestParameters = params;
}



@end
