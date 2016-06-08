//
//  NSMutableArray+DuplicacyRemover.h
//  NaukriGulf
//
//  Created by Arun Kumar on 14/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A category of NSMutableArray for removing duplicate objects.
 */
@interface NSMutableArray (DuplicacyRemover)

/**
 *  Remove duplicate objects.
 */
-(void)removeDuplicateObjects;
@end
