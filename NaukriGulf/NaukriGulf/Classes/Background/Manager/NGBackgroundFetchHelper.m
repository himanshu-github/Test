//
//  NGBackgroundFetchHelper.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGBackgroundFetchHelper.h"
#import "NGSettingsModel.h"
#import "NGRecommendedJobDetailModel.h"

@interface NGBackgroundFetchHelper(){
    
}
@end

@implementation NGBackgroundFetchHelper{
    // syntax follow the C rule; read from the centre outwards
    void (^_completionHandler)(UIBackgroundFetchResult);
}

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}
-(void) checkForNewRecommendedJobs:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventAction:K_GA_EVENT_RECOMMENDED_JOBS_BACKGROUND_FETCH withEventLabel:K_GA_EVENT_RECOMMENDED_JOBS_BACKGROUND_FETCH withEventValue:nil];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_MNJ_INCOMPLETE_SECTION];
    __weak NGBackgroundFetchHelper *mySelfWeak = self;
    
    
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseData) {
        if (responseData.isSuccess) {
            switch (responseData.serviceType) {
                case SERVICE_TYPE_MNJ_INCOMPLETE_SECTION:
                {
                    NSInteger newRecoJobsCountFromServer = 0;
                    NSInteger totalRecoJobsCountFromServer = 0;
                    
                    NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
                    totalRecoJobsCountFromServer = [[responseDataDict objectForKey:KEY_MNJ_RECOMMENDED_JOBS_COUNT_DATA]integerValue];

                    newRecoJobsCountFromServer = [[responseDataDict objectForKey:KEY_MNJ_RECOMMENDED_NEW_JOBS_COUNT_DATA]integerValue];
                    
                    [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_JA withBadgeNumber:newRecoJobsCountFromServer];
                    
                    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_NOTIFICATION_CATEGORY withEventAction:K_GA_EVENT_RECOMMENDED_JOB_NOTIFICATION withEventLabel:K_GA_EVENT_RECOMMENDED_JOB_NOTIFICATION withEventValue:nil];
                    
                    [NGSavedData saveLastHitDateOfRecoJobsDownload:[NSDate date]];
                    
                    if (0 < newRecoJobsCountFromServer) {
                        //set app badge count
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [NGUIUtility modifyBadgeOnIcon:[NGUIUtility getAllNotificationsCount]];
                            
                            [mySelfWeak showAlertForRecommendedJobs:newRecoJobsCountFromServer];
                            
                            //this for background fetch performance
                            if(0 < totalRecoJobsCountFromServer){
                                _completionHandler(UIBackgroundFetchResultNewData);
                            }else{
                                _completionHandler(UIBackgroundFetchResultNoData);
                            }
                        });
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            
            NSString *eventLabel = K_GA_EVENT_BACKGROUNDFETCH_FAILED_API_INVALID_RESPONSE;
            NSNumber *responseCodeNum = [NSNumber numberWithInteger:responseData.responseCode];
            if (responseData.isNetworFailed)
                eventLabel = K_GA_EVENT_BACKGROUNDFETCH_FAILED_NETWORK_NOT_FOUND;
            
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_BACKGROUNDFETCH withEventAction:K_GA_ACTION_BACKGROUNDFETCH_RECO_JOBS withEventLabel:eventLabel withEventValue:responseCodeNum];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _completionHandler(UIBackgroundFetchResultFailed);
            });
        }
    }];
    
    _completionHandler = completionHandler;
}

-(void)showAlertForRecommendedJobs:(NSInteger)countForNewJobs {
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) return;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    [localNotif setCategory:@"reco"]; //adding for watch
     NSDate *fireTime = [NSDate dateWithTimeIntervalSinceNow:60*2]; // after 2minutess
    localNotif.fireDate = fireTime;
    localNotif.alertBody = [NSString stringWithFormat:@"You have %ld new recommended %@",(long)countForNewJobs,(countForNewJobs <= 1)?@"job":@"jobs"];
    
    localNotif.alertAction = @"View";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.userInfo = @{
                            K_NOTIFICATION_TYPE_TITLE : [NSNumber numberWithInteger: K_RECOMMENDED_JOBS_LOCAL_NOTIFICATION]
                            };
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}
-(BOOL)shouldPerformBgFetchForRecommendedJobs{
    
    
    long long recoJobHitIntervalTime = [[NGSavedData recoJobBackgroundHitInterval] longLongValue];
   
    if (0 > recoJobHitIntervalTime) {//-1 is a switch to close it, hence check it before all
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_BACKGROUNDFETCH withEventAction:K_GA_ACTION_BACKGROUNDFETCH_RECO_JOBS withEventLabel:K_GA_EVENT_BACKGROUNDFETCH_FAILED_SERVER_INTERVAL withEventValue:[NSNumber numberWithFloat:(recoJobHitIntervalTime/3600.0)]];
        
        return NO;
    }
    
    
    if([NGDateManager isNightTimeInDate:[NSDate date]]){//if time is between 1 to 7am
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_BACKGROUNDFETCH withEventAction:K_GA_ACTION_BACKGROUNDFETCH_RECO_JOBS withEventLabel:K_GA_EVENT_BACKGROUNDFETCH_FAILED_NIGHT_TIME withEventValue:nil];
        
        return NO;
    }
    
    NSDate *lastHitDate  = [NGSavedData lastHitDateOfRecoJobsDownload];
    
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:lastHitDate];
    
    if(distanceBetweenDates >= recoJobHitIntervalTime)
    {
        return YES;
    }
    else{
       
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_BACKGROUNDFETCH withEventAction:K_GA_ACTION_BACKGROUNDFETCH_RECO_JOBS withEventLabel:K_GA_EVENT_BACKGROUNDFETCH_FAILED_BEFORE_INTERVAL_ACCESS withEventValue:nil];
    }
    
    
    return NO;
}

@end
