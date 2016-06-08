//
//  NGAppDelegate.h
//  NaukriGulf
//
//  Created by Arun Kumar on 21/05/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "NGOpenWithResumeHandler.h"
#import "NGNotificationAppHandler.h"

@interface NGAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MFSideMenuContainerViewController *container;
+ (NGAppDelegate*)appDelegate;
-(void)showSingletonNetworkErrorLayer;
-(void)removeSingletonNetworkErrorLayer;

@end
