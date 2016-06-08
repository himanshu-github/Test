//
//  NGShortCutHandler.m
//  NaukriGulf
//
//  Created by Himanshu on 2/3/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGShortCutHandler.h"
#import "NGJobAnalyticsViewController.h"
#import "NGShortlistedJobsViewController.h"
@implementation NGShortCutHandler

+(NGShortCutHandler *)sharedInstance{
    
    static NGShortCutHandler *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGShortCutHandler alloc]init];
    });
    return sharedInstance;
}
-(void)handleShortcutWithIdentifier:(NSString *)shortcutType{
    _shotcutIdentifier = shortcutType;
    [self navigateToScreensAccordingToIdentifier];
}

-(void)navigateToScreensAccordingToIdentifier{
    if(_shotcutIdentifier){
        if([_shotcutIdentifier isEqualToString:@"com.naukrigulf.recoJobs"]){
            if([[NGHelper sharedInstance] isUserLoggedIn]){
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_FORCE_TOUCH withEventAction:K_GA_EVENT_FORCE_TOUCH_CLICK withEventLabel:K_GA_EVENT_SHORTCUT_RECO_JOBS withEventValue:nil];
                
                [[NGAppStateHandler sharedInstance] setDelegate:self];
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_RECOMMENDED_JOBS usingNavigationController:APPDELEGATE.container.centerViewController animated:FALSE];
            }
            else{
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_LOGIN usingNavigationController:APPDELEGATE.container.centerViewController animated:FALSE];
            }
        }
        else if([_shotcutIdentifier isEqualToString:@"com.naukrigulf.searchJobs"]){
            _shotcutIdentifier = nil;
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_FORCE_TOUCH withEventAction:K_GA_EVENT_FORCE_TOUCH_CLICK withEventLabel:K_GA_EVENT_SHORTCUT_SEARCH_JOBS withEventValue:nil];
            
            [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JOB_SEARCH usingNavigationController:APPDELEGATE.container.centerViewController animated:FALSE];
            
        }
        else if([_shotcutIdentifier isEqualToString:@"com.naukrigulf.cvviewed"]){
            if([[NGHelper sharedInstance] isUserLoggedIn]){
                _shotcutIdentifier = nil;
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_FORCE_TOUCH withEventAction:K_GA_EVENT_FORCE_TOUCH_CLICK withEventLabel:K_GA_EVENT_SHORTCUT_CV_VIEWED withEventValue:nil];
                [[NGAppStateHandler sharedInstance] setDelegate:self];
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE_VIEWER usingNavigationController:APPDELEGATE.container.centerViewController animated:FALSE];
                
            }
            else{
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_LOGIN usingNavigationController:APPDELEGATE.container.centerViewController animated:FALSE];
            }
            
        }
        else if([_shotcutIdentifier isEqualToString:@"com.naukrigulf.savedJobs"]){
            _shotcutIdentifier = nil;
            if([[NGHelper sharedInstance] isUserLoggedIn]){
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_FORCE_TOUCH withEventAction:K_GA_EVENT_FORCE_TOUCH_CLICK withEventLabel:K_GA_EVENT_SHORTCUT_SHORTLISTED_JOBS withEventValue:nil];
                
                [[NGAppStateHandler sharedInstance] setDelegate:self];
                
                [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_SHORTLISTED_JOB usingNavigationController:APPDELEGATE.container.centerViewController animated:FALSE];
            }else{
            NGShortlistedJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"ShortlistedJobsView"];
            
            [((IENavigationController*)APPDELEGATE.container.centerViewController) pushActionViewController:navgationController_ Animated:YES];
            }
        }
    }
}
-(void) setPropertiesOfVC:(id)vc{

    if([vc isKindOfClass:[NGJobAnalyticsViewController class]])
    {
        NGJobAnalyticsViewController* jaVC = (NGJobAnalyticsViewController*)vc;
        if(_shotcutIdentifier)
            jaVC.selectedTabIndex = [_shotcutIdentifier isEqualToString:@"com.naukrigulf.savedJobs"]?1:2;
        else
            jaVC.selectedTabIndex = 1;
        
        if(jaVC.selectedTabIndex == 1)
        {
            NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]getAllSavedJobs]];
            jaVC.savedJobsArr = (NSMutableArray*)[[tempArr reverseObjectEnumerator] allObjects];
        }
        [[NGAppStateHandler sharedInstance]setDelegate:nil];
        _shotcutIdentifier = nil;
    }


}

@end
