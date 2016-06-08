//
//  NGForgetPasswordClient.m
//  NaukriGulf
//
//  Created by Minni Arora on 24/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGForgetPasswordClient.h"
#import "NGForgetPasswordParser.h"


@implementation NGForgetPasswordClient

-(id)init{
    if (self==[super init]) {
        [self initialize];
    }
    
    return self;
}


-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_FORGET_PASSWORD];
    self.apiRequestObj.apiId = SERVICE_TYPE_FORGET_PASSWORD;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGForgetPasswordParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params
{
    self.apiRequestObj.requestParameters = params;
}

@end
