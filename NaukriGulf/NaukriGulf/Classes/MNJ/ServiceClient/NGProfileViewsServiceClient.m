//
//  NGProfileViewsServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGProfileViewsServiceClient.h"

#import "NGProfileViewsParser.h"

@implementation NGProfileViewsServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_WHO_VIEWED_MY_CV];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_WHO_VIEWED_MY_CV;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGProfileViewsParser alloc]init];
    
}


-(void)customizeRequestParams:(NSMutableDictionary *)params {
    self.apiRequestObj.authorisationHeaderNeeded =  YES;
}


@end
