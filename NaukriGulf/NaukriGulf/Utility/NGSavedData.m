//
//  NGSavedData.m
//  NaukriGulf
//
//  Created by Arun Kumar on 12/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSavedData.h"




@implementation NGSavedData

+(void)saveEmailID:(NSString *)emailID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:emailID forKey:KEY_EMAIL_ID];
    [defaults synchronize];
}

+(NSString *)getEmailID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *emailID = [defaults objectForKey:KEY_EMAIL_ID];
    return emailID;
}

+(void)saveReadJobWithID:(NSString *)jobID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [defaults objectForKey:KEY_READ_JOBS];
    NSMutableArray *finalArr;
    if (arr==nil) {
        finalArr = [[NSMutableArray alloc]init];
    }else{
        finalArr = [[NSMutableArray alloc]initWithArray:arr];
    }
    [finalArr addObject:jobID];
    [finalArr removeDuplicateObjects];
    [defaults setObject:finalArr forKey:KEY_READ_JOBS];
    [defaults synchronize];
}

+(NSMutableArray *)getAllReadJobsID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [defaults objectForKey:KEY_READ_JOBS];
    
    return arr;
}

+(void)saveJDOpenedTime:(NSDate*)time {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:time forKey:@"JDOpenedTime"];
    [defaults synchronize];
    
}

+(NSDate*)getJDOpenedTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"JDOpenedTime"];
}

+(void)setIfSimJobsExistsForTheJob:(BOOL)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:IF_SIMLAR_JOBS_EXISTS];
    [defaults synchronize];
    
}

+(BOOL)getIfSimJobsExistsForTheJob
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:IF_SIMLAR_JOBS_EXISTS];
}

#pragma mark Recent Jobs Part


+(void)saveSearchedJobCriteria:(NGRescentSearchTuple *)recentJob{
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:recentJob];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *arr = [defaults objectForKey:KEY_RECENT_SEARCH];
    NSMutableArray *finalArr;

    if (arr==nil) {
        finalArr = [[NSMutableArray alloc] init];
    }
    else{
        
        NSMutableArray *tempArr = [NSKeyedUnarchiver unarchiveObjectWithData:arr];
       
        if (tempArr != nil)
            finalArr = [[NSMutableArray alloc] initWithArray:tempArr];
        else
            finalArr = [[NSMutableArray alloc] init];
    }
    
    BOOL addToRecentsearch=TRUE;
    
    for (int i=0; i<finalArr.count; i++)
    {
        NGRescentSearchTuple* touple=[NSKeyedUnarchiver unarchiveObjectWithData:[finalArr fetchObjectAtIndex:i] ];
        if ([touple.keyword isEqualToString:recentJob.keyword] && [touple.location isEqualToString:recentJob.location] && [touple.experience integerValue]==[recentJob.experience integerValue])
        {
            addToRecentsearch=FALSE;
        }
    }
    if (addToRecentsearch)
        [finalArr addObject:encodedObject];
    
    if (finalArr.count == 6) {
        // The number 6   ^ is configurable here
        [finalArr removeObjectAtIndex:0];
    }
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:finalArr] forKey:KEY_RECENT_SEARCH];
    [defaults synchronize];
}

+ (NSMutableArray *)getRecentJobs{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *arr = [defaults objectForKey:KEY_RECENT_SEARCH];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    if (arr == nil) {
        //Do Something
    }
    else{
         tempArr = [NSKeyedUnarchiver unarchiveObjectWithData:arr];
        
        for (int i = 0; i<tempArr.count; i++) {
            NSData *myEncodedObject = tempArr[i];
            NGRescentSearchTuple *obj = (NGRescentSearchTuple *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
            tempArr[i] = obj;
        }

    }
    
        
    return tempArr;
}

+ (void)saveDeviceToken:(NSString *)deviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:KEY_DEVICE_TOKEN];
    [defaults synchronize];
}

