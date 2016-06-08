//
//  NGResetNotificationCountParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGResetNotificationCountParser.h"

@implementation NGResetNotificationCountParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict {
    return dataDict;
}

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    
    
    NSMutableDictionary *parseDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = [responseData JSONValue];
    
    NSString *statusStr = [[[dict objectForKey:@"Root"]objectForKey:@"Header"]objectForKey:@"status"];
    
    
    [parseDict setCustomObject:statusStr forKey:KEY_RESET_NOTIFICATION];
    
    
    if ([statusStr isEqualToString:@"success"])
    {
        [parseDict setCustomObject:statusStr forKey:@"ResetSuccess"];
    }
    
    return parseDict;
}


@end
