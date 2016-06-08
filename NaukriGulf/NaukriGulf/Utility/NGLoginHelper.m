//
//  NGLoginHelper.m
//  NaukriGulf
//
//  Created by Swati Kaushik on 09/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGLoginHelper.h"
#import "NGUserDetails.h"
#import "WatchHelper.h"
#import "NGShortCutHandler.h"

@implementation NGLoginHelper
+(NGLoginHelper *)sharedInstance{
    static NGLoginHelper *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGLoginHelper alloc]init];
    });
    return sharedInstance;
}
-(void)setConMnj:(NSString *)conMnj{
    _conMnj = conMnj;
    [NGSavedData saveUserDetails:@"conmnj" withValue:conMnj];
    [NGHelper sharedInstance].isUserLoggedIn = YES;
    [self loginUser];
}
-(void)loginUser{
    NSString *deviceToken = [NGSavedData getDeviceToken];
    [[NGNotificationWebHandler sharedInstance]registerDevice:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",deviceToken,@"tokenId",[NSNumber numberWithBool:1],@"loginStatus",[NSString getAppVersion],@"appVersion" ,nil]];
    [self getUserDetails];
    [self getUserProfilePhoto];
    [NGSavedData resetBadgeConsumedInfo];
    
    [[NGLocalNotificationHelper sharedInstance] cancelLocalNotificationsForNonLoggedInUser];
}

#pragma mark - Other Methods
- (void)getUserProfilePhoto{
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_PROFILE_PHOTO];
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseData){}];
    
}
- (void)getUserDetails{
    
    __weak NGLoginHelper *weakObj = self;
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_USER_DETAILS];
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseData){
        
        if (responseData.isSuccess) {
            
            NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
            
            NSString *statusStr = [responseDataDict objectForKey:KEY_USER_DETAILS_STATUS];
            
            if ([statusStr isEqualToString:@"success"]) {
                
                [[WatchOSAndiOSCommunicationLayer sharedInstance] sendLoginStatusToWatch:YES];
                
                NGMNJProfileModalClass *userDetailsObj = [responseDataDict objectForKey:KEY_USER_DETAILS_INFO];

                
                [[DataManagerFactory getStaticContentManager] saveMNJUserProfile:userDetailsObj];
                [NGLoginHelper sendAppleWatchUserDetails];

                
                NSString *name = userDetailsObj.name;
                NSString *currentDesignation = userDetailsObj.currentDesignation;
                NSString *modifiedDate = userDetailsObj.profileModifiedDate;
                
                if (!currentDesignation) {
                    currentDesignation = @"";
                }
                NSDictionary *photoMetaDataDict = userDetailsObj.photoMetaData;
                NSString *photoUploadDate = @"";
                if (photoMetaDataDict) {
                    [NGSavedData saveUserDetails:@"photoUploadDate" withValue:[photoMetaDataDict objectForKey:@"uploadDate"]];
                    photoUploadDate = [photoMetaDataDict objectForKey:@"uploadDate"];
                }
                else{
                    [NGSavedData saveUserDetails:@"photoUploadDate" withValue:@""];
                }
                
                [NGSavedData saveUserDetails:@"name" withValue:name];
                [NGSavedData saveUserDetails:@"currentDesignation" withValue:currentDesignation];
                [NGSavedData saveEmailID:userDetailsObj.username];
                
                [NGSavedData saveUserDetails:@"modifiedDate" withValue:modifiedDate];
                
                [NGHelper sharedInstance].usrObj = [[NGUserDetails alloc]init];
                [NGHelper sharedInstance].usrObj.name = name;
                [NGHelper sharedInstance].usrObj.designation = currentDesignation;
                [NGHelper sharedInstance].usrObj.photoModifiedDate = photoUploadDate;
                [NGHelper sharedInstance].usrObj.lastModifiedDate = modifiedDate;
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakObj.delegate doneFetchingProfile:userDetailsObj];
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakObj.delegate doneFetchingProfile:nil];
                });
                
            }
            
        }else{
            
            [[WatchOSAndiOSCommunicationLayer sharedInstance] sendLoginStatusToWatch:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakObj.delegate doneFetchingProfile:nil];
            });
        }
        
    }];
}

-(void)showMNJHome{
    
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ usingNavigationController:APPDELEGATE.container.centerViewController animated:![[NGShortCutHandler sharedInstance] shotcutIdentifier]];
    [[NGShortCutHandler sharedInstance] navigateToScreensAccordingToIdentifier];

}
#pragma mark - send login feedback

+ (void)sendAppleWatchUserDetails {
    if ([[NGHelper sharedInstance] isUserLoggedIn]){
        if([WCSession isSupported]){
        WCSession *defaultSession = [WCSession defaultSession];
        if(defaultSession.watchAppInstalled){
            
          NGMNJProfileModalClass *_modalClassObj =  [[DataManagerFactory getStaticContentManager] getMNJUserProfile];

            NSString *emailID = @"";
            if(_modalClassObj.username.length>0)
                emailID = _modalClassObj.username;
            else
                emailID = [NGSavedData getEmailID];

            NSString *name = @"";
            if(_modalClassObj.name.length>0)
            name = _modalClassObj.name;
            else
            name = [[NGSavedData getUserDetails] valueForKey:@"name"];
            
        NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
        [params setValue:@"Apple Watch User Details" forKey:@"comment"];
        NSString *iosInfo = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion]];
        [params setValue:iosInfo forKey:@"mtype"];
        [params setValue:@"Apple watch user details " forKey:@"subject"];
        [params setValue:name forKey:@"name"];
        [params setValue:emailID forKey:@"email"];
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_FEEDBACK];
        
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(responseData.isSuccess){
                    //NSLog(@"Apple watch user sent successfully");
                    
                }else{
                    if ([responseData responseCode] == K_RESPONSE_ERROR){
                        //NSLog(@"Apple watch user not sent!");
                    }
                }
            });
        }];
        }
      }
    }
}

@end
