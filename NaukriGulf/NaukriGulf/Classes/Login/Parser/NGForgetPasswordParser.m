//
//  NGForgetPasswordParser.m
//  NaukriGulf
//
//  Created by Minni Arora on 24/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGForgetPasswordParser.h"

@implementation NGForgetPasswordParser
-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict {
    return dataDict;
}

-(id)parseErrorResponseDataFromServer:(NGAPIResponseModal *)dataDict {

    NSString *response = ERROR_MESSAGE_NOTHING;
    response = ERROR_MESSAGE_EMAIL_NOT_IN_DATABASE;
    dataDict.parsedResponseData = response;
    return dataDict;
}

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict
{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    
    NSMutableDictionary *parseDict = [NSMutableDictionary dictionary];
    NSDictionary *forgetPassword = [responseData JSONValue];
    
   
    
    
    NSString *statusStr = [[[forgetPassword objectForKey:@"Root"]objectForKey:@"Header"]objectForKey:@"status"];
    
    [parseDict setObject:statusStr forKey:KEY_FORGET_PASSWORD_STATUS];
    
    if ([statusStr isEqualToString:@"error"])
    {
        NSArray *errorsArr = [[forgetPassword objectForKey:@"Root"]objectForKey:@"Errors"];
        
        if (errorsArr.count>0)
        {
            NSDictionary *errorDict = [errorsArr fetchObjectAtIndex:0];
            NSString *msgStr = [[errorDict objectForKey:@"Error"]objectForKey:@"Message"];
            [parseDict setObject:msgStr forKey:@"Message"];
        }
        
    }
    else if ([statusStr isEqualToString:@"success"])
    {
        
         NSString* msgStr=[[[forgetPassword objectForKey:@"Root"]objectForKey:@"Header"]objectForKey:@"Message"];
         [parseDict setObject:msgStr forKey:@"Message"];
    }
  
    
    return parseDict;
}

@end