+ (NSString *)getDeviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:KEY_DEVICE_TOKEN];
    return deviceToken;
}
+(void)DDDataBaseCreated:(BOOL )isCreated{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isCreated] forKey:KEY_DD_DATABASE_CREATED];
    [defaults synchronize];
}
+(BOOL )getDDDatabaseCreated{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:KEY_DD_DATABASE_CREATED];
    return num.boolValue;

}
+ (void)saveForgetPasswordMessage:(NSString*)msg
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:msg forKey:KEY_FORGET_PWD];
    [defaults synchronize];
}

+ (NSString *)getForgetPasswordMessage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *msg = [defaults objectForKey:KEY_FORGET_PWD];
    return msg;
}


+ (void)saveBadgeInfo:(NSString *)badgeType withBadgeNumber: (NSInteger) badgeNumber{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [defaults objectForKey:KEY_BADGE_INFO];
    NSMutableDictionary *finalDict = nil;
    if (dict) {
        finalDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    else{
        finalDict = [NSMutableDictionary dictionary];
    }
    [finalDict setCustomObject:[NSNumber numberWithInteger:badgeNumber] forKey:badgeType];
    [defaults setObject:finalDict forKey:KEY_BADGE_INFO];
    [defaults synchronize];
}

+ (void)saveAllBadges:(NSArray *)arr{
    for (NSInteger i = 0; i<arr.count; i++) {
        NSDictionary *dict = [arr fetchObjectAtIndex:i];
        
        NSString *pushType = [dict objectForKey:@"pushType"];
        NSInteger pushCount = [[dict objectForKey:@"pushCount"]integerValue];
        
        [NGSavedData saveBadgeInfo:pushType withBadgeNumber:pushCount];
    }
}

+ (NSMutableDictionary *)getBadgeInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [defaults objectForKey:KEY_BADGE_INFO];
    return dict;
}


+ (void)saveUserDetails:(NSString *)fieldType withValue: (NSString *) value{
    
    if ([@"profileModifiedTimeStamp" isEqualToString:fieldType]) {
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [defaults objectForKey:KEY_USER_DETAILS];
    NSMutableDictionary *finalDict = nil;
    if (dict) {
        finalDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    else{
        finalDict = [NSMutableDictionary dictionary];
    }
    [finalDict setCustomObject:value forKey:fieldType];
    [defaults setObject:finalDict forKey:KEY_USER_DETAILS];
    [defaults synchronize];
}

+ (NSMutableDictionary *)getUserDetails{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [defaults objectForKey:KEY_USER_DETAILS];
    return dict;
}

+ (void)setTotalSimJobsCount:(NSString*)simJobsCount
{
    [[NSUserDefaults standardUserDefaults] setObject:simJobsCount forKey:@"TotalSimJobsCount"];
}

+ (NSInteger)getTotalSimJobsCount
{
    NSString* simJobsCount=[[NSUserDefaults standardUserDefaults] valueForKey:@"TotalSimJobsCount"];
    return [simJobsCount integerValue];
}

+ (void)setBoolForDuplicateApply:(BOOL)bool_
{
    [[NSUserDefaults standardUserDefaults] setBool:bool_ forKey:KEY_DUPLICATE_APPLY];
}

+ (void)clearAllCookies{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];//
    [defaults setObject:[NSDictionary dictionary] forKey:KEY_USER_DETAILS];    
    [defaults synchronize];
    
    [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_JA withBadgeNumber:0];
    [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_PV withBadgeNumber:0];
    [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_PU withBadgeNumber:0];
    [NGSavedData saveMNJHomePageData:nil];
}

+ (void)saveViewedDateForProfile:(NSString *)date;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:date forKey:KEY_CURRENT_VIEW_DATE];
    [defaults synchronize];
}

+ (NSString *)getViewedDateForProfile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *viewedDate = [defaults objectForKey:KEY_CURRENT_VIEW_DATE];
    return viewedDate;
}

+ (void)deleteViewedDateForProfile
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:KEY_CURRENT_VIEW_DATE];
    [defaults synchronize];
}

