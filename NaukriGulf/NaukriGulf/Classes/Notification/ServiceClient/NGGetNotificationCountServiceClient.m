//
//  NGGetNotificationCountServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGGetNotificationCountServiceClient.h"

#import "NGGetNotificationCountParser.h"

@implementation NGGetNotificationCountServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_GET_NOTIFICATION];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.apiId = SERVICE_TYPE_GET_NOTIFICATION;
    self.apiRequestObj.isBackgroundTask = YES;
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGGetNotificationCountParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] initWithDictionary:params];
    self.apiRequestObj.requestParameters = paramsDict;
}



@end
