//
//  NGAppDelegate.m
//  NaukriGulf
//
//  Created by Arun Kumar on 21/05/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//


#import "NGAppDelegate.h"
#import <MobileAppTracker/MobileAppTracker.h>
#import "NGBackgroundFetchHelper.h"
#import "NGSpotlightSearchHelper.h"
#import "NGNetworkStatusView.h"
#import "NGViewController.h"
#import "NGShortCutHandler.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "NGBlockThisIPView.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <DropboxSDK/DropboxSDK.h>

@interface NGAppDelegate()
{
    
    BOOL appComingFromBackgroundFlagForOpenWithTypeDocument;
}

@end

@implementation NGAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NGAppManager applicationLaunch];
    [NGAppManager applicationLaunch:launchOptions];
    [NGAppManager registerForRemoteNotification:application];
    self.container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    [self.container setCenterViewController:[[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"navigationController"]];
    ((IENavigationController*)self.container.centerViewController).navigationBar.translucent = NO;
    [self addObserverForNetworkRechabilityChange];
    [self addObserverForIPBlockServerError];
    
    [[WatchOSAndiOSCommunicationLayer sharedInstance] sendLoginStatusToWatch:[NGHelper sharedInstance].isUserLoggedIn];
    
  //  [[FBSDKApplicationDelegate sharedInstance] application:application  didFinishLaunchingWithOptions:launchOptions];//For Social Login

    return YES;
}
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [[NGShortCutHandler sharedInstance] handleShortcutWithIdentifier:shortcutItem.type];
}

#pragma mark -
#pragma mark - Network Check
-(void)addObserverForNetworkRechabilityChange{
    
    [[NSNotificationCenter defaultCenter] removeObserver:kReachabilityChangedNotif];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotif object:nil];
    [NGDecisionUtility checkNetworkStatus];
    
}
-(void) checkNetworkStatus:(NSNotification *)notice
{
    Reachability *reachabilityStatus = notice.object;    
    NetworkStatus internetStatus = [reachabilityStatus currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            [NGHelper sharedInstance].isNetworkAvailable = NO;
            [self showSingletonNetworkErrorLayer];
            break;
       
        }
        case ReachableViaWiFi:
        {
            [NGHelper sharedInstance].isNetworkAvailable = YES;
            [self removeSingletonNetworkErrorLayer];
            break;
        }
        case ReachableViaWWAN:
        {
            [NGHelper sharedInstance].isNetworkAvailable = YES;
            [self removeSingletonNetworkErrorLayer];
            break;
        }
    }

}
-(void)showSingletonNetworkErrorLayer{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeSingletonNetworkErrorLayer) object:nil];
    NSArray *navArr =[(IENavigationController*)[(MFSideMenuContainerViewController*)APPDELEGATE.window.rootViewController centerViewController] viewControllers];
    UIViewController *topVC = nil;
    if(navArr.count>0)
    topVC = [navArr lastObject];
    
    if(topVC!=nil)
    {
    if([topVC isKindOfClass:[NGViewController class]])
    {
        return;
    }
    }
    
    UIView *netView = [NGNetworkStatusView sharedInstance];
    [APPDELEGATE.window addSubview:netView];
    CGPoint fadeInToPoint;
    fadeInToPoint = CGPointMake(netView.center.x, 64.0f+CGRectGetHeight(netView.frame)/2.f);
    [UIView animateWithDuration:0.5 animations:^
     {
        netView.center = fadeInToPoint;
     } completion:^(BOOL finished)
     {
     }];
}
-(void)removeSingletonNetworkErrorLayer{
    UIView *netView = [NGNetworkStatusView sharedInstance];
    CGPoint fadeOutToPoint;
    fadeOutToPoint = CGPointMake(netView.center.x, -CGRectGetHeight(netView.frame));
    [UIView animateWithDuration:0.5 animations:^
     {
         netView.center = fadeOutToPoint;
     } completion:^(BOOL finished)
     {
         [[NGNetworkStatusView sharedInstance] removeFromSuperview];
     }];

}
#pragma mark- IP Block Server Error
-(void)addObserverForIPBlockServerError{
    [[NSNotificationCenter defaultCenter] removeObserver:BLOCK_IP_NOTIFICATION_OBSERVER];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlockTheIPMessage:) name:BLOCK_IP_NOTIFICATION_OBSERVER object:nil];

}
-(void) showBlockTheIPMessage:(NSNotification *)notice{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([NGBlockThisIPView sharedInstance].isViewShowing == FALSE)
            [[NGBlockThisIPView sharedInstance] showBlockIPView];
    });
}
#pragma mark -
#pragma mark AppDelegate Methods

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [NGAppManager deviceRegistrationSucceed:[deviceToken description]];
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    if (application.applicationState == UIApplicationStateActive)
         [NGNotificationAppHandler sharedInstance].performPushNotificationWithDesiredPageLanding = NO;
    else
         [NGNotificationAppHandler sharedInstance].performPushNotificationWithDesiredPageLanding = YES;
    
    [[NGNotificationAppHandler sharedInstance] validateAndSetPushNotificationWithDictionary:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(application.applicationState != UIApplicationStateActive )
        [[NGLocalNotificationHelper sharedInstance] validateAndSetLNWithNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [NGUIUtility modifyBadgeOnIcon:[NGUIUtility getAllNotificationsCount]];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [NGUIUtility modifyBadgeOnIcon:[NGUIUtility getAllNotificationsCount]];
    [[NGResmanNotificationHelper sharedInstance] checkAndManageResmanNotificationForAppState:NGResmanNotificationAppStateBackground];
    [NGGoogleAnalytics appEnteredBackground:YES];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    appComingFromBackgroundFlagForOpenWithTypeDocument = YES;
    [NGUIUtility modifyBadgeOnIcon:[ NGUIUtility getAllNotificationsCount]];
    [[NGNotificationWebHandler sharedInstance] getNotifications];
    [NGSavedData resetBadgeConsumedInfo];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [NGAppManager awakeLibararies];
    [NGAppManager fetchDataOnAwake];
    [[NGResmanNotificationHelper sharedInstance] checkAndManageResmanNotificationForAppState:NGResmanNotificationAppStateActive];
    [NGGoogleAnalytics appEnteredBackground:NO];
  
}

- (void)applicationWillTerminate:(UIApplication *)application{}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication: (NSString *)sourceApplication annotation:(id)annotation
{
    [NGDirectoryUtility deeplinkingFileLogger:[NSString stringWithFormat:@"%s-->\nurl:%@ \nsourceApplication:%@",__PRETTY_FUNCTION__,url,sourceApplication]];
    BOOL isdeepLinking = [[NGDeepLinkingHelper sharedInstance] validateAndPerformDeeplinkingWithURL:url];
    if(isdeepLinking == FALSE)
    {
        if ([[DBSession sharedSession] handleOpenURL:url])
        {
            if ([[DBSession sharedSession] isLinked]&&appComingFromBackgroundFlagForOpenWithTypeDocument)
            {
                    [[NSNotificationCenter defaultCenter] postNotificationName:K_APP_NOTIFICATION_OPEN_URL_ANNOTATION object:nil userInfo:@{K_APP_NOTIFICATION_USER_INFO_KEY:K_NOTIFICATION_INFO_DROPBOX_OPEN_URL}];
            }
            return YES;
        }

        NSString *longPressedFileName = [NGDirectoryUtility validatePathOfOpenWithTypeDocument];
        if (nil != longPressedFileName)
        {
            [NGOpenWithResumeHandler sharedInstance].isRegisteredByLocalObserver = YES;
            BOOL isLoggedInUser = [[NGHelper sharedInstance] isUserLoggedIn];
            if (isLoggedInUser && appComingFromBackgroundFlagForOpenWithTypeDocument)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_WITH_DOCUMENT_TYPE_HANDLER object:nil];
                appComingFromBackgroundFlagForOpenWithTypeDocument = NO;
            }
            else if (NO== isLoggedInUser && appComingFromBackgroundFlagForOpenWithTypeDocument)
            {
                [NGDirectoryUtility clearInboxDir];
                [NGUIUtility showAlertWithTitle:@"Error" withMessage:[NSArray arrayWithObjects:@"Please login to attach a CV.", nil] withButtonsTitle:@"OK" withDelegate:nil];
                [NGOpenWithResumeHandler sharedInstance].isRegisteredByLocalObserver = NO;
            }
            return YES;
        }
    }
    
    [Tune applicationDidOpenURL:[url absoluteString] sourceApplication:sourceApplication];
    
    