+ (void)saveLastSearch:(NSDictionary *)lastdict{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lastdict forKey:KEY_LAST_SEARCH];
    [defaults synchronize];
}

+ (NSDictionary *)getLastSearch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:KEY_LAST_SEARCH];
    return dict;
}

+ (void)saveProfileNotificationUpdate:(NSDictionary*)dict
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:KEY_PROFILE_UPDATE];
    [defaults synchronize];
}

+ (NSDictionary*)getProfileNotificationUpdate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:KEY_PROFILE_UPDATE];
    return dict;
}

+ (void)saveProductURL:(NSString*)url{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([url class]==[NSNull class])
        [defaults setObject:PRODUCT_UPDATE_STATIC_URL forKey:KEY_PRODUCT_URL];
    
    else
        [defaults setObject:url forKey:KEY_PRODUCT_URL];
    
    [defaults synchronize];
}

+ (NSString*)getProductURL{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [defaults objectForKey:KEY_PRODUCT_URL];
    if (!url || url.length==0) {
        url = PRODUCT_UPDATE_STATIC_URL;
    }
    return url;
}

+ (void)saveMNJHomePageData:(NSDictionary *)dict{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:KEY_MNJ_HOME_PAGE_DATA];
    [defaults synchronize];
}

+ (NSDictionary *)getMNJHomePageData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:KEY_MNJ_HOME_PAGE_DATA];
    return dict;
}

+ (BOOL)isNewUserApplyPreviewAvailable {
    
    NGApplyFieldsModel *model = [[DataManagerFactory getStaticContentManager] getApplyFields];
    if (model) {
        return YES;
    }
    return NO;
}


+ (void)resetBadgeConsumedInfo{
    [NGSavedData saveBadgeConsumedInfoWithType:KEY_BADGE_TYPE_JA isConsumed:FALSE];
    [NGSavedData saveBadgeConsumedInfoWithType:KEY_BADGE_TYPE_PV isConsumed:FALSE];
}
+ (void)saveBadgeConsumedInfoWithType:(NSString *)badgeType isConsumed: (BOOL) isConsumed{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [defaults objectForKey:KEY_BADGE_CONSUMED_INFO];
    NSMutableDictionary *finalDict = nil;
    if (dict) {
        finalDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    else{
        finalDict = [NSMutableDictionary dictionary];
    }
    [finalDict setCustomObject:[NSNumber numberWithBool:isConsumed] forKey:badgeType];
    [defaults setObject:finalDict forKey:KEY_BADGE_CONSUMED_INFO];
    [defaults synchronize];
}


+ (BOOL)isBadgeConsumedWithType:(NSString *)badgeType{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [defaults objectForKey:KEY_BADGE_CONSUMED_INFO];
    
    if (dict) {
        return [[dict objectForKey:badgeType]boolValue];
    }
    return FALSE;
}



+ (NSString*)getProfileStatusForCheck{
    
    NSString* strTemp =  [[NSUserDefaults standardUserDefaults]objectForKey:K_PROFILE_SIX_MONTH_OLD];
    
    if ([NGDecisionUtility isValidNonEmptyNotNullString:strTemp])
        return [[NSUserDefaults standardUserDefaults] objectForKey:K_PROFILE_SIX_MONTH_OLD];
    else
        [[NSUserDefaults standardUserDefaults]setObject:@"true" forKey:K_PROFILE_SIX_MONTH_OLD];
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:K_PROFILE_SIX_MONTH_OLD];
}

