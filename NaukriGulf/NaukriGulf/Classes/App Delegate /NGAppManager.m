//
//  NGAppManager.m
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGAppManager.h"
#import "DropDown.h"
#import <MobileAppTracker/MobileAppTracker.h>
#import <AdSupport/AdSupport.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "NGAppBlockHandler.h"
#import "NGSettingsHelper.h"
#import "ACTReporter.h"
#import "NGStaticDDCoreDataLayer.h"
#import "GTMOAuth2ViewControllerTouch.h"

#import "DDCountry.h"
#import "WatchOSAndiOSCommunicationLayer.h"
#import <DropboxSDK/DropboxSDK.h>

@interface NGAppManager(){
    
}

@end

@implementation NGAppManager

+ (void) applicationLaunch
{
    [NGAppManager iniitialOperations];
    [NGAppManager applicationLaunchUICustomization];
    [NGAppManager libarariesInitialization];
    [NGAppManager checkAndSetParameters];
    [NGAppManager checkIfUserHasRecentlyUpdatedTheApp];

}

+ (void) applicationLaunch:(NSDictionary *)launchOptions
{
    NGSpotlightSearchHelper* spotlightHelper = [NGSpotlightSearchHelper sharedInstance];
    [spotlightHelper setSpotlightConfigFromLaunchOption:launchOptions];
    
    NGDeepLinkingHelper *deeplinkingHelper = [NGDeepLinkingHelper sharedInstance];
    [deeplinkingHelper setDeeplinkingConfigFromLaunchOption:launchOptions];

    NGLocalNotificationHelper *lnHelper = [NGLocalNotificationHelper sharedInstance];
    [lnHelper setLNConfigFromLaunchOption:launchOptions];
    
    NGNotificationAppHandler *pnHandler = [NGNotificationAppHandler sharedInstance];
    [pnHandler setPushNotificationConfigFromLaunchOption:launchOptions];
    
    WatchOSAndiOSCommunicationLayer* commLayer = [WatchOSAndiOSCommunicationLayer sharedInstance];
    [commLayer activateSession];
    
    if (![NGHelper sharedInstance].isUserLoggedIn) {
        [[NGNotificationWebHandler sharedInstance] deletePushNotificationCount];
    }
    [[NGNotificationWebHandler sharedInstance] getNotifications];
}


+(void) awakeLibararies
{
    [NGGoogleAnalytics appEnteredBackground:NO];
    [FBSDKAppEvents activateApp];
    [Tune measureSession];
}

+(void) fetchDataOnAwake
{
    
    [[NGAppBlockHandler sharedInstance] performActionOverStoredAppBlockerResponse];

    //pull blocker , once in a day
    //Delay execution of fetchAppBlockerSettings block for 3 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,   NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if ([NGDateManager isDate: [NGSavedData getLastSavedPullBlockerApiDate] nDaysOld:1])
            [[NGAppBlockHandler sharedInstance]fetchAppBlockerSettings];
    });
    
    
    if ([NGDateManager isDate: [NGSavedData settingsAPILastHitDate] nDaysOld:1])
        [[NGSettingsHelper sharedInstance] fetchSettingsFromServer];
    
    if([ [NGHelper sharedInstance] isUserLoggedIn] &&
       [NGDateManager isDate:[NGSavedData lastestSuccessHitDateForActiveUserStateAPI] nDaysOld:1])
    {
        [NGAppManager doUserActiveStateRequest];
    }
}

+ (void)deviceRegistrationSucceed:(NSString *)newToken
{
    newToken = [newToken trimCharctersInSet :[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [NGSavedData saveDeviceToken:newToken];
    NSString *deviceID = [[NSString getUniqueDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([NGHelper sharedInstance].isUserLoggedIn) {
        [[NGNotificationWebHandler sharedInstance]registerDevice:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",newToken,@"tokenId",[NSNumber numberWithBool:1],@"loginStatus",[NSString getAppVersion],@"appVersion" ,nil]];
    }else{
        [[NGNotificationWebHandler sharedInstance]registerDevice:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",newToken,@"tokenId",deviceID,@"deviceId",[NSString getAppVersion],@"appVersion", nil]];
    }
}

#pragma mark Helper Methods

+ (void) iniitialOperations
{
    NSSetUncaughtExceptionHandler(&handleException);
    [ACTConversionReporter reportWithConversionID:KEY_GOOGLE_CONVERSION_ID label:KEY_GOOGLE_CONVERSION_LABEL value:KEY_GOOGLE_CONVERSION_VALUE currencyCode:@"INR" isRepeatable:NO];

    [[NGStaticDDCoreDataLayer sharedInstance] managedObjectContext];
    [[NGStaticDDCoreDataLayer sharedInstance] managedObjectContext];

    [NGAppManager checkAppVersionAndResetCacheData];
    [NGAppManager initialseAppTracer];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [NGSavedData setProfileStatusForCheck:@"true"];
    [NGExceptionHandler initiateExceptionLoggingTimer];
  
}
+(void)initialseAppTracer{
    if([(NSString*)([[NSBundle mainBundle] infoDictionary][@"isDebugMode"]) boolValue]){
        [AppTracer setLogType:TraceLoadTime|TraceApi|TraceCrashesAndExceptions];
        [AppTracer setMode:ON];
    }
    else
        [AppTracer setMode:OFF];

}

+ (void) applicationLaunchUICustomization
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
        
        [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
        
    }
    
    [NGAppManager customizeNavigationBar];
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    [NGHelper sharedInstance].screenSize = appRect.size;
    
    
}

+(void) libarariesInitialization
{
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:DROPBOX_APP_KEY
                            appSecret:DROPBOX_APP_SECRET_KEY
                            root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    [NGGoogleAnalytics initialiseGoogleAnalytics];
    
    [Tune setDelegate:(id<TuneDelegate>)self];
    [Tune initializeWithTuneAdvertiserId:MAT_ADVERTISER_ID tuneConversionKey:MAT_CONVERSION_KEY];
    [Tune setAppleAdvertisingIdentifier:[[ASIdentifierManager sharedManager] advertisingIdentifier] advertisingTrackingEnabled:[[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]];
    
    [FBSDKSettings setAppID:FB_APP_ID];//For MAT
    
}




+(void)doUserActiveStateRequest
{
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_USER_ACTIVE_STATE];
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"markactive"
                                                                           }] handler:^(NGAPIResponseModal *responseData) {
        
        if (responseData.isSuccess) {
            if(K_RESPONSE_SUCESS_WITHOUT_BODY == responseData.responseCode){
                [NGSavedData saveLastestSuccessHitDateForActiveUserStateAPI:[NSDate date]];
            }
        }
    }];
}

+(void)customizeNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x403E3F)];
}


