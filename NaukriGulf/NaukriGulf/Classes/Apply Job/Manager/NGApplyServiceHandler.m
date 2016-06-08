//
//  NGApplyServiceHandler.m
//  NaukriGulf
//
//  Created by Rahul on 20/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.†
//

#import "NGApplyServiceHandler.h"
#import "NGLoader.h"
#import "BaseWebDataManager.h"
#import "NGSRPViewController.h"
#import "NGApplyConfirmationViewController.h"
#import "NGResmanLoginDetailsViewController.h"
#import "NGResmanHalfWayToFullViewController.h"
#import "NGCustomQuestionViewController.h"
#import "NGViewMoreSimJobsViewController.h"
#import "NGJobAnalyticsViewController.h"
#import "NSString+Extra.h"

@interface NGApplyServiceHandler ()

@property (nonatomic, strong) NGLoader *aloader;
@property (nonatomic, strong) NGJobsHandlerObject *aObject;


@end
@implementation NGApplyServiceHandler{
    NSInteger serviceTypeGlobal;
    NSDictionary *parsedResponseGlobal;
}


+(NGApplyServiceHandler *)sharedManager {
    
   static NGApplyServiceHandler *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NGApplyServiceHandler alloc]init];
    });
    return sharedManager;
}

- (void) setupServiceForAppliedJobs:(NGJobsHandlerObject *)jobsObj {
    
    UIView *aview = [(UIViewController *)jobsObj.Controller view];
    
    NGLoader *loader = [[NGLoader alloc]initWithFrame:aview.frame];
    [loader showAnimation:aview];
    self.aloader =  loader;
    self.aObject =  jobsObj;
    
    NSMutableDictionary *params = [self fetchDefaultsCustomQuestionsParamsWithLocation:jobsObj.openJDLocation];

    self.jdOpenPage = jobsObj.openJDLocation;
    //MIS Params
    [params setCustomObject:jobsObj.jobObj.xzMIS forKey:@"xz"];
    
    NSInteger serviceType =  -1;
    
    //NOTE:While adding new type apply, also add deeplinking source method call at
    //customizeRequestParams method of respective service clients
    if (jobsObj.applyState == LoginApplyStateUnRegistered) {
        serviceType  = SERVICE_TYPE_UNREG_APPLY;
    }
    else {
        serviceType = SERVICE_TYPE_LOGGED_IN_APPLY;
    }
    
    __weak NGApplyServiceHandler *mySelfWeak = self;

    [self applyJobHavingParam:params serviceType:serviceType withCallback:^(NGAPIResponseModal *modal) {
        
        [[NGDeepLinkingHelper sharedInstance] setDeeplinkingPage:NGDeeplinkingPageNone];
        if (modal.isSuccess) {
            [mySelfWeak receivedSuccessFromServer:modal];
        }else{
            [mySelfWeak receivedErrorFromServer:modal];
        }
        
    }];

}

-(void)applyJobHavingParam:(NSMutableDictionary*)params  serviceType:(NSInteger)serviceType
              withCallback:(void (^)(NGAPIResponseModal* modal))callback{
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:serviceType];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData) {
        callback(responseData);
    }];

}

#pragma mark - Private Method

- (NSMutableDictionary *) fetchDefaultsCustomQuestionsParamsWithLocation:(NSInteger)openLocation {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.aObject.applyState==LoginApplyStateUnRegistered) {
        [params setDictionary:[self.aObject.unregApplyModal dictionaryOfObjectData]];
    }
    
    [params setValue:self.aObject.jobObj.jobID forKey:@"JOBID"];
    [params setValue:self.aObject.jobObj.jobID forKey:@"jobId"];
    [params setValue:@"0" forKey:@"offset"];
    [params setValue:@"1" forKey:@"_body"];
    [params setValue:[NSNumber numberWithInteger:SIMJOBS_PAGINATION_LIMIT] forKey:@"limit"];
    
    // Sending The Custom Question to Server if available
    if (self.aObject.cqData != nil) {
        [params setValue:self.aObject.cqData forKey:@"CQDATA"];
        [params setValue:self.aObject.jobObj.jobID forKey:@"JOBID"];
    }
    
    if (self.aObject.isCQCancelled) {
        [params setValue:@"1" forKey:@"cqCancel"];
    }
    
    [params setCustomObject:@"ios" forKey:@"reqsource"];
    if (openLocation ==JD_FROM_RECOMMENDED_JOBS_PAGE) {
        [params setCustomObject:@"recommend" forKey:@"source"];
    }
    
    if (openLocation ==JD_FROM_ACP_SIM_JOB_PAGE||openLocation ==JD_FROM_VIEWMORE_OR_JD_SIM_JOB) {
        [params setCustomObject:@"32_0_34" forKey:@"searchloc"];
    }
    return params;
}

