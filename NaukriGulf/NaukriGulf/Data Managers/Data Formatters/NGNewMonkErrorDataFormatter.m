//
//  NGNewMonkErrorDataFormatter.m
//  NaukriGulf
//
//  Created by Himanshu on 12/23/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "NGNewMonkErrorDataFormatter.h"

@implementation NGNewMonkErrorDataFormatter
-(id)convertFromDict:(NSDictionary *)paramsDict{
    NSString *jsonString = @"";
    NSError *error;
    if ([paramsDict count] > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:paramsDict];
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
