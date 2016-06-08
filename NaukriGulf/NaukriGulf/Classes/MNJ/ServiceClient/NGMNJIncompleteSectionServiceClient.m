//
//  NGMNJIncompleteSectionServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 18/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJIncompleteSectionServiceClient.h"

#import "NGMNJIncompleteSectionParser.h"

@implementation NGMNJIncompleteSectionServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_MNJ_INCOMPLETE_SECTION];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_MNJ_INCOMPLETE_SECTION;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;

    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGMNJIncompleteSectionParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    
}


@end
