//
//  IENavigationControllerDelegate.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "IENavigationControllerDelegate.h"
#import "NGBaseViewController.h"
#import "NGQLDocumentPreviewViewController.h"

@interface IENavigationControllerDelegate (){
    BOOL isOS_iOS7x;//is Current OS is iOS7 or 7.x version
}

//queue to be processed
@property (strong,nonatomic) NSMutableArray *viewControllerQueue;
@property(nonatomic,readwrite) NSInteger queueLength;
@end

@implementation IENavigationControllerDelegate

-(id)init{
    if (self) {
        self.viewControllerQueue = [NSMutableArray new];
        
        isOS_iOS7x = SYSTEM_VERSION_LESS_THAN(@"8.0");
    }
    return self;
}
-(void)processQueueChange{
    
    if (self.viewControllerQueue && 0 < self.viewControllerQueue.count) {
        NGBaseViewController *nextVC = (NGBaseViewController*)self.viewControllerQueue.firstObject;
        if (IENavigationActionTypePush == nextVC.navigationAction.actionType) {
            [self.navController pushViewController:nextVC animated:nextVC.navigationAction.isAnimationRequired];
        }else if (IENavigationActionTypePopTo ==  nextVC.navigationAction.actionType){
            [self.navController popToViewController:nextVC animated:nextVC.navigationAction.isAnimationRequired];
        }else if(IENavigationActionTypePop == nextVC.navigationAction.actionType){
            [self.navController popViewControllerAnimated:nextVC.navigationAction.isAnimationRequired];
        }else{
            //dummy
        }
    }
}
-(void)addObjectToQueue:(id)paramObject{
    if (paramObject) {
        [self.viewControllerQueue addObject:paramObject];
        self.queueLength = self.viewControllerQueue.count;
        
        NSNumber *newVal = [NSNumber numberWithInteger:self.queueLength];
        
        if (newVal.integerValue == 1) {
            [self processQueueChange];
        }
        
    }
}
-(void)removeObjectFromQueue:(id)paramObject{
    if (paramObject) {
        [self.viewControllerQueue removeObject:paramObject];
        
        self.queueLength = self.viewControllerQueue.count;
        
        [self processQueueChange];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"%@ kk %@,   Is cancelled: %i", navigationController.topViewController,viewController,[context isCancelled]);
        if([context isCancelled] == 1){
        
        
        }
    }];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //commenting the swipe back feature for future

//    if ([_navController respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        _navController.interactivePopGestureRecognizer.enabled = YES;

    
    
    if ([navigationController isKindOfClass:[IENavigationController class]] && ([viewController isKindOfClass:[NGBaseViewController class]] || [viewController isKindOfClass:[NGQLDocumentPreviewViewController class]])) {
        
        NGBaseViewController *processedViewController;
        
        if (isOS_iOS7x) {
            processedViewController =  ((NGBaseViewController*)self.viewControllerQueue.firstObject);
            
            if (nil != processedViewController.navigationAction.performAction) {
                processedViewController.navigationAction.performAction(processedViewController);
            }
            
            [self removeObjectFromQueue:processedViewController];
            
        }else{
            
            processedViewController =  ((NGBaseViewController*)viewController);
            
            if (nil != processedViewController.navigationAction.performAction) {
                processedViewController.navigationAction.performAction(processedViewController);
            }
        }
        
        //reset navigation action
        processedViewController.navigationAction = nil;
        processedViewController = nil;
        
    }
}

@end
