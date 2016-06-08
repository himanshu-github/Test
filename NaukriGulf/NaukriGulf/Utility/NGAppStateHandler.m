 //
//  NGAppStateHandler.m
//  NaukriGulf
//
//  Created by Arun Kumar on 19/11/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGAppStateHandler.h"
#import "NGResmanLoginDetailsViewController.h"

@implementation NGAppStateHandler


+(NGAppStateHandler *)sharedInstance{
    static NGAppStateHandler *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGAppStateHandler alloc]init];
    });
    return sharedInstance;
}
-(UIViewController *)setAppState:(NSInteger)appState usingNavigationController:(UINavigationController *)navCntrllr animated:(BOOL)animated{
    
    NSArray *vcStack = navCntrllr.viewControllers;
    BOOL isExist = FALSE;
    IENavigationController *newNavController = (IENavigationController*)navCntrllr;
    
    NSString *vcClassName = [self viewControllerForAppState:appState];
    NSString *vcIdentifier = [self viewIdentifierForAppState:appState];
    id vcClass = NSClassFromString(vcClassName);
    
    for (UIViewController *vc in vcStack) {
        if ([vc isKindOfClass:[vcClass class]]) {
            isExist = TRUE;
            if([_delegate respondsToSelector:@selector(setPropertiesOfVC:)])
            {
                [_delegate setPropertiesOfVC:vc];
                _delegate = nil;
            }
            IENavigationAction *navAction = [[IENavigationAction alloc] init];
            navAction.actionType = IENavigationActionTypePopTo;
            navAction.isAnimationRequired = animated;
            
            ((NGBaseViewController*)vc).navigationAction = navAction;
            
            [newNavController popToActionViewController:vc];
            
            return vc;
        }
    }
    
    if (!isExist) {
        UIStoryboard *storyboard = [self storyBoardForAppState:appState];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcIdentifier];
        if(_delegate && [_delegate respondsToSelector:@selector(setPropertiesOfVC:)])
        {
            [_delegate setPropertiesOfVC:vc];
            _delegate = nil;
        }
        [newNavController pushActionViewController:vc Animated:animated];
        
        return vc;
    }    
   
    
    newNavController = nil;
    
    return nil;
}


#pragma mark Helper Methods

-(NSString *)viewControllerForAppState:(NSInteger)appState{
    id viewCntrllr = nil;
    
    switch (appState) {
        case APP_STATE_PROFILE:
            viewCntrllr = @"NGProfileViewController";
            break;
            
        case APP_STATE_MNJ:
            viewCntrllr = @"NGMNJViewController";
            break;
            
        case APP_STATE_JOB_SEARCH:
            viewCntrllr = @"NGSearchJobsViewController";
            break;
            
        case APP_STATE_PROFILE_VIEWER:
            viewCntrllr = @"NGWhoViewedMyCVViewController";
            break;
            
        case APP_STATE_APPLIED_JOBS:
            viewCntrllr = @"NGJobAnalyticsViewController";
            break;
            
        case APP_STATE_UNREG_APPLY:
            viewCntrllr = @"NGWhoViewedMyCVViewController";
            break;
            
        case APP_STATE_JD:
            viewCntrllr = @"NGJDParentViewController";
            break;
        case APP_STATE_MNJ_ANALYTICS:
            viewCntrllr = @"NGJobAnalyticsViewController";
            break;
        case APP_STATE_FEEDBACK:
            viewCntrllr = @"NGFeedbackViewController";
            break;
        case APP_STATE_LOGIN:
            viewCntrllr = @"NGLoginViewController";
            break;
        case K_APP_STATE_FORCE_UPGRADE:
            viewCntrllr = @"NGForceUpgradeViewController";
            break;
         
        case APP_STATE_APPLY_CONFIRMATION:
            viewCntrllr = @"NGApplyConfirmationViewController";
            break;
        case APP_STATE_RECOMMENDED_JOBS:
            viewCntrllr = @"NGJobAnalyticsViewController";
            break;
        case APP_STATE_SHORTLISTED_JOB:
            viewCntrllr = @"NGJobAnalyticsViewController";
            break;
                
        default:
            break;
    }
    return viewCntrllr;
}

