//
//  NGLocalNotificationHelper.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 10/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGLocalNotificationHelper.h"
#import "NGJobAnalyticsViewController.h"
#import "NGProfileViewController.h"

@interface NGLocalNotificationHelper(){
    UILocalNotification *localNotificationObj;
    
    BOOL isCVNotUploadedNotificationSet;
    BOOL isProfilePicNotUploadedNotificationSet;
    BOOL isUserBirthdayNotificationSet;

    BOOL isNotLoggedInUserNotificationSet;
    
    UserProfile profilelandingSection;
    
    BOOL didBecomeActiveFired;
    
    BOOL alreadyValidatedLocalNotifications;
}

@end

@implementation NGLocalNotificationHelper

-(instancetype)init{
    if (self) {
        
        didBecomeActiveFired = NO;
        
        self.launchingFromState = NGLocalNotificationLaunchingFromStateNone;
        
        [self validateLocalNotifications];
        
        [self listenAppStateNotificationForLN];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

-(void) handleNotificationResponse: (UILocalNotification*)paramNotification{
    
    NGHelper *ngHelper = [NGHelper sharedInstance];
    NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
    
    profilelandingSection = NONE_SECTION;
    
    UILocalNotification *lnNotification = [paramNotification copy];
    
    //reset original object
    localNotificationObj = nil;
    
    
    NGLocalNotificationGA localNotificationGACode = NGLocalNotificationGANone;
    NSNumber *localNotificationGAObject = [lnNotification.userInfo objectForKey:K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY];
    if (nil!=localNotificationGAObject && [localNotificationGAObject isKindOfClass:[NSNull class]]) {
        localNotificationGACode = (NGLocalNotificationGA)[localNotificationGAObject unsignedIntegerValue];
        if (NGLocalNotificationGANone != localNotificationGACode) {
            [NGLocalNotificationHelper sendLocalNotificationGA:localNotificationGACode];
        }
    }
    
    int notifType = [[lnNotification.userInfo objectForKey:K_NOTIFICATION_TYPE_TITLE] intValue];
    
    switch (notifType) {
            
        case  K_RECOMMENDED_JOBS_LOCAL_NOTIFICATION:{
            
            if(ngHelper.isUserLoggedIn) {
                
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_NOTIFICATION_CATEGORY withEventAction:K_GA_EVENT_RECOMMENDED_NOTIFICATION_CLICK withEventLabel:K_GA_EVENT_RECOMMENDED_NOTIFICATION_CLICK withEventValue:nil];
                
                [[NGAppStateHandler sharedInstance]setDelegate:self];
                
                [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGJobAnalyticsViewController"];
                
                if (self.launchingFromState == NGLocalNotificationLaunchingFromStateLaunch) {
                    [appStateHandler setAppState:APP_STATE_MNJ usingNavigationController:((IENavigationController*)APPDELEGATE.container.centerViewController) animated:YES];
                }
                
                [appStateHandler setAppState:APP_STATE_MNJ_ANALYTICS usingNavigationController:((IENavigationController*)APPDELEGATE.container.centerViewController) animated:YES];
            }
            
            break;
            
        }
        case K_RESMAN_LOCAL_NOTIFICATION:{
            [[NGResmanNotificationHelper sharedInstance] processNotificationInfo:lnNotification.userInfo];
        }break;
            
        case K_MNJ_PAGE_LOCAL_NOTIFICATION:{
            //LANDING PAGE IS MNJ
            if (ngHelper.isUserLoggedIn) {
                [appStateHandler setDelegate:self];
                [appStateHandler setAppState:APP_STATE_MNJ usingNavigationController:APPDELEGATE.container.centerViewController animated:YES];
            }
            
        }break;
            
        case K_EDIT_CV_PAGE_LOCAL_NOTIFICATION:
        case K_PROFILE_PAGE_LOCAL_NOTIFICATION:{
            
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGProfileViewController"];
            
            if (ngHelper.isUserLoggedIn) {
                
                if (K_EDIT_CV_PAGE_LOCAL_NOTIFICATION == notifType) {
                    //landing page edit cv upload
                    profilelandingSection = CV;
                }
                
                [appStateHandler setDelegate:self];
                [appStateHandler setAppState:APP_STATE_PROFILE usingNavigationController:APPDELEGATE.container.centerViewController animated:YES];
            }
        }break;
            
        case K_LOGIN_PAGE_LOCAL_NOTIFICATION:{
            
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGLoginViewController"];
            
            //landing page login
            if (NO == ngHelper.isUserLoggedIn) {
                [appStateHandler setDelegate:self];
                [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:APPDELEGATE.container.centerViewController animated:YES];
            }
            
        }break;
        case K_LOCAL_NOTIFICATION_BIRTHDAY:{
            
            //LANDING PAGE IS MNJ
            if (ngHelper.isUserLoggedIn) {
                [appStateHandler setDelegate:self];
                [appStateHandler setAppState:APP_STATE_MNJ usingNavigationController:APPDELEGATE.container.centerViewController animated:YES];
            }
            
        }break;
            
            
        default:
            break;
    }
    
    appStateHandler = nil;
    ngHelper = nil;
    //delegate = nil;
}

-(void)setLNConfigFromLaunchOption:(NSDictionary*)paramLaunchOption{
    [NGDirectoryUtility deeplinkingFileLogger:[NSString stringWithFormat:@"%s-->\nparamLaunchOption:%@",__PRETTY_FUNCTION__,paramLaunchOption]];
    
    //local notification
    UILocalNotification *lnData = [paramLaunchOption objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    BOOL isAppLaunchedViaLN = (nil!=lnData && nil!=lnData.userInfo && 0<lnData.userInfo.count);
    
    if (isAppLaunchedViaLN) {
        localNotificationObj = lnData;
        self.launchingFromState = NGLocalNotificationLaunchingFromStateLaunch;
    }else{
        self.launchingFromState = NGLocalNotificationLaunchingFromStateNone;
    }
    
    lnData = nil;
    
    [NGDirectoryUtility deeplinkingFileLogger:[NSString stringWithFormat:@"%s-->\nisAppLaunchedViaLN:%@ \nlaunchingFromState:%ld",__PRETTY_FUNCTION__,isAppLaunchedViaLN?@"YES":@"NO",(unsigned long)self.launchingFromState]];
}
-(void)validateAndSetLNWithNotification:(UILocalNotification*)paramLNData{
    BOOL isAppLaunchedViaLN = (nil!=paramLNData && nil!=paramLNData.userInfo && 0<paramLNData.userInfo.count);
    
    if(isAppLaunchedViaLN){
        localNotificationObj = paramLNData;
    }else{
        localNotificationObj = nil;
    }
}
-(void)listenAppStateNotificationForLN{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLNAppNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLNAppNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLNAppNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
-(void)handleLocalNotification{
    if (NGLocalNotificationLaunchingFromStateLaunch==self.launchingFromState && nil != localNotificationObj) {
        [self handleNotificationResponse:localNotificationObj];
    }
}
-(void)handleLNAppNotification:(NSNotification*)paramNotification{
    if (nil != paramNotification && nil != paramNotification.name) {
        if([paramNotification.name isEqualToString:UIApplicationDidBecomeActiveNotification]){
            
            if (didBecomeActiveFired) {
                return;
            }
            
            didBecomeActiveFired = YES;
            
            [self validateLocalNotifications];
            
            //cancel local notifications on the basis of there SetRules
            [self manageNotificationForAction:NO];
            
            
            if (self.launchingFromState == NGLocalNotificationLaunchingFromStateBackground && nil!=localNotificationObj) {
                
                [self handleNotificationResponse:localNotificationObj];
                
            }
        }else if ([paramNotification.name isEqualToString:UIApplicationWillEnterForegroundNotification]){
            //this line means,,user is coming from background state.
            //hence we r setting local notification app state as background
            self.launchingFromState = NGLocalNotificationLaunchingFromStateBackground;
            
        }else if([paramNotification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]){
            
            didBecomeActiveFired = NO;
            alreadyValidatedLocalNotifications = NO;
            
            //set notifications on the basis of there setRules
            [self manageNotificationForAction:YES];
            
        }else{
            self.launchingFromState = NGLocalNotificationLaunchingFromStateNone;
        }
        
    }
    
}

-(void)manageNotificationForAction:(BOOL)setNotification{
    
    if ([NGHelper sharedInstance].isUserLoggedIn) {
        [self setOrCancelInactiveLoggedInUserNotificationWithAction:setNotification];
        
        //check whether user have uploaded cv or not
        //if yes,,,cancel notification
        //if no,, set notification
        NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
        if (0>=[[ValidatorManager sharedInstance] validateValue:objModel.attachedCvFormat withType:ValidationTypeString].count) {
            [self setOrCancelCVNotUploadedNotificationWithAction:NO];
        }else{
            [self setOrCancelCVNotUploadedNotificationWithAction:YES];
        }
        
        
        //check whether user have uploaded profile pic or not
        //if yes,,,cancel notification
        //if no,, set notification
        if ([[NSFileManager defaultManager]fileExistsAtPath:[NSString getProfilePhotoPath]]){
            [self setOrCancelProfilePicNotUploadedNotificationWithAction:NO];
        }else{
            [self setOrCancelProfilePicNotUploadedNotificationWithAction:YES];
        }
        
        [self setOrCancelNotLoggedInUserNotificationWithAction:NO];
        
        //check whether user have date of birth mentioned
        //if yes,,,set notification
        //if yes,, cancel notification
        if (0>=[[ValidatorManager sharedInstance] validateValue:objModel.dateOfBirth withType:ValidationTypeString].count) {
            [self setOrCancelBirthdayNotificationWithAction:YES];
        }else{
            [self setOrCancelBirthdayNotificationWithAction:NO];
        }
        
        
        
        
    }else{
        [self setOrCancelNotLoggedInUserNotificationWithAction:YES];
        [self setOrCancelBirthdayNotificationWithAction:NO];

    }
}
#pragma mark- Set/Cancel Local notification methods
-(void)setOrCancelBirthdayNotificationWithAction:(BOOL)setNotification{
    
    
    if (setNotification) {
        
        isUserBirthdayNotificationSet = NO;
        [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_BIRTHDAY];
        
        NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
        if(objModel.dateOfBirth.length==0)
            return;
        
        //set notifications
        NSDate *scheduleDate;
        NSString *alertBodyVal;
        NSDictionary *alertUserInfo;
        
        NSString *birthdate = [NGDateManager getDateInLongStyle:objModel.dateOfBirth];

//#warning testing
//        birthdate = @"February 3,2016";
        
        NSDate *date = [NGDateManager dateFromString:birthdate WithDateFormat:@"MMM dd,yyyy"];
        NSString *strFromDate = [NGDateManager stringFromDate:date WithDateFormat:@"dd/MM/yyyy"];
        
        //+1 Year notification and yearly repeating
        scheduleDate = [self getValidBirthdate:strFromDate];

        
        if(objModel.name.length)
        alertBodyVal =[NSString stringWithFormat:@"Dear %@, Wish you a very happy birthday from Naukrigulf Team. May new opportunities come your way on this special day!",objModel.name];
        else
        alertBodyVal =[NSString stringWithFormat:@"Hi, Wish you a very happy birthday from Naukrigulf Team. May new opportunities come your way on this special day!"];

        alertUserInfo = @{
                                        K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_LOCAL_NOTIFICATION_BIRTHDAY],
                                        K_LOCAL_NOTIFICATION_ID:K_LOCAL_NOTIFICATION_PAGE_ID_BIRTHDAY
//                                        K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY:[NSNumber numberWithUnsignedInteger:NGLocalNotificationGALoggedInInactiveUserMonthlyClick]
                                        };
        
        [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:([UIApplication sharedApplication].applicationIconBadgeNumber+1) WithRepetitionOn:YES RepeatingType:NSCalendarUnitYear andUserInfo:alertUserInfo];
        isUserBirthdayNotificationSet = YES;

//        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGALoggedInInactiveUserMonthlySet];
    }
    else{
        isUserBirthdayNotificationSet = NO;
        [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_BIRTHDAY];
    }
    
}

-(NSDate*)getValidBirthdate:(NSString*)dateStr{
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"/"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay: [[dateArr objectAtIndex:0] integerValue]];
    [components setMonth: [[dateArr objectAtIndex:1] integerValue]];
    [components setYear: [[dateArr objectAtIndex:2] integerValue]];
    [components setHour: 10];
    [components setMinute: 0];
    [components setSecond: 0];
    [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
    NSDate *dateToFire = [calendar dateFromComponents:components];
    return dateToFire;
}
-(void)setOrCancelInactiveLoggedInUserNotificationWithAction:(BOOL)setNotification{
    //landing page:MNJ
    //monthly repeating
    
    //cancel notification
    [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_MNJ];
    [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGALoggedInInactiveUserMonthlyCancel];
    
    
    if (setNotification) {
        
        //+30 Days notification and monthly repeating
        NSDate *scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:30 InUnit:NGTimeUnitDay ToDate:[NSDate date]] ElseSetHour:10 andMinute:00];
        
        NSString *alertBodyVal = @"You are missing on new job opportunities. Start your job search now!";
        NSDictionary *alertUserInfo = @{
                                        K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_MNJ_PAGE_LOCAL_NOTIFICATION],
                                        K_LOCAL_NOTIFICATION_ID:K_LOCAL_NOTIFICATION_PAGE_ID_MNJ,
                                        K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY:[NSNumber numberWithUnsignedInteger:NGLocalNotificationGALoggedInInactiveUserMonthlyClick]
                                        };
        
        [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:([UIApplication sharedApplication].applicationIconBadgeNumber+1) WithRepetitionOn:YES RepeatingType:NSCalendarUnitMonth andUserInfo:alertUserInfo];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGALoggedInInactiveUserMonthlySet];
    }
}

