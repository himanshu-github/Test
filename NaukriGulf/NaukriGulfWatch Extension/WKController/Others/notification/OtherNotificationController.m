//
//  OtherNotificationController.m
//  NaukriGulf
//
//  Created by Arun on 1/7/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "OtherNotificationController.h"
#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface OtherNotificationController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblOtherAlertTitle;

@end

@implementation OtherNotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {

    [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"other_rcv",@"name", nil]
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {}
                               errorHandler:^(NSError * _Nonnull error) {}];
    [_lblOtherAlertTitle setText:localNotification.alertBody];
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}


/*
- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    // This method is called when a remote notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}
*/

@end