+ (void)setProfileStatusForCheck:(NSString*)status{
    
    NSString* strTemp = [NGSavedData getProfileStatusForCheck];
    
    if ([NGDecisionUtility isValidNonEmptyNotNullString:strTemp])
        [[NSUserDefaults standardUserDefaults]setObject:status forKey:K_PROFILE_SIX_MONTH_OLD];
    else
        [[NSUserDefaults standardUserDefaults]setObject:@"true" forKey:K_PROFILE_SIX_MONTH_OLD];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+  (BOOL)allowRateUs{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dictRateUs = [defaults objectForKey:K_KEY_RATING];
    NSString* lastAppearedDate = [dictRateUs objectForKey:K_KEY_RATING_LATER];
    
    if ([NGDateManager daysDiffrence:lastAppearedDate] >= K_RATING_DAYS_LIMIT ||
        ![[defaults objectForKey:K_KEY_ALLOW_RATING] intValue])
        return YES;
    else
        return NO;
    
}
+ (void)saveRemindMeLaterDate{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [defaults objectForKey:K_KEY_RATING];
    NSMutableDictionary *finalDict = nil;
    
    if (dict)
        finalDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    else
        finalDict = [NSMutableDictionary dictionary];
    
    
    NSDate *today = [NSDate date];
    NSString *todayDateString = [NGDateManager stringFromDate:today WithDateFormat:@"yyyy-MM-dd"];
    [finalDict setCustomObject:todayDateString forKey:K_KEY_RATING_LATER];
    [defaults setObject:finalDict forKey:K_KEY_RATING];
    [defaults synchronize];
    
}
+ (void)savePullBlockerApiDate:(NSDate*)paramDate{
    
    if(paramDate)
        [[NSUserDefaults standardUserDefaults] setObject:paramDate forKey:K_PULL_BLOCKER_API_SAVED_DATE];
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_PULL_BLOCKER_API_SAVED_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate*) getLastSavedPullBlockerApiDate{
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:K_PULL_BLOCKER_API_SAVED_DATE]) {
        return [NSDate dateWithTimeIntervalSince1970:0];
    }
    return [[NSUserDefaults standardUserDefaults]objectForKey:K_PULL_BLOCKER_API_SAVED_DATE];
}

+ (void)saveSettingsAPILastHitDate:(NSDate*)paramDate{
    if(paramDate){
        [[NSUserDefaults standardUserDefaults] setObject:paramDate forKey:K_SETTINGS_API_LAST_HIT_DATE];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_SETTINGS_API_LAST_HIT_DATE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSDate*)settingsAPILastHitDate{
    NSDate *tmpDate = [[NSUserDefaults standardUserDefaults]objectForKey:K_SETTINGS_API_LAST_HIT_DATE];
    return tmpDate?tmpDate:[NSDate dateWithTimeIntervalSince1970:0];
}
#pragma mark - Unreg Apply Data
+ (BOOL)isApplyDataCached{
    return [[NSUserDefaults standardUserDefaults]boolForKey:K_APPLY_CACHE_AVAILABLE];
}
+ (void)setApplyDataCached:(BOOL)flag{
    
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:K_APPLY_CACHE_AVAILABLE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveUnregApplyFieldsDataDate:(NSDate*)paramDate{
    
    if(paramDate)
        [[NSUserDefaults standardUserDefaults] setObject:paramDate forKey:K_UNREG_DATA_DATE];
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_UNREG_DATA_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate*) getLastSavedUnregApplyFieldsDataDate{
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:K_UNREG_DATA_DATE]) {
        return [NSDate date];
    }
    return [[NSUserDefaults standardUserDefaults]objectForKey:K_UNREG_DATA_DATE];
}
+ (void) blockAllNotifications:(BOOL) flag {
    
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:K_PULL_BLOCKER_BACKGROUND_SETTING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) areAllNotificationsBlocked{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:K_PULL_BLOCKER_BACKGROUND_SETTING];
}
+ (void)saveLastHitDateOfRecoJobsDownload:(NSDate*)paramDate{
    if(paramDate){
        [[NSUserDefaults standardUserDefaults] setObject:paramDate forKey:K_LAST_HIT_DATE_OF_RECOJOBS_DOWNLOAD];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_LAST_HIT_DATE_OF_RECOJOBS_DOWNLOAD];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSDate*)lastHitDateOfRecoJobsDownload{
    NSDate *tmpDate = [[NSUserDefaults standardUserDefaults]objectForKey:K_LAST_HIT_DATE_OF_RECOJOBS_DOWNLOAD];
    return tmpDate?tmpDate:[NSDate dateWithTimeIntervalSince1970:0];
}

