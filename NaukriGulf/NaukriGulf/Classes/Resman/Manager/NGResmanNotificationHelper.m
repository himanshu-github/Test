//
//  NGResmanHelper.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 09/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanNotificationHelper.h"
#import "NGResmanLoginDetailsViewController.h"
#import "NGResmanFresherOrExpViewController.h"
#import "NGResmanKeySkillsViewController.h"
#import "NGResmanPersonalDetailsViewController.h"
#import "NGResmanFresherEducationViewController.h"
#import "NGResmanJobPreferencesViewController.h"

#define  K_RESMAN_NOTIFICATION_STATUS @"resmanNotificationStatusKey"

@interface NGResmanNotificationHelper (){
    
    NGResmanPage currentPage;//current resman page
    NGResmanPage previousPage;//previous resman page, i.e drop-out page
    
    NGResmanPage higestVisitedPage;//highest visited page to hold
    
    BOOL isFresherUser;//by default NO, means user is experience by default
    
    BOOL isNotificationON;
    
    BOOL hasUserComeViaNotification;
    
    NSArray *freshScreenArray;
    NSArray *experienceScreenArray;
    
    NGLoader* loader;
}
@property (nonatomic,readwrite) BOOL isUserRegistered;
@end

@implementation NGResmanNotificationHelper

static dispatch_once_t onceToken;
static NGResmanNotificationHelper *instanceVar;

+(instancetype)sharedInstance{
    dispatch_once(&onceToken, ^{
        instanceVar = [[NGResmanNotificationHelper alloc] init];
    });
    return instanceVar;
}

-(id)init{
    if (self) {
        //default init values
        currentPage = NGResmanPageNone;
        previousPage = NGResmanPageNone;
        higestVisitedPage = NGResmanPageNone;
        
        hasUserComeViaNotification = NO;
        isFresherUser = NO;
        
        freshScreenArray = @[[NSNumber numberWithInteger:NGResmanPageCreateAccount],
                             [NSNumber numberWithInteger:NGResmanPageSelectFresherOrExperience],
                             [NSNumber numberWithInteger:NGResmanPageFresherEducationDetails],
                             [NSNumber numberWithInteger:NGResmanPageFresherKeySkills],
                             [NSNumber numberWithInteger:NGResmanPageFresherPersonalDetailAndRegister]];
        
        experienceScreenArray = @[[NSNumber numberWithInteger:NGResmanPageCreateAccount],
                                  [NSNumber numberWithInteger:NGResmanPageSelectFresherOrExperience],
                                  [NSNumber numberWithInteger:NGResmanPageExperienceBasicDetails],
                                  [NSNumber numberWithInteger:NGResmanPageExperienceProfessionalDetails],
                                  [NSNumber numberWithInteger:NGResmanPageExperienceKeySkills],
                                  [NSNumber numberWithInteger:NGResmanPageExperiencePersonalDetailAndRegister],
                                  ];
        
    }
    return self;
}
-(BOOL)isUserRegistered{
    return [[NGHelper sharedInstance] isUserLoggedIn];
}
-(void)checkAndManageResmanNotificationForAppState:(NGResmanNotificationAppState)paramAppState{
    
    [self retrieveResmanNotificationInfo];
    
    if (isNotificationON) {
        if (NGResmanNotificationAppStateActive == paramAppState || NGResmanNotificationAppStateCancel == paramAppState) {
            [self cancelNotificationForIncompleteRegistration];
        }
    }else{
        if (NGResmanNotificationAppStateBackground == paramAppState) {
            
            if (NO == self.isUserRegistered) {
                
                BOOL isUserSubmittedFirstPage = (NGResmanPageCreateAccount < higestVisitedPage);
                
                if ([self isRegistrationProcessPage:currentPage] && isUserSubmittedFirstPage) {
                    //case - user drop from resman flow
                    [self createNotificationForIncompleteRegistrationWithLandingPage:currentPage];
                    
                }else if (isUserSubmittedFirstPage){
                    //case - when user exit from resman,but had visited more than 1st page of resman
                    [self createNotificationForIncompleteRegistrationWithLandingPage:NGResmanPageCreateAccount];
                }else{
                    //dummy
                }
                
            }else{
                if (NGResmanPageProfileOrSearchOption == currentPage) {
                    [self createNotificationForJobPreferencePage];
                }
            }
        }
    }
    
    [self saveResmanNotificationInfo];
}
-(BOOL)isRegistrationProcessPage:(NGResmanPage)paramPage{
    BOOL returnFlag = NO;
    switch (paramPage) {
        case NGResmanPageCreateAccount:
        case NGResmanPageSelectFresherOrExperience:
        case NGResmanPageExperienceBasicDetails:
        case NGResmanPageFresherEducationDetails:
        case NGResmanPageExperienceProfessionalDetails:
        case NGResmanPageFresherKeySkills:
        case NGResmanPageExperienceKeySkills:
        case NGResmanPageFresherPersonalDetailAndRegister:
        case NGResmanPageExperiencePersonalDetailAndRegister:
            returnFlag = YES;
            break;
            
        default:
            break;
    }
    return returnFlag;
}
-(void)setCurrentPage:(NGResmanPage)paramPage{
    if (NGResmanPageNone == paramPage){
        previousPage = currentPage = NGResmanPageNone;
        
    }else if (currentPage != paramPage) {
        previousPage = currentPage;
        currentPage = paramPage;
        
        if (currentPage > higestVisitedPage) {
            higestVisitedPage = currentPage;
        }
        
    }else{
        //dummy
    }
}
-(void)setHighestVisitedPage:(NGResmanPage)paramPage{
    higestVisitedPage = paramPage;
}


