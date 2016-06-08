//
//  BaseSegmentedControl.m
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseSegmentedControl.h"

@implementation BaseSegmentedControl


- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super init];
    if (self)
    {
        self.tag=[[params valueForKey:KEY_TAG] intValue];
        self.frame=[[params valueForKey:KEY_FRAME] CGRectValue];
    }
    return self;
}

@end
