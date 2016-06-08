//
//  IENavigationAction.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "IENavigationAction.h"

@implementation IENavigationAction

-(id)init{
    if(self){
        self.isAnimationRequired = NO;
        self.actionType = IENavigationActionTypeNone;
        self.performAction = nil;
    }
    return self;
}

@end
