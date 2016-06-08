//
//  NSMutableArray+DuplicacyRemover.m
//  NaukriGulf
//
//  Created by Arun Kumar on 14/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NSMutableArray+DuplicacyRemover.h"

@implementation NSMutableArray (DuplicacyRemover)

-(void)removeDuplicateObjects{
    NSArray *copy = [self copy];
    
    NSInteger index = [copy count] - 1;
    
    for (id object in [copy reverseObjectEnumerator])
    {
        
        if ([self indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound)
            
        {
            [self removeObjectAtIndex:index];
            
        }
        
        index--;
    }
}


@end
