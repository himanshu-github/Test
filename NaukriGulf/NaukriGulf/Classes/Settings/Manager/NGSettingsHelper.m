//
//  NGSettingsHelper.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 10/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGSettingsHelper.h"
#import "NGWebDataManager.h"
#import "NGSettingsModel.h"

@implementation NGSettingsHelper

+(NGSettingsHelper *)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}
-(void)fetchSettingsFromServer{
    
    if([NGHelper sharedInstance].serverSettingsRunning == YES)
        return;
    
    [[NGHelper sharedInstance] serverSettingsISRunning];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SETTINGS];
    
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format", nil]] handler:^(NGAPIResponseModal *responseData) {
        
        if (responseData.isSuccess) {
            
            switch (responseData.serviceType) {
                case SERVICE_TYPE_SETTINGS:{
                    
                    if (K_RESPONSE_SUCCESS == responseData.responseCode) {
                        
                        [NGSavedData saveSettingsAPILastHitDate:[NSDate date]];
                        NGSettingsModel *settingsModel = [responseData.parsedResponseData objectForKey:@"apiModel"];

                        [NGSavedData saveWillShowCelebrationImageKeyValue:settingsModel.willShowCelebrationImage];
                        [NGSavedData saveLoggingEnabledKeyValue:settingsModel.isLoggingEnabled];

                        
                        if (![[NGHelper sharedInstance] isUserLoggedIn]) {
                            
                            return ;
                        }
                        
                        
                        NSNumber *backgroundFetchIntervalFromServer = settingsModel.localRecoInterval;
                        if(backgroundFetchIntervalFromServer){
                            NSComparisonResult compareResult = [[NSNumber numberWithFloat:0.0] compare:backgroundFetchIntervalFromServer];
                            if (compareResult == NSOrderedDescending){
                                //cancel all logged in user notification
                                [[NGLocalNotificationHelper sharedInstance] cancelLocalNotificationsForLoggedInUser];
                            }
                            [NGSavedData saveRecoJobBackgroundHitInterval:backgroundFetchIntervalFromServer];

                        }
                        else{
                            //dummy
                        }
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        }
        else{
            [NGSavedData saveRecoJobBackgroundHitInterval:[NSNumber numberWithLongLong:K_DEFAULT_RECOJOBS_BACKGROUND_HIT_INTERVAL]];//default interval incase of server response error
        }
        
    }];
    
}
@end
