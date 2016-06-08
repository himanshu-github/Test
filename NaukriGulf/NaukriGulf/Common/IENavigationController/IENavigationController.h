//
//  IENavigationController.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IENavigationControllerDelegate.h"
#import "IENavigationAction.h"

@interface IENavigationController : UINavigationController

-(void)pushActionViewController:(id)viewController Animated:(BOOL)isAnimated;
-(void)popToActionViewController:(id)viewController;

-(void)popActionViewControllerWithAction:(IENavigationAction*)navAction;
-(void)popActionViewControllerAnimated:(BOOL)isAnimated;
@end
