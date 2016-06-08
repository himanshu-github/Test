//
//  BannerManager.h
//  Naukri
//
//  Created by Swati Kaushik on 10/09/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertBanner.h"
@interface BannerManager : NSObject

@property (nonatomic,assign) int numVisibleBanners;
+ (id)sharedInstance;
-(void)showAlertBannerWithType:(BannerType)type position:(BannerPosition)position onView:(id)view title:(NSString *)title subtitle:(NSString *)subtitle;
-(void)showAlertBannerWithType:(BannerType)type position:(BannerPosition)position onView:(id)view duration:(float)duration title:(NSString*)title subtitle:(NSString*)subtitle priority:(BannerPriority)priority afterDelay:(float)delay;
-(void)hideAllBanners;
@end
