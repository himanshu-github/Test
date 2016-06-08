//
//  NGAnimator.m
//  NaukriGulf
//
//  Created by Arun Kumar on 24/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGAnimator.h"

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)

@implementation NGAnimator

static NGAnimator *singleton;

+(NGAnimator *)sharedInstance{
    if (singleton==nil) {
        singleton = [[NGAnimator alloc]init];
    }
    return singleton;
}

-(id)init{
    if (self=[super init]) {
        
        self.viewCntlrArr = [[NSMutableArray alloc]init];
        self.delegateArr = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)showScreen:(NSInteger)appState{
    
    [self popToViewController:self.currentViewCntrllr animated:YES];
    
    switch (appState) {
        default:
            break;
    }
    [NGHelper sharedInstance].appState = appState;
}

-(id<NGAnimatorDelegate>)getDelegateForViewController:(UIViewController *)vc{
    
    for (NSInteger i = 0; i<self.viewCntlrArr.count; i++) {
        if ([self.viewCntlrArr fetchObjectAtIndex:i]==vc) {
            if (self.delegateArr.count>i) {
                return [self.delegateArr fetchObjectAtIndex:i];
            }
            
        }
    }
    
    return nil;
}

-(void)removeAllViewsFromView:(UIViewController *)vc{
    NSInteger index = [self.viewCntlrArr indexOfObject:vc];
    
    self.delegate1 = [self getDelegateForViewController:[self.viewCntlrArr fetchObjectAtIndex:index+1]];
    
    NSArray *tempArr = [self.viewCntlrArr copy];
    for (NSInteger i = index+1; i<tempArr.count; i++) {
        UIViewController *tempVC = [tempArr fetchObjectAtIndex:i];
        [tempVC removeFromParentViewController];
        [tempVC.view removeFromSuperview];
        id<NGAnimatorDelegate> delegate = [self getDelegateForViewController:tempVC];
        
        [self.viewCntlrArr removeObject:tempVC];
        [self.delegateArr removeObject:delegate];
    }
}

-(void)popToViewController:(UIViewController *)vc animated:(BOOL)animationFlag{
    
    id<NGAnimatorDelegate> delegate = [self getDelegateForViewController:vc];
    
    __block UIViewController *tempVC = vc;
    
    if (!vc) {
        return;
    }
    
    BOOL lastFlag = [self.viewCntlrArr lastObject]==vc?YES:NO;
    
    
    
    if (!lastFlag) {
        [self removeAllViewsFromView:vc];
        
        
        if ([self.delegate1 respondsToSelector:@selector(animatorWillDisappearScreen:)]) {
            [self.delegate1 animatorWillDisappearScreen:YES];
        }
        
        if ([self.delegate1 respondsToSelector:@selector(animatorDidDisappearScreen:)]) {
            [self.delegate1 animatorDidDisappearScreen:YES];
        }
        
        return;
    }
    
    
    vc.view.alpha = 1.0f;
    
    vc.view.layer.anchorPoint = CGPointMake(0, 0);
    vc.view.layer.position = CGPointMake(0, 0);
    
    if ([delegate respondsToSelector:@selector(animatorWillDisappearScreen:)]) {
        [delegate animatorWillDisappearScreen:YES];
    }
    
    
    
    if (animationFlag)
    {
        
        [UIView animateWithDuration:0.28f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^
         {
             vc.view.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
             
         } completion:^(BOOL finished)
         {
             [vc removeFromParentViewController];
             [vc.view removeFromSuperview];
             [self.viewCntlrArr removeObject:vc];
             
             tempVC = nil;
             
             
             
             if ([delegate respondsToSelector:@selector(animatorDidDisappearScreen:)]) {
                 [delegate animatorDidDisappearScreen:YES];
             }
             
             
             [self.delegateArr removeObject:delegate];
             
             
         }];
        
    }
    
    else{
        vc.view.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
        [self.viewCntlrArr removeObject:vc];
        vc = nil;
        
        if ([delegate respondsToSelector:@selector(animatorDidDisappearScreen:)]) {
            [delegate animatorDidDisappearScreen:YES];
        }
        
        [self.delegateArr removeObject:delegate];
    }
    
    
    
}

-(void)popViewControllerAnimated:(BOOL)animationFlag{
    if (self.viewCntlrArr.count>0)
    {
        UIViewController *vc = (UIViewController *)[self.viewCntlrArr lastObject];
        
        [self popToViewController:vc animated:animationFlag];
        
    }
}

-(void)pushViewController:(UIViewController *)vc inViewController:(UIViewController *)parentController animated:(BOOL)animationFlag{
    
    if (!vc) {
        return;
    }

    vc.view.alpha = 1.0f;
    [parentController addChildViewController:vc];
    [parentController.view addSubview:vc.view];
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    vc.view.frame = CGRectMake(0, 0, size.width, size.height);
    
    vc.view.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    vc.view.layer.anchorPoint = CGPointMake(0, 0);
    vc.view.layer.position = CGPointMake(0, 0);
    
    
    id<NGAnimatorDelegate> delegate = (id)parentController;
    
    
    if ([delegate respondsToSelector:@selector(animatorWillAppearScreen:)]) {
        [delegate animatorWillAppearScreen:YES];
    }
    
    
    if (animationFlag) {
        
        [UIView animateWithDuration:0.28f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^
         {
             vc.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
             
         } completion:^(BOOL finished)
         {
         
             if ([delegate respondsToSelector:@selector(animatorDidAppearScreen:)]) {
                 [delegate animatorDidAppearScreen:YES];
             }
             
             
         }];
        
    }else{
        vc.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        if ([delegate respondsToSelector:@selector(animatorDidAppearScreen:)]) {
            [delegate animatorDidAppearScreen:YES];
        }
    }
    
    [self.delegateArr addObject:delegate];
    [self.viewCntlrArr addObject:vc];
}


#pragma mark Blurr View

-(NGView *)showBlurrView{
    NSMutableDictionary* dictionaryForView=[[NSMutableDictionary alloc] initWithObjectsAndKeys:VIEW_TYPE_VIEW,KEY_VIEW_TYPE,
                                            [NSValue valueWithCGRect:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT) ],KEY_FRAME,
                                            [NSNumber numberWithInt:0],KEY_TAG,
                                            nil];
    
    NGView* v=  (NGView*)[NGViewBuilder createView:dictionaryForView];
    v.backgroundColor = [UIColor whiteColor];
    
    v.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^
     {
         v.alpha = 0.6f;
         
     } completion:^(BOOL finished)
     {
         
     }];
    
    
    return v;
}

