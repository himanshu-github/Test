//
//  NGDataParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGDataParser.h"

@implementation NGDataParser

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    NSString *responseData = [dataDict objectForKey:KEY_RESPONSE_PARAMS];
    NSDictionary *apiDict = [dataDict objectForKey:KEY_API_PARAMS];
    
    NSInteger serviceType = [[apiDict objectForKey:KEY_API_TYPE]integerValue];
    
    NSDictionary *parsedDict = [NSDictionary dictionary];
    
    
    
    switch (serviceType) {
        
            
        case SERVICE_TYPE_JD:
            parsedDict = [self parseJobDetail:responseData];
            break;
          
        case SERVICE_TYPE_MIS_JD:
            parsedDict = [self parseMISJobDetail:responseData];
            break;
            
        default:
            break;
    }
    
    return parsedDict;
}


/**
 *  This method is used to parse the data received for JD MIS API.
 *
 *  @param responseData Represents the data received from the server.
 *
 *  @return Returns the parsed data.
 */
-(NSDictionary *)parseMISJobDetail:(NSString *)responseData{
    NSMutableDictionary *parsedJD = [NSMutableDictionary dictionary];
    return parsedJD;
}

/**
 *  This method is used to parse the data received for JD API.
 *
 *  @param responseData Represents the data received from the server.
 *
 *  @return Returns the parsed data.
 */
-(NSDictionary *)parseJobDetail:(NSString *)responseData{
    
    NSDictionary *jobDetail = [responseData JSONValue];
    NSMutableDictionary *parsedJD = [NSMutableDictionary dictionary];
    NSString *statusStr = [[[jobDetail objectForKey:@"Root"]objectForKey:@"Header"]objectForKey:@"status"];

    [parsedJD setCustomObject:statusStr forKey:KEY_JD_STATUS];

    if ([statusStr isEqualToString:@"success"])
    {
        
        NSError* err = nil;
        NGJDJobDetails *objModel = [[NGJDJobDetails alloc]initWithDictionary:[[jobDetail objectForKey:@"Root"] valueForKey:@"Job"] error:&err];
        
        
        [parsedJD setCustomObject:objModel forKey:KEY_JD];        

    }
    
    else if([statusStr isEqualToString:@"error"])
    {
        
        NSArray *errorsArr = [[jobDetail objectForKey:@"Root"]objectForKey:@"Errors"];
        
        if (errorsArr.count>0)
        {
            NSDictionary *errorDict = [errorsArr fetchObjectAtIndex:0];
            NSString *msgStr = [[errorDict objectForKey:@"Error"]objectForKey:@"Message"];
            [parsedJD setCustomObject:msgStr forKey:KEY_GET_JD_MESSAGE];
        }
        
    }
    
    return parsedJD;
}


@end
