//
//  NGRegistrationParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 3/9/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGRegistrationParser.h"

@implementation NGRegistrationParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSString *responseData = dataDict.responseData;
    
    NSDictionary *dict = [responseData JSONValue];
    NSMutableDictionary *parsedDict = [NSMutableDictionary dictionary];
    
    BOOL hasNoError = (nil == [dict objectForKey:KEY_ERROR]);

    if (hasNoError) {
        [parsedDict setCustomObject:[dict objectForKey:@"NAUKRIGULF id"] forKey:@"conmnj"];
        NSString *headline = [[[dict objectForKey:@"Profile"] objectForKey:@"headline"]objectForKey:@"default"];
        [parsedDict setCustomObject:headline forKey:@"headline"];
    }else{
        [parsedDict setCustomObject:[dict objectForKey:KEY_ERROR] forKey:KEY_ERROR];
    }
    
    dataDict.parsedResponseData = parsedDict;
    return dataDict;
}


@end
