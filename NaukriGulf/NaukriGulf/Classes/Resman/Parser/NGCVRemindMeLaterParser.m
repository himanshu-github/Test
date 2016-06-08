//
//  NGCVRemindMeLaterParser.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 10/03/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGCVRemindMeLaterParser.h"

@implementation NGCVRemindMeLaterParser

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
