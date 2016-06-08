//
//  WatchHelper.h
//  NaukriGulf
//
//  Created by Arun on 1/8/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface WatchHelper : NSObject
+(WatchHelper *)sharedInstance;

-(void)activateSession;
 @property(nonatomic, assign) BOOL isUserLoggedIn;

-(void)sendWatchUserDetail;
+(BOOL)checkIfUserHasInstalledWatchAppRecently;
+(void)sendScreenReportOnGA:(NSString*)screenName;
+(void)sendClickEventOnGA:(NSString*)clickName;

@end
