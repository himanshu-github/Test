//
//  NGMNJProfileDataParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJProfileDataParser.h"



@implementation NGMNJProfileDataParser


-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSDictionary *userDetailsDict = [dataDict.responseData JSONValue];
    NSDictionary* profileDict = [userDetailsDict objectForKey:@"Profile"];

    NSMutableDictionary* parseDict = [NSMutableDictionary dictionary];
    if (profileDict){
        @try {
            [NGDatabaseHelper decodeUTFDict:(NSMutableDictionary*)profileDict keyStack:nil];
        }
        @catch (NSException *exception) {
        }
        
        NSError* err = nil;
        NGMNJProfileModalClass *objModel = [[NGMNJProfileModalClass alloc]initWithDictionary:profileDict error:&err];
        
        [parseDict setCustomObject:objModel forKey:KEY_USER_DETAILS_INFO];
                [parseDict setCustomObject:KEY_SUCCESS_RESPONSE forKey:KEY_USER_DETAILS_STATUS];

    }
    else
    {
        NSDictionary *dict = [userDetailsDict objectForKey:@"error"];
        if (dict) {
            
            [parseDict setCustomObject:[dict objectForKey:@"message"]forKey:KEY_USER_DETAILS_ERROR];
            [parseDict setCustomObject:KEY_ERROR forKey:KEY_USER_DETAILS_STATUS];

        }
        
        
    }
    dataDict.parsedResponseData = parseDict;
    return dataDict;
}
@end