-(void)setOrCancelCVNotUploadedNotificationWithAction:(BOOL)setNotification{
    
    if (setNotification && NO == isCVNotUploadedNotificationSet) {
        //set notifications
        NSDate *scheduleDate;
        NSString *alertBodyVal;
        NSDictionary *alertUserInfo;
        
        //+1 Day day notification
        scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:1 InUnit:NGTimeUnitDay ToDate:[NSDate date]] ElseSetHour:10 andMinute:30];
        alertBodyVal = @"CV Attachment Missing! Upload Your CV to get noticed by Recruiters";
        alertUserInfo = @{
                          K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_EDIT_CV_PAGE_LOCAL_NOTIFICATION],
                          K_LOCAL_NOTIFICATION_ID:K_LOCAL_NOTIFICATION_PAGE_ID_EDIT_CV,
                          K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY:[NSNumber numberWithUnsignedInteger:NGLocalNotificationGAEditCV1DayClick]
                          };
        [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:([UIApplication sharedApplication].applicationIconBadgeNumber+1) andUserInfo:alertUserInfo];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGAEditCV1DaySet];
        
        
        //+30 Days notification and monthly repeating
        scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:30 InUnit:NGTimeUnitDay ToDate:[NSDate date]] ElseSetHour:10 andMinute:30];
        
        //alertBodyVal ,same as above
        alertUserInfo = @{
                          K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_EDIT_CV_PAGE_LOCAL_NOTIFICATION],
                          K_LOCAL_NOTIFICATION_ID:K_LOCAL_NOTIFICATION_PAGE_ID_EDIT_CV,
                          K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY:[NSNumber numberWithUnsignedInteger:NGLocalNotificationGAEditCVMonthlyClick]
                          };
        
        [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:([UIApplication sharedApplication].applicationIconBadgeNumber+1) WithRepetitionOn:NO RepeatingType:NSCalendarUnitMonth andUserInfo:alertUserInfo];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGAEditCVMonthlySet];
        
        isCVNotUploadedNotificationSet = YES;
        
    }else if (NO == setNotification && YES==isCVNotUploadedNotificationSet){
        //cancel notification
        [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_EDIT_CV];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGAEditCV1DayCancel];
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGAEditCVMonthlyCancel];
        
        isCVNotUploadedNotificationSet = NO;
    }else{
        //dummy
    }
}

