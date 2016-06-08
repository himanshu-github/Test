//
//  NGDropDownParser.m
//  NaukriGulf
//
//  Created by Ayush Goel on 28/05/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGDropDownParser.h"

@implementation NGDropDownParser


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
