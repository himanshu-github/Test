//
//  NGGoogleAnalytics.m
//  NaukriGulf
//
//  Created by Ajeesh T S on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGGoogleAnalytics.h"

@implementation NGGoogleAnalytics

static bool appInBackground;


+(void)initialiseGoogleAnalytics{
    
    appInBackground = NO;
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;

    
}
+(void)appEnteredBackground:(BOOL)paramStatus{
    appInBackground = paramStatus;
}
+(void)sendScreenReport:(NSString *)screenName{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker set:kGAIScreenName
           value:screenName];
    tracker.allowIDFACollection = YES;
    GAIDictionaryBuilder *gaBuilder = [GAIDictionaryBuilder createScreenView];
    [tracker send:[gaBuilder build]];
}

+(id)defaultGATRacker{
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:appInBackground?[[NSBundle mainBundle] infoDictionary][@"GoogleAnalyticBackground"]:[[NSBundle mainBundle] infoDictionary][@"GoogleAnalyticActive"]];
    tracker.allowIDFACollection = YES;
    return tracker;
    
}

+(void)sendEventWithEventCategory:(NSString *)category withEventAction:(NSString *)action withEventLabel:(NSString *)label withEventValue:(NSNumber*)value{
  
    GAIDictionaryBuilder *gaBuilder = [GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
                                           action:action  // Event action (required)
                                            label:label          // Event label
                                                                              value:value];
    [[[self class] defaultGATRacker] send:[gaBuilder build]];    // Event value


}

+(void)sendLoadTime:(NSTimeInterval )loadTime withCategory:(NSString *)category withEventName:(NSString *)name withTimngLabel:(NSString *)timingLabel{
    
    NSInteger timeSec = loadTime;
    NSNumber *timeValue;
    timeSec = 1000 *loadTime;
    timeValue = [NSNumber numberWithInteger:timeSec];
    
    
    GAIDictionaryBuilder *gaBuilder = [GAIDictionaryBuilder createTimingWithCategory:category
                                                                            interval:timeValue
                                                                                name:name  // Timing name
                                                                               label:timingLabel];
    [[[self class] defaultGATRacker] send:[gaBuilder build]];    // Timing label
}

+(void)sendExceptionWithDescription:(NSString *)description withIsFatal:(BOOL)isFatal{
    
    GAIDictionaryBuilder *gaBuilder = [GAIDictionaryBuilder createExceptionWithDescription:description withFatal:[NSNumber numberWithBool:isFatal]];
    [[[self class] defaultGATRacker] send:[gaBuilder build]];
    // Exception description. May be truncated to 100 chars
                    // isFatal (required). NO indicates non-fatal exception.


}


@end
