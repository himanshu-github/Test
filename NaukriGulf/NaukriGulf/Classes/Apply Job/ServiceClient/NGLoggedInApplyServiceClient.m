//
//  NGLoggedInApplyServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLoggedInApplyServiceClient.h"

#import "NGLoggedInApplyParser.h"

@implementation NGLoggedInApplyServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_LOGGED_IN_APPLY];
    self.apiRequestObj.apiId = SERVICE_TYPE_LOGGED_IN_APPLY;
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGLoggedInApplyParser alloc]init];
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{

    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    params =  [self setJDPageDeeplinkingSourceInParam:params];
    
    self.apiRequestObj.requestParameters = params;
    
    if([params objectForKey:KEY_IS_API_HIT_FROM_WATCH])
        self.apiRequestObj.isAPIHitFromiWatch = YES;
    else
        self.apiRequestObj.isAPIHitFromiWatch = NO;

}



@end