-(void)removeBlurrView:(UIView *)view{
    if (!view) {
        return;
    }
    
    view.alpha = 0.6f;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^
     {
         view.alpha = 0.0f;
         
     } completion:^(BOOL finished)
     {
         [view removeFromSuperview];
         
     }];
    
}

#pragma mark ZoomIn/Out View

-(void)zoomInAndOutView:(UIView *)view AtScale:(float)scale{
    if (!view || scale<1) {
        return;
    }
    
    view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    view.layer.position = view.center;
    
    CGPoint center = view.center;
    
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^
     {
         view.center = center;
         [view setTransform:CGAffineTransformMakeScale(scale, scale)];
         
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^
          {
              view.center = center;
              [view setTransform:CGAffineTransformMakeScale(1, 1)];
              
          } completion:^(BOOL finished)
          {
              
          }];
         
         
     }];    
    

}

-(void)scaleView:(UIView *)view AtScale:(float)scale duration:(float)d delay:(float)delay{
    if (!view) {
        return;
    }
    
    view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    view.layer.position = view.center;
    
    
    CGPoint center = view.center;
    
    
    [UIView animateWithDuration:d delay:delay options:UIViewAnimationOptionCurveEaseInOut  animations:^
     {
         view.center = center;
         [view setTransform:CGAffineTransformMakeScale(scale, scale)];
         
     } completion:^(BOOL finished)
     {
         
     }];
    
}

-(void)fadeInView:(UIView *)view duration:(float)d delay:(float)delay{
    view.alpha = 0.0f;
    
    [UIView animateWithDuration:d delay:delay options:UIViewAnimationOptionAllowUserInteraction  animations:^
     {
         view.alpha = 1.0f;
         
     } completion:^(BOOL finished)
     {
                  
     }];
}

-(void)rotateView:(UIView *)view withAplha:(float)alpha AtAngle:(float)angle duration:(float)d delay:(float)delay{
    [UIView animateWithDuration:d delay:delay options:UIViewAnimationOptionCurveEaseInOut  animations:^
     {
         view.alpha = alpha;
         view.transform = CGAffineTransformMakeRotation(degreesToRadians(angle));
         
     } completion:^(BOOL finished)
     {
         
     }];
}

-(void)pushViewControllerWithFlipAnimation:(UIViewController *)vc withNavigationController:(UINavigationController*)nc{
    
    [UIView animateWithDuration:0.6 delay:0.0f options:UIViewAnimationOptionAllowUserInteraction  animations:^
     {
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [nc pushViewController:vc animated:NO];
         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:nc.view cache:NO];
         
     } completion:^(BOOL finished)
     {
         
     }];
}

-(void)popViewControllerWithFlipAnimationwithNavigationController:(UINavigationController*)nc{
    
    [UIView animateWithDuration:0.6 delay:0.0f options:UIViewAnimationOptionAllowUserInteraction  animations:^
     {
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [nc popViewControllerAnimated:YES];
         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:nc.view cache:NO];
         
     } completion:^(BOOL finished)
     {
         
     }];
}

-(void)popToRootViewControllerWithFlipAnimationwithNavigationController:(UINavigationController*)nc{
    
    [UIView animateWithDuration:0.6 delay:0.0f options:UIViewAnimationOptionAllowUserInteraction  animations:^
     {
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [nc popToRootViewControllerAnimated:YES];
         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:nc.view cache:NO];
         
     } completion:^(BOOL finished)
     {
         
     }];
}

@end