-(void)processNotificationInfo:(NSDictionary*)paramNotificationInfo{
    
    if (nil == paramNotificationInfo || 0>=paramNotificationInfo.count) {
        return;
    }
    
    NGResmanPage landingPage = NGResmanPageNone;
    @try {
        landingPage = (NGResmanPage)[[paramNotificationInfo objectForKey:K_NOTIFICATION_TYPE_SUBTITLE] unsignedIntegerValue];
        
        
        NSString *notificationId = (NSString*)[paramNotificationInfo objectForKey:K_LOCAL_NOTIFICATION_ID];
        
        if ([K_RESMAN_LOCAL_NOTIFICATION_6_HOUR_KEY isEqualToString:notificationId]) {
            [self sendResmanNotificationGA:NGResmanNotificationGA6HourClick];
            
        }else if ([K_RESMAN_LOCAL_NOTIFICATION_3_DAY_KEY isEqualToString:notificationId]){
            [self sendResmanNotificationGA:NGResmanNotificationGA3DayClick];
            
        }else if ([K_RESMAN_LOCAL_NOTIFICATION_7_DAY_KEY isEqualToString:notificationId]) {
            [self sendResmanNotificationGA:NGResmanNotificationGA7DayClick];
            
        }else if ([K_RESMAN_LOCAL_NOTIFICATION_2_DAY_JOB_PREF_KEY isEqualToString:notificationId]){
            [self sendResmanNotificationGA:NGResmanNotificationGA2DayJobPreferenceClick];
            
        }else if ([K_RESMAN_LOCAL_NOTIFICATION_2nd_WEEK_JOB_PREF_KEY isEqualToString:notificationId]){
            [self sendResmanNotificationGA:NGResmanNotificationGA2ndWeekJobPreferenceClick];
            
        }else{
            //dummy
        }
        
    }
    @catch (NSException *exception) {
        return;
    }
    
    
    if (self.isUserRegistered && NGResmanPageJobPreference != landingPage){
        return;
        //do nothing
        //invalid case
    }
    
    //check for resman user name
    NGResmanDataModel *resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    NSString *userName = resmanModel.userName;
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    BOOL isUserNameExist = (0 >=[vManager validateValue:userName withType:ValidationTypeString].count);
    isUserNameExist = (0 >=[vManager validateValue:userName withType:ValidationTypeEmail].count);
    
    if (NO==self.isUserRegistered && isUserNameExist) {
        [self checkForEmailExistanceAtServerForUserName:userName AndLandingPage:landingPage];
    }else{
        [self loadPage:landingPage];
    }
    
    resmanModel = nil;
    vManager = nil;
}
-(void)loadPage:(NGResmanPage)paramLandingPage{
    NGAppDelegate *appDelegate = [NGAppDelegate appDelegate];
    id landingVC;
    
    switch (paramLandingPage) {
        case NGResmanPageCreateAccount:{
            landingVC = [[NGResmanLoginDetailsViewController alloc] initWithNibName:nil bundle:nil];
        }break;
            
        case NGResmanPageSelectFresherOrExperience:{
            landingVC = [[NGResmanFresherOrExpViewController alloc] initWithNibName:nil bundle:nil];
        }break;
            
            //fresher
        case NGResmanPageFresherEducationDetails:{
            landingVC = [[NGResmanFresherEducationViewController alloc]  initWithNibName:nil bundle:nil];
        }break;
            
        case NGResmanPageFresherKeySkills:{
            landingVC = [[NGResmanKeySkillsViewController alloc]  initWithNibName:nil bundle:nil];
        }break;
            
        case NGResmanPageFresherPersonalDetailAndRegister:{
            landingVC = [[NGResmanPersonalDetailsViewController alloc]  initWithNibName:nil bundle:nil];
        }break;
            
            
            //experience
        case NGResmanPageExperienceBasicDetails:{
            landingVC = [[NGResmanExpBasicDetailsViewController alloc]  initWithNibName:nil bundle:nil];
        }break;
            
        case NGResmanPageExperienceProfessionalDetails:{
            landingVC = [[NGResmanExpProfessionalDetailsViewController alloc]  initWithNibName:nil bundle:nil];
        }break;
            
        case NGResmanPageExperienceKeySkills:{
            landingVC = [[NGResmanKeySkillsViewController alloc]  initWithNibName:nil bundle:nil];
        }break;
            
        case NGResmanPageExperiencePersonalDetailAndRegister:{
            landingVC = [[NGResmanPersonalDetailsViewController alloc]  initWithNibName:nil bundle:nil];
        }break;
            
            //job preference page
        case NGResmanPageJobPreference:{
            landingVC = [[NGResmanJobPreferencesViewController alloc]  initWithNibName:nil bundle:nil];
        }break;
            
        default:
            break;
    }
    
    
    if (landingVC) {
        hasUserComeViaNotification = YES;
        
        BOOL isAlreadyExist = NO;
        
        @try {
            //NOTE:To prevent re-pushing of same viewcontroller, check it's existance in stack
            UINavigationController *navCtnl = (UINavigationController*)appDelegate.container.centerViewController;
            id topViewController  = navCtnl.viewControllers.lastObject;
            NSString *topVCName = NSStringFromClass([topViewController class]);
            NSString *landingVCName = NSStringFromClass([landingVC class]);
            
            isAlreadyExist = [topVCName.lowercaseString isEqualToString:landingVCName.lowercaseString];
        }
        @catch (NSException *exception) {
        }
        
        if (NO == isAlreadyExist) {
            [appDelegate.container.centerViewController pushActionViewController:landingVC Animated:YES];
        }
    }
    
    appDelegate = nil;
}
-(void)saveResmanNotificationInfo{
    [NGSavedData saveResmanNotificationData:@{K_RESMAN_NOTIFICATION_STATUS:[NSNumber numberWithBool:isNotificationON]}];
}
-(void)retrieveResmanNotificationInfo{
    NSDictionary *resmanNotificationDic = [NGSavedData resmanNotificationData];
    if (nil != resmanNotificationDic && 0<resmanNotificationDic.count) {
        isNotificationON = [[resmanNotificationDic objectForKey:K_RESMAN_NOTIFICATION_STATUS] boolValue];
    }else{
        isNotificationON = NO;
    }
}
-(void)createNotificationForIncompleteRegistrationWithLandingPage:(NGResmanPage)paramLandingPage{
    NSDate *scheduleDate;
    NSString *alertBodyVal;
    NSDictionary *alertUserInfo;
    
    
    
    //+6hours day notification
    scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:6 InUnit:NGTimeUnitHour ToDate:[NSDate date]]];
    alertBodyVal = [NSString stringWithFormat:@"You are just %ld steps away from a complete Naukrigulf profile. Complete your Registration Now!",(long)[self stepAwayFromRegister]];
    alertUserInfo = @{
                      K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_RESMAN_LOCAL_NOTIFICATION],
                      K_NOTIFICATION_TYPE_SUBTITLE:[NSNumber numberWithUnsignedInteger:paramLandingPage],
                      K_RESMAN_LOCAL_NOTIFICATION_PREV_PAGE:[NSNumber numberWithUnsignedInteger:previousPage],
                      K_LOCAL_NOTIFICATION_ID:K_RESMAN_LOCAL_NOTIFICATION_6_HOUR_KEY
                      };
    [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:1 andUserInfo:alertUserInfo];
    [self sendResmanNotificationGA:NGResmanNotificationGA6HourSet];
    
    
    //+3 day notification
    scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:3 InUnit:NGTimeUnitDay ToDate:[NSDate date]]];
    alertBodyVal = @"More than 8000 recruiters are looking for you. Complete your Naukrigulf Registration Now!";
    alertUserInfo = @{
                      K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_RESMAN_LOCAL_NOTIFICATION],
                      K_NOTIFICATION_TYPE_SUBTITLE:[NSNumber numberWithUnsignedInteger:paramLandingPage],
                      K_RESMAN_LOCAL_NOTIFICATION_PREV_PAGE:[NSNumber numberWithUnsignedInteger:previousPage],
                      K_LOCAL_NOTIFICATION_ID:K_RESMAN_LOCAL_NOTIFICATION_3_DAY_KEY
                      };
    [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:1 andUserInfo:alertUserInfo];
    [self sendResmanNotificationGA:NGResmanNotificationGA3DaySet];
    
    
    //+7 day notification
    scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:7 InUnit:NGTimeUnitDay ToDate:[NSDate date]]];
    alertBodyVal = @"Apply to 8,000+ jobs in one click. Complete your Naukrigulf Registration Now!";
    alertUserInfo = @{
                      K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_RESMAN_LOCAL_NOTIFICATION],
                      K_NOTIFICATION_TYPE_SUBTITLE:[NSNumber numberWithUnsignedInteger:paramLandingPage],
                      K_RESMAN_LOCAL_NOTIFICATION_PREV_PAGE:[NSNumber numberWithUnsignedInteger:previousPage],
                      K_LOCAL_NOTIFICATION_ID:K_RESMAN_LOCAL_NOTIFICATION_7_DAY_KEY
                      };
    [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:1 andUserInfo:alertUserInfo];
    
    [self sendResmanNotificationGA:NGResmanNotificationGA7DaySet];
    
    isNotificationON = YES;
}

