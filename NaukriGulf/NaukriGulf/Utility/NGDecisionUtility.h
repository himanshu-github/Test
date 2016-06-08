//
//  NGSystemUtility.h
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGDecisionUtility : NSObject

+(BOOL)checkNetworkConnectivity;
+(BOOL)checkNetworkStatus;


+(BOOL)isJobReadWithID:(NSString *)jobID;
+(BOOL)isLooseCriteria:(NSDictionary *)paramsDict;
+(BOOL)isLeftSwipeEnabledForAppState:(NSInteger)appState;
+(BOOL)isRightSwipeEnabledForAppState:(NSInteger)appState;
+(BOOL)isEmailDomainRestricted:(NSString*)paramEmailDomain;
+(BOOL)isValidDeeplinkingURL:(NSString*)paramURL;
+(void)checkForSessionExpire:(enum ResponseCode)errorCode;

+(BOOL) isValidEmail:(NSString *)checkString;
+(BOOL) isValidNumber:(NSString *)checkString;
+(BOOL) isTextFieldNotEmpty:(NSString *)checkString;
+(BOOL)doesStringContainSpecialCharOrNumeric:(NSString *)checkString;
+(BOOL) isTextViewNotEmpty:(NSString *)checkString;
+(BOOL)isValidString:(id)checkString;
+(BOOL)isValidDate:(NSString *)dateStr;

+(BOOL)isValidJSON:(NSString *)str;
+(BOOL) doesStringContainSpecialCharsForKeywords:(NSString*) checkString;
+(BOOL)doesStringContainsSpecialChar:(NSString *)checkString;
+(BOOL) isValidNonEmptyNotNullString:(id)checkString;
+(BOOL)isValidArray:(NSArray*)paramArray;
+(BOOL)doesStringContainsSpecialCharAndNumeric:(NSString *)checkString;
+(BOOL)doesStringContainsSpecialCharForDesignation:(NSString *)checkString;
+(BOOL)isValidDropDownItem:(NSDictionary*)paramDDItem;
@end
