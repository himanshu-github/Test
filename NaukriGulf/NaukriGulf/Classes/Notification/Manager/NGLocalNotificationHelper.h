//
//  NGLocalNotificationHelper.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 10/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NGLocalNotificationLaunchingFromState){
    NGLocalNotificationLaunchingFromStateNone,
    NGLocalNotificationLaunchingFromStateLaunch,
    NGLocalNotificationLaunchingFromStateBackground
};

typedef NS_ENUM(NSUInteger, NGLocalNotificationGA){
    NGLocalNotificationGANone = 0,
    NGLocalNotificationGAUploadProfilePic2DaySet,
    NGLocalNotificationGAUploadProfilePic2DayCancel,
    NGLocalNotificationGAUploadProfilePic2DayClick,
    
    
    NGLocalNotificationGAUploadProfilePicMonthlySet,
    NGLocalNotificationGAUploadProfilePicMonthlyCancel,
    NGLocalNotificationGAUploadProfilePicMonthlyClick,
    
    
    NGLocalNotificationGAEditCV1DaySet,
    NGLocalNotificationGAEditCV1DayCancel,
    NGLocalNotificationGAEditCV1DayClick,
    
    NGLocalNotificationGAEditCVMonthlySet,
    NGLocalNotificationGAEditCVMonthlyCancel,
    NGLocalNotificationGAEditCVMonthlyClick,
    
    
    NGLocalNotificationGANonLoggedInUser12HourSet,
    NGLocalNotificationGANonLoggedInUser12HourCancel,
    NGLocalNotificationGANonLoggedInUser12HourClick,
    
    
    NGLocalNotificationGANonLoggedInUserWeeklySet,
    NGLocalNotificationGANonLoggedInUserWeeklyCancel,
    NGLocalNotificationGANonLoggedInUserWeeklyClick,
    
    
    NGLocalNotificationGALoggedInInactiveUserMonthlySet,
    NGLocalNotificationGALoggedInInactiveUserMonthlyCancel,
    NGLocalNotificationGALoggedInInactiveUserMonthlyClick
};

@interface NGLocalNotificationHelper : NSObject

@property(nonatomic,readwrite) NGLocalNotificationLaunchingFromState launchingFromState;

/**
 * Returns the singleton instance.
 *
 *  @return Singleton Instance
 */
+(NGLocalNotificationHelper *)sharedInstance;
-(void)setLNConfigFromLaunchOption:(NSDictionary*)paramLaunchOption;
-(void)validateAndSetLNWithNotification:(UILocalNotification*)paramLNData;
-(void)handleLocalNotification;
-(void)cancelAllLocalNotifications;
-(void)cancelLocalNotificationsForLoggedInUser;
-(void)cancelLocalNotificationsForNonLoggedInUser;


+  (void)scheduleLocalNotificationForDate:(NSDate*)paramDate alertBody:(NSString*)paramAlertBody alertAction:(NSString*)paramAlertAction ApplicationBadge:(NSUInteger)paramAppBadge andUserInfo:(NSDictionary*)paramUserInfo;

+ (void)scheduleLocalNotificationForDate:(NSDate*)paramDate alertBody:(NSString*)paramAlertBody alertAction:(NSString*)paramAlertAction ApplicationBadge:(NSUInteger)paramAppBadge WithRepetitionOn:(BOOL)paramIsRepeatingAlert RepeatingType:(NSCalendarUnit)paramRepeatingUnit andUserInfo:(NSDictionary*)paramUserInfo;

+ (void)scheduleLocalNotificationForDate:(NSDate*)paramDate alertBody:(NSString*)paramAlertBody alertAction:(NSString*)paramAlertAction andUserInfo:(NSDictionary*)paramUserInfo;
@end
