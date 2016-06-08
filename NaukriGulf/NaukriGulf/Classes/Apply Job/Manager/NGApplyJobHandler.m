//
//  NGApplyJobHandler.m
//  NaukriGulf
//
//  Created by Rahul on 19/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//
#import "NGNewUserApplyPreviewViewController.h"
#import "NGUnRegApplyViewController.h"
#import "NGUnRegApplyForFresherAndExperiencedViewController.h"

@interface NGApplyJobHandler ()
@end

@implementation NGApplyJobHandler{
    
}

+ (NGApplyJobHandler *)sharedManager {
    
    static NGApplyJobHandler *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager =  [[NGApplyJobHandler alloc]init];
    });
    return sharedManager;
}

#pragma mark - Public Methods

- (void) jobHandlerWithJobDescriptionPageApply:(NGJobsHandlerObject *)loginObj ;
 {
    if (![[NGHelper sharedInstance] isUserLoggedIn]) {

        _loginObjForThisClass = loginObj;
        
        NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
        [appStateHandler setDelegate:self];
        
        NGAppDelegate *appDelegate = [NGAppDelegate appDelegate];
        [[NGAppStateHandler sharedInstance] setDelegate:self];
        [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:appDelegate.container.centerViewController animated:YES];
        
        appStateHandler = nil;
        appDelegate = nil;
        
        return;
    }
    else {
        [self jobHandlerAppliedForFinalStep:loginObj];
    }
}

- (void) jobHandlerWithNewUserApply:(NGJobsHandlerObject *)loginObj {
    
    IENavigationController *navigationContlr = (IENavigationController*)APPDELEGATE.container.centerViewController;
    
    if ([NGSavedData isNewUserApplyPreviewAvailable]) {
              NGNewUserApplyPreviewViewController *previewVC=[[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"NewUserApplyPreview"];
        
                previewVC.jobObj= loginObj.jobObj;
                previewVC.openJDLocation = loginObj.openJDLocation;
        
             [navigationContlr pushActionViewController:previewVC Animated:YES];
            
        }
        else{
            NGUnRegApplyViewController *unregApplyVC = [[NGUnRegApplyViewController alloc] init];
            unregApplyVC.jobObj = loginObj.jobObj;
            unregApplyVC.openJDLocation = loginObj.openJDLocation;
            [navigationContlr pushActionViewController:unregApplyVC Animated:YES];
        }
}

- (void) jobHandlerWithExperiencedUserApply:(NGJobsHandlerObject *)loginObj {
    
    IENavigationController *navigationContlr = (IENavigationController*)APPDELEGATE.container.centerViewController;
    
    NGUnRegApplyForFresherAndExperiencedViewController *unregApplyVc = [[NGUnRegApplyForFresherAndExperiencedViewController alloc] initWithNibName:nil bundle:nil];
    
    unregApplyVc.jobHandler= loginObj;
     
    [navigationContlr pushActionViewController:unregApplyVc Animated:YES];

}

- (void) jobHandlerAppliedForFinalStep:(NGJobsHandlerObject *)loginObj {
        [[NGCQHandler sharedManager]fetchCustomQuestions:loginObj];
}
-(void)setPropertiesOfVC:(id)vc{
    
    if([vc isKindOfClass:[NGLoginViewController class]])
    {
        NGLoginViewController* viewC = (NGLoginViewController*)vc;
        
        [viewC setTitleForLoginView:@"Login to Apply"];
        [viewC showViewWithType:LOGINVIEWTYPE_APPLY_VIEW];
        viewC.jobObj =  _loginObjForThisClass.jobObj;
        viewC.applyHandlerState = LoginApplyStateUnRegistered;
        viewC.openJDLocation = _loginObjForThisClass.openJDLocation;

    }
    
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
    
}
@end
