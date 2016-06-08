//
//  NGUserActiveStateDataParser.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 02/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGUserActiveStateDataParser.h"

@implementation NGUserActiveStateDataParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal*)model{
    
    @try {
        NSDictionary *serverResponseObj = [model.responseData JSONValue];
        
        model.parsedResponseData = serverResponseObj;
    }
    @catch (NSException *exception) {
        
    }
    return model;
}


@end