-(void)cancelNotificationForIncompleteRegistration{
    NSArray *localNotificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (nil != localNotificationList) {
        for (UILocalNotification *localNotification in localNotificationList) {
            NSString *notificationId = [[localNotification userInfo] objectForKey:K_LOCAL_NOTIFICATION_ID];
            if (nil != notificationId && 0<notificationId.length && [self isCancellableNotificationId:notificationId]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
    isNotificationON = NO;
}
-(BOOL)isCancellableNotificationId:(NSString*)paramNotificationId{
    if ([K_RESMAN_LOCAL_NOTIFICATION_6_HOUR_KEY isEqualToString:paramNotificationId] || [K_RESMAN_LOCAL_NOTIFICATION_3_DAY_KEY isEqualToString:paramNotificationId] || [K_RESMAN_LOCAL_NOTIFICATION_7_DAY_KEY isEqualToString:paramNotificationId]) {
        return YES;
    }
    return NO;
}
-(void)createNotificationForJobPreferencePage{
    NSDate *scheduleDate;
    NSString *alertBodyVal;
    NSDictionary *alertUserInfo;
    
    
    //+2 Days notification
    scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:2 InUnit:NGTimeUnitDay ToDate:[NSDate date]]];
    alertBodyVal = @"Complete Your Naukrigulf Profile Now! A rich profile has stronger chances of getting short-listed.";
    alertUserInfo = @{
                      K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_RESMAN_LOCAL_NOTIFICATION],
                      K_NOTIFICATION_TYPE_SUBTITLE:[NSNumber numberWithUnsignedInteger:NGResmanPageJobPreference],
                      K_RESMAN_LOCAL_NOTIFICATION_PREV_PAGE:[NSNumber numberWithUnsignedInteger:NGResmanPageNone],
                      K_LOCAL_NOTIFICATION_ID:K_RESMAN_LOCAL_NOTIFICATION_2_DAY_JOB_PREF_KEY
                      };
    [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:1 andUserInfo:alertUserInfo];
    
    [self sendResmanNotificationGA:NGResmanNotificationGA2DayJobPreferenceSet];
    
    
    //+14 Days(After 2 weeks) notification
    scheduleDate = [self createValidDateFromDate:[NGDateManager dateByAddingValue:14 InUnit:NGTimeUnitDay ToDate:[NSDate date]]];
    //alertBodyVal is same as above
    alertUserInfo = @{
                      K_NOTIFICATION_TYPE_TITLE:[NSNumber numberWithInt:K_RESMAN_LOCAL_NOTIFICATION],
                      K_NOTIFICATION_TYPE_SUBTITLE:[NSNumber numberWithUnsignedInteger:NGResmanPageJobPreference],
                      K_RESMAN_LOCAL_NOTIFICATION_PREV_PAGE:[NSNumber numberWithUnsignedInteger:NGResmanPageNone],
                      K_LOCAL_NOTIFICATION_ID:K_RESMAN_LOCAL_NOTIFICATION_2nd_WEEK_JOB_PREF_KEY
                      };
    [NGLocalNotificationHelper scheduleLocalNotificationForDate:scheduleDate alertBody:alertBodyVal alertAction:k_LOCAL_NOTIFICATION_ALERT_VIEW ApplicationBadge:1 andUserInfo:alertUserInfo];
    
    [self sendResmanNotificationGA:NGResmanNotificationGA2ndWeekJobPreferenceSet];
    
    
    
    isNotificationON = YES;
}

