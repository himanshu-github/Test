//
//  NotificationController.m
//  NaukriGulfWatch Extension
//
//  Created by Arun on 12/24/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "RecoNotificationController.h"
#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface RecoNotificationController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblAlertTitle;

@end


@implementation RecoNotificationController

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

    [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"reco_rcv",@"name", nil]
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {}
                               errorHandler:^(NSError * _Nonnull error) {}];
    
    [_lblAlertTitle setText:localNotification.alertBody];
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}



- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    // This method is called when a remote notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}



@end



