//
//  NGAppBlockerParser.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGAppBlockerParser.h"
#import "NGAppBlockerModel.h"

@implementation NGAppBlockerParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal*)model{
    
    NSDictionary *dict = [model.responseData JSONValue];
    
    NSMutableDictionary *responseDict = [NSMutableDictionary dictionary];
    
    if([dict objectForKey:KEY_ERROR]){
      
        NSMutableDictionary* errorDict = [dict objectForKey:KEY_ERROR];
        [responseDict setCustomObject:errorDict forKey:@"apiModel"];
        [responseDict setCustomObject:@"Error" forKey:K_KEY_APP_BLOCKER_STATUS];
    }
    else{
        
        NSError *error = nil;
        NGAppBlockerModel *objModel = [[NGAppBlockerModel alloc]initWithDictionary:dict error:&error];
        [responseDict setCustomObject:objModel forKey:@"apiModel"];
        [responseDict setCustomObject:@"Success" forKey:K_KEY_APP_BLOCKER_STATUS];
        
    }
    
    model.parsedResponseData = responseDict;
    return model;
    
}

@end