-(void)sendResmanNotificationGA:(NGResmanNotificationGA)paramResmanGA{
    NSString *eventAction = @"";
    NSString *eventLabel = @"";
    switch (paramResmanGA) {
        case NGResmanNotificationGA6HourSet:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_SET_6_HOUR;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_SET;
        }break;
            
        case NGResmanNotificationGA3DaySet:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_SET_3_DAY;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_SET;
        }break;
            
        case NGResmanNotificationGA7DaySet:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_SET_7_DAY;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_SET;
        }break;
            
        case NGResmanNotificationGA2DayJobPreferenceSet:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_SET_2_DAY_JOB_PREF;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_SET;
        }break;

        case NGResmanNotificationGA2ndWeekJobPreferenceSet:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_SET_2nd_WEEK_JOB_PREF;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_SET;
        }break;

            
        case NGResmanNotificationGA6HourClick:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_CLICK_6_HOUR;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_CLICK;
        }break;
            
        case NGResmanNotificationGA3DayClick:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_CLICK_3_DAY;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_CLICK;
        }break;
            
        case NGResmanNotificationGA7DayClick:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_CLICK_7_DAY;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_CLICK;
        }break;
            
        case NGResmanNotificationGA2DayJobPreferenceClick:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_CLICK_2_DAY_JOB_PREF;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_CLICK;
        }break;
            
        case NGResmanNotificationGA2ndWeekJobPreferenceClick:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_CLICK_2nd_WEEK_JOB_PREF;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_CLICK;
        }break;

            
        case  NGResmanNotificationGAUserRegViaNotificationGeneral:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_GENERAL_USER_REG_VIA_NOTIFICATION;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_GENERAL;
        }break;
            
        case NGResmanNotificationGAUserAlreadyRegisteredGeneral:{
            eventLabel = K_GA_LABEL_RESMAN_NOTIFICATION_GENERAL_USER_REG_ALREADY_REGISTERED;
            eventAction = K_GA_ACTION_RESMAN_NOTIFICATION_GENERAL;
        }break;
            
        default:
            break;
    }
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_RESMAN_NOTIFICATION withEventAction:eventAction withEventLabel:eventLabel withEventValue:nil];
}
-(void)reportUserRegistrationForGA{
    if (hasUserComeViaNotification) {
        [self sendResmanNotificationGA:NGResmanNotificationGAUserRegViaNotificationGeneral];
    }
    
    //NOTE:On successful registration of user
    //mandatory flow ended and we need not to
    //monitor page info
    [self setCurrentPage:NGResmanPageNone];
    [self setHighestVisitedPage:NGResmanPageNone];
}
-(void)setJobPreferenceNotification{
    [self createNotificationForJobPreferencePage];
}
-(NSDate*)createValidDateFromDate:(NSDate*)paramFromDate{
    //given date lies in night time
    //change hour and minute to 9:30am
    if ([NGDateManager isNightTimeInDate:paramFromDate]) {
        return [NGDateManager createNewDateFromDate:paramFromDate ForHour:9 AndForMinute:30];
    }
    return paramFromDate;
}

