//
//  NGNotificationAppHandler.h
//  NaukriGulf
//
//  Created by Minni Arora on 22/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NGPushNotificationAppState){
    NGPushNotificationAppStateNone,
    NGPushNotificationAppStateLaunch,
    NGPushNotificationAppStateBackground
};

/**
 *  A Singelton Class for handling Push Notifications Of Application
 */
@interface NGNotificationAppHandler : NSObject

@property(nonatomic,readwrite) BOOL performPushNotificationWithDesiredPageLanding;

@property(nonatomic,readwrite) NGPushNotificationAppState pushNotificationAppState;
/**
 *  Singleton Instance handle
 *
 *  @return sharedInstance
 */
+(NGNotificationAppHandler *)sharedInstance;
-(void)handlePushNotification;
-(void)setPushNotificationConfigFromLaunchOption:(NSDictionary*)paramLaunchOption;
-(void)validateAndSetPushNotificationWithDictionary:(NSDictionary*)paramPushNotificationData;
@end