+ (void)saveRecoJobBackgroundHitInterval:(NSNumber*)paramRecoJobBackgroundHitInterval{
    [[NSUserDefaults standardUserDefaults] setObject:paramRecoJobBackgroundHitInterval forKey:K_KEY_RECO_JOB_BACKGROUND_HIT_INTERVAL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSNumber*)recoJobBackgroundHitInterval{
    //This interval is in hours
    id savedValue = [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_RECO_JOB_BACKGROUND_HIT_INTERVAL];
    return savedValue?savedValue:@43200;// by default interval is 12 * 60 * 60 seconds
}
+ (NSString*)appVersionOfLastCacheResetRun{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] objectForKey:K_APP_VERSION_OF_LAST_CACHE_RUN];
    return savedValue;
}
+ (void)setAppVersionOfLastCacheResetRunWithVersion:(NSString*)paramAppVersion{
    [[NSUserDefaults standardUserDefaults] setObject:paramAppVersion forKey:K_APP_VERSION_OF_LAST_CACHE_RUN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)saveResmanNotificationData:(NSDictionary*)paramDict{
    if (nil != paramDict) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:paramDict forKey:KEY_RESMAN_NOTIFICATION_SAVE_DATA];
        [defaults synchronize];
    }
}
+ (NSDictionary*)resmanNotificationData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:KEY_RESMAN_NOTIFICATION_SAVE_DATA];
    return dict;
}
+ (void)saveLastestSuccessHitDateForActiveUserStateAPI:(NSDate*)paramDate{
    [[NSUserDefaults standardUserDefaults] setObject:paramDate forKey:K_LAST_SUCCESS_HIT_DATE_ACTIVE_USER_STATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSDate*)lastestSuccessHitDateForActiveUserStateAPI{
    NSDate *tmpDate = (NSDate*)[[NSUserDefaults standardUserDefaults] objectForKey:K_LAST_SUCCESS_HIT_DATE_ACTIVE_USER_STATE];
    return nil==tmpDate?[NSDate dateWithTimeIntervalSince1970:0]:tmpDate;
}
+ (void)saveLocalNotificationFlagsData:(NSDictionary*)paramDict{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:paramDict forKey:KEY_LOCAL_NOTIFICATION_FLAG_SAVE_DATA];
    [defaults synchronize];
}
+ (NSDictionary*)localNotificationFlagsData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:KEY_LOCAL_NOTIFICATION_FLAG_SAVE_DATA];
    return dict;
}
#pragma mark - Celebration Image Key
+(void)saveWillShowCelebrationImageKeyValue:(NSNumber*)keyValue{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:keyValue forKey:KEY_CELEBRATION_IMAGE];
    [defaults synchronize];
}
+(NSNumber*)willShowCelebrationImageKeyValue{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:KEY_CELEBRATION_IMAGE];
    return num;
}
#pragma mark - isLoggingEnable  Key
+(void)saveLoggingEnabledKeyValue:(NSNumber*)keyValue{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:keyValue forKey:KEY_LOGGING_ENABLED];
    [defaults synchronize];
}
+(NSNumber*)LoggingEnabledKeyValue{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:KEY_LOGGING_ENABLED];
    return num;
}
+(NSDictionary *)getCachedAppBlockerResponse{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:K_APP_BLOCKER_CACHE_RESPONSE];
}

+(void)saveAppBlockerResponse:(NSDictionary *)appBlockerDictionary{
    
    if(appBlockerDictionary == nil){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_APP_BLOCKER_CACHE_RESPONSE];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:appBlockerDictionary forKey:K_APP_BLOCKER_CACHE_RESPONSE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end
