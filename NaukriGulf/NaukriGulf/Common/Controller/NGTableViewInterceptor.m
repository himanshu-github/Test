//
//  NGTableViewInterceptor.m
//  test
//
//  Created by Himanshu on 7/20/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "NGTableViewInterceptor.h"

@implementation NGTableViewInterceptor

@synthesize receiver = _receiver;
@synthesize middleMan = _middleMan;

- (id) forwardingTargetForSelector:(SEL)aSelector {
    
    if ([_middleMan respondsToSelector:aSelector])
        return _middleMan;
    
    if ([_receiver respondsToSelector:aSelector])
        return _receiver;
    
    return	[super forwardingTargetForSelector:aSelector];
    
}

- (BOOL) respondsToSelector:(SEL)aSelector {
    
    if ([_middleMan respondsToSelector:aSelector])
        return YES;
    
    if ([_receiver respondsToSelector:aSelector])
        return YES;
    
    return [super respondsToSelector:aSelector];
    
}


@end
