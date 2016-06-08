//
//  NGLogoutServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLogoutServiceClient.h"

#import "NGLogoutParser.h"

@implementation NGLogoutServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_LOGOUT];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURLWithServiceType:K_BASE_URL_LOGIN];
    self.apiRequestObj.apiId = SERVICE_TYPE_LOGOUT;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;

    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGLogoutParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
   
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    NSMutableDictionary* finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [finalParams setCustomObject:@"ios" forKey:@"lsource"];
    self.apiRequestObj.requestParameters = finalParams;
}



@end