-(NSInteger)stepAwayFromRegister{
    NSInteger stepsAway = 0;
    
    NGResmanPage pageToConsider = (NGResmanPageNone < currentPage) ? currentPage : ((NGResmanPageNone < higestVisitedPage) ? NGResmanPageCreateAccount: NGResmanPageNone);
    
    if (NGResmanPageNone < pageToConsider) {
        NSUInteger screenPosition = NSNotFound;
        NSInteger totalScreens = 6;//as per experience flow
        
        if (isFresherUser) {
            screenPosition = [freshScreenArray indexOfObject:[NSNumber numberWithInteger:pageToConsider]];
            totalScreens = 5;
            
        }else{
            screenPosition = [experienceScreenArray indexOfObject:[NSNumber numberWithInteger:pageToConsider]];
        }
        
        if (NSNotFound != screenPosition) {
            stepsAway = totalScreens - screenPosition;
        }
    }
    return stepsAway;
}

-(void)setUserAsFresher:(BOOL)paramIsFresher{
    isFresherUser = paramIsFresher;
}
-(void) checkForEmailExistanceAtServerForUserName:(NSString*)paramUserName AndLandingPage:(NGResmanPage)paramLandingPage{
    
    [self showAnimator];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_CHECK_REGISTERED_USER];
    
    __weak NGResmanNotificationHelper *weakSelf = self;
    
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:paramUserName,@"email", nil] handler:^(NGAPIResponseModal *responseInfo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideAnimator];
            
            if (responseInfo.isSuccess) {
                NSString* emailExistStr = [[responseInfo.responseData JSONValue] objectForKey:KEY_REGISTERED_EMAIL_DATA];
                BOOL isEmailRegistered = [emailExistStr isEqualToString:@"true"]?TRUE:FALSE;
                if (isEmailRegistered) {
                    //send already registered GA
                    [weakSelf sendResmanNotificationGA:NGResmanNotificationGAUserAlreadyRegisteredGeneral];

                    //cancel all notifications
                    [self cancelNotificationForIncompleteRegistration];
                    
                    [self loadLoginPage];
                }else{
                    [weakSelf loadPage:paramLandingPage];
                }
            }else{
                [weakSelf loadPage:paramLandingPage];
            }
        });
        
    }];
}
-(void)loadLoginPage{
    if (NO == self.isUserRegistered) {
        NGAppDelegate *appDelegate = [NGAppDelegate appDelegate];
        NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
        [appStateHandler setDelegate:self];
        
        [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:appDelegate.container.centerViewController animated:YES];
        
        appStateHandler = nil;
    }
}

-(void)setPropertiesOfVC:(id)vc{
    
    if([vc isKindOfClass:[NGLoginViewController class]])
    {
        NGLoginViewController* viewC = (NGLoginViewController*)vc;
        
        [viewC showViewWithType:LOGINVIEWTYPE_REGISTER_VIEW];
        [viewC setTitleForLoginView:@"Job Seeker Login"];
    }
    
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
    
}
-(void)showAnimator{
    UIView *topView = ((UINavigationController*)[NGAppDelegate appDelegate].container.centerViewController).topViewController.view;
    
    if(!loader){
        loader = [[NGLoader alloc] initWithFrame:topView.frame];
        
    }
    [loader showAnimation:topView];
    
}

-(void)hideAnimator{
    UIView *topView = ((UINavigationController*)[NGAppDelegate appDelegate].container.centerViewController).topViewController.view;
    
    if ([loader isLoaderAvail]){
        [loader hideAnimatior:topView];
        loader = nil;
    }
    
}
@end