#pragma mark - Web manager Delegate
-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
 
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoader];
        
        IENavigationController *navController = (IENavigationController*)APPDELEGATE.container.centerViewController;
        
        switch (responseData.serviceType)
        {
                

            case SERVICE_TYPE_LOGGED_IN_APPLY:
            {
                if(self.jdOpenPage == JD_FROM_VIEWMORE_OR_JD_SIM_JOB)
                {
                    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_LOGGED_IN withEventAction:K_GA_ACTION_JDSIMJOB_LOGGED_IN_APPLY withEventLabel:K_GA_SUCCESS_COUNT_APPLY withEventValue:nil];
                }
                else
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_LOGGED_IN withEventAction:K_GA_ACTION_LOGGED_IN_APPLY withEventLabel:K_GA_SUCCESS_COUNT_APPLY withEventValue:nil];

                NSDictionary* parsedRespon = (NSDictionary*)responseData.parsedResponseData;
                [NGUIUtility showRateUsView];
                
                //Put Shorlist code here
                [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:self.aObject.jobObj forStoring:NO];
                self.aObject.jobObj.isAlreadyApplied=YES;
                [[DataManagerFactory getStaticContentManager]markJobAsAlreadyApplied:self.aObject.jobObj.jobID];
                
                if ([[parsedRespon valueForKey:@"Sim Jobs"] count]==0)
                {
                    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"NoSimJobsFound"];
                    
                    [NGUIUtility removeAllViewControllersTillJobTupleSourceView];
                    
                    [navController popActionViewControllerAnimated:YES];
                    
                }else
                {
                    serviceTypeGlobal = SERVICE_TYPE_LOGGED_IN_APPLY;
                    parsedResponseGlobal = parsedRespon;
                    [[NGAppStateHandler sharedInstance]setDelegate:self];
                    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_APPLY_CONFIRMATION usingNavigationController:APPDELEGATE.container.centerViewController animated:YES];
                }
            }
                break;
                
            case SERVICE_TYPE_UNREG_APPLY:
            {
                
                if(self.jdOpenPage == JD_FROM_VIEWMORE_OR_JD_SIM_JOB)
                {
                    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_UNREG withEventAction:K_GA_ACTION_JDSIMJOB_NON_LOGGED_IN_APPLY withEventLabel:K_GA_SUCCESS_COUNT_APPLY withEventValue:nil];
                }
                else
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_UNREG withEventAction:K_GA_ACTION_UNREG_APPLY withEventLabel:K_GA_LABEL_UNREG_APPLY withEventValue:nil];
                
                //If Applied Successfully just set 'ApplyUnsuccessfullMsg' to FALSE.
                [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"ApplyUnsuccessfullMsg"];
                
                [NGUIUtility showRateUsView];
                
                //Remove from  Shortlist (if there)
                [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:self.aObject.jobObj forStoring:NO];
                
                NSArray* simJobsArr = [responseData.parsedResponseData valueForKey:@"Sim Jobs"];

                if (_aObject.isEmailRegistered) {
                    
                    if ([simJobsArr count]==0)
                    {
                        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"NoSimJobsFound"];
                        [NGUIUtility removeAllViewControllersTillJobTupleSourceView];
                        
                        
                    }
                    //Redirect to ApplyConfirmation page
                    else
                    {
                        serviceTypeGlobal = SERVICE_TYPE_UNREG_APPLY;
                        parsedResponseGlobal = responseData.parsedResponseData;
                        [[NGAppStateHandler sharedInstance]setDelegate:self];
                        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"NoSimJobsFound"];
                        [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_APPLY_CONFIRMATION usingNavigationController:APPDELEGATE.container.centerViewController animated:YES];
                    }
                }
                else{
                    
                    IENavigationController *navigationContlr = (IENavigationController*)APPDELEGATE.container.centerViewController;
                    
                    NGResmanHalfWayToFullViewController *myVc=[[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"ResmanHalfway2Full"];
                     myVc.isSuccess = YES;
                    myVc.serviceType = SERVICE_TYPE_UNREG_APPLY;
                    myVc.aObject = _aObject;
                    myVc.parsedResponseForSim = responseData.parsedResponseData;
                    [navigationContlr pushActionViewController:myVc Animated:YES];
                }
                
            }
                break;
            default:
                break;
        }

    });
}

