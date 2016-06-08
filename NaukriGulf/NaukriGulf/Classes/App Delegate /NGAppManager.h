//
//  NGAppManager.h
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGAppManager : NSObject


+ (void) applicationLaunch;
+ (void) applicationLaunch:(NSDictionary *)launchOptions;
+(void)registerForRemoteNotification:(UIApplication *)application;
+ (void)deviceRegistrationSucceed:(NSString *)newToken;
+ (void)doUserActiveStateRequest;
+(void) awakeLibararies;
+(void) fetchDataOnAwake;




@end