-(void)setOrCancelProfilePicNotUploadedNotificationWithAction:(BOOL)setNotification{
    if (setNotification && NO == isProfilePicNotUploadedNotificationSet) {
        //set notifications
        NSDate *scheduleDate;
        NSString *alertBodyVal;
        NSDictionary *alertUserInfo;
        
        //+2 Day day notification
        scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:2 InUnit:NGTimeUnitDay ToDate:[NSDate date]] ElseSetHour:10 andMinute:30];
        alertBodyVal = @"Profile Photo Missing! Upload a Profile Photo for getting 40%% more CV views.";
        alertUserInfo = @{
                          K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_PROFILE_PAGE_LOCAL_NOTIFICATION],
                          K_LOCAL_NOTIFICATION_ID:K_LOCAL_NOTIFICATION_PAGE_ID_PROFILE,
                          K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY:[NSNumber numberWithUnsignedInteger:NGLocalNotificationGAUploadProfilePic2DayClick]
                          };
        [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:([UIApplication sharedApplication].applicationIconBadgeNumber+1) andUserInfo:alertUserInfo];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGAUploadProfilePic2DaySet];
        
        
        //+30 Days notification and monthly repeating
        scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:30 InUnit:NGTimeUnitDay ToDate:[NSDate date]] ElseSetHour:10 andMinute:30];
        
        //alertBodyVal ,same as above
        alertUserInfo = @{
                          K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_PROFILE_PAGE_LOCAL_NOTIFICATION],
                          K_LOCAL_NOTIFICATION_ID:K_LOCAL_NOTIFICATION_PAGE_ID_PROFILE,
                          K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY:[NSNumber numberWithUnsignedInteger:NGLocalNotificationGAUploadProfilePicMonthlyClick]
                          };
        
        [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:([UIApplication sharedApplication].applicationIconBadgeNumber+1) WithRepetitionOn:NO RepeatingType:NSCalendarUnitMonth andUserInfo:alertUserInfo];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGAUploadProfilePicMonthlySet];
        
        isProfilePicNotUploadedNotificationSet = YES;
        
    }else if (NO == setNotification && YES==isProfilePicNotUploadedNotificationSet){
        //cancel notification
        [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_PROFILE];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGAUploadProfilePic2DayCancel];
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGAUploadProfilePicMonthlyCancel];
        
        isProfilePicNotUploadedNotificationSet = NO;
    }else{
        //dummy
    }
}

