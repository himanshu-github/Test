//
//  NGSSAParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSSAParser.h"

@implementation NGSSAParser

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    NSMutableDictionary *parseDict = [NSMutableDictionary dictionary];
    NSDictionary *ssaDict = [responseData JSONValue];
    NSString *statusStr = [[[ssaDict objectForKey:@"Root"]objectForKey:@"Header"]objectForKey:@"status"];
    
    [parseDict setCustomObject:statusStr forKey:KEY_SSA_STATUS];
    
    if ([statusStr isEqualToString:@"error"]) {
        NSArray *errorsArr = [[ssaDict objectForKey:@"Root"]objectForKey:@"Errors"];
        
        if (errorsArr.count>0) {
            NSDictionary *errorDict = [errorsArr fetchObjectAtIndex:0];
            NSString *msgStr = [[errorDict objectForKey:@"Error"]objectForKey:@"Message"];
            [parseDict setCustomObject:msgStr forKey:KEY_SSA_MESSAGE];
        }
        
    }else if ([statusStr isEqualToString:@"success"]) {
        NSString *msgStr = [[ssaDict objectForKey:@"Root"]objectForKey:@"message"];
        NSString *alertID = [[ssaDict objectForKey:@"Root"]objectForKey:@"alertId"];
        
        [parseDict setCustomObject:msgStr forKey:KEY_SSA_MESSAGE];
        [parseDict setCustomObject:alertID forKey:KEY_SSA_ALERT_ID];
    }
    
    
    return parseDict;
}
-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSDictionary *ssaDict = [dataDict.responseData JSONValue];
    dataDict.parsedResponseData = ssaDict;
    return dataDict;
}

@end
