//
//  NGDeleteNotificationCountServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGDeleteNotificationCountServiceClient.h"

#import "NGDeleteNotificationCountParser.h"

@implementation NGDeleteNotificationCountServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_DELETE_PUSH_COUNT];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.apiId = SERVICE_TYPE_DELETE_PUSH_COUNT;
    self.apiRequestObj.isBackgroundTask = YES;
    [self.apiRequestObj.httpHeadersArr addObject:@{@"X-HTTP-Method-Override" : @"DELETE"}];
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGDeleteNotificationCountParser alloc]init];
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.requestParameters = params;
}



@end