-(void)setOrCancelNotLoggedInUserNotificationWithAction:(BOOL)setNotification{
    if (setNotification && NO == isNotLoggedInUserNotificationSet) {
        //set notifications
        NSDate *scheduleDate;
        NSString *alertBodyVal;
        NSDictionary *alertUserInfo;
        
        //+12 Hour day notification
        scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:12 InUnit:NGTimeUnitHour ToDate:[NSDate date]] ElseSetHour:10 andMinute:00];
        alertBodyVal = @"Login into the app and get Recommended Jobs matching your profile!";
        alertUserInfo = @{
                          K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_LOGIN_PAGE_LOCAL_NOTIFICATION],
                          K_LOCAL_NOTIFICATION_ID:K_LOCAL_NOTIFICATION_PAGE_ID_LOGIN,
                          K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY:[NSNumber numberWithUnsignedInteger:NGLocalNotificationGANonLoggedInUser12HourClick]
                          };
        [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:([UIApplication sharedApplication].applicationIconBadgeNumber+1) andUserInfo:alertUserInfo];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGANonLoggedInUser12HourSet];
        
        
        //+7 Days notification and Weekly repeating
        scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:7 InUnit:NGTimeUnitDay ToDate:[NSDate date]] ElseSetHour:10 andMinute:00];
        
        //alertBodyVal ,same as above
        alertUserInfo = @{
                          K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_LOGIN_PAGE_LOCAL_NOTIFICATION],
                          K_LOCAL_NOTIFICATION_ID:K_LOCAL_NOTIFICATION_PAGE_ID_LOGIN,
                          K_LOCAL_NOTIFICATION_CLICKED_EVENT_GA_KEY:[NSNumber numberWithUnsignedInteger:NGLocalNotificationGANonLoggedInUserWeeklyClick]
                          };
        
        [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:([UIApplication sharedApplication].applicationIconBadgeNumber+1) WithRepetitionOn:YES RepeatingType:NSCalendarUnitWeekOfYear andUserInfo:alertUserInfo];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGANonLoggedInUserWeeklySet];
        
        isNotLoggedInUserNotificationSet = YES;
        
    }else if (NO == setNotification && YES==isNotLoggedInUserNotificationSet){
        //cancel notification
        [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_PROFILE];
        
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGANonLoggedInUser12HourCancel];
        [NGLocalNotificationHelper sendLocalNotificationGA:NGLocalNotificationGANonLoggedInUserWeeklyCancel];
        
        
        isNotLoggedInUserNotificationSet = NO;
    }else{
        //dummy
    }
}
#pragma mark---
+ (void)scheduleLocalNotificationForDate:(NSDate*)paramDate alertBody:(NSString*)paramAlertBody alertAction:(NSString*)paramAlertAction ApplicationBadge:(NSUInteger)paramAppBadge WithRepetitionOn:(BOOL)paramIsRepeatingAlert RepeatingType:(NSCalendarUnit)paramRepeatingUnit andUserInfo:(NSDictionary*)paramUserInfo{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    [localNotification setCategory:@"other"]; //adding for watch
    
    [localNotification setFireDate:paramDate];
    [localNotification setAlertBody:paramAlertBody];
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    [localNotification setAlertAction:paramAlertAction];
    [localNotification setUserInfo:paramUserInfo];
    
    if (0 < paramAppBadge) {
        [localNotification setApplicationIconBadgeNumber:paramAppBadge];
    }
    
    if (paramIsRepeatingAlert) {
        [localNotification setRepeatInterval:paramRepeatingUnit];
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

+ (void)scheduleLocalNotificationForDate:(NSDate*)paramDate alertBody:(NSString*)paramAlertBody alertAction:(NSString*)paramAlertAction ApplicationBadge:(NSUInteger)paramAppBadge andUserInfo:(NSDictionary*)paramUserInfo{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    [localNotification setCategory:@"other"]; //adding for watch
    [localNotification setFireDate:paramDate];
    [localNotification setAlertBody:paramAlertBody];
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    [localNotification setAlertAction:paramAlertAction];
    [localNotification setUserInfo:paramUserInfo];
    
    if (0 < paramAppBadge) {
        [localNotification setApplicationIconBadgeNumber:paramAppBadge];
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
+ (void)scheduleLocalNotificationForDate:(NSDate*)paramDate alertBody:(NSString*)paramAlertBody alertAction:(NSString*)paramAlertAction andUserInfo:(NSDictionary*)paramUserInfo{
    
    [NGLocalNotificationHelper scheduleLocalNotificationForDate:paramDate alertBody:paramAlertBody alertAction:paramAlertAction ApplicationBadge:0 andUserInfo:paramUserInfo];
    
}

-(NSDate*)createValidDateFromDate:(NSDate*)paramFromDate ElseSetHour:(NSInteger)paramHour andMinute:(NSInteger)paramMinute{
    //given date lies in night time
    //change hour and minute to hours:minutes given
    if ([NGDateManager isNightTimeInDate:paramFromDate]) {
        return [NGDateManager createNewDateFromDate:paramFromDate ForHour:paramHour AndForMinute:paramMinute];
    }
    return paramFromDate;
}
+(void)cancelLocalNotificationForNotificationId:(NSString*)paramNotificationId{
    NSArray *localNotificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (nil != localNotificationList && 0<[localNotificationList count]) {
        for (UILocalNotification *localNotification in localNotificationList) {
            NSString *notificationId = [[localNotification userInfo] objectForKey:K_LOCAL_NOTIFICATION_ID];
            if (nil != notificationId && 0<notificationId.length && [notificationId isEqualToString:paramNotificationId]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
}

+(void)sendLocalNotificationGA:(NGLocalNotificationGA)paramResmanGA{
    NSString *eventAction = @"";
    NSString *eventLabel = @"";
    switch (paramResmanGA) {
            //upload profile photo 2 day
        case NGLocalNotificationGAUploadProfilePic2DaySet:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_SET_UPLOAD_PROFILE_PIC_2_DAY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
        case NGLocalNotificationGAUploadProfilePic2DayCancel:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CANCEL_UPLOAD_PROFILE_PIC_2_DAY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
        case NGLocalNotificationGAUploadProfilePic2DayClick:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CLICK_UPLOAD_PROFILE_PIC_2_DAY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
            
            
            //upload profile photo monthly
        case NGLocalNotificationGAUploadProfilePicMonthlySet:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_SET_UPLOAD_PROFILE_PIC_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
        case NGLocalNotificationGAUploadProfilePicMonthlyCancel:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CANCEL_UPLOAD_PROFILE_PIC_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
        case NGLocalNotificationGAUploadProfilePicMonthlyClick:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CLICK_UPLOAD_PROFILE_PIC_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
            
            
            //Edit cv 1 day
        case NGLocalNotificationGAEditCV1DaySet:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_SET_EDIT_CV_1_DAY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
        case NGLocalNotificationGAEditCV1DayCancel:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CANCEL_EDIT_CV_1_DAY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
        case NGLocalNotificationGAEditCV1DayClick:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CLICK_EDIT_CV_1_DAY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
            
            
            //Edit CV monthly
        case NGLocalNotificationGAEditCVMonthlySet:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_SET_EDIT_CV_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
        case NGLocalNotificationGAEditCVMonthlyCancel:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CANCEL_EDIT_CV_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
        case NGLocalNotificationGAEditCVMonthlyClick:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CLICK_EDIT_CV_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_PROFILE;
        }break;
            
            
            //Non loggedIn User 12 hours
        case NGLocalNotificationGANonLoggedInUser12HourSet:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_SET_NON_LOGGEDIN_USER_12_HOUR;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
        case NGLocalNotificationGANonLoggedInUser12HourCancel:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CANCEL_NON_LOGGEDIN_USER_12_HOUR;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
        case NGLocalNotificationGANonLoggedInUser12HourClick:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CLICK_NON_LOGGEDIN_USER_12_HOUR;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
            
            
            //Non loggedIn User Weekly
        case NGLocalNotificationGANonLoggedInUserWeeklySet:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_SET_NON_LOGGEDIN_USER_WEEKLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
        case NGLocalNotificationGANonLoggedInUserWeeklyCancel:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CANCEL_NON_LOGGEDIN_USER_WEEKLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
        case NGLocalNotificationGANonLoggedInUserWeeklyClick:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CLICK_NON_LOGGEDIN_USER_WEEKLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
            
            
            //LoggedIn Inactive User Monthly
        case NGLocalNotificationGALoggedInInactiveUserMonthlySet:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_SET_LOGGEDIN_INACTIVE_USER_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
        case NGLocalNotificationGALoggedInInactiveUserMonthlyCancel:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CANCEL_LOGGEDIN_INACTIVE_USER_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
        case NGLocalNotificationGALoggedInInactiveUserMonthlyClick:{
            eventLabel = K_GA_LOCAL_NOTIFICATION_LABEL_CLICK_LOGGEDIN_INACTIVE_USER_MONTHLY;
            eventAction = K_GA_LOCAL_NOTIFICATION_ACTION_USER_ENGAGEMENT;
        }break;
            
            
        default:
            break;
    }
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_NOTIFICATION_CATEGORY withEventAction:eventAction withEventLabel:eventLabel withEventValue:nil];
}

-(void)cancelAllLocalNotifications{
    //cancel all and sync all flags to NO
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self cancelLocalNotificationsForLoggedInUser];
    
    [self cancelLocalNotificationsForNonLoggedInUser];
}

-(void)cancelLocalNotificationsForLoggedInUser{
    //cancel all local notification for loggedin user
    //and sync it
    isCVNotUploadedNotificationSet = NO;
    isProfilePicNotUploadedNotificationSet = NO;
    
    [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_EDIT_CV];
    [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_PROFILE];
    [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_MNJ];
}

-(void)cancelLocalNotificationsForNonLoggedInUser{
    isNotLoggedInUserNotificationSet = NO;
    
    [NGLocalNotificationHelper cancelLocalNotificationForNotificationId:K_LOCAL_NOTIFICATION_PAGE_ID_LOGIN];
    
    [[NGResmanNotificationHelper sharedInstance] checkAndManageResmanNotificationForAppState:NGResmanNotificationAppStateCancel];
}

-(void)validateLocalNotifications{
    
    if (alreadyValidatedLocalNotifications) {
        return;
    }
    
    NSArray *localNotificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (nil != localNotificationList && 0<[localNotificationList count]) {
        for (UILocalNotification *localNotification in localNotificationList) {
            NSString *notificationId = [[localNotification userInfo] objectForKey:K_LOCAL_NOTIFICATION_ID];
            if (nil != notificationId && 0<notificationId.length){
                
                if ([K_LOCAL_NOTIFICATION_PAGE_ID_EDIT_CV isEqualToString:notificationId]){
                    isCVNotUploadedNotificationSet = YES;
                    
                }else if ([K_LOCAL_NOTIFICATION_PAGE_ID_PROFILE isEqualToString:notificationId]){
                    isProfilePicNotUploadedNotificationSet = YES;
                    
                }else if ([K_LOCAL_NOTIFICATION_PAGE_ID_LOGIN isEqualToString:notificationId]){
                    isNotLoggedInUserNotificationSet = YES;
                    
                }
                else if ([K_LOCAL_NOTIFICATION_PAGE_ID_BIRTHDAY isEqualToString:notificationId]){
                    isUserBirthdayNotificationSet = YES;
                    
                }
                
                
                else{
                    //dummy
                }
            }
        }
    }
}

#pragma mark - AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc{
    if([vc isKindOfClass:[NGJobAnalyticsViewController class]])
    {
        NGJobAnalyticsViewController* jaVC = (NGJobAnalyticsViewController*)vc;
        jaVC.selectedTabIndex = 2;
        
        NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager] getAllRecommendedJobs]];
        jaVC.savedJobsArr = (NSMutableArray*)[[tempArr reverseObjectEnumerator] allObjects];//coolban
        
    }else if([vc isKindOfClass:[NGLoginViewController class]]){
        
        NGLoginViewController* viewC = (NGLoginViewController*)vc;
        
        [viewC showViewWithType:LOGINVIEWTYPE_REGISTER_VIEW];
        [viewC setTitleForLoginView:@"Job Seeker Login"];
    }else if ([vc isKindOfClass:[NGProfileViewController class]]){
        ((NGProfileViewController*)vc).autoLandingSection = profilelandingSection;
    }else{
        //dummy
    }
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
}

@end
