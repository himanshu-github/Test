//
//  NIProfileCompletionView.h
//  PercentCompletionView
//
//  Created by Swati Kaushik on 17/04/14.
//  Copyright (c) 2014 Swati Kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NGProfileCompletionView : UIView
{
    float newValue;
    
    UILabel *percentCompLbl;
    UIImageView* profileImg;
    
    BOOL IsAnimationInProgress;
}

@property(nonatomic,assign) id delegate;
@property float currentValue;

-(void)refreshPhoto;
-(id)initWithOriginPoint:(CGPoint)origin;
@end

@protocol NGProfileCompletionViewDelegate
- (void)didFinishAnimation:(NGProfileCompletionView*)progressView;
@end

