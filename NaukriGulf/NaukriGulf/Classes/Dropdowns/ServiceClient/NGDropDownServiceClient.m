//
//  NGDropDownServiceClient.m
//  NaukriGulf
//
//  Created by Ayush Goel on 28/05/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGDropDownServiceClient.h"
#import "WebDataFormatter.h"
#import "NGDropDownParser.h"


@implementation NGDropDownServiceClient


- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


-(void)initialize
{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_DROPDOWN];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_DROPDOWN;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[WebDataFormatter alloc]init];
    self.dataParserObj = [[NGDropDownParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    [self customizeURLWithResourceParams:params];
    self.apiRequestObj.authorisationHeaderNeeded = YES;
}

-(void)customizeURLWithResourceParams:(NSMutableDictionary*)requestResourceParams
{
    if(requestResourceParams.allKeys.count>0)
    {
        NSString* apiUrl = self.apiRequestObj.apiUrl;
        apiUrl = [apiUrl stringByReplacingOccurrencesOfString:@"%@" withString:[requestResourceParams objectForKey:@"dropdownType"]];
        self.apiRequestObj.apiUrl = apiUrl;
    }
}

@end
