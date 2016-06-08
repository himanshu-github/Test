//
//  NGNotificationWebHandler.m
//  NaukriGulf
//
//  Created by Minni Arora on 22/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGNotificationWebHandler.h"

@implementation NGNotificationWebHandler

static NGNotificationWebHandler *singleton;

/**
 *  A Shared Instance Singleton class of NGNotificationWebHandler
 *
 *  @return sharedInstance created once only
 */

+(NGNotificationWebHandler *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleton==nil) {
            singleton = [[NGNotificationWebHandler alloc]init];
            
        }
    });
    return singleton;
}

-(id)init{
    if (self=[super init]) {
        
    }
    
    return self;
}

#pragma mark - Public Methods
/**
 *  @name Public Method
 */
/**
 *  Method register the logged in user device
 *
 *  @param params NSDictionary
 */
-(void)registerDevice:(NSDictionary*)params{
    [self updateInfo:params];
}
/**
 *  Method updaate the user infomation
 *
 *  @param params NSDictionary
 */
-(void)updateUser:(NSDictionary*)params{
    [self updateInfo:params];
}


#pragma mark - Private Methods
/**
 *  @name Private Methods
 */
/**
 *  Method create the service request for type : SERVICE_TYPE_UPDATE_INFO_NOTIFICATION, trigger when updateUser: or registerDevice: is called
 *
 *  @param params NSDictionary
 */
-(void)updateInfo:(NSDictionary*)params{
    
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_INFO_NOTIFICATION];
    [obj getDataWithParams:(NSMutableDictionary*)params handler:^(NGAPIResponseModal *responseData){}];
    
    
}

#pragma mark Push Notification Count

-(void)getNotifications
{
    
        NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
        [params setValue:[NGSavedData getDeviceToken] forKey:@"tokenId"];
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_GET_NOTIFICATION];
        
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
            
            if(responseData.isSuccess){
                
                NSArray *pushArray = responseData.parsedResponseData;
                
                
                pushArray = [self removeJADicFromDic:pushArray];
                
                
                [NGSavedData saveAllBadges:pushArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePush" object:nil userInfo:nil];
                    [NGUIUtility modifyBadgeOnIcon:[NGUIUtility getAllNotificationsCount]];
                });
            }
            
        }];
        
    
}
/*
 NOTE:This method is introduced to remove Job alert dic from server response.
 Discussed with all teams as well.
 */
-(NSArray*)removeJADicFromDic:(NSArray*)paramArray {
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:paramArray];
    if(newArray && 0 < newArray.count){
        NSInteger itemIndexToDelete = -1;
        NSInteger arrCount = [newArray count];
        for (NSInteger i = 0; i<arrCount; i++) {
            NSDictionary *dict = [newArray fetchObjectAtIndex:i];
            
            NSString *pushType = [dict objectForKey:@"pushType"];
            if ([KEY_BADGE_TYPE_JA isEqualToString:pushType]) {
                itemIndexToDelete = i;
                break;
            }
        }
        
        if (-1 != itemIndexToDelete) {
            [newArray removeObjectAtIndex:itemIndexToDelete];
        }
    }
    return newArray;
}

-(void)resetNotifications:(NSString*)pushType
{
    
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    [params setValue:[NGSavedData getDeviceToken] forKey:@"tokenId"];
    [params setValue:pushType forKey:@"pushType"];
    
    
    __weak NGNotificationWebHandler *weakVC = self;
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_RESET_NOTIFICATION];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        
        
        if(responseData.isSuccess){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePush" object:nil userInfo:nil];
                
                [NGUIUtility modifyBadgeOnIcon:[NGUIUtility getAllNotificationsCount]];
                [weakVC getNotifications];
                
            });
        }
        
    }];
    
    
}

-(void)deletePushNotificationCount
{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    [params setValue:[NGSavedData getDeviceToken] forKey:@"deviceId"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DELETE_PUSH_COUNT];

    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        if(responseData.isSuccess){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePush" object:nil userInfo:nil];
                [NGUIUtility modifyBadgeOnIcon:[NGUIUtility getAllNotificationsCount]];
            });
        }
    }];
}


@end
