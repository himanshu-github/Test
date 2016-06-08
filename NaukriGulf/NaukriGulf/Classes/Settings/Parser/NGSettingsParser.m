//
//  NGSettingsParser.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGSettingsParser.h"
#import "NGSettingsModel.h"


@implementation NGSettingsParser

-(id)parseResponseDataFromServer:(NGAPIResponseModal*)model{
    
    NSDictionary *dict = [model.responseData JSONValue];
    
    NSMutableDictionary *responseDict = [NSMutableDictionary dictionary];
    
    if([dict objectForKey:KEY_ERROR]){
        
        NSMutableDictionary* errorDict = [dict objectForKey:KEY_ERROR];
        [responseDict setCustomObject:errorDict forKey:@"apiModel"];
        [responseDict setCustomObject:@"Error" forKey:K_KEY_SETTINGS_API_STATUS];
    }
    else{
        
        //if both default and app keys are present then they can have same values,
        //hence give preference to app key
        NSError *error = nil;
        NSDictionary *customDic = [self createCustomDictionaryFromServerDictionary:dict];
        NGSettingsModel *objModel = [[NGSettingsModel alloc]initWithDictionary:customDic error:&error];
        [objModel setDropDownModifiedListFromDic:dict];
        [responseDict setCustomObject:objModel forKey:@"apiModel"];
        [responseDict setCustomObject:@"Success" forKey:K_KEY_SETTINGS_API_STATUS];
        
    }
    
    model.parsedResponseData = responseDict;
    return model;
    
}
-(NSDictionary*)createCustomDictionaryFromServerDictionary:(NSDictionary*)paramServerDictionary{
    NSDictionary *customeDictionary = nil;
    NSDictionary *defaultKeyData = nil;
    NSDictionary *appKeyData = nil;
    NSNumber *localRecoInterval = @12.0;
    NSNumber *defaultRecoInterval = nil;
    NSNumber *appRecoInterval = nil;
    NSNumber *willShowCelebrationImage = nil;
    NSNumber *isLoggingEnabled = nil;

    @try {
        defaultKeyData = [paramServerDictionary objectForKey:@"default"];
        
        if ([self isValidDataDic:defaultKeyData]){
            NSDictionary *intervalSettingsKeyData = [defaultKeyData objectForKey:@"intervalSettings"];
            defaultRecoInterval = [intervalSettingsKeyData objectForKey:@"localRecoInterval"];
            intervalSettingsKeyData = nil;
        }
    }@catch (NSException *exception) {
    }
    
    @try {
        //note:don't make is else, it should be another if, so that values can be override
        appKeyData = [paramServerDictionary objectForKey:@"app"];
        if([self isValidDataDic:appKeyData]){
            NSDictionary *intervalSettingsKeyData = [appKeyData objectForKey:@"intervalSettings"];
            appRecoInterval = [intervalSettingsKeyData objectForKey:@"localRecoInterval"];
            willShowCelebrationImage = [appKeyData objectForKey:@"isNewSplash"];
            isLoggingEnabled = [appKeyData objectForKey:@"isLoggingEnabled"]?[appKeyData objectForKey:@"isLoggingEnabled"]:[NSNumber numberWithInt:0];

            intervalSettingsKeyData = nil;
        }
    }@catch (NSException *exception) {
    }
    
    //localRecoInterval is in hours from server side eg:2.5hr
    //hence we are converting it to seconds and saving at our end
    if (defaultRecoInterval && ![defaultRecoInterval isKindOfClass:[NSNull class]]) {
        localRecoInterval = defaultRecoInterval;
    }
    if (appRecoInterval && ![appRecoInterval isKindOfClass:[NSNull class]]) {
        localRecoInterval = appRecoInterval;
    }
    localRecoInterval = @([localRecoInterval doubleValue]*60*60);
    
    //now create our custom dictionary for model to pass
    customeDictionary = @{@"localRecoInterval":localRecoInterval,@"willShowCelebrationImage":willShowCelebrationImage,@"isLoggingEnabled":isLoggingEnabled};
    return customeDictionary;
}
-(BOOL)isValidDataDic:(NSDictionary*)paramDataDic{
    return (nil!=paramDataDic && ![paramDataDic isKindOfClass:[NSNull class]] && 0<[paramDataDic count]);
}
@end
