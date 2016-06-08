//
//  NSMutableDictionary+SetObject.m
//  NaukriGulf
//
//  Created by Arun Kumar on 23/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NSMutableDictionary+SetObject.h"

@implementation NSMutableDictionary (SetObject)

-(void)setCustomObject:(id)anObject forKey:(id<NSCopying>)aKey{
    
    if (anObject)
    {
        [self setObject:anObject forKey:aKey];
    }
}

- (NSString*)trimCharctersInSet:(NSCharacterSet*)set{
    
    return @"";
}

@end
