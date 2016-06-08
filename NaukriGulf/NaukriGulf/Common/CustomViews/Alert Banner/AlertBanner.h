//
//  AlertBanner.h
//  Naukri
//
//  Created by Swati Kaushik on 10/09/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AlertBannerDelegate<NSObject>
-(void)bannerDidHide:(id)banner;
@end
@interface AlertBanner : UIView

typedef enum {
    BannerTypeInfo=0,
    BannerTypeError,
    BannerTypeSuccess
}BannerType;
typedef enum {
    BannerPositionTop=0,
    BannerPositionBottom
}BannerPosition;
typedef enum {
    BannerPriorityLow=0,
    BannerPriorityHigh
}BannerPriority;
typedef enum {
    ViewTypeWindow=0,
    ViewTypeCurrentView
}ParentViewType;

typedef enum {
    BannerStatePending=0,
    BannerStateDisplaying,
    BannerStateCompleted
}BannerState;
@property (nonatomic,strong) NSString* bannerId;
@property (nonatomic,weak) id baseView;
@property (nonatomic,assign)  BannerType bannerType;
@property (nonatomic,assign)  BannerPosition bannerPosition;
@property (nonatomic,assign)  id onView;
@property (nonatomic,assign)  BannerState bannerState;
@property (nonatomic,assign)  BannerPriority bannerPriority;
@property (nonatomic,assign)  float displayTime;
@property (nonatomic,assign)  int priority;

-(id)initWithType:(BannerType)type position:(BannerPosition)position onView:(id)view duration:(float)duration title:(NSString *)title subtitle:(NSString *)subtitle priority:(BannerPriority)priority;

@end
