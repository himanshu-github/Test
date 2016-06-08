//
//  NGResmanHelper.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 09/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NGResmanPage){
    NGResmanPageNone = 0,
    NGResmanPageCreateAccount = 1,
    NGResmanPageSelectFresherOrExperience = 2,

    NGResmanPageExperienceBasicDetails = 3,
    NGResmanPageFresherEducationDetails = 4,
    
    NGResmanPageExperienceProfessionalDetails = 5,
    NGResmanPageFresherKeySkills = 6,
    
    NGResmanPageExperienceKeySkills = 7,
    NGResmanPageFresherPersonalDetailAndRegister = 8,
    
    NGResmanPageExperiencePersonalDetailAndRegister = 9,
    
    NGResmanPageProfileOrSearchOption,//do not give any constant number
    NGResmanPageJobPreference//do not give any constant number
};

typedef NS_ENUM(NSUInteger, NGResmanNotificationGA){
    NGResmanNotificationGA6HourSet,
    NGResmanNotificationGA3DaySet,
    NGResmanNotificationGA7DaySet,
    NGResmanNotificationGA2DayJobPreferenceSet,
    NGResmanNotificationGA2ndWeekJobPreferenceSet,
    NGResmanNotificationGA6HourClick,
    NGResmanNotificationGA3DayClick,
    NGResmanNotificationGA7DayClick,
    NGResmanNotificationGA2DayJobPreferenceClick,
    NGResmanNotificationGA2ndWeekJobPreferenceClick,
    NGResmanNotificationGAUserRegViaNotificationGeneral,
    NGResmanNotificationGAUserAlreadyRegisteredGeneral
};

typedef NS_ENUM(NSUInteger, NGResmanNotificationAppState){
    NGResmanNotificationAppStateNone,
    NGResmanNotificationAppStateCancel,
    NGResmanNotificationAppStateActive,
    NGResmanNotificationAppStateBackground
};

@interface NGResmanNotificationHelper : NSObject

+(instancetype)sharedInstance;
-(void)setCurrentPage:(NGResmanPage)paramPage;
-(void)setUserAsFresher:(BOOL)paramIsFresher;
-(void)reportUserRegistrationForGA;
-(void)setJobPreferenceNotification;
-(void)checkAndManageResmanNotificationForAppState:(NGResmanNotificationAppState)paramAppState;
-(void)processNotificationInfo:(NSDictionary*)paramNotificationInfo;
@end
