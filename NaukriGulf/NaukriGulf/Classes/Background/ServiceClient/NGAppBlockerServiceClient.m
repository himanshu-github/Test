//
//  NGAppBlockerServiceClient.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGAppBlockerServiceClient.h"
#import "NGAppBlockerParser.h"
@implementation NGAppBlockerServiceClient

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_APP_BLOCKER];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_APP_BLOCKER;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = YES;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGURLDataFormatter alloc]init];
    self.dataParserObj = [[NGAppBlockerParser alloc]init];
    if([NGHelper sharedInstance].isUserLoggedIn) {
        
        self.apiRequestObj.authorisationHeaderNeeded = TRUE;
        
    }
    
}


-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:
                                        [params objectForKey:K_ATTRIBUTE_PARAMS]];
    [finalParams setCustomObject:@"ng" forKey:@"site"];
    [finalParams setCustomObject:@"1f0n3" forKey:@"clientId"];
    [finalParams setCustomObject:@"" forKey:@"user"];
    
    self.apiRequestObj.requestParameters = finalParams;
}

@end
