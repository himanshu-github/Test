//
//  NGJsonDataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJsonDataFormatter.h"

@implementation NGJsonDataFormatter

-(id)convertFromDict:(NSDictionary *)paramsDict{
    NSString *jsonString = @"";
    NSError *error;
    if ([paramsDict count] > 0) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:paramsDict];
    [NGDatabaseHelper encodeURLDict:dict keyStack:nil];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData
                                       encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
