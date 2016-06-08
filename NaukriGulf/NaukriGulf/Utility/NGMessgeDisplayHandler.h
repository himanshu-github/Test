//
//  NGMessgeDisplayHandler.h
//  NaukriGulf
//
//  Created by Arun Kumar on 16/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGMessgeDisplayHandler : NSObject

#pragma mark Success Messages

+(void)showSuccessBannerFromBottom:(UIView *)view title:(NSString*)title
                          subTitle:(NSString*)subTitle
                     animationTime:(float)animationTime
             showAnimationDuration:(float)showAnimationDuration;


+(void)showSuccessBannerFromTop:(UIView *)view title:(NSString*)title
                          subTitle:(NSString*)subTitle
                     animationTime:(float)animationTime
             showAnimationDuration:(float)showAnimationDuration;

+(void)showSuccessBannerFromTopWindow:(UIView *)view title:(NSString*)title
                             subTitle:(NSString*)subTitle
                        animationTime:(float)animationTime
                showAnimationDuration:(float)showAnimationDuration;

+(void)showSuccessBannerFromBottomWindow:(UIView *)view title:(NSString*)title
                                subTitle:(NSString*)subTitle
                           animationTime:(float)animationTime
                   showAnimationDuration:(float)showAnimationDuration;
#pragma mark Error Messages

+(void)showErrorBannerFromBottom:(UIView *)view title:(NSString*)title
                        subTitle:(NSString*)subTitle
                   animationTime:(float)animationTime
           showAnimationDuration:(float)showAnimationDuration;

+(void)showErrorBannerFromTop:(UIView *)view title:(NSString*)title
                        subTitle:(NSString*)subTitle
                   animationTime:(float)animationTime
           showAnimationDuration:(float)showAnimationDuration;



+(void)showErrorBannerFromTopWindow:(UIView *)view title:(NSString*)title
                           subTitle:(NSString*)subTitle
                      animationTime:(float)animationTime
              showAnimationDuration:(float)showAnimationDuration;

#pragma mark Hide All Messages

+(void)forceHideAllTopWindowMessages;

@end
