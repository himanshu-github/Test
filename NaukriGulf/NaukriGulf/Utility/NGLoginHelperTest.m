//
//  NGLoginHelperTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGLoginHelperTest.h"
#import "NGLoginHelper.h"

@implementation NGLoginHelperTest{
    NGMNJProfileModalClass *userProfileModal;
}

+(instancetype)sharedInstance{
    static NGLoginHelperTest *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGLoginHelperTest alloc]init];
    });
    return sharedInstance;
}

-(NSString*)defaultTestUserId{
    return @"gulflive1@gmail.com";
}
- (NSString*)defaultTestUserPassword{
    return @"123456";
    //@"naukri";
}
- (void)makeUserLogIn{
    NSDictionary *dict = [NGSavedData getUserDetails];
    NSString *conmnj = [dict objectForKey:@"conmnj"];
    if (nil==conmnj || 0<conmnj.length) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self defaultTestUserId],@"username",[self defaultTestUserPassword],@"password", nil];
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_LOGIN];
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (responseData.isSuccess) {
                    NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
                    
                    NSString *conMnj = [responseDataDict objectForKey:KEY_LOGIN_CONMNJ]?[responseDataDict objectForKey:KEY_LOGIN_CONMNJ]:[responseDataDict objectForKey:KEY_LOGIN_AUTH];
                    [NGLoginHelper sharedInstance].delegate = self;
                    [NGLoginHelper sharedInstance].conMnj = conMnj;
                    
                }
                else{
                    [_delegate errorInLoginTest];
                }
            });
        }];
        
    }else{
        [self callSuccessLoginTestDelegate];
    }
}

- (void)makeUserLogOut{
    NSDictionary *dict = [NGSavedData getUserDetails];
    NSString *conmnj = [dict objectForKey:@"conmnj"];
    if (conmnj){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_LOGOUT];
        
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
            
            if(responseData.isSuccess){
                
                if(responseData.serviceType == SERVICE_TYPE_LOGOUT){
                    
                    [NGUIUtility makeUserLoggedOutOnSessionExpired:NO];
                    NSString *deviceToken = [NGSavedData getDeviceToken];
                    [[NGNotificationWebHandler sharedInstance]registerDevice:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",deviceToken,@"tokenId",[NSNumber numberWithBool:NO],@"loginStatus" ,nil]];
                }
                [_delegate successfullyLogoutTest];
                
            }else{
                [_delegate errorInLogoutTest];
            }
        }];
    }else{
        [_delegate successfullyLogoutTest];
    }
}

-(void)doneFetchingProfile:(NGMNJProfileModalClass *)profileModal{
    if (nil != profileModal) {
        userProfileModal = profileModal;
    }
    [self callSuccessLoginTestDelegate];
}
-(void)callSuccessLoginTestDelegate{
    if ([_delegate respondsToSelector:@selector(successfullyLoginTestWithProfileModal:)]) {
        [_delegate successfullyLoginTestWithProfileModal:userProfileModal];
    }else if ([_delegate respondsToSelector:@selector(successfullyLoginTest)]) {
        [_delegate successfullyLoginTest];
    }else{
        //do nothing
    }
}
@end
