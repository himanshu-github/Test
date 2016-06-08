//
//  NGFileUploadServiceClient.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 13/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGFileUploadServiceClient.h"
#import "NGFileUploadApiCaller.h"
#import "NGFileUploadDataFormatter.h"
#import "NGFileUploadDataParser.h"

@implementation NGFileUploadServiceClient

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
    self.apiRequestObj.apiUrl = [[NGHelper sharedInstance]getAPIURLWithServiceType:SERVICE_TYPE_FILE_UPLOAD];
    self.apiRequestObj.baseUrl = [[NGHelper sharedInstance]getBaseURLWithServiceType:K_BASE_URL_FILE_UPLOAD];
    self.apiRequestObj.apiId = SERVICE_TYPE_FILE_UPLOAD;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[NGFileUploadApiCaller alloc]init];
    self.webDataFormatterObj = [[NGFileUploadDataFormatter alloc]init];
    self.dataParserObj = [[NGFileUploadDataParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    //get appId and and change url accordingly
    NSString *appIdString = [params objectForKey:k_FILE_UPLOAD_APP_ID_KEY];
    if(nil == appIdString || [appIdString isKindOfClass:[NSNull class]]){
        if ([NGHelper sharedInstance].isUserLoggedIn) {
            appIdString = k_FILE_UPLOAD_APP_ID_MNJ;
        }else{
            appIdString = k_FILE_UPLOAD_APP_ID_UNREG;
        }
    }
    
    self.apiRequestObj.apiUrl = [self.apiRequestObj.apiUrl stringByReplacingOccurrencesOfString:@"%@" withString:appIdString];
    
    self.apiRequestObj.requestParameters = params;
    self.apiRequestObj.authorisationHeaderNeeded = YES;
}

@end
