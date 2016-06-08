//
//  NGUnregApplyServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGUnregApplyServiceClient.h"
#import "NGUnregApplyAPICaller.h"
#import "NGUnregApplyParser.h"

@implementation NGUnregApplyServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_UNREG_APPLY];
    self.apiRequestObj.apiId = SERVICE_TYPE_UNREG_APPLY;
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    self.apiRequestObj.queryStringParameterKey = @"UnregData";
    
    self.webAPICallerObj = [[NGUnregApplyAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGUnregApplyParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    params = [self setJDPageDeeplinkingSourceInParam:params];
    
    self.apiRequestObj.requestParameters = params;
}



@end
