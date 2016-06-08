//
//  NGUpdateInfoNotificationServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGUpdateInfoNotificationServiceClient.h"

#import "NGUpdateInfoNotificationParser.h"

@implementation NGUpdateInfoNotificationServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_UPDATE_INFO_NOTIFICATION];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.apiId = SERVICE_TYPE_UPDATE_INFO_NOTIFICATION;
    self.apiRequestObj.isBackgroundTask = YES;
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGUpdateInfoNotificationParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.authorisationHeaderNeeded = [[NGHelper sharedInstance]isUserLoggedIn];
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setValue:[params objectForKey:@"tokenId"] forKey:@"tokenId"];
    [paramsDict setValue:[NSString getAppVersion] forKey:@"appVersion"];
    self.apiRequestObj.requestParameters = paramsDict;
}



@end
