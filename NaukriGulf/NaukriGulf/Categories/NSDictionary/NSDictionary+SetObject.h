//
//  NSDictionary+SetObject.h
//  NaukriGulf
//
//  Created by Arun Kumar on 7/13/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SetObject)
-(NSString*)trimCharctersInSet:(NSCharacterSet*)set;
-(void)setCustomObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end
