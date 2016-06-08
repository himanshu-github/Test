//
//  NGLoader.m
//  NaukriGulf
//
//  Created by Arun Kumar on 11/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLoader.h"

@interface NGLoader (){
    UIView          * animatorBaseView;
    UIImageView     * rotatingImageView;
    UIImageView     * logoImageView;
}

@end

@implementation NGLoader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isLoaderAvail =  NO;
    }
    return self;
}

-(void)showAnimation:(UIView *)shoWView{

    self.frame = shoWView.frame;
    
     if(!animatorBaseView){
    
        animatorBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 -25, self.frame.size.height/2 -25-50, 50, 50)];
        [animatorBaseView setBackgroundColor:[UIColor clearColor]];
        
    }
    if(!rotatingImageView){
    
        rotatingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loader_back"]];
        rotatingImageView.frame = CGRectMake(3, 3, 44, 44);
        [animatorBaseView addSubview:rotatingImageView];
    }
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0  * 2 * 60.0 ];
    rotationAnimation.duration = 40.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    [rotatingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    if(!logoImageView){

        logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loader_front"]];
        logoImageView.frame = CGRectMake(4, 4, 42, 42);
        [animatorBaseView addSubview:logoImageView];
    }
    [self addSubview:animatorBaseView];
    [shoWView addSubview:self];
     self.isLoaderAvail =  YES;

}


-(void)hideAnimatior:(UIView *)showView{
   
    
    [rotatingImageView.layer removeAnimationForKey:@"rotationAnimation"];
    
    
    animatorBaseView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    animatorBaseView.layer.position = animatorBaseView.center;
    
    
    CGPoint center = animatorBaseView.center;
    
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  animations:^
     {
         animatorBaseView.center = center;
         [animatorBaseView setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
         animatorBaseView.alpha = 0.0f;
         
     } completion:^(BOOL finished)
     {
         [rotatingImageView removeFromSuperview];
         rotatingImageView.image = nil;
         rotatingImageView = nil;
         [logoImageView removeFromSuperview];
         logoImageView.image = nil;
         logoImageView = nil;
         [animatorBaseView removeFromSuperview];
         animatorBaseView = nil;
         self.isLoaderAvail =  NO;
         
         [self removeFromSuperview];
     }];
}


@end
