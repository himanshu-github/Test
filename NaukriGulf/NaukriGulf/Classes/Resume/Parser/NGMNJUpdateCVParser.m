//
//  NGMNJUpdateCVParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJUpdateCVParser.h"

@implementation NGMNJUpdateCVParser
-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSMutableDictionary* parsedDict = [NSMutableDictionary dictionary];
    [parsedDict setObject:KEY_SUCCESS_RESPONSE forKey:KEY_UPDATE_RESUME_STATUS];
    dataDict.parsedResponseData  = parsedDict;
    return dataDict;
}
-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    
    
    NSMutableDictionary *parseDict = [NSMutableDictionary dictionary];
    NSDictionary *userDetailsDict = [responseData JSONValue];
    
    NSString *statusStr = [userDetailsDict objectForKey:@"status"];
    [parseDict setCustomObject:statusStr forKey:KEY_UPDATE_RESUME_STATUS];
    
    if ([statusStr isEqualToString:@"error"]) {
        id arr = [userDetailsDict objectForKey:@"errors"];
        if ([arr isKindOfClass:[NSArray class]]) {
            NSArray *arr1 = arr;
            if (arr1.count>0) {
                NSDictionary *dict = [arr1 fetchObjectAtIndex:0];
                
                [parseDict setCustomObject:[dict objectForKey:@"message"]forKey:KEY_UPDATE_RESUME_ERROR];
            }
        }else{
            [parseDict setCustomObject:[userDetailsDict objectForKey:@"errors"]forKey:KEY_UPDATE_RESUME_ERROR];
        }
        
        
    }else if ([statusStr isEqualToString:@"success"]) {
        
    }
    
    
    return parseDict;
}

@end
