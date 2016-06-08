//
//  NGEmailJobParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEmailJobParser.h"

@implementation NGEmailJobParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    return dataDict;
}

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    
    NSDictionary *sndEmailList = [responseData JSONValue];
    
  

    NSMutableDictionary *parseDict = [NSMutableDictionary dictionary];
    
    NSString *statusStr = [[[sndEmailList objectForKey:@"Root"]objectForKey:@"Header"]objectForKey:@"status"];
    
    [parseDict setCustomObject:statusStr forKey:KEY_SEND_EMAIL_STATUS];
    return parseDict;
}


@end
