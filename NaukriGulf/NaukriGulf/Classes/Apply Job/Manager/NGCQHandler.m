//
//  NGCQHandler.m
//  NaukriGulf
//
//  Created by Rahul on 19/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//


#import "NGCQHandler.h"
#import "NGApplyServiceHandler.h"
#import "NGCustomQuestionViewController.h"

@interface NGCQHandler()

@property (nonatomic, weak) NGLoader *aLoader;
@property (nonatomic, strong) NGJobsHandlerObject *jbHandlerObj;
@end

@implementation NGCQHandler

+ (NGCQHandler *)sharedManager {
    static NGCQHandler *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager =  [[NGCQHandler alloc]init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.jbHandlerObj =  nil;
        
    }
    return self;
}




#pragma mark - Public Method
- (void)fetchCustomQuestions:(NGJobsHandlerObject *)jbHandlerObj {
    
    UIView *aView = [(UIViewController *)jbHandlerObj.Controller view];
    NGLoader *loader = [[NGLoader alloc] initWithFrame:aView.frame];
    [loader showAnimation:aView];
    self.aLoader = loader;
    self.jbHandlerObj = jbHandlerObj;
    
    __weak NGCQHandler *mySelfWeak = self;
    
        [self fetchCQFor:[self getParametersInDictionary] withCallBack:^(NGAPIResponseModal *modal) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [mySelfWeak hideAnimator];
            
            if (modal.isSuccess) {
                [mySelfWeak updateGoogleAnalyticStateWithStatus:@"Success"];
                NSArray* cQuestArr = [(NSDictionary*)modal.parsedResponseData valueForKey:@"list"];
                if (!cQuestArr || cQuestArr.count == 0) {
                    // If no custom Question availables
                    [mySelfWeak cqHandlerCallUpdateAppliedService:mySelfWeak.jbHandlerObj];
                }
                else {
                    [mySelfWeak navigateToCustomQuestion:cQuestArr];
                }
            }else{
                [mySelfWeak updateGoogleAnalyticStateWithStatus:@"Failure"];
                [mySelfWeak cqHandlerCallUpdateAppliedService:mySelfWeak.jbHandlerObj];
            }
        });
    }];
}

-(void)fetchCQFor:(NSMutableDictionary*)dict withCallBack:(void (^)(NGAPIResponseModal* modal))callback{
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_CUSTOM_QUESTION];
        [obj getDataWithParams:dict handler:^(NGAPIResponseModal *responseData) {
        
        callback(responseData);
    }];
    
    
}

#pragma mark - Private Methods
-(NSMutableDictionary*)getParametersInDictionary{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSMutableDictionary *)@{@"jobId": self.jbHandlerObj.jobObj.jobID},K_RESOURCE_PARAMS, nil];
    
    return params;
}

- (void)updateGoogleAnalyticStateWithStatus:(NSString *)serviceStatus {
    if (self.jbHandlerObj.viewLoadingStartTime != nil) {
        NSDate *searchEndTime = [NSDate date];
        NSTimeInterval timeDifference = [searchEndTime timeIntervalSinceDate:self.jbHandlerObj.viewLoadingStartTime];
        
        [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"Job Description View Loading Time" withTimngLabel:serviceStatus];
    }
}

- (void)navigateToCustomQuestion:(NSArray*)cqArray {
    NGCustomQuestionViewController* customQuestionVC=[[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"CustomQuestion"];
    customQuestionVC.cqArray= cqArray;
    customQuestionVC.bIsRegistredEmailId = self.jbHandlerObj.isEmailRegistered;
    customQuestionVC.jobObj= self.jbHandlerObj.jobObj;
    customQuestionVC.openJDLocation = self.jbHandlerObj.openJDLocation;
    customQuestionVC.applyHandlerState =  self.jbHandlerObj.applyState;
    
    IENavigationController *navigationContlr = (IENavigationController*)APPDELEGATE.container.centerViewController;
    
    [navigationContlr pushActionViewController:customQuestionVC Animated:YES];
}

#pragma mark - JobManager Delegate
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [self updateGoogleAnalyticStateWithStatus:@"Failure"];
    [self hideAnimator];
    [self cqHandlerCallUpdateAppliedService:self.jbHandlerObj];
    
}
-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    [self updateGoogleAnalyticStateWithStatus:@"Success"];
    NSArray* cQuestArr = [(NSDictionary*)responseData.parsedResponseData valueForKey:@"list"];
    if (!cQuestArr || cQuestArr.count == 0) {
        // If no custom Question availables
        [self cqHandlerCallUpdateAppliedService:self.jbHandlerObj];
    }
    else {
        [self navigateToCustomQuestion:cQuestArr];
    }
    [self hideAnimator];
}

-(void)hideAnimator{
    UIView *aview = [(UIViewController *)self.jbHandlerObj.Controller view];
    [self.aLoader hideAnimatior:aview];
}
- (void) cqHandlerCallUpdateAppliedService:(NGJobsHandlerObject *)obj {
    [[NGApplyServiceHandler sharedManager]setupServiceForAppliedJobs:obj];
}
@end