+(void)checkAppVersionAndResetCacheData{
    //1. Get current app version
    NSString *currentAppVersion = [NSString getAppVersion];
    
    //2. Get app version for which cache reset run
    NSString *appVersionOfLastCacheResetRun =  [NGSavedData appVersionOfLastCacheResetRun];
    
    if (![appVersionOfLastCacheResetRun isEqualToString:currentAppVersion]) {
        //NOTE:This object is just storing basic details and conmnj values
        
        [NGSavedData saveMNJHomePageData:nil];
        
        NGStaticContentManager* staticContentMngr = [DataManagerFactory getStaticContentManager];
        [staticContentMngr deleteAllRecommendedJobs];
        [staticContentMngr deleteAllProfileViews];
        [staticContentMngr deleteMNJUserProfile];
        
        [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME];
        [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];

        [NGSavedData deleteViewedDateForProfile];
        //4.after clearing cache save current version as old version
        [NGSavedData setAppVersionOfLastCacheResetRunWithVersion:currentAppVersion];
        if(nil==appVersionOfLastCacheResetRun)
        {
            [[NGLocalNotificationHelper sharedInstance] cancelAllLocalNotifications];
        }
        else
        {
            if ([NGHelper sharedInstance].isUserLoggedIn)
            {
                //cancel local notifications for non-loggedIn user only
                [[NGLocalNotificationHelper sharedInstance] cancelLocalNotificationsForNonLoggedInUser];
            }
            else
            {
                //cancel local notifications for loggedIn user only
                [[NGLocalNotificationHelper sharedInstance] cancelLocalNotificationsForLoggedInUser];
            }
        }
    }
}
+(void)checkIfUserHasRecentlyUpdatedTheApp{

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL versionUpgraded;
    NSString *version = [NSString getAppVersion];
    NSString *preVersion = [prefs stringForKey:@"appVersion"];

    if ([prefs stringForKey:@"appVersion"] != nil) {
        //see if version is the same as prior
        //if not it is an Upgraded
        versionUpgraded = !([preVersion isEqualToString: version]);
    } else {
        //nil means new install
        //This needs to be YES for the case that
        //"appVersion" is not set anywhere else.
        versionUpgraded = YES;
    }
    
    if (versionUpgraded) {
        [prefs setObject:version forKey:@"appVersion"];
        [prefs setObject:preVersion forKey:@"prevAppVersion"];
        [prefs synchronize];
        [NGLoginHelper sendAppleWatchUserDetails];
        //logout dropbox for upgraded version
        [[DBSession sharedSession] unlinkAll];
        //remove google drive link
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemNameForGoogleDrive];
        [NGSavedData DDDataBaseCreated:FALSE];

        NSLog(@"Version Upgraded");
        
    }

}
+(void)registerForRemoteNotification:(UIApplication *)application{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
}

+(void) checkAndSetParameters
{
    NSDictionary *dict = [NGSavedData getUserDetails];
    NSString *conmnj = [dict objectForKey:@"conmnj"];
    if (conmnj)
        [NGHelper sharedInstance].isUserLoggedIn = TRUE;
    else
        [NGHelper sharedInstance].isUserLoggedIn = FALSE;
    
    [NGSavedData setIfSimJobsExistsForTheJob:FALSE];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:K_GA_APP_LAUNCH_COUNT])
    {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:K_GA_APP_LAUNCH_COUNT];
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY_APP_LAUNCH_COUNT withEventAction:K_GA_EVENT_APP_LAUNCH withEventLabel:K_GA_EVENT_APP_LAUNCH withEventValue:nil];
        [Tune setExistingUser:NO];
    }
    else
        [Tune setExistingUser:YES];
    
    [NGSavedData resetBadgeConsumedInfo];
}

#pragma mark Exception Handler
static void handleException(NSException *exception)
{
    
    IENavigationController*navbAR = (IENavigationController*) APPDELEGATE.container.centerViewController;
    
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    
    [NGGoogleAnalytics sendExceptionWithDescription:[NSString stringWithFormat:@"NSArray Fetch Object Exception: %@ %@ %s %@ %@",exception.name, exception.description,__PRETTY_FUNCTION__,navbAR.topViewController, [NSString stringWithFormat:@"Trace %@ %@",[array objectAtIndex:3],[array objectAtIndex:4] ]] withIsFatal:YES];
    
    [NGExceptionHandler logException:exception withTopView:NSStringFromClass(navbAR.topViewController.class)];
}

@end
