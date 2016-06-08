//
//  NGNotificationAppHandler.m
//  NaukriGulf
//
//  Created by Minni Arora on 22/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGNotificationAppHandler.h"
#import "NGJobAnalyticsViewController.h"


@interface NGNotificationAppHandler ()
{
    NSString *actionValue ;
    NSInteger pushResultCount_;
    
    NSDictionary *pushNotificationDict;
}

/**
 *  Mutable dictionary containing the appsInfo
 */
@property (nonatomic,strong) NSMutableDictionary* appsInfo;

@end
@implementation NGNotificationAppHandler

static NGNotificationAppHandler *singleton;
/**
 *  A Shared Instance Singleton class of NGNotificationAppHandler
 *
 *  @return sharedInstance created once only
 */

+(NGNotificationAppHandler *)sharedInstance{
    if (singleton==nil) {
        singleton = [[NGNotificationAppHandler alloc]init];
        
    }
    
    return singleton;
}

-(instancetype)init{
    if (self) {
        self.pushNotificationAppState = NGPushNotificationAppStateNone;
        [self listenAppStateNotificationForPushNotification];
    }
    return self;
}
#pragma mark - Public Method
/**
 *  @name Public Method
 */

/**
 *  Method triggers when the user enter the application on tapping push Notification
 *
 *  @param notificationParams notificationParams description
 */
-(void)handleNotification:(NSDictionary *)notificationParams{
    
    NSDictionary *pushNotificationData = [notificationParams copy];
    
    //reset original object
    pushNotificationDict = nil;
    
    self.appsInfo=[pushNotificationData valueForKey:@"aps"];
    NSDictionary *action = [self getActionType:pushNotificationData];
    
    NSString *actionType = [action objectForKey:@"type"];
    actionValue = [action objectForKey:@"value"];
    NSString *pushResultCount = [action objectForKey:@"count"];
    
    if ([actionValue isEqualToString:@"PROD"]) {
        NSString *pushUrl = [action objectForKey:@"url"];
        [NGSavedData saveProductURL:pushUrl];
    }
    
    
    pushResultCount_= [pushResultCount integerValue];
    
    if ([actionType isEqualToString:@"web"]) {
        [self handleWebActionWithValue:actionValue];
    }else{
        [self handleAppActionWithValue:actionValue withPushCount:pushResultCount_ ];
    }
    
    pushNotificationData = nil;
}
#pragma mark - Private Methods
/**
 *  @name Private Methods
 */
/**
 *  Method for updating the appsInfo dictionary from the action key
 *
 *  @param notificationParams notificationParams description
 *
 *  @return return NSDictionary containing the objectForKey:@"action"
 */
-(NSDictionary *)getActionType:(NSDictionary *)notificationParams{
    return [notificationParams objectForKey:@"action"];
}

-(void)handleWebActionWithValue:(NSString *)actionValue{
    //future plan, will be used for handling web actions
}

/**
 *  Method triggers controller in respect to the action value *(@"JA", @"PV", @"PU",@"PROD")
 *
 *  @param actionValue keys
 *  @param pushCount   total number of pushes
 */
-(void)handleAppActionWithValue:(NSString *)actionValue_ withPushCount:(NSInteger ) pushCount {
    
    NGAppDelegate *delegate = [NGAppDelegate appDelegate];
    IENavigationController *navController = (IENavigationController*)delegate.container.centerViewController;
    
    if(delegate.container.menuState == MFSideMenuStateLeftMenuOpen){
        [delegate.container toggleLeftSideMenuCompletion:nil];
    }
    
    
    if([actionValue_ isEqualToString:@"JA"]) {
        if (self.performPushNotificationWithDesiredPageLanding) {
            self.performPushNotificationWithDesiredPageLanding = NO;
            
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGJobAnalyticsViewController"];
            
            [self goToMNJ:YES];
            
            [[NGAppStateHandler sharedInstance]setDelegate:self];
            
            [[NGAppStateHandler sharedInstance] setAppState:APP_STATE_MNJ_ANALYTICS usingNavigationController:navController animated:YES];
        }
    }
    else if ([actionValue_ isEqualToString:@"PV"])
    {
        NSMutableDictionary* dict=[NGSavedData getBadgeInfo];
        NSInteger prevCount=  [[dict objectForKey:KEY_BADGE_TYPE_PV] integerValue];
        
        [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_PV withBadgeNumber:(prevCount+pushCount)];
        
        if (self.performPushNotificationWithDesiredPageLanding) {
            self.performPushNotificationWithDesiredPageLanding = NO;
            
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGWhoViewedMyCVViewController"];
            
            [self goToMNJ:YES];
            
            [[NGAppStateHandler sharedInstance]setDelegate:self];
            
            [[NGAppStateHandler sharedInstance] setAppState:APP_STATE_PROFILE_VIEWER usingNavigationController:navController animated:YES];
        }
    }
    else if ([actionValue_ isEqualToString:@"PU"])
    {
        [NGSavedData saveProfileNotificationUpdate:self.appsInfo];
        
        if (self.performPushNotificationWithDesiredPageLanding)
        {
            self.performPushNotificationWithDesiredPageLanding = NO;
            
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGProfileViewController"];
            
            [[NGAppStateHandler sharedInstance]setDelegate:self];
            
            [[NGAppStateHandler sharedInstance] setAppState:APP_STATE_PROFILE usingNavigationController:navController animated:YES];
        }
    }
    else if ([actionValue_ isEqualToString:@"PROD"])
    {
        if (self.performPushNotificationWithDesiredPageLanding){
            self.performPushNotificationWithDesiredPageLanding = NO;
            
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGWebViewController"];
            
            [self goToMNJ:YES];
            
            [[NGNotificationWebHandler sharedInstance] resetNotifications:KEY_BADGE_TYPE_PROD];
            [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_PROD withBadgeNumber:0];
            
            NGWebViewController *webView = (NGWebViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"webView"];
            webView.isCloseBtnHidden = NO;
            [webView setNavigationTitle:@"Whats New" withUrl:[NGSavedData getProductURL]];
            
            [navController pushActionViewController:webView Animated:YES];
        }
    }else{
        [self goToMNJ:NO];
    }
    
    delegate = nil;
    navController = nil;
    
    //Perform server notification sync after some seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NGNotificationWebHandler sharedInstance] getNotifications];
    });
}
-(void)goToMNJ:(BOOL)isAnimated{
    if ([NGHelper sharedInstance].isUserLoggedIn) {
        [[NGAppStateHandler sharedInstance] setDelegate:self];
        [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:isAnimated];
    }
}