#pragma mark - Commenting the social Login support
    
//    if ([url.absoluteString rangeOfString:@"fb" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 2)].location != NSNotFound){
//        return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                   openURL:url
//                                         sourceApplication:sourceApplication
//                                                annotation:annotation
//     ];
//    }
//    
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:sourceApplication
//                                      annotation:annotation];

    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if([[NGHelper sharedInstance] isUserLoggedIn] && ![NGSavedData areAllNotificationsBlocked])
    {
        NGBackgroundFetchHelper *backgroundFetchHelper = [NGBackgroundFetchHelper sharedInstance];
        if([backgroundFetchHelper shouldPerformBgFetchForRecommendedJobs]){
            [backgroundFetchHelper checkForNewRecommendedJobs:completionHandler];
            return;
        }
        backgroundFetchHelper = nil;
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
+ (NGAppDelegate*)appDelegate
{
    return APPDELEGATE;
}
#pragma mark CoreSpotlight
-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    
    
    if ([userActivity.activityType isEqualToString:@"com.apple.corespotlightitem"]) {
        
        [NGSpotlightSearchHelper sharedInstance].isComingFromSpotlightSearch = YES;
        [NGSpotlightSearchHelper sharedInstance].spotlightUserActivity = userActivity;
        
        NSString* identifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
        NSArray* arrIdentifiers = [identifier componentsSeparatedByString:@"."];
        NSString* landingPage = [arrIdentifiers firstObject];
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_ACTION_SPOTLIGHT withEventLabel:landingPage withEventValue:nil];
        
        if ([[NGSpotlightSearchHelper sharedInstance] spotlightAppState] == NGSpotlightAppStateNone){
            [[NGSpotlightSearchHelper sharedInstance] handleSpotlightItemClick];
        }
        return true;
        
    }
    return true;
    
}
@end
