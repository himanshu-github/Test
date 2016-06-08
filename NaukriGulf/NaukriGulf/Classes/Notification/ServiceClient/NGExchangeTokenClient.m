//
//  NGExchangeTokenClient.m
//  NaukriGulf
//
//  Created by Swati Kaushik on 21/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGExchangeTokenClient.h"
#import "NGExchangeTokenParser.h"
@implementation NGExchangeTokenClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_EXCHANGE_TOKEN];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURLWithServiceType:K_BASE_URL_LOGIN];
    self.apiRequestObj.apiId = SERVICE_TYPE_EXCHANGE_TOKEN;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGExchangeTokenParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.requestParameters = params;
}

@end
