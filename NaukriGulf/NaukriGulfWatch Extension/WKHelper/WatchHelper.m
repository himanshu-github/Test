//
//  WatchHelper.m
//  NaukriGulf
//
//  Created by Arun on 1/8/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "WatchHelper.h"
#import <WatchConnectivity/WatchConnectivity.h>


@interface WatchHelper()<WCSessionDelegate>{
    
}

@end

@implementation WatchHelper

+(WatchHelper *)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

-(void)activateSession{
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        [self checkUserStatus];
    }
}

-(void)checkUserStatus{
    
    [[WCSession defaultSession] sendMessage:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"api_login",@"name",nil]
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){
                                   _isUserLoggedIn = [replyMessage[@"login_status"] boolValue];
                               }
                               errorHandler:^(NSError * _Nonnull error) {
                                   _isUserLoggedIn = NO;
                               }];
}

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext{
    _isUserLoggedIn = [applicationContext[@"login_status"] boolValue];
}
-(void)sendWatchUserDetail{
    
    if([WatchHelper checkIfUserHasInstalledWatchAppRecently])
    {
    [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"watchUser_feedback",@"name", nil]
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                   
                               }
                               errorHandler:^(NSError * _Nonnull error) {
                               
                               }];
    }
}
+(BOOL)checkIfUserHasInstalledWatchAppRecently{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL isInstalledRecently;
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    if ([prefs stringForKey:@"watchAppVersion"] != nil) {
        isInstalledRecently = NO;
    } else {
        isInstalledRecently = YES;
    }
    
    if (isInstalledRecently) {
        [prefs setObject:version forKey:@"watchAppVersion"];
        [prefs synchronize];
    }
    return isInstalledRecently;
}
+(void)sendScreenReportOnGA:(NSString*)screenName{
    [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:screenName,@"name", nil]
    replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                   
    }
    errorHandler:^(NSError * _Nonnull error) {
                                   
    }];
}
+(void)sendClickEventOnGA:(NSString*)clickName{
    [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:clickName,@"name", nil]
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                   
                               }
                               errorHandler:^(NSError * _Nonnull error) {
                                   
                               }];

}
@end
