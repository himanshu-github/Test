//
//  NSMutableDictionary+SetObject.h
//  NaukriGulf
//
//  Created by Arun Kumar on 23/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SetObject)

-(void)setCustomObject:(id)anObject forKey:(id<NSCopying>)aKey;
-(NSString*)trimCharctersInSet:(NSCharacterSet*)set;

@end
