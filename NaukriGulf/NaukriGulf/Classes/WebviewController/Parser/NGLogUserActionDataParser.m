//
//  NGLogUserActionDataParser.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 01/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGLogUserActionDataParser.h"

@implementation NGLogUserActionDataParser

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