-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self hideLoader];
        
        NSDictionary* errorDict = [[responseData.responseData JSONValue]objectForKey:@"error"];
        NSString* errorMsg = [[errorDict objectForKey:@"customData"] objectForKey:@"error"];
        switch (responseData.serviceType)
        {
            case SERVICE_TYPE_LOGGED_IN_APPLY:{
               
                if(errorMsg && ![errorMsg isKindOfClass:[NSNull class]] && [errorMsg isEqualToString:@"duplicateapply"])
                    [self popToSourceViewController];
                
                else{
                    
                    [self handleApplyError:errorDict];
                    if (!responseData.isNetworFailed)
                        [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
                    
                }
                break;
                
            }
            case SERVICE_TYPE_UNREG_APPLY:
            {
                
                if(errorMsg && ![errorMsg isKindOfClass:[NSNull class]] && [errorMsg isEqualToString:@"duplicateapply"]){
                    
                    if (_aObject.isEmailRegistered)
                        [self popToSourceViewController];
                        
                    else {

                        IENavigationController *navigationContlr = (IENavigationController*)APPDELEGATE.container.centerViewController;
                        
                        NGResmanHalfWayToFullViewController *myVc=[[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"ResmanHalfway2Full"];
                        myVc.isSuccess = NO;
                        myVc.serviceType = SERVICE_TYPE_UNREG_APPLY;
                        myVc.aObject = _aObject;
                        myVc.parsedResponseForSim = responseData.parsedResponseData;
                        [navigationContlr pushActionViewController:myVc Animated:YES];
                        
                    }
                    
                }else{
                    
                    [self handleApplyError:errorDict];
                    if (!responseData.isNetworFailed)
                        [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
                    
                 }
                break;
                
            }
                
            default:
                break;
                
        }
    });
}

-(void)popToSourceViewController{
    
    UINavigationController *navController = APPDELEGATE.container.centerViewController;
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:KEY_DUPLICATE_APPLY];
    [NGUIUtility removeAllViewControllersTillJobTupleSourceView];
    [navController popViewControllerAnimated:YES];
}
-(void)handleApplyError:(NSDictionary*)errorDict{
    
    NSString* errorMsg = [[errorDict objectForKey:@"customData"] objectForKey:@"EMAIL"];
    if(errorMsg && ![errorMsg isKindOfClass:[NSNull class]] &&
       [errorMsg isEqualToString:@"INVALID"]){
        
        [NGUIUtility showAlertWithTitle:[errorDict objectForKey:@"message"] withMessage:@[@"Email Id is incorrect"] withButtonsTitle:@"Ok" withDelegate:nil];
        
        return;
    }
}

-(void)hideLoader{
    UIView *aview = [(UIViewController *)self.aObject.Controller view];
    [self.aloader hideAnimatior:aview];
    self.aloader = nil;
}
-(void)setPropertiesOfVC:(id)vc{
    
    if([vc isMemberOfClass:[NGApplyConfirmationViewController class]])
    {
        NGApplyConfirmationViewController* viewC = (NGApplyConfirmationViewController*)vc;
        viewC.bScrollTableToTop = YES;

        if (SERVICE_TYPE_LOGGED_IN_APPLY == serviceTypeGlobal) {
            viewC.jobObj = self.aObject.jobObj;
            viewC.simJobs=[parsedResponseGlobal valueForKey:@"Sim Jobs"];
            viewC.jobDesignation=[self.aObject.jobObj designation];
            
        }else if (SERVICE_TYPE_UNREG_APPLY == serviceTypeGlobal){
            
            viewC.simJobs=(NSMutableArray*)[parsedResponseGlobal valueForKey:@"Sim Jobs"];;
            viewC.jobDesignation=self.aObject.jobObj.designation;
            viewC.jobObj= self.aObject.jobObj;

        }else{
            //dummy
        }
        
    }
    
    serviceTypeGlobal = -1;
    parsedResponseGlobal = nil;
    
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
    
}


@end
