//
//  WatchAndiOSCommunicationLayer.m
//  NaukriGulf
//
//  Created by Arun on 10/11/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "WatchOSAndiOSCommunicationLayer.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "NGJobTupleCustomCell.h"
#import "NGJobAnalyticsViewController.h"
#import "NGApplyServiceHandler.h"
#import "NGJobDetails.h"
#import "NGBaseViewController.h"
#import "NGRecommendedJobDetailModel.h"
#import "NGJDdataFetcher.h"
#import "NGHelper.h"
#import "NGWhoViewedMyCVViewController.h"
#import "WatchConstants.h"

@interface WatchOSAndiOSCommunicationLayer()<WCSessionDelegate>{
    

}

@end

@implementation WatchOSAndiOSCommunicationLayer

+(WatchOSAndiOSCommunicationLayer *)sharedInstance{
    
    static WatchOSAndiOSCommunicationLayer *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance  =  [[WatchOSAndiOSCommunicationLayer alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    if (self) {
    }
    return self;
}

-(void)activateSession{

    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message
  replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    
    if ([message[@"name"] isEqualToString:@"api_login"]) {
         replyHandler([NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:[NGHelper sharedInstance].isUserLoggedIn], @"login_status", nil]);
    }
    else if ([message[@"name"] isEqualToString:@"api_apply"]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSMutableDictionary *)@{@"jobId": message[@"job_id"]},K_RESOURCE_PARAMS, @"1", KEY_IS_API_HIT_FROM_WATCH, nil];
        
        
        [[NGCQHandler sharedManager] fetchCQFor:params withCallBack:^(NGAPIResponseModal *modal) {

            if (modal.isSuccess) {
                //send error
                replyHandler([NSDictionary dictionaryWithObjectsAndKeys:@"cq",@"apply_status", nil]);
            }
            else{
                
                NSMutableDictionary* params = [NSMutableDictionary dictionary];
                [params setValue:message[@"job_id"] forKey:@"JOBID"];
                [params setValue:message[@"job_id"] forKey:@"jobId"];
                [params setValue:@"1" forKey:KEY_IS_API_HIT_FROM_WATCH];
                
                [[NGApplyServiceHandler sharedManager] applyJobHavingParam:params
                       serviceType:SERVICE_TYPE_LOGGED_IN_APPLY
                      withCallback:^(NGAPIResponseModal *modal) {

                    if (modal.isSuccess){
                        
                        NGJobDetails* jobDetail = [[NGJobDetails alloc] init];
                        jobDetail.jobID = message[@"job_id"];
                        jobDetail.isAlreadyApplied = YES;
                        [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:jobDetail forStoring:NO];
                        [[DataManagerFactory getStaticContentManager] markJobAsAlreadyApplied:message[@"job_id"]];
                        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_APPLY_FROM_WATCH withEventLabel:K_GA_APPLY_FROM_WATCH withEventValue:nil];
                        replyHandler([NSDictionary dictionaryWithObjectsAndKeys:@"sucess",@"apply_status", nil]);
                        
                    }
                          
                else
                        replyHandler([NSDictionary dictionaryWithObjectsAndKeys:@"error",@"apply_status", nil]);
                          
                      }];
                }

        }];
    }
    else if ([message[@"name"] isEqualToString:@"api_saved_jobs"]) {
       
        NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]getAllSavedJobs]];
        NSMutableArray* tempReverseArr = (NSMutableArray*)[[tempArr reverseObjectEnumerator] allObjects];
        
        //get JD for isWebJob and IsRedirection key
        for (NGJobDetails *modal in tempReverseArr) {
            NSDictionary* dictJob = [NSDictionary dictionaryWithObjectsAndKeys:modal.jobID,@"jobId",@"1", KEY_IS_API_HIT_FROM_WATCH, nil];
            
            NGBaseViewController* vc = [[NGBaseViewController alloc] init];
            [vc fetchJDFromServer:dictJob withCallback:^(NGAPIResponseModal *modal) {}];
        }

        
        
        NSMutableArray* arrSaved = [NSMutableArray array];
        
        for (NGJobDetails *modal in tempReverseArr) {
            
           NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:modal.cmpnyName,@"Name", nil];
            NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:modal.minExp,@"Min", modal.maxExp,@"Max", nil];
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         modal.jobID ,@"JobId",
                                          modal.isWebJob?@"true":@"false",@"IsWebJob",
                                         [NSNumber numberWithInteger:0], @"IsApplied",
                                         [NSNumber numberWithInteger:1], @"IsSaved",
                                         modal.designation, @"Designation",
                                         dict1, @"Company",
                                         dict2, @"Experience",
                                         modal.location, @"Location",
                                         nil];
            
            NSInteger isJobTypeRedirection = [[DataManagerFactory getStaticContentManager] isRedirectionJobToWebView:modal.jobID]?1:0;
            [dict setObject:[NSNumber numberWithInteger:isJobTypeRedirection] forKey:@"isRedirectionJob"];
            
            [arrSaved addObject:dict];
           
        }
        replyHandler([NSDictionary dictionaryWithObjectsAndKeys:arrSaved,@"response", nil]);

    }
    else if ([message[@"name"] isEqualToString:@"api_reco_jobs"]) {
        
        
        NGJobAnalyticsViewController *vc = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"JobAnalyticsView"];
        
        vc.isAPIHitFromiWatch = YES;
        
        [vc myRecoJobs:^(NGAPIResponseModal *modal) {
            

            if (modal.isSuccess) {
                
                NSData *data = [modal.responseData dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers error:nil];
                NSMutableArray* arrJobs = jsonDict[@"list"];
                for (NSDictionary* dict in arrJobs) {
                    
                    NSDictionary* dictJob = [NSDictionary dictionaryWithObjectsAndKeys:dict[@"Job"][@"JobId"],@"jobId",@"1", KEY_IS_API_HIT_FROM_WATCH, nil];
                    
                    NGBaseViewController* vc = [[NGBaseViewController alloc] init];
                    [vc fetchJDFromServer:dictJob withCallback:^(NGAPIResponseModal *modal) {}];
                }
                NSDictionary *responseDataDict = (NSDictionary *)modal.parsedResponseData;
                NGStaticContentManager *jobMgrObj = [DataManagerFactory getStaticContentManager];
                [jobMgrObj deleteAllRecommendedJobs];
                
                NGRecommendedJobDetailModel *objModel = [responseDataDict objectForKey:KEY_JOBS_INFO];
                [jobMgrObj saveRecommendedJobs:objModel.jobList];
                
               
                NSMutableArray* responseArr = [NSMutableArray array];
                for (NSDictionary* dict in arrJobs) {
                    
                    NSMutableDictionary* myDict = [NSMutableDictionary dictionaryWithDictionary:[dict valueForKey:@"Job"]];
                    NSString* jobId = myDict[@"JobId"];
                    NSInteger isJobAlreadyApplied = [[DataManagerFactory getStaticContentManager] isJobApplied: jobId];
                    NSInteger isJobAlreadySaved = [[DataManagerFactory getStaticContentManager] isShortlistedJob:jobId]?1:0;
                    NSInteger isJobTypeRedirection = [[DataManagerFactory getStaticContentManager] isRedirectionJobToWebView:jobId]?1:0;
                    
                    [myDict setObject:[NSNumber numberWithInteger:isJobAlreadyApplied] forKey:@"IsApplied"];
                    [myDict setObject:[NSNumber numberWithInteger:isJobAlreadySaved] forKey:@"IsSaved"];
                    [myDict setObject:[NSNumber numberWithInteger:isJobTypeRedirection] forKey:@"isRedirectionJob"];

                    [responseArr addObject:myDict];

                }
                replyHandler([NSDictionary dictionaryWithObjectsAndKeys:responseArr,@"response", nil]);
                
            }else
                replyHandler([NSDictionary dictionaryWithObjectsAndKeys:modal.statusMessage,@"response", nil]);
        }];
        
    }
    else if ([message[@"name"] isEqualToString:@"get_cached_reco"]) {
        
        NGStaticContentManager *jobMgrObj = [DataManagerFactory getStaticContentManager];
        NSArray *jobsArr = [jobMgrObj getAllRecommendedJobs];
        NSMutableArray* responseArr = [NSMutableArray array];
        for (NGJobDetails* jobDet in jobsArr) {
            
            NSMutableDictionary* myDict = [self getRecoJob:jobDet];
            NSString* jobId = myDict[@"JobId"];
            NSInteger isJobAlreadyApplied = [[DataManagerFactory getStaticContentManager] isJobApplied: jobId];
            NSInteger isJobAlreadySaved = [[DataManagerFactory getStaticContentManager] isShortlistedJob:jobId]?1:0;
            NSInteger isJobTypeRedirection = [[DataManagerFactory getStaticContentManager] isRedirectionJobToWebView:jobId]?1:0;
            
            [myDict setObject:[NSNumber numberWithInteger:isJobAlreadyApplied] forKey:@"IsApplied"];
            [myDict setObject:[NSNumber numberWithInteger:isJobAlreadySaved] forKey:@"IsSaved"];
            [myDict setObject:[NSNumber numberWithInteger:isJobTypeRedirection] forKey:@"isRedirectionJob"];
            [responseArr addObject:myDict];
            
        }
        replyHandler([NSDictionary dictionaryWithObjectsAndKeys:responseArr,@"response", nil]);
        
    }
    else if ([message[@"name"] isEqualToString:@"api_save"]) {
        
        NSInteger isJobAlreadySaved = [[DataManagerFactory getStaticContentManager] isShortlistedJob:message[@"job_id"]]?1:0;

        if(!isJobAlreadySaved)
        {
        NGJobAnalyticsViewController *vc = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"JobAnalyticsView"];
        [vc synchSavedJobHavingIndex:message[@"job_id"] forStoring:YES];
        
        replyHandler([NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:isJobAlreadySaved],@"save_reply", nil]);
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_SAVE_FROM_WATCH withEventLabel:K_GA_SAVE_FROM_WATCH withEventValue:nil];
        }
        
    }
    else if ([message[@"name"] isEqualToString:@"api_unsave"]) {
        
        NGJobAnalyticsViewController *vc = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"JobAnalyticsView"];
        [vc synchSavedJobHavingIndex:message[@"job_id"] forStoring:NO];

        NSInteger isJobAlreadySaved = [[DataManagerFactory getStaticContentManager] isShortlistedJob:message[@"job_id"]]?1:0;
        replyHandler([NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:isJobAlreadySaved],@"unsave_reply", nil]);
        
    }
   else if ([message[@"name"] isEqualToString:GA_WATCH_RECO_RESPONSE_SCREEN]){
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_RECO_NOTIFICATION_RECIEVED withEventLabel:K_GA_RECO_NOTIFICATION_RECIEVED withEventValue:nil];
    }
    
    else if ([message[@"name"] isEqualToString:GA_WATCH_OTHER_RESPONSE_SCREEN]){
         [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_OTHER_NOTIFICATION_RECIEVED  withEventLabel:K_GA_OTHER_NOTIFICATION_RECIEVED withEventValue:nil];
    }
    
    else if ([message[@"name"] isEqualToString:GA_WATCH_OPTION_SCREEN]){
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_OPTION_SCREEN_WATCH  withEventLabel:K_GA_OPTION_SCREEN_WATCH withEventValue:nil];}
    
    else if ([message[@"name"] isEqualToString:GA_WATCH_RECO_SCREEN]){
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_RECO_SCREEN_WATCH  withEventLabel:K_GA_RECO_SCREEN_WATCH withEventValue:nil];}
    
    else if ([message[@"name"] isEqualToString:GA_WATCH_SAVEDJOB_SCREEN]){
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_SAVED_SCREEN_WATCH withEventLabel:K_GA_SAVED_SCREEN_WATCH withEventValue:nil];
    }
    else if ([message[@"name"] isEqualToString:GA_WATCH_JD_SCREEN]){
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_JD_SCREEN  withEventLabel:K_GA_JD_SCREEN withEventValue:nil];
    }

    else if([message[@"name"] isEqualToString:GA_WATCH_NOTI_CLICKED]){
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_NOTIFICATION_CLICKED_WATCH withEventLabel:K_GA_NOTIFICATION_CLICKED_WATCH withEventValue:nil];
    }
    else if ([message[@"name"] isEqualToString:@"jd"]){
        
        NGJDdataFetcher *dataFetcher = [[NGJDdataFetcher alloc] init];
        NGJDJobDetails *jdObj = [dataFetcher getJobFromLocal:message[@"jobId"]];
        
        if (jdObj)
         replyHandler([NSDictionary dictionaryWithObjectsAndKeys:[self jdDetails:jdObj],@"response", nil]);
        
        else{
            
            NSDictionary* dictJob = [NSDictionary dictionaryWithObjectsAndKeys:message[@"jobId"],@"jobId",@"1", KEY_IS_API_HIT_FROM_WATCH,nil];
            
            
            NGBaseViewController* vc = [[NGBaseViewController alloc] init];
            [vc fetchJDFromServer:dictJob withCallback:^(NGAPIResponseModal *modal) {
                
                if(modal.isSuccess)
                    replyHandler([NSDictionary dictionaryWithObjectsAndKeys:
                                  [self jdDetails:modal.parsedResponseData],@"response", nil]);
                else
                    replyHandler([NSDictionary dictionaryWithObjectsAndKeys:
                                                                    @"error",@"response", nil]);

            }];
        }

    }
    else if ([message[@"name"] isEqualToString:@"watchUser_feedback"]){
        [NGLoginHelper sendAppleWatchUserDetails];
    }
    else if ([message[@"name"] isEqualToString:@"check_eligibility"]){
        
        replyHandler([NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[NGHelper sharedInstance].isUserLoggedIn],@"isLoggedIn",
                      [NSNumber numberWithBool:[NGHelper sharedInstance].isNetworkAvailable], @"internet", nil]);
    }
    else if([message[@"name"] isEqualToString:GA_WATCH_VIEWEDCV_SCREEN]){
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_CATEGORY_APPLE_WATCH withEventAction:K_GA_CVVIEWS_SCREEN_WATCH withEventLabel:K_GA_CVVIEWS_SCREEN_WATCH withEventValue:nil];
    }
    else if ([message[@"name"] isEqualToString:@"api_CVViews"]){
        
        
        NGWhoViewedMyCVViewController *whoViewedMyCV = [[NGHelper sharedInstance].mNJStoryboard instantiateViewControllerWithIdentifier:@"WhoViewedMyCV"];
        
        whoViewedMyCV.isAPIHitFromiWatch = YES;

        [whoViewedMyCV getCVViews:^(NGAPIResponseModal *modal) {
            
            
            if (modal.isSuccess) {
                [NGSavedData saveBadgeConsumedInfoWithType:KEY_BADGE_TYPE_PV isConsumed:TRUE];

                NSData *data = [modal.responseData dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers error:nil];
                NSMutableDictionary *responseDict = jsonDict;
                NSMutableArray* responseArr = [NSMutableArray array];
                if ([responseDict objectForKey:@"ViewsDetail"] == [NSNull null]) {
                    //empty case

                }else  {

                    for (NSDictionary* dict in [responseDict objectForKey:@"ViewsDetail"]) {
                        
                        NSMutableDictionary *myDict = [self parseCVViewsForWatch:dict];
                        [responseArr addObject:myDict];
                    }
                    NGStaticContentManager *jobMgrObj = [DataManagerFactory getStaticContentManager];
                    [jobMgrObj deleteAllProfileViews];
                    [jobMgrObj saveProfileViews:[modal.parsedResponseData objectForKey:@"ViewsDetail"]];
                    
                    NSString *dateStr = [responseDict objectForKey:@"CurrentViewDate"];
                    [NGSavedData saveViewedDateForProfile:dateStr];
                    
                }
                replyHandler([NSDictionary dictionaryWithObjectsAndKeys:responseArr,@"response", nil]);
                
            }else
                replyHandler([NSDictionary dictionaryWithObjectsAndKeys:modal.statusMessage,@"response", nil]);
        }];
        
    }

    
}


