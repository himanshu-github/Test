//
//  ExtensionDelegate.m
//  NaukriGulfWatch Extension
//
//  Created by Arun on 12/24/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "ExtensionDelegate.h"
#import <UIKit/UIKit.h>
#import "WatchHelper.h"
#import "WatchConstants.h"

@interface ExtensionDelegate()<WCSessionDelegate>

@end
@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    // Perform any final initialization of your application.
    [[WatchHelper sharedInstance] activateSession];
    [[WatchHelper sharedInstance] sendWatchUserDetail];
 
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[WatchHelper sharedInstance] activateSession];

    
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}


-(void)handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)localNotification{
    
    [WatchHelper sendClickEventOnGA:GA_WATCH_NOTI_CLICKED];
   
    WKInterfaceController* rootCntrl = [WKExtension sharedExtension].rootInterfaceController;
    if ([localNotification.category isEqualToString:@"reco"]){
        
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession];
            session.delegate = self;
            [session activateSession];
            if (session.reachable) {
                [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"check_eligibility",@"name", nil]
                                           replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            if([[replyMessage objectForKey:@"internet"] boolValue]){
                if([[replyMessage objectForKey:@"isLoggedIn"] boolValue]){
                
                  [rootCntrl pushControllerWithName:CONTROLLER_RECOJOBS context:[NSDictionary dictionaryWithObjectsAndKeys:@"reco_jobs",@"page",@"notification",@"comingFrom", nil]];
            }
            else
             [rootCntrl presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
                [NSDictionary dictionaryWithObjectsAndKeys:K_LOGIN_FROM_IPHONE,KEY_MESSAGE, nil]];
                                                   
            }
            else
            [rootCntrl presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:[NSDictionary dictionaryWithObjectsAndKeys:K_NO_INTERENT,KEY_MESSAGE,                                                                                                             nil]];
            }
            errorHandler:^(NSError * _Nonnull error) {
            [rootCntrl presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
                [NSDictionary dictionaryWithObjectsAndKeys:K_SOME_ERROR_OCCURED,KEY_MESSAGE, nil]];
            }];
            }
            else
            [rootCntrl presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
                 [NSDictionary dictionaryWithObjectsAndKeys:K_ERROR_REACHABLE,KEY_MESSAGE, nil]];
        }
    }
    else
        [rootCntrl presentControllerWithName:@"OtherInterfaceController" context:nil];

}


@end
