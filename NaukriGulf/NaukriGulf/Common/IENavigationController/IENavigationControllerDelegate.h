//
//  IENavigationControllerDelegate.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IENavigationController;

@interface IENavigationControllerDelegate : NSObject<UINavigationControllerDelegate>

-(void)addObjectToQueue:(id)paramObject;
-(void)removeObjectFromQueue:(id)paramObject;
@property (nonatomic,strong) IENavigationController *navController;

@end
