//
//  NGGeneralDataParser.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 14/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGGeneralDataParser.h"

@implementation NGGeneralDataParser
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
