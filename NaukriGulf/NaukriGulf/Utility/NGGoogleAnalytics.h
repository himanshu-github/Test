//
//  NGGoogleAnalytics.h
//  NaukriGulf
//
//  Created by Ajeesh T S on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAILogger.h"
#import "GAI.h"

@interface NGGoogleAnalytics : NSObject

// It is for send the screen report to Google Analytics.

+(void)initialiseGoogleAnalytics;

+(void)appEnteredBackground:(BOOL)flag;

+(void)sendScreenReport:(NSString *)screenName;

+(void)sendEventWithEventCategory:(NSString *)category withEventAction:(NSString *)action withEventLabel:(NSString *)label withEventValue:(NSNumber*)value;

+(void)sendLoadTime:(NSTimeInterval)loadTime withCategory:(NSString *)category withEventName:(NSString *)name withTimngLabel:(NSString *)timingLabel;

+(void)sendExceptionWithDescription:(NSString *)description withIsFatal:(BOOL)isFatal;

@end
