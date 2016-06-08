//
//  NGAnimator.h
//  NaukriGulf
//
//  Created by Arun Kumar on 24/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGView.h"
@protocol NGAnimatorDelegate <NSObject>

-(void)animatorWillAppearScreen:(BOOL)flag;
-(void)animatorDidAppearScreen:(BOOL)flag;
-(void)animatorWillDisappearScreen:(BOOL)flag;
-(void)animatorDidDisappearScreen:(BOOL)flag;

@end

@interface NGAnimator : NSObject

@property (nonatomic, strong) UIViewController *currentViewCntrllr;

@property (nonatomic, strong) NSMutableArray *viewCntlrArr;

@property (nonatomic, strong) NSMutableArray *delegateArr;

@property (nonatomic, assign) id<NGAnimatorDelegate> delegate1;

+(NGAnimator *)sharedInstance;

-(void)showScreen:(NSInteger)appState;

-(void)popToViewController:(UIViewController *)vc animated:(BOOL)animationFlag;

-(void)pushViewController:(UIViewController *)vc inViewController:(UIViewController *)parentController animated:(BOOL)animationFlag;

-(NGView *)showBlurrView;
-(void)removeBlurrView:(UIView *)view;

-(void)zoomInAndOutView:(UIView *)view AtScale:(float)scale;

-(void)scaleView:(UIView *)view AtScale:(float)scale duration:(float)d delay:(float)delay;
-(void)fadeInView:(UIView *)view duration:(float)d delay:(float)delay;
-(void)rotateView:(UIView *)view withAplha:(float)alpha AtAngle:(float)angle duration:(float)d delay:(float)delay;

-(void)pushViewControllerWithFlipAnimation:(UIViewController *)vc withNavigationController:(UINavigationController*)nc;
-(void)popViewControllerWithFlipAnimationwithNavigationController:(UINavigationController*)nc;
-(void)popToRootViewControllerWithFlipAnimationwithNavigationController:(UINavigationController*)nc;

@end
