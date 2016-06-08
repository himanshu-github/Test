//
//  NGResetNotificationCountServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGResetNotificationCountServiceClient.h"

#import "NGResetNotificationCountParser.h"

@implementation NGResetNotificationCountServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_RESET_NOTIFICATION];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.apiId = SERVICE_TYPE_RESET_NOTIFICATION;
    self.apiRequestObj.isBackgroundTask = YES;
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGResetNotificationCountParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.requestParameters = params;
}



@end
