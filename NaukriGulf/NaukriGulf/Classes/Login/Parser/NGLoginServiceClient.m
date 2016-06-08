//
//  NGLoginServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLoginServiceClient.h"

#import "NGLoginParser.h"

@implementation NGLoginServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_LOGIN];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURLWithServiceType:K_BASE_URL_LOGIN];
    self.apiRequestObj.apiId = SERVICE_TYPE_LOGIN;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGLoginParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    NSMutableDictionary* finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [finalParams setCustomObject:@"ios" forKey:@"lsource"];
    [finalParams setCustomObject:@"1" forKey:@"_body"];
    self.apiRequestObj.requestParameters = finalParams;
}



@end
