//
//  NGSSAServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSSAServiceClient.h"

#import "NGSSAParser.h"

@implementation NGSSAServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_SSA];
    self.apiRequestObj.apiId = SERVICE_TYPE_SSA;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGSSAParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    self.apiRequestObj.requestParameters = params;
}



@end
