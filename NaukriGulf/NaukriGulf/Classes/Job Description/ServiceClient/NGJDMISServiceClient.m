//
//  NGJDMISServiceClient.m
//  NaukriGulf
//
//  Created by bazinga on 10/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGJDMISServiceClient.h"
#import "NGJDMISParser.h"
@implementation NGJDMISServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_MIS_JD];
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.apiId = SERVICE_TYPE_MIS_JD;
    self.apiRequestObj.isBackgroundTask = YES;
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGJDMISParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    [self customizeURLWithResourceParams:params];
    
    params = [self setJDPageDeeplinkingSourceInParam:params];
    
    self.apiRequestObj.otherParameters  = params;
    self.apiRequestObj.requestParameters  = nil;
}

-(void)customizeURLWithResourceParams:(NSMutableDictionary*)requestResourceParams
{
    if(requestResourceParams.allKeys.count>0)
    {
        NSString* url = self.apiRequestObj.apiUrl;
        
        url = [url stringByReplacingOccurrencesOfString:@"%@" withString:[requestResourceParams objectForKey:@"jobId"]];
        self.apiRequestObj.apiUrl = url;
    }
}




@end
