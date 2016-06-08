//
//  NGCQParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCQParser.h"

@implementation NGCQParser
-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
      dataDict.parsedResponseData = [dataDict.responseData JSONValue];
    return dataDict;
}
-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    
    
    NSMutableDictionary *parseDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = [responseData JSONValue];
    
    NSString *statusStr = [[[dict objectForKey:@"Root"]objectForKey:@"Header"]objectForKey:@"status"];
    
   
    
    [parseDict setCustomObject:statusStr forKey:KEY_CUSTOM_QUESTION_STATUS];
    
    if ([statusStr isEqualToString:@"error"]) {
        NSArray *errorsArr = [[dict objectForKey:@"Root"]objectForKey:@"Errors"];
        
        if (errorsArr.count>0)
        {
            NSDictionary *errorDict = [errorsArr fetchObjectAtIndex:0];
            NSString *msgStr = [[errorDict objectForKey:@"Error"]objectForKey:@"Message"];
            [parseDict setCustomObject:msgStr forKey:@"CustomQusetionList"];
        }
        
    }
    else if ([statusStr isEqualToString:@"success"]) {
        
        
        NSArray *cqArray = [[dict objectForKey:@"Root"]objectForKey:@"cq"];
        
        [parseDict setCustomObject:cqArray forKey:@"CustomQusetionList"];
    }
    
    return parseDict;
}


@end
