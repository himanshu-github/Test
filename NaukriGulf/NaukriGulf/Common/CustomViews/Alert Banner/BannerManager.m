//
//  BannerManager.m
//  Naukri
//
//  Created by Swati Kaushik on 10/09/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "BannerManager.h"
@interface BannerManager()
{
    int numShowing;
}
@property (nonatomic,strong) NSMutableArray* visibleBanners;
@property (nonatomic,assign) int currentHighestPriority;
@end
static const NSInteger kPriorityDefault = 1000;
static const float animationTime = 0.30f;
static const float defaultDuration = 2;
@implementation BannerManager
+ (id)sharedInstance
{
    static dispatch_once_t once;
    static BannerManager* sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.currentHighestPriority = 1000;
        sharedInstance.visibleBanners = [[NSMutableArray alloc]init];
        sharedInstance.numVisibleBanners = 1;
    });
    return sharedInstance;
}

-(void)showAlertBannerWithType:(BannerType)type position:(BannerPosition)position onView:(id)view title:(NSString *)title subtitle:(NSString *)subtitle
{
    [self showAlertBannerWithType:type position:position onView:view duration:defaultDuration title:title subtitle:subtitle priority:kPriorityDefault afterDelay:0];
}
-(void)showAlertBannerWithType:(BannerType)type position:(BannerPosition)position onView:(id)view duration:(float)duration title:(NSString *)title subtitle:(NSString *)subtitle priority:(BannerPriority)priority afterDelay:(float)delay{
    
     AlertBanner* alert = [[AlertBanner alloc]initWithType:type position:position onView:view duration:duration title:title subtitle:subtitle priority:priority];
    alert.priority = priority == BannerPriorityHigh?++_currentHighestPriority:kPriorityDefault;

    [_visibleBanners addObject:alert];
    [self showBanners];
}
#pragma mark - Private Methods
-(AlertBanner*)fetchLeastPriorityBanner{
    
    AlertBanner* bannerToRemove;
    for (int i = 0; i<_visibleBanners.count; i++) {
        AlertBanner* banner = [_visibleBanners objectAtIndex:i];
        if(banner.priority <= kPriorityDefault)
        {
            bannerToRemove = banner;
            break;
        }
        if(!bannerToRemove || banner.priority < bannerToRemove.priority)
            bannerToRemove = banner;
    }
    return bannerToRemove;
}
-(float)bannerOrigin:(AlertBanner*)banner{
    
    if(banner.bannerPosition==BannerPositionTop)
    {
        return 44+20;
        
        
    }
    else
    {
        return [UIScreen mainScreen].bounds.size.height-banner.frame.size.height;
    }
}
-(void)showBanners{
    
    AlertBanner*alert = [self fetchNextAlertToDisplay];
    if(!alert)
        return;
    if(numShowing>_numVisibleBanners-1)
    {
        if(alert.priority >= _currentHighestPriority)
        {
            AlertBanner* leastPriorityBanner = [self fetchLeastPriorityBanner];
            if(![leastPriorityBanner isEqual:alert])
            [self removeBanner:leastPriorityBanner];

        }
        else
        return;
        
    }
    numShowing +=1;
    
    if(alert.baseView == ViewTypeWindow)
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    else
    {
        if([alert.baseView isKindOfClass:[UIViewController class]])
        {
            [((UIViewController*)alert.baseView).view addSubview:alert ];
            
        }
        else
        {
            [(UIView*)alert.baseView addSubview:alert];
            
        }

    }
    
    CGRect frame = alert.frame;
    
    frame.origin.y = alert.bannerPosition==BannerPositionTop?-frame.size.height:[UIScreen mainScreen].bounds.size.height;
    alert.frame = frame;

    
    [UIView animateWithDuration:animationTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frameNew = alert.frame;
        frameNew.origin.y = [self bannerOrigin:alert];
        alert.frame = frameNew;
        
        for (NSInteger i = _visibleBanners.count-2; i>=0; i--) {
            
            AlertBanner* nextAlert = [_visibleBanners fetchObjectAtIndex:i];
            if(nextAlert)
            {
                CGRect frame = nextAlert.frame;
                frame.origin.y += alert.frame.size.height;
                nextAlert.frame = frame;
            }
        }
    }
   completion:^(BOOL completed)
     {
         alert.bannerState = BannerStateDisplaying;
         [self performSelector:@selector(hideBanner:) withObject:alert afterDelay:alert.displayTime];//
     }];
}

-(void)hideBanner:(AlertBanner*)alert
{
    if(![_visibleBanners containsObject:alert])
    {
        return;
    }
    [UIView animateWithDuration:animationTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = alert.frame;
        frame.origin.y = alert.bannerPosition==BannerPositionTop?-frame.size.height:[UIScreen mainScreen].bounds.size.height;
        alert.frame = frame;
        for (NSInteger i = [_visibleBanners indexOfObject:alert]-1; i>=0; i--) {
            AlertBanner* nextAlert = [_visibleBanners fetchObjectAtIndex:i];
            if(nextAlert)
            {
                CGRect frame = nextAlert.frame;
                frame.origin.y -= alert.frame.size.height;
                nextAlert.frame = frame;
            }
        }
        
    } completion:^(BOOL completed)
     {
         [self removeBanner:alert];
         [self showBanners];

     }];
    
}
-(void)removeBanner:(AlertBanner*)alert{
    alert.bannerState = BannerStateCompleted;
    [alert removeFromSuperview];
    numShowing = numShowing==0?0:numShowing-1;
    [_visibleBanners removeObject:alert];
    if([self isHighPriorityBanner:alert])
    {
        for (AlertBanner*banner in _visibleBanners)
        {
            if([self isHighPriorityBanner:banner])//high priority banner
            {
                banner.priority = --_currentHighestPriority;
            }
        }
    }
    
    if(_visibleBanners.count == 0)
        _currentHighestPriority = kPriorityDefault;
}
-(BOOL)isHighPriorityBanner:(AlertBanner*)alert{
    if(alert.priority > kPriorityDefault)
        return YES;
    return NO;
}
-(AlertBanner*)fetchNextAlertToDisplay{
    for (NSInteger i = _visibleBanners.count-1; i>=0; i--) {
        AlertBanner* nextAlert = [_visibleBanners fetchObjectAtIndex:i];
        if(nextAlert.bannerState == BannerStatePending)
            return nextAlert;
    }
    return nil;
}
-(void)hideAllBanners{
    for (AlertBanner*banner in _visibleBanners)
    {
        [banner removeFromSuperview];
    }
    [_visibleBanners removeAllObjects];
    numShowing = 0;
    _currentHighestPriority = 0;
}
@end
