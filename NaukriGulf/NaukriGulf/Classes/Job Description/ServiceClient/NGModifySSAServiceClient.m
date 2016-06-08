//
//  NGModifySSAServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGModifySSAServiceClient.h"

#import "NGModifySSAParser.h"

@implementation NGModifySSAServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    NSMutableDictionary *apiparamsDict = [NSMutableDictionary dictionary];
    [apiparamsDict setCustomObject:[NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_MODIFY_SSA] forKey:KEY_API_URL];
    [apiparamsDict setCustomObject:[NSNumber numberWithInteger:SERVICE_TYPE_MODIFY_SSA] forKey:KEY_API_TYPE];
    [apiparamsDict setCustomObject:FORMAT_TYPE_JSON forKey:KEY_INPUT_FORMAT_TYPE];
    [apiparamsDict setCustomObject:FORMAT_TYPE_JSON forKey:KEY_OUTPUT_FORMAT_TYPE];
    
    self.apiParams = apiparamsDict;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGModifySSAParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
    [requestParams setCustomObject:@"http://" forKey:HTTP_HEADER_PARAMS];
    [requestParams setCustomObject:[NSDictionary dictionary] forKey:OTHER_PARAMS];
    [requestParams setCustomObject:@"searchParameterData" forKey:REQUEST_HEADER_PARAMS];
    [requestParams setCustomObject:@"X-Job-Search-Auth-Signature" forKey:AUTH_SIGNATURE_PARAMS];
    [requestParams setCustomObject:@"X-Job-Search-Auth-Token" forKey:AUTH_TOKEN_PARAMS];
    [requestParams setCustomObject:PUBLIC_KEY_JOB_SEARCH forKey:PUBLIC_KEY_PARAMS];
    [requestParams setCustomObject:PRIVATE_KEY_JOB_SEARCH forKey:PRIVATE_KEY_PARAMS];
    [requestParams setCustomObject:[NSNumber numberWithBool:FALSE] forKey:BACKGROUND_TASK_PARAMS];
    
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [finalParams setCustomObject:@"json" forKey:@"format"];
    [finalParams setCustomObject:@"" forKey:@"expRange"];
    [finalParams setCustomObject:@"" forKey:@"alertFrequency"];
    
    /// ctc, gender, jobtitle, alertid
    
    [requestParams setCustomObject:finalParams forKey:REQUEST_PARAMS];
    
    self.requestParams = requestParams;
}



@end
