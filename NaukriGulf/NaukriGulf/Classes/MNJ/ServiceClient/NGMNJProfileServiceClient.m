//
//  NGMNJProfileServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJProfileServiceClient.h"

@implementation NGMNJProfileServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_USER_DETAILS];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_USER_DETAILS;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;

    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGMNJProfileDataParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
    if([params objectForKey:KEY_IS_API_HIT_FROM_WATCH])
        self.apiRequestObj.isAPIHitFromiWatch = YES;
    else
        self.apiRequestObj.isAPIHitFromiWatch = NO;

}



@end
