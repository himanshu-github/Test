//
//  NGLoginParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLoginParser.h"

@implementation NGLoginParser


-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    NSDictionary *ssaDict = [dataDict.responseData JSONValue];
    dataDict.parsedResponseData = ssaDict;
    return dataDict;
}


@end
