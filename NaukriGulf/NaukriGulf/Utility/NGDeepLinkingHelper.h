//
//  NGDeepLinkingHelper.h
//  NaukriGulf
//
//  Created by Swati Kaushik on 21/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ENUM(NSUInteger, NGDeeplinkingPage){
    NGDeeplinkingPageNone,
    NGDeeplinkingPageProfile,
    NGDeeplinkingPageJD
};

NS_ENUM(NSUInteger, NGDeepLinkingAppState){
    NGDeepLinkingAppStateNone,
    NGDeepLinkingAppStateLaunch,
    NGDeepLinkingAppStateBackground
};


@interface NGDeepLinkingHelper : NSObject

@property(nonatomic,readwrite) BOOL homeScreenFlagOfDeeplinking;

@property(nonatomic,readwrite) enum NGDeepLinkingAppState deeplinkingAppState;

@property(nonatomic,strong) NSString *deeplinkingSource;

@property(nonatomic,readwrite) enum NGDeeplinkingPage deeplinkingPage;

+ (id)sharedInstance;
-(void)setDeeplinkingConfigFromLaunchOption:(NSDictionary*)paramLaunchOption;
-(BOOL)validateAndPerformDeeplinkingWithURL:(NSURL*)paramURL;
-(void)handleDeeplinkingNotification;
@end
