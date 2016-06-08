//
//  NGDeepLinkingHelper.m
//  NaukriGulf
//
//  Created by Swati Kaushik on 21/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGJobAnalyticsViewController.h"
#import "NGMNJViewController.h"
#import "NGEditPhotoViewController.h"
#import "NGEditResumeViewController.h"

@interface NGDeepLinkingHelper()<LoginHelperDelegate>
{
    NSArray* landingPageDetailsArr;
    NGLoader* loader;
    NSURL *deeplinkingURL;
}
@end
@implementation NGDeepLinkingHelper
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}
-(instancetype)init{
    if (self) {
        self.deeplinkingSource = nil;
        self.deeplinkingPage = NGDeeplinkingPageNone;
        self.deeplinkingAppState = NGDeepLinkingAppStateNone;
        [self listenAppStateNotificationForDeeplinking];
    }
    return self;
}
#pragma mark - Private Methods
-(NSArray*)breakURLIntoInfo:(NSString*)paramURLString{
    //Check whether source is present or not
    //If present, break url at & and set source variable
    //and return landing page arr
    NSArray *landingPageArray = [paramURLString componentsSeparatedByString:@"&"];
    
    BOOL isDeeplinkingSourceExist = (NSNotFound != [paramURLString rangeOfString:K_SOURCE_KEY_FOR_API_PARAMS options:NSCaseInsensitiveSearch].location);
    if (isDeeplinkingSourceExist) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:landingPageArray];
        NSInteger sourceParamLocation = -1;
        NSInteger dataArrayLength = dataArray.count;
        for (NSInteger i=0; i<dataArrayLength; i++) {
            NSArray *dataArrayKeyValue = [[dataArray fetchObjectAtIndex:i] componentsSeparatedByString:@"="];
            if (dataArrayKeyValue) {
                NSString *keyString = [dataArrayKeyValue firstObject];
                if ([K_SOURCE_KEY_FOR_API_PARAMS isEqualToString:keyString.lowercaseString]) {
                    sourceParamLocation = i;
                    self.deeplinkingSource = [[dataArrayKeyValue lastObject] trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    break;
                }
            }
        }
        if (-1 != sourceParamLocation) {
            [dataArray removeObjectAtIndex:sourceParamLocation];
        }
        landingPageArray = (NSArray*)dataArray;
    }
    return landingPageArray;
}
-(void)performDeeplinking:(NSURL *)url
{
    //once this method reached destroy deeplinking url
    deeplinkingURL = nil;
    
    NSString* urlStr = [url.absoluteString substringFromIndex:[url.absoluteString rangeOfString:@"ng://?view="].length];
   
     //variable to store landing page array only
    landingPageDetailsArr = [self breakURLIntoInfo:urlStr];
    
    
    if([[NGHelper sharedInstance]isUserLoggedIn])
    {
        [self navigateToLandingPage];
    }
    else
    {
        if([[landingPageDetailsArr objectAtIndex:0] isEqualToString:@"unreg"])
        {
            [NGUIUtility removeAllViewControllersTillSplashScreen];
           
            [[NGAppStateHandler sharedInstance] loadNativeRegistrationView];
            
        }else{
            NSString* conmailer = [[[[landingPageDetailsArr lastObject] componentsSeparatedByString:@"="]fetchObjectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             if([NGDecisionUtility isValidString:conmailer]){
                 loader = [[NGLoader alloc] initWithFrame:APPDELEGATE.window.frame];
                 [loader showAnimation:APPDELEGATE.window];
                 
                 
                 NGWebDataManager* dataManager = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_EXCHANGE_TOKEN];
                 __weak NGDeepLinkingHelper *mySelfWeak = self;
                 [dataManager getDataWithParams:[NSMutableDictionary dictionaryWithObject:conmailer forKey:@"conmailer"] handler:^(NGAPIResponseModal *responseData) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (responseData.isSuccess) {
                             
                             [mySelfWeak hideLoader];
                             if(responseData.serviceType == SERVICE_TYPE_EXCHANGE_TOKEN)
                             {
                                 NSString *conMnj = [responseData.parsedResponseData objectForKey:KEY_LOGIN_AUTH];
                                 [NGLoginHelper sharedInstance].delegate = mySelfWeak;
                                 [NGLoginHelper sharedInstance].conMnj = conMnj;
                             }
                         }else{
                             [mySelfWeak hideLoader];
                             [mySelfWeak navigateToLandingPage];
                         }
                             
                     });
                 }];

             }
        }
    }
}
-(void)goToMNJ:(BOOL)isAnimated{
    
    if ([NGHelper sharedInstance].isUserLoggedIn) {
        [[NGAppStateHandler sharedInstance] setDelegate:self];
        [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:isAnimated];
    }
}
-(void)navigateToLandingPage
{
    NSString* landingPage = [landingPageDetailsArr objectAtIndex:0];
    
    NGAppDelegate* delegate = [NGAppDelegate appDelegate];

    UIViewController* regView = [delegate.container.centerViewController presentedViewController];
    if(regView)
       [regView dismissViewControllerAnimated:YES completion:nil];
    
    if([landingPage isEqualToString:@"jd"])
    {
        self.deeplinkingPage = NGDeeplinkingPageJD;
        
        [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGJDParentViewController"];
        [[NGAppStateHandler sharedInstance] setDelegate:self];
        [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JD usingNavigationController:delegate.container.centerViewController animated:YES];
    }
    else if ([NGHelper sharedInstance].isUserLoggedIn)
    {
        if([landingPage isEqualToString:@"profile"])
        {
            self.deeplinkingPage = NGDeeplinkingPageProfile;
            
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGProfileViewController"];
            
            [[NGAppStateHandler sharedInstance] setDelegate:self];
            [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE usingNavigationController:delegate.container.centerViewController animated:YES];
        }
        else if([landingPage isEqualToString:@"profileViews"])
        {
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGWhoViewedMyCVViewController"];
         
            [self goToMNJ:YES];
            
            [[NGAppStateHandler sharedInstance] setDelegate:self];
            [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE_VIEWER usingNavigationController:((IENavigationController*)delegate.container.centerViewController) animated:YES];
        }
        else if([landingPage isEqualToString:@"appliedJobs"])
        {
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGJobAnalyticsViewController"];
            
            [self goToMNJ:YES];
            
            [[NGAppStateHandler sharedInstance] setDelegate:self];
            [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ_ANALYTICS usingNavigationController:((IENavigationController*)delegate.container.centerViewController) animated:YES];
            
        }else if([landingPage isEqualToString:@"photo"]){
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGEditPhotoViewController.h"];
            
            [self goToMNJ:YES];
            
            NGEditPhotoViewController *vc = [[NGEditPhotoViewController alloc]init];
            [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
            
        }else if([landingPage isEqualToString:@"cv"]){
            [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGEditResumeViewController.h"];
            
            [self goToMNJ:YES];
            
             NGEditResumeViewController *vc = (NGEditResumeViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"editResumeVCIdentifier"];
            
             NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
            
            if (0>=[[ValidatorManager sharedInstance] validateValue:objModel.attachedCvFormat withType:ValidationTypeString].count) {
                
                [NGHelper sharedInstance].resumeFormat = objModel.attachedCvFormat;
                [vc setUploadOrDownload:YES];
                
            }
            
            [NGHelper sharedInstance].resumeFormat = objModel.attachedCvFormat;
            [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController)
                                                                            pushActionViewController:vc Animated:NO];
        }
        
        
        else{
            
            [self goToMNJ:NO];
        }

    }else{
        //dummy
    }
    
}
#pragma mark - AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc{
    
    if([vc isKindOfClass:[NGJobAnalyticsViewController class]])
    {
        NGJobAnalyticsViewController* jaVC = (NGJobAnalyticsViewController*)vc;
        jaVC.selectedTabIndex = 3;
    }
    else if([vc isKindOfClass:[NGJDParentViewController class]])
    {
        NGJDParentViewController *jdVC = (NGJDParentViewController*)vc;
        NGJobDetails* jobObj = [[NGJobDetails alloc]init];
        
        NSString* landingPageId = [[[landingPageDetailsArr objectAtIndex:1] componentsSeparatedByString:@"="]objectAtIndex:1];
        jobObj.jobID = landingPageId;
        jobObj.isInitiatedFromDeeplinking = YES;
        jdVC.allJobsArr = [NSMutableArray arrayWithObject:jobObj];
        jdVC.selectedIndex = 0;
        
    }else{
        //dummy
    }
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
}

-(void)hideLoader{
    [loader hideAnimatior:APPDELEGATE.window];
}
#pragma mark - Login Helper Delegate
-(void)doneFetchingProfile:(NGMNJProfileModalClass *)profileModal{
    [self navigateToLandingPage];
}

-(void)listenAppStateNotificationForDeeplinking{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeeplinkingAppNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeeplinkingAppNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)handleDeeplinkingNotification{
    if (NGDeepLinkingAppStateLaunch==self.deeplinkingAppState && nil != deeplinkingURL) {
        [self performDeeplinking:deeplinkingURL];
    }
}
-(void)handleDeeplinkingAppNotification:(NSNotification*)paramNotification{
    if (nil != paramNotification && nil != paramNotification.name) {
        if([paramNotification.name isEqualToString:UIApplicationDidBecomeActiveNotification]){
            if (self.deeplinkingAppState == NGDeepLinkingAppStateBackground && nil!=deeplinkingURL) {
                
                [self performDeeplinking:deeplinkingURL];
                
            }
        }else if ([paramNotification.name isEqualToString:UIApplicationWillEnterForegroundNotification]){
            self.deeplinkingAppState = NGDeepLinkingAppStateBackground;
        }else{
            self.deeplinkingAppState = NGDeepLinkingAppStateNone;
        }
            
    }
    
}

-(void)setDeeplinkingConfigFromLaunchOption:(NSDictionary*)paramLaunchOption{
    [NGDirectoryUtility deeplinkingFileLogger:[NSString stringWithFormat:@"%s-->\nparamLaunchOption:%@",__PRETTY_FUNCTION__,paramLaunchOption]];
    
    NSURL *urlLaunchOption = [paramLaunchOption objectForKey:UIApplicationLaunchOptionsURLKey];
    BOOL isAppLaunchedViaDeeplinking = (urlLaunchOption && [NGDecisionUtility isValidDeeplinkingURL:urlLaunchOption.absoluteString]);
    
    if (isAppLaunchedViaDeeplinking) {
        self.deeplinkingAppState = NGDeepLinkingAppStateLaunch;
    }else{
        self.deeplinkingAppState = NGDeepLinkingAppStateNone;
    }

    [NGDirectoryUtility deeplinkingFileLogger:[NSString stringWithFormat:@"%s-->\nisAppLaunchedViaDeeplinking:%@ \ndeeplinkingAppState:%ld",__PRETTY_FUNCTION__,isAppLaunchedViaDeeplinking?@"YES":@"NO",(unsigned long)self.deeplinkingAppState]];
}
-(BOOL)validateAndPerformDeeplinkingWithURL:(NSURL*)paramURL{
    if([paramURL.scheme caseInsensitiveCompare:@"ng"] == NSOrderedSame && [NGDecisionUtility isValidDeeplinkingURL:paramURL.absoluteString]){

        deeplinkingURL = paramURL;
        
        return YES;
    }else{
        deeplinkingURL = nil;
    }
    return NO;
}
@end
