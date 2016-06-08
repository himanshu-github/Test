//
//  BaseDataParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseDataParser.h"

@implementation BaseDataParser

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict{
    return dataDict;
}
-(NSDictionary*)parseTextResponseData:(NSDictionary *)dataDict;
{
    return dataDict;
}
-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    return dataDict;
}
-(id)parseErrorResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    return dataDict;
}
@end
