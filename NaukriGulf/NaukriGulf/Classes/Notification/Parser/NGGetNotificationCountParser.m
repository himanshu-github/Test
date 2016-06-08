//
//  NGGetNotificationCountParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGGetNotificationCountParser.h"

@implementation NGGetNotificationCountParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    NSArray *data;
    
    NSDictionary *dict = [dataDict.responseData JSONValue];
    if( [dict objectForKey:@"list"] ==nil || [[dict objectForKey:@"list"] count] == 0)
        data=[NSArray array];
    else
        data = [dict objectForKey:@"list"];
    
    dataDict.parsedResponseData = data;

    return dataDict;
}

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    
    
    NSMutableDictionary *parseDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = [responseData JSONValue];
    
    
    
    NSString *statusStr = [[[dict objectForKey:@"Root"]objectForKey:@"Header"]objectForKey:@"status"];
    
    
    [parseDict setCustomObject:statusStr forKey:KEY_GET_NOTIFICATIONS];
    
    
    
    if ([statusStr isEqualToString:@"success"])
    {
        
        NSArray *data;
        
        if([[dict objectForKey:@"Root"]objectForKey:@"data"]==[NSNull null])
            data=[NSArray array];
        else
            data = [[dict objectForKey:@"Root"]objectForKey:@"data"];
        
        [parseDict setCustomObject:data forKey:@"NotificationData"];
    }
    
   
    
    return parseDict;
}


@end
