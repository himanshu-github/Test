//
//  NGAppBlockHandler.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGAppBlockHandler.h"
#import "NGForceUpgradeViewController.h"
#import "NGAppBlockerModel.h"
@interface NGAppBlockHandler (){
    
    NGWebViewController* webView;
    NGForceUpgradeViewController *forceUpgradeView;
    NGLoader *loader;
}

@end

NSString *const kBlockerUrl = @"http://www.naukrigulf.com/app.php";

@implementation NGAppBlockHandler

+(NGAppBlockHandler *)sharedInstance{
    static NGAppBlockHandler *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGAppBlockHandler alloc]init];
    });
    return sharedInstance;
}

-(void)fetchAppBlockerSettings{
    

    __weak NGAppBlockHandler *weavVC = self;
    NGWebDataManager* dataManager = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_APP_BLOCKER];
    
    [dataManager getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionary],K_RESOURCE_PARAMS,[NSDictionary dictionaryWithObjectsAndKeys:@"",@"time", nil],K_ATTRIBUTE_PARAMS, nil] handler:^(NGAPIResponseModal *responseData){
        
        if(responseData.isSuccess){
            
            [NGSavedData savePullBlockerApiDate:[NSDate date]];
            NGAppBlockerModel *obj = [responseData.parsedResponseData objectForKey:@"apiModel"];
            [NGSavedData saveAppBlockerResponse:obj.toDictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resetAll];
                [weavVC performActionBasisResponse:obj];
            });
            
            
        }
        if(responseData.responseCode!=0){
            [NGSavedData savePullBlockerApiDate:[NSDate date]];
        }
        else{
            [NGSavedData savePullBlockerApiDate:nil];
        }
        
        
        
    }];
    
}
-(void)performActionOverStoredAppBlockerResponse
{
    NSDictionary * cachedResponse = [NGSavedData getCachedAppBlockerResponse];
    if(cachedResponse){
        NGAppBlockerModel * appBlockerResponse = [[NGAppBlockerModel alloc] initWithDictionary:cachedResponse error:nil];
        [self performActionBasisResponse:appBlockerResponse];
    }
}

-(void)performActionBasisResponse:(NGAppBlockerModel *)obj{
    
    
    if([self shouldForceUpgradeBaisedOnApplicationVersion:obj.appMinVersion]){
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showForceUpgrade) userInfo:nil repeats:NO];
        return;
    }

    switch (obj.flag) {
            
        case K_NA:
            [NGSavedData saveAppBlockerResponse:nil];
            break;
            
        case K_BLOCKER:{
            [self logoutUser];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showWebView:) userInfo:nil repeats:NO];
           
            break;
        }
            
//        case K_FORCE_UPGRADE:{
//            [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(showForceUpgrade) userInfo:nil repeats:NO];
//            break;
//        }
            
        case K_NON_BLOCKING_MSG:{
            [NGSavedData saveAppBlockerResponse:nil];
            [NGUIUtility showAlertWithTitle:@"" withMessage:[NSArray arrayWithObjects:obj.msg, nil] withButtonsTitle:@"Ok" withDelegate:nil];
            
            break;
        }
            
        case K_BLOCK_NOTIFICATIONS:{
            
            [NGSavedData blockAllNotifications:TRUE];
            [[NGLocalNotificationHelper sharedInstance] cancelAllLocalNotifications];
            [NGSavedData saveAppBlockerResponse:nil];
            break;
            
        }
        default:
            break;
    }
}
-(BOOL)shouldForceUpgradeBaisedOnApplicationVersion:(NSString *)minimumVersionRequired
{
    if([NGUIUtility getAppVersionInFloat:minimumVersionRequired]>[NGUIUtility getAppVersionInFloat:[NSString getAppVersion]]){
        return YES;
    }
    else{
        return NO;
    }
}


-(void)showWebView:(NSTimer *)timer{
    
    IENavigationController *cntrllr = APPDELEGATE.container.centerViewController;
    if([cntrllr.viewControllers.lastObject isKindOfClass:[NGWebViewController class]]){
        [cntrllr popViewControllerAnimated:NO];
    }

    webView = (NGWebViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.isCloseBtnHidden = YES;
    [webView setNavigationTitle:@"naukrigulf.com" withUrl:kBlockerUrl];
    cntrllr.navigationItem.leftBarButtonItem = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [cntrllr pushActionViewController:webView Animated:NO];
    

}

-(void)showForceUpgrade{
    
    UINavigationController *cntrllr = APPDELEGATE.container.centerViewController;
    forceUpgradeView = (NGForceUpgradeViewController*)[[NGAppStateHandler sharedInstance]setAppState:K_APP_STATE_FORCE_UPGRADE usingNavigationController:cntrllr animated:NO];
}

-(void)resetAll{
    if (webView) {
        UINavigationController *cntrllr = APPDELEGATE.container.centerViewController;
        [cntrllr popViewControllerAnimated:NO];
        webView = nil;
    }
    
    if (forceUpgradeView) {
        UINavigationController *cntrllr = APPDELEGATE.container.centerViewController;
        [cntrllr popViewControllerAnimated:NO];
        forceUpgradeView = nil;
    }
}


-(void) logoutUser{
    
    if ([NGHelper sharedInstance].isUserLoggedIn) {

    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_LOGOUT withEventLabel:K_GA_EVENT_LOGOUT withEventValue:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_LOGOUT];
 
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(responseData.isSuccess){
                
                [[WatchOSAndiOSCommunicationLayer sharedInstance] sendLoginStatusToWatch:NO];
                dispatch_async(dispatch_get_main_queue(), ^{

               //[APPDELEGATE.container toggleLeftSideMenuCompletion:nil];
                    
                [NGUIUtility makeUserLoggedOutOnSessionExpired:NO];
                NSString *deviceToken = [NGSavedData getDeviceToken];
                [[NGNotificationWebHandler sharedInstance]registerDevice:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",deviceToken,@"tokenId",[NSNumber numberWithBool:NO],@"loginStatus" ,nil]];
              });
            }else{
                
                [[WatchOSAndiOSCommunicationLayer sharedInstance] sendLoginStatusToWatch:YES];

                [NGSavedData savePullBlockerApiDate:nil];

            }
        });
    }];
    }

}




@end