-(NSDictionary*)jdDetails:(NGJDJobDetails*)jdObj{
    
    NSLog(@"jobID>>%@  kk  isWebJob>>%@",jdObj.jobId,jdObj.isWebjob);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:jdObj.designation,@"designation",
                          jdObj.companyName,@"company",
                          jdObj.formattedExperience,@"experience",
                          
                          jdObj.location,@"location",
                          jdObj.jobDescription,@"job_description",
                          jdObj.companyProfile,@"employer_details",
                          jdObj.gender,@"gender",
                          jdObj.nationality,@"nationality",
                          jdObj.education,@"education",
                          jdObj.dcProfile, @"dc_profile",
                          jdObj.contactName,@"contact_name",
                          jdObj.formattedVacancies,@"vacancy",
                          jdObj.formattedSalary,@"salary",
                          jdObj.formattedLatestPostedDate,@"postedOn",
                          jdObj.isCtcHidden,@"isCtcHidden",
                          jdObj.industryType,@"industryType",
                          jdObj.functionalArea,@"functionalArea",
                          jdObj.keywords,@"keywords",
                          jdObj.contactWebsite,@"contact_website",
                          jdObj.isJobRedirection,@"isRedirectionJob",nil];
    
    return dict;
}
-(NSMutableDictionary*)getRecoJob:(NGJobDetails*)jdObj{
    return ([NSMutableDictionary dictionaryWithObjectsAndKeys:
             jdObj.designation,@"Designation",
             jdObj.location,@"Location",
             [NSDictionary dictionaryWithObjectsAndKeys:jdObj.minExp,@"Min",jdObj.maxExp,@"Max", nil],@"Experience",
             [NSDictionary dictionaryWithObjectsAndKeys:jdObj.cmpnyName,@"Name",jdObj.cmpnyID,@"Id",nil],@"Company",
             jdObj.jobID,@"JobId",
             jdObj.isWebJob?@"true":@"false",@"IsWebJob",
             [NSString stringWithFormat:@"%i",jdObj.isAlreadyApplied],@"IsApplied",
             nil]);
}

