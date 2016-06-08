//
//  NGExchangeTokenParser.m
//  NaukriGulf
//
//  Created by Swati Kaushik on 21/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGExchangeTokenParser.h"

@implementation NGExchangeTokenParser
-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    dataDict.parsedResponseData = [dataDict.responseData JSONValue];
    return dataDict;
}

@end
