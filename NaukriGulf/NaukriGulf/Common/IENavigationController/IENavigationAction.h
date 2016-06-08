//
//  IENavigationAction.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGEnum.h"

@interface IENavigationAction : NSObject

@property (nonatomic,readwrite) BOOL isAnimationRequired;
@property(nonatomic,readwrite) IENavigationActionType actionType;
@property (nonatomic,copy) void (^performAction)(id viewControllerProcessed);

@end
