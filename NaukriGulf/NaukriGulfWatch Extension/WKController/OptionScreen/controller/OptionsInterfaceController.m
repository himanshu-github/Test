//
//  OptionsInterfaceController.m
//  NaukriGulf
//
//  Created by Arun on 1/4/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "OptionsInterfaceController.h"
#import "WatchHelper.h"
#import "WatchConstants.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "NGWhoViewedCVInterfaceController.h"

@interface OptionsInterfaceController ()<WCSessionDelegate>{
    
    NSMutableArray* arrRecoJobs;
    
 
    
}
@property ( nonatomic) BOOL isRecoApiHitting;


@end

@implementation OptionsInterfaceController

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    [self setTitle:@"Naukrigulf"];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    arrRecoJobs = [NSMutableArray array];

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    //fetch reco job saved locally if array is empty
    if(arrRecoJobs.count==0){
        [[WCSession defaultSession] sendMessage:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"get_cached_reco",@"name",nil]
                                   replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){
                                       if([replyMessage[@"response"] isKindOfClass:[NSMutableArray class]]){
                                           //NSLog(@"success in fetching cached reco");
                                           if (arrRecoJobs.count == 0)
                                           [arrRecoJobs addObjectsFromArray:replyMessage[@"response"]];
                                       }
                                       else{
                                           //NSLog(@"got error in fetching cached reco");
                                       }
                                   } errorHandler:^(NSError * _Nonnull error) {
                                       //NSLog(@"got error in fetching cached reco");
                                       
                                   }];
    }
    //hit reco job api for upated reco
    _isRecoApiHitting = YES;
    [[WCSession defaultSession] sendMessage:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"api_reco_jobs",@"name",nil]
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){
                                   if([replyMessage[@"response"] isKindOfClass:[NSMutableArray class]]){
                                       //NSLog(@"success in reco service");
                                       if (arrRecoJobs.count)
                                           [arrRecoJobs removeAllObjects];
                                       [arrRecoJobs addObjectsFromArray:replyMessage[@"response"]];
                                       _isRecoApiHitting = NO;
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"RecoData" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:arrRecoJobs,@"response", nil]];
                                   }
                                   else{
                                       //NSLog(@"got error in reco service");
                                       _isRecoApiHitting = NO;
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"RecoData" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:K_NO_INTERENT,@"response", nil]];
                                   }
                                   
                               } errorHandler:^(NSError * _Nonnull error) {
                                   //NSLog(@"got error in connectivity");
                                   _isRecoApiHitting = NO;
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"RecoData" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:K_ERROR_REACHABLE,@"response", nil]];
                               }];

    [WatchHelper sendScreenReportOnGA:GA_WATCH_OPTION_SCREEN];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (IBAction)onRecommended {
  
       if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.reachable) {
         [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"check_eligibility",@"name", nil]
                                           replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            if([[replyMessage objectForKey:@"internet"] boolValue]){
                
            if([[replyMessage objectForKey:@"isLoggedIn"] boolValue]){
                
                [self pushControllerWithName:CONTROLLER_RECOJOBS context:[NSDictionary dictionaryWithObjectsAndKeys:@"reco_jobs",@"page",
                                                 arrRecoJobs,@"data",
                [NSNumber numberWithBool:_isRecoApiHitting],@"_isRecoApiHitting", nil]];
            }
            else
            [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
            [NSDictionary dictionaryWithObjectsAndKeys:K_LOGIN_FROM_IPHONE,KEY_MESSAGE, nil]];
                
            }
            else
            [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:[NSDictionary dictionaryWithObjectsAndKeys:K_NO_INTERENT,KEY_MESSAGE,                                                                                                             nil]];
                                               
            }
            errorHandler:^(NSError * _Nonnull error) {
            [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
            [NSDictionary dictionaryWithObjectsAndKeys:K_SOME_ERROR_OCCURED,KEY_MESSAGE, nil]];
                
            }];
       
        }else
        {
            [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
                                        [NSDictionary dictionaryWithObjectsAndKeys:K_ERROR_REACHABLE,KEY_MESSAGE, nil]];
        }

    }
}

- (IBAction)onSaved {
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];

        if (session.reachable) {
            [self pushControllerWithName:CONTROLLER_RECOJOBS context:
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"saved_jobs",@"page",
                                                                       nil]];

        }else
            [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
             [NSDictionary dictionaryWithObjectsAndKeys:K_ERROR_REACHABLE,KEY_MESSAGE, nil]];
    }

}
- (IBAction)CVViewAction {
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.reachable) {
            [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"check_eligibility",@"name", nil]
       replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
           if([[replyMessage objectForKey:@"internet"] boolValue]){
               
               if([[replyMessage objectForKey:@"isLoggedIn"] boolValue]){
                   
                   [self pushControllerWithName:CONTROLLER_CVVIEWS context:nil];
               }
               else
                   [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
                    [NSDictionary dictionaryWithObjectsAndKeys:K_LOGIN_FROM_IPHONE,KEY_MESSAGE, nil]];
               
           }
           else
               [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:[NSDictionary dictionaryWithObjectsAndKeys:K_NO_INTERENT,KEY_MESSAGE,                                                                                                             nil]];
           
       }
       errorHandler:^(NSError * _Nonnull error) {
           [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
            [NSDictionary dictionaryWithObjectsAndKeys:K_SOME_ERROR_OCCURED,KEY_MESSAGE, nil]];
           
       }];
            
        }else
        {
            [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
             [NSDictionary dictionaryWithObjectsAndKeys:K_ERROR_REACHABLE,KEY_MESSAGE, nil]];
        }
        
    }

    
}



-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext{
    
    [WatchHelper sharedInstance].isUserLoggedIn = [applicationContext[@"login_status"] boolValue];
}
- (void)sessionWatchStateDidChange:(WCSession *)session{
    //NSLog(@"isReachable helper>>>%i",session.isReachable);
    
}
- (void)sessionReachabilityDidChange:(WCSession *)session{
   // NSLog(@"isReachablehelper 111>>>%i",session.isReachable);
    
}
@end



