//
//  NSArray+FetchObject.h
//  NaukriGulf
//
//  Created by Arun Kumar on 20/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A category of NSArray to fetch object at a specific index.
 */
@interface NSArray (FetchObject)

/**
 *  Fetch Object at specific index.
 *
 *  @param index index at which object is to be fetched.
 *
 *  @return Return object if exists otherwise nil.
 */
-(id)fetchObjectAtIndex:(NSInteger)index;
- (NSUInteger)indexOfCaseInsensitiveStringObject:(NSString*)paramObject;
@end