-(NSMutableDictionary*)parseCVViewsForWatch:(NSDictionary*)cvObj{
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    if([cvObj objectForKey:@"cityLabel"] !=[NSNull null])
    {
        [dataDict setObject:[cvObj objectForKey:@"cityLabel"] forKey:@"cityLabel"];
    }
    if([cvObj objectForKey:@"clientId"] !=[NSNull null])
    {
        [dataDict setObject:[cvObj objectForKey:@"clientId"] forKey:@"clientId"];
    }
    if([cvObj objectForKey:@"compName"] !=[NSNull null])
    {
        [dataDict setObject:[cvObj objectForKey:@"compName"] forKey:@"compName"];
    }
    
    if([cvObj objectForKey:@"countryLabel"] !=[NSNull null])
    {
        [dataDict setObject:[cvObj objectForKey:@"countryLabel"] forKey:@"countryLabel"];
    }
    if([cvObj objectForKey:@"viewedDate"] !=[NSNull null])
    {
        [dataDict setObject:[cvObj objectForKey:@"viewedDate"] forKey:@"viewedDate"];
    }
    if([cvObj objectForKey:@"indLabel"] !=[NSNull null])
    {
        [dataDict setObject:[cvObj objectForKey:@"indLabel"] forKey:@"indLabel"];
    }
    
    return dataDict;
}


-(void)sendLoginStatusToWatch:(BOOL)userLoggedIn{
    
    [[WCSession defaultSession] updateApplicationContext:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [NSNumber numberWithBool:userLoggedIn],@"login_status", nil] error:nil];
}

@end
