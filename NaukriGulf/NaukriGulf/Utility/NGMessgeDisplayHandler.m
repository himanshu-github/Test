//
//  NGMessgeDisplayHandler.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMessgeDisplayHandler.h"

#import "BannerManager.h"

@implementation NGMessgeDisplayHandler

#pragma mark Success Messages

+(void)showSuccessBannerFromBottom:(UIView *)view title:(NSString*)title
                                                  subTitle:(NSString*)subTitle
                                                  animationTime:(float)animationTime
                                                  showAnimationDuration:(float)showAnimationDuration
{
    
    NSInteger minutesForAnimationTime = floor(animationTime/60);
    NSInteger minutesForAnimationDuration = floor(showAnimationDuration/60);
    
    [[BannerManager sharedInstance]showAlertBannerWithType:BannerTypeSuccess position:BannerPositionBottom onView:view duration:animationTime+(minutesForAnimationTime*60) title:title subtitle:subTitle priority:BannerPriorityHigh afterDelay:showAnimationDuration+(minutesForAnimationDuration*60)];
}

+(void)showSuccessBannerFromTop:(UIView *)view title:(NSString*)title
                          subTitle:(NSString*)subTitle
                     animationTime:(float)animationTime
             showAnimationDuration:(float)showAnimationDuration
{
    
    NSInteger minutesForAnimationTime = floor(animationTime/60);
    NSInteger minutesForAnimationDuration = floor(showAnimationDuration/60);
    
    [[BannerManager sharedInstance]showAlertBannerWithType:BannerTypeSuccess position:BannerPositionTop onView:view duration:animationTime+(minutesForAnimationTime*60) title:title subtitle:subTitle priority:BannerPriorityHigh afterDelay:showAnimationDuration+(minutesForAnimationDuration*60)];
}

+(void)showSuccessBannerFromTopWindow:(UIView *)view title:(NSString*)title
                             subTitle:(NSString*)subTitle
                        animationTime:(float)animationTime
                showAnimationDuration:(float)showAnimationDuration
{
    NSInteger minutesForAnimationTime = floor(animationTime/60);
    NSInteger minutesForAnimationDuration = floor(showAnimationDuration/60);
    
    [[BannerManager sharedInstance]showAlertBannerWithType:BannerTypeSuccess position:BannerPositionTop onView:ViewTypeWindow duration:animationTime+(minutesForAnimationTime*60) title:title subtitle:subTitle priority:BannerPriorityHigh afterDelay:showAnimationDuration+(minutesForAnimationDuration*60)];
}

+(void)showSuccessBannerFromBottomWindow:(UIView *)view title:(NSString*)title
                             subTitle:(NSString*)subTitle
                        animationTime:(float)animationTime
                showAnimationDuration:(float)showAnimationDuration
{
    NSInteger minutesForAnimationTime = floor(animationTime/60);
    NSInteger minutesForAnimationDuration = floor(showAnimationDuration/60);
    
    [[BannerManager sharedInstance]showAlertBannerWithType:BannerTypeSuccess position:BannerPositionBottom onView:ViewTypeWindow duration:animationTime+(minutesForAnimationTime*60) title:title subtitle:subTitle priority:BannerPriorityHigh afterDelay:showAnimationDuration+(minutesForAnimationDuration*60)];
}


#pragma mark Error Messages

+(void)showErrorBannerFromBottom:(UIView *)view title:(NSString*)title
                          subTitle:(NSString*)subTitle
                     animationTime:(float)animationTime
             showAnimationDuration:(float)showAnimationDuration
{
    
    NSInteger minutesForAnimationTime = floor(animationTime/60);
    NSInteger minutesForAnimationDuration = floor(showAnimationDuration/60);
    
    [[BannerManager sharedInstance]showAlertBannerWithType:BannerTypeError position:BannerPositionBottom onView:view duration:animationTime+(minutesForAnimationTime*60) title:title subtitle:subTitle priority:BannerPriorityHigh afterDelay:showAnimationDuration+(minutesForAnimationDuration*60)];
}

+(void)showErrorBannerFromTop:(UIView *)view title:(NSString*)title
                        subTitle:(NSString*)subTitle
                   animationTime:(float)animationTime
           showAnimationDuration:(float)showAnimationDuration
{
    
    NSInteger minutesForAnimationTime = floor(animationTime/60);
    NSInteger minutesForAnimationDuration = floor(showAnimationDuration/60);
    
    [[BannerManager sharedInstance]showAlertBannerWithType:BannerTypeError position:BannerPositionTop onView:view duration:animationTime+(minutesForAnimationTime*60) title:title subtitle:subTitle priority:BannerPriorityHigh afterDelay:showAnimationDuration+(minutesForAnimationDuration*60)];
}



+(void)showErrorBannerFromTopWindow:(UIView *)view title:(NSString*)title
                     subTitle:(NSString*)subTitle
                animationTime:(float)animationTime
        showAnimationDuration:(float)showAnimationDuration
{
    
    NSInteger minutesForAnimationTime = floor(animationTime/60);
    NSInteger minutesForAnimationDuration = floor(showAnimationDuration/60);
    
    [[BannerManager sharedInstance]showAlertBannerWithType:BannerTypeError position:BannerPositionTop onView:ViewTypeWindow duration:animationTime+(minutesForAnimationTime*60) title:title subtitle:subTitle priority:BannerPriorityHigh afterDelay:showAnimationDuration+(minutesForAnimationDuration*60)];
}

#pragma mark Hide All Messages

+(void)forceHideAllTopWindowMessages{
    [[BannerManager sharedInstance]hideAllBanners];
}

@end