-(void)handlePushNotification{
    if (NGPushNotificationAppStateLaunch==self.pushNotificationAppState && nil != pushNotificationDict) {
        self.performPushNotificationWithDesiredPageLanding = YES;
        [self handleNotification:pushNotificationDict];
    }
}

-(void)listenAppStateNotificationForPushNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushNotificationAppNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushNotificationAppNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)handlePushNotificationAppNotification:(NSNotification*)paramNotification{
    if (nil != paramNotification && nil != paramNotification.name) {
        if([paramNotification.name isEqualToString:UIApplicationDidBecomeActiveNotification]){
            if (self.pushNotificationAppState == NGPushNotificationAppStateBackground && nil!=pushNotificationDict) {
                
                [self handleNotification:pushNotificationDict];
                
            }
        }else if ([paramNotification.name isEqualToString:UIApplicationWillEnterForegroundNotification]){
            self.pushNotificationAppState = NGPushNotificationAppStateBackground;
        }else{
            self.pushNotificationAppState = NGPushNotificationAppStateNone;
        }
        
    }
    
}
-(void)setPushNotificationConfigFromLaunchOption:(NSDictionary*)paramLaunchOption{
    [NGDirectoryUtility deeplinkingFileLogger:[NSString stringWithFormat:@"%s-->\nparamLaunchOption:%@",__PRETTY_FUNCTION__,paramLaunchOption]];
    
    NSDictionary *pnData = [paramLaunchOption objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    BOOL isAppLaunchedViaPushNotification = (pnData && 0<pnData.count);
    
    if (isAppLaunchedViaPushNotification) {
        pushNotificationDict = pnData;
        self.pushNotificationAppState = NGPushNotificationAppStateLaunch;
    }else{
        self.pushNotificationAppState = NGPushNotificationAppStateNone;
    }
    
    [NGDirectoryUtility deeplinkingFileLogger:[NSString stringWithFormat:@"%s-->\nisAppLaunchedViaPushNotification:%@ \npushNotificationAppState:%ld",__PRETTY_FUNCTION__,isAppLaunchedViaPushNotification?@"YES":@"NO",(unsigned long)self.pushNotificationAppState]];
}
-(void)validateAndSetPushNotificationWithDictionary:(NSDictionary*)paramPushNotificationData{
    BOOL isAppLaunchedViaPushNotification = (nil!=paramPushNotificationData && 0<paramPushNotificationData.count);
    
    if(isAppLaunchedViaPushNotification){
        pushNotificationDict = paramPushNotificationData;
        
        if (!self.performPushNotificationWithDesiredPageLanding) {
            [self handleNotification:pushNotificationDict];
        }
        
    }else{
        pushNotificationDict = nil;
    }
}
#pragma mark - AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc{
    if([vc isKindOfClass:[NGJobAnalyticsViewController class]] && [actionValue isEqualToString:@"JA"])
    {
        NGJobAnalyticsViewController *jobAnalytics = (NGJobAnalyticsViewController*)vc;
        jobAnalytics.selectedTabIndex = 2;
    }else{
        //dummy
    }
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
}

@end
