//
//  IENavigationController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "IENavigationController.h"
//#import "NGVCConstant.h"


@interface IENavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    IENavigationControllerDelegate *navControllerDelegateObj;
    
    BOOL isOS_iOS7x;//is Current OS is iOS7 or 7.x version
}
@end

@implementation IENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    navControllerDelegateObj = [[IENavigationControllerDelegate alloc] init];
    navControllerDelegateObj.navController = self;
    
    self.delegate = navControllerDelegateObj;
    
    isOS_iOS7x = SYSTEM_VERSION_LESS_THAN(@"8.0");
    
    
    //commenting the swipe back feature for future
//    {
//    self.interactivePopGestureRecognizer.delegate = self;
//    self.interactivePopGestureRecognizer.enabled = YES;
//    }
    
}
//commenting the swipe back feature for future

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
//        
//        // Don't handle gestures if navigation controller is still animating a transition
//        if ([self.navigationController.transitionCoordinator isAnimated])
//            return NO;
//        
//        NSArray *navArr = ((IENavigationController*)APPDELEGATE.container.centerViewController).viewControllers;
//        NGBaseViewController *topVC = navArr.lastObject;
//        NSLog(@"topVC>>%@  _isSwipePopGestureEnabled  base>>%i  kk   %i",topVC,topVC.isSwipePopGestureEnabled,topVC.isSwipePopGestureEnabled);
//        if(topVC.isSwipePopGestureEnabled &&navArr.count>1){
//            topVC.isSwipePopDuringTransition = YES;
//            return true;
//        }
//        else{
//            topVC.isSwipePopDuringTransition = NO;
//            return false;
//        }
//    }else
//        return true;
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)popActionViewControllerAnimated:(BOOL)isAnimated{
    
    IENavigationAction *navAction = nil;
    if (NO == isAnimated) {
        navAction = [[IENavigationAction alloc] init];
        navAction.actionType = IENavigationActionTypePop;
    }
    [self popActionViewControllerWithAction:navAction];
}
-(void)popActionViewControllerWithAction:(IENavigationAction*)navAction{
    //get top view controller
    //set it's navAction,if nil and type
    
    NGBaseViewController *topVC = (NGBaseViewController*)self.viewControllers.lastObject;
    
    if (nil == navAction) {
        navAction = [[IENavigationAction alloc] init];
        navAction.actionType = IENavigationActionTypePop;
        navAction.isAnimationRequired = YES;
    }
    
    topVC.navigationAction = navAction;
    
    
    if(isOS_iOS7x){
        [navControllerDelegateObj addObjectToQueue:topVC];
    }else{
        [self popViewControllerAnimated:navAction.isAnimationRequired];
    }
}

-(void)popToActionViewController:(id)viewController{
    
    //if view controller is already on top then no delegate is fired,
    //hence need to clear queue here
    NSString *topVCName = NSStringFromClass([(NGBaseViewController*)self.viewControllers.lastObject class]);
    NSString *newVCName = NSStringFromClass([viewController class]);
    if (NO == [topVCName isEqualToString:newVCName]) {
        
        if(isOS_iOS7x){
            [navControllerDelegateObj addObjectToQueue:viewController];
        }else{
            [self popToViewController:viewController animated:((NGBaseViewController*)viewController).navigationAction.isAnimationRequired];
        }
        
        
    }
}
-(void)pushActionViewController:(id)viewController{
    
    //commenting the swipe back feature for future
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        self.interactivePopGestureRecognizer.enabled = NO;
    
    if(isOS_iOS7x){
        [navControllerDelegateObj addObjectToQueue:viewController];
    }else{
        [self pushViewController:viewController animated:((NGBaseViewController*)viewController).navigationAction.isAnimationRequired];
    }
}
-(void)pushActionViewController:(id)viewController Animated:(BOOL)isAnimated{
    
    //commenting the swipe back feature for future
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        self.interactivePopGestureRecognizer.enabled = NO;
    
    IENavigationAction *navAction = [[IENavigationAction alloc] init];
    navAction.actionType = IENavigationActionTypePush;
    navAction.isAnimationRequired = isAnimated;
    ((NGBaseViewController*)viewController).navigationAction = navAction;
    [self pushActionViewController:viewController];
}

-(void)pushViewController:(UIViewController *)viewController WithAction:(IENavigationAction*)navigationAction animated:(BOOL)animated{
    //commenting the swipe back feature for future
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        self.interactivePopGestureRecognizer.enabled = NO;

}

@end
