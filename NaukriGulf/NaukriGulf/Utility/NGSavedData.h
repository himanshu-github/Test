//
//  NGSavedData.h
//  NaukriGulf
//
//  Created by Arun Kumar on 12/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGRescentSearchTuple.h"

@interface NGSavedData : NSObject



+ (void)saveEmailID:(NSString *)emailID;
+ (NSString *)getEmailID;

+(void)saveReadJobWithID:(NSString *)jobID;
+(NSMutableArray *)getAllReadJobsID;

+(void)saveSearchedJobCriteria: (NGRescentSearchTuple *)recentJob;
+(NSMutableArray *)getRecentJobs;
+(void)saveAllBadges:(NSArray *)arr;
+ (void)clearAllCookies;
+(void)deleteViewedDateForProfile;
+(void)setBoolForDuplicateApply:(BOOL)bool_;
+ (BOOL)isNewUserApplyPreviewAvailable;
+ (BOOL)allowRateUs;
+ (void)saveRemindMeLaterDate;
+ (void) saveUnregApplyFieldsDataDate:(NSDate*)paramDate;

+(void)saveDeviceToken:(NSString *)deviceToken;
+(NSString *)getDeviceToken;

+(void)DDDataBaseCreated:(BOOL )isCreated;
+(BOOL )getDDDatabaseCreated;

+(void)saveBadgeInfo:(NSString *)badgeType withBadgeNumber: (NSInteger) badgeNumber;
+(NSMutableDictionary *)getBadgeInfo;

+(void)saveUserDetails:(NSString *)fieldType withValue: (NSString *) value;
+(NSMutableDictionary *)getUserDetails;

+(void)saveViewedDateForProfile:(NSString *)date;
+(NSString *)getViewedDateForProfile;

+(void)saveLastSearch:(NSDictionary *)lastdict;
+(NSDictionary *)getLastSearch;

+(void)saveProfileNotificationUpdate:(NSDictionary*)dict;
+(NSDictionary*)getProfileNotificationUpdate;

 +(void)saveJDOpenedTime:(NSDate*)time;
 +(NSDate*)getJDOpenedTime;

 +(void)saveProductURL:(NSString*)url;
 +(NSString*)getProductURL;

+ (void)setTotalSimJobsCount:(NSString*)simJobsCount;
+ (NSInteger)getTotalSimJobsCount;

+(void)saveForgetPasswordMessage:(NSString*)msg;
+(NSString *)getForgetPasswordMessage;

+(void)saveMNJHomePageData:(NSDictionary *)dict;
+(NSDictionary *)getMNJHomePageData;

+(void)setIfSimJobsExistsForTheJob:(BOOL)value;
+(BOOL)getIfSimJobsExistsForTheJob;

+ (void)saveBadgeConsumedInfoWithType:(NSString *)badgeType isConsumed: (BOOL) isConsumed;
+(void)resetBadgeConsumedInfo;
+ (BOOL)isBadgeConsumedWithType:(NSString *)badgeType;

+ (NSString*)getProfileStatusForCheck;
+ (void)setProfileStatusForCheck:(NSString*)status;

+ (NSDate*)getLastSavedPullBlockerApiDate;
+ (void)savePullBlockerApiDate:(NSDate*)paramDate;

+ (BOOL)isApplyDataCached;
+ (void)setApplyDataCached:(BOOL)flag;

+ (void) blockAllNotifications:(BOOL)flag;
+(BOOL) areAllNotificationsBlocked;

+ (void)saveLastHitDateOfRecoJobsDownload:(NSDate*)paramDate;
+ (NSDate*)lastHitDateOfRecoJobsDownload;

+ (void)saveRecoJobBackgroundHitInterval:(NSNumber*)paramRecoJobHitInterval;
+ (NSNumber*)recoJobBackgroundHitInterval;

+ (void)saveSettingsAPILastHitDate:(NSDate*)paramDate;
+ (NSDate*)settingsAPILastHitDate;

+(NSString*)appVersionOfLastCacheResetRun;
+(void)setAppVersionOfLastCacheResetRunWithVersion:(NSString*)paramAppVersion;

+(void)saveResmanNotificationData:(NSDictionary*)paramDict;
+(NSDictionary*)resmanNotificationData;

+ (void)saveLastestSuccessHitDateForActiveUserStateAPI:(NSDate*)paramDate;
+ (NSDate*)lastestSuccessHitDateForActiveUserStateAPI;

+ (void)saveLocalNotificationFlagsData:(NSDictionary*)paramDict;
+ (NSDictionary*)localNotificationFlagsData;

+(void)saveWillShowCelebrationImageKeyValue:(NSNumber*)keyValue;
+(NSNumber*)willShowCelebrationImageKeyValue;

+(NSDictionary *)getCachedAppBlockerResponse;
+(void)saveAppBlockerResponse:(NSDictionary *)appBlockerDictionary;

+(void)saveLoggingEnabledKeyValue:(NSNumber*)keyValue;
+(NSNumber*)LoggingEnabledKeyValue;


@end