-(NSString *)viewIdentifierForAppState:(NSInteger)appState{
    id viewIdentifier;
    
    switch (appState) {
        case APP_STATE_PROFILE:
            viewIdentifier = @"ProfileView";
            break;
            
        case APP_STATE_MNJ:
            viewIdentifier = @"MNJView";
            break;
            
        case APP_STATE_JOB_SEARCH:
            viewIdentifier = @"JobSearch";
            break;
            
        case APP_STATE_PROFILE_VIEWER:
            viewIdentifier = @"WhoViewedMyCV";
            break;
            
        case APP_STATE_APPLIED_JOBS:
            viewIdentifier = @"JobAnalyticsView";
            break;
            
        case APP_STATE_UNREG_APPLY:
            viewIdentifier = @"NGWhoViewedMyCVViewController";
            break;
            
        case APP_STATE_JD:
            viewIdentifier = @"JDView";
            break;
        case APP_STATE_MNJ_ANALYTICS:
            viewIdentifier = @"JobAnalyticsView";
            break;
        case APP_STATE_FEEDBACK:
            viewIdentifier = @"Feedback";
            break;
        case APP_STATE_LOGIN:
            viewIdentifier = @"Login";
            break;
            
        case K_APP_STATE_FORCE_UPGRADE:
            viewIdentifier = @"ForceUpgradeView";
            break;
            
        case APP_STATE_APPLY_CONFIRMATION:
            viewIdentifier = @"ApplyConfirmationView";
            break;
        case APP_STATE_RECOMMENDED_JOBS:
            viewIdentifier = @"JobAnalyticsView";
            break;
        case APP_STATE_SHORTLISTED_JOB:
            viewIdentifier = @"JobAnalyticsView";
            break;
        default:
            break;
    }
    
    return viewIdentifier;
}
-(void)loadNativeRegistrationView{
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_UNREG_MAILERS withEventAction:K_GA_RESMAN_LANDING_FROM_MAILERS withEventLabel:K_GA_RESMAN_LANDING_FROM_MAILERS withEventValue:nil];
    
    NGResmanLoginDetailsViewController *resmanVc = [[NGResmanLoginDetailsViewController alloc] initWithNibName:nil bundle:nil];
    resmanVc.isComingFromMailer = YES;
    [(IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController pushActionViewController:resmanVc Animated:YES];
    
}
-(UIStoryboard *)storyBoardForAppState:(NSInteger)appState{
    id storyBoard;
    
    switch (appState) {
        case APP_STATE_HOME:
        case APP_STATE_JOB_SEARCH:
        case APP_STATE_SRP:
        case APP_STATE_JD:
        case APP_STATE_UNREG_APPLY:
        case APP_STATE_CQ:
        case APP_STATE_APPLY_CONFIRMATION:
            storyBoard = [NGHelper sharedInstance].jobSearchstoryboard;
            break;
            
        case APP_STATE_SHORTLISTED_JOB:
        case APP_STATE_APPLIED_JOBS:
        case APP_STATE_RECOMMENDED_JOBS:
        case APP_STATE_MNJ_ANALYTICS:
            storyBoard = [NGHelper sharedInstance].jobsForYouStoryboard;
            break;
            
        case APP_STATE_MNJ:
        case APP_STATE_PROFILE_VIEWER:
            storyBoard = [NGHelper sharedInstance].mNJStoryboard;
            break;
            
            
        case APP_STATE_PROFILE:
            storyBoard = [NGHelper sharedInstance].profileStoryboard;
            break;
            
            
        case APP_STATE_EDIT_FLOW:
            storyBoard = [NGHelper sharedInstance].editFlowStoryboard;
            break;
        
        case K_APP_STATE_FORCE_UPGRADE:
        case APP_STATE_FEEDBACK:
        case APP_STATE_LOGIN:
            storyBoard = [NGHelper sharedInstance].othersStoryboard;
            break;
        
        default:
            break;
    }
    
    return storyBoard;
}
@end
