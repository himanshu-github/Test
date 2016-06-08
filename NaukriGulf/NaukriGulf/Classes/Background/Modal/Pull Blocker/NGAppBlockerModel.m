//
//  NGAppBlockerModel.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGAppBlockerModel.h"

@implementation NGAppBlockerModel

#pragma mark JSON Model Methods

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}



+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       
                                                       }];
}
@end
