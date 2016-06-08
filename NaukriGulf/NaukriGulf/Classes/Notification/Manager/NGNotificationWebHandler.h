//
//  NGNotificationWebHandler.h
//  NaukriGulf
//
//  Created by Minni Arora on 22/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This Singleton Class for sending request to server about logged in user registerDevice and update user info
 * Conforms the EditContactDetailsDelegate
 */
@interface NGNotificationWebHandler : NSObject

+(NGNotificationWebHandler *)sharedInstance;

-(void)registerDevice:(NSDictionary*)params;

-(void)updateUser:(NSDictionary*)params;

/**
 *  Method is used to reset Push Notification Count on server database.
 *
 *  @param pushType Type of Push Notification.
 */
-(void)resetNotifications:(NSString*)pushType;
/**
 *  Method is used to get Push Notification Count from the server.
 */
-(void)getNotifications;
/**
 *  Method is used to delete Push Notification Count from the server database.
 */
-(void)deletePushNotificationCount;

@end
