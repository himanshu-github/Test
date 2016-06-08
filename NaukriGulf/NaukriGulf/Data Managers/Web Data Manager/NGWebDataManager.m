//
//  NGWebDataManager.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGWebDataManager.h"


#import "NGMNJUpdateServiceClient.h"
#import "NGRecentSearchServiceClient.h"
#import "NGAllJobsServiceClient.h"
#import "NGSSAServiceClient.h"
#import "NGModifySSAServiceClient.h"
#import "NGEmailJobServiceClient.h"
#import "NGLoginServiceClient.h"
#import "NGLogoutServiceClient.h"
#import "NGCQServiceClient.h"
#import "NGUnregApplyServiceClient.h"
#import "NGLoggedInApplyServiceClient.h"
#import "NGRecommendedJobsServiceClient.h"
#import "NGAppliedJobsServiceClient.h"
#import "NGProfileViewsServiceClient.h"
#import "NGUpdateInfoNotificationServiceClient.h"
#import "NGDeleteResumeServiceClient.h"
#import "NGGetNotificationCountServiceClient.h"
#import "NGResetNotificationCountServiceClient.h"
#import "NGDeleteNotificationCountServiceClient.h"
#import "NGFeedbackServiceClient.h"
#import "NGMNJIncompleteSectionServiceClient.h"
#import "NGSimJobsServiceClient.h"
#import "NGForgetPasswordClient.h"
#import "NGRegisteredServiceClient.h"
#import "NGMNJProfilePhotoServiceClient.h"
#import "NGMNJUploadPhotoServiceClient.h"
#import "NGJDServiceClient.h"
#import "NGErrorLoggingClient.h"
#import "NGJDMISServiceClient.h"
#import "NGMNJDeletePhotoServiceClient.h"
#import "NGExchangeTokenClient.h"
#import "NGAppBlockerServiceClient.h"
#import "NGSettingsClient.h"
#import "NGRegisterationServiceClient.h"
#import "NGDownloadResumeClient.h"
#import "NGUploadResumeServiceClient.h"
#import "NGCVRemindMeLaterClient.h"
#import "NGLogUserActionServiceClient.h"
#import "NGDropDownServiceClient.h"
#import "NGUserActiveStateClient.h"
#import "NGFileUploadServiceClient.h"

@interface NGWebDataManager ()

/**
 *  Denotes the type of service.
 */
@property (nonatomic) NSInteger serviceType;

/**
 *  Denotes the object of service client.
 */
@property (nonatomic, strong) id serviceClient;

@end

@implementation NGWebDataManager


-(id)initWithServiceType:(NSInteger)serviceType{
    self = [super init];
    if (self) {
        self.serviceType = serviceType;
        [self initServiceClient];
    }
    
    return self;
}

/**
 *  Initialize a service client object.
 */
-(void)initServiceClient{
    switch (self.serviceType) {
            
        case SERVICE_TYPE_ALL_JOBS:{
            NGAllJobsServiceClient *client = [[NGAllJobsServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_JD:{
            NGJDServiceClient *client = [[NGJDServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
    
        case SERVICE_TYPE_RECENT_SEARCH_COUNT:{
            NGRecentSearchServiceClient *client = [[NGRecentSearchServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }  
        
            
        case SERVICE_TYPE_SSA:{
            NGSSAServiceClient *client = [[NGSSAServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_MODIFY_SSA:{
            NGModifySSAServiceClient *client = [[NGModifySSAServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_EMAIL_JOB:{
            NGEmailJobServiceClient *client = [[NGEmailJobServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_CUSTOM_QUESTION:{
            NGCQServiceClient *client = [[NGCQServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_UNREG_APPLY:{
            NGUnregApplyServiceClient *client = [[NGUnregApplyServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_CHECK_REGISTERED_USER:{
            NGRegisteredServiceClient *client = [[NGRegisteredServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_LOGGED_IN_APPLY:{
            NGLoggedInApplyServiceClient *client = [[NGLoggedInApplyServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
        case SERVICE_TYPE_SIM_JOBS_PAGINATION:
        {
            NGSimJobsServiceClient *client=[[NGSimJobsServiceClient alloc] init];
            self.serviceClient=client;
            break;
        }
            
        case SERVICE_TYPE_LOGIN:{
            NGLoginServiceClient *client = [[NGLoginServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_LOGOUT:{
            NGLogoutServiceClient *client = [[NGLogoutServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
        case SERVICE_TYPE_FORGET_PASSWORD:{
            NGForgetPasswordClient *client = [[NGForgetPasswordClient alloc]init];
            self.serviceClient = client;
            break;
        }
        case SERVICE_TYPE_UPDATE_INFO_NOTIFICATION:{
            NGUpdateInfoNotificationServiceClient *client = [[NGUpdateInfoNotificationServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_GET_NOTIFICATION:{
            NGGetNotificationCountServiceClient *client = [[NGGetNotificationCountServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_RESET_NOTIFICATION:{
            NGResetNotificationCountServiceClient *client = [[NGResetNotificationCountServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_DELETE_PUSH_COUNT:{
            NGDeleteNotificationCountServiceClient *client = [[NGDeleteNotificationCountServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_RECOMMENDED_JOBS:{
            NGRecommendedJobsServiceClient *client = [[NGRecommendedJobsServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_APPLIED_JOBS:{
            NGAppliedJobsServiceClient *client = [[NGAppliedJobsServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_WHO_VIEWED_MY_CV:{
            NGProfileViewsServiceClient *client = [[NGProfileViewsServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_FEEDBACK:{
            NGFeedbackServiceClient *client = [[NGFeedbackServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_USER_DETAILS:{
            NGMNJProfileServiceClient *client = [[NGMNJProfileServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_DELETE_RESUME:{
            NGDeleteResumeServiceClient *client = [[NGDeleteResumeServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_UPDATE_RESUME:{
            NGMNJUpdateServiceClient *client = [[NGMNJUpdateServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
         
        case SERVICE_TYPE_MNJ_INCOMPLETE_SECTION:{
            NGMNJIncompleteSectionServiceClient *client = [[NGMNJIncompleteSectionServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_PROFILE_PHOTO:{
            NGMNJProfilePhotoServiceClient *client = [[NGMNJProfilePhotoServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_UPLOAD_PHOTO:{
            NGMNJUploadPhotoServiceClient *client = [[NGMNJUploadPhotoServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
        case SERVICE_TYPE_MIS_JD:{
            NGJDMISServiceClient *client = [[NGJDMISServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
        case SERVICE_TYPE_ERROR_LOGGING:{
            NGErrorLoggingClient *client = [[NGErrorLoggingClient alloc]init];
            self.serviceClient = client;
            break;
        }
        case SERVICE_TYPE_DELETE_PHOTO:{
            NGMNJDeletePhotoServiceClient *client = [[NGMNJDeletePhotoServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }

        case SERVICE_TYPE_EXCHANGE_TOKEN:{
            NGExchangeTokenClient *client = [[NGExchangeTokenClient alloc]init];
            self.serviceClient = client;
            break;
        }

        case SERVICE_TYPE_APP_BLOCKER:{
            
            NGAppBlockerServiceClient *client = [[NGAppBlockerServiceClient alloc]init];
            self.serviceClient = client;
            break;
        }
            
        case SERVICE_TYPE_SETTINGS:{
            self.serviceClient = [[NGSettingsClient alloc]init];
            break;
        }
        case SERVICE_TYPE_USER_REGISTERATION:{
            self.serviceClient = [[NGRegisterationServiceClient alloc]init];
            break;
        }
        case SERVICE_TYPE_UPLOAD_RESUME:{
            self.serviceClient = [[NGUploadResumeServiceClient alloc] init];
            break;
        }
            
        case SERVICE_TYPE_DOWNLOAD_RESUME:{
            self.serviceClient = [[NGDownloadResumeClient alloc]init];
            break;
        }
            
        case SERVICE_TYPE_CV_REMIND_ME_LATER:{
            self.serviceClient = [[NGCVRemindMeLaterClient alloc] init];
            break;
        }
         
        case SERVICE_TYPE_LOG_USER_ACTION:
            self.serviceClient = [[NGLogUserActionServiceClient alloc] init];
            break;
        
        case SERVICE_TYPE_FILE_UPLOAD:{
            self.serviceClient = [[NGFileUploadServiceClient alloc] init];
        }
            break;
            
        case SERVICE_TYPE_DROPDOWN:
            self.serviceClient = [[NGDropDownServiceClient alloc] init];
            break;

        case SERVICE_TYPE_USER_ACTIVE_STATE:{
            self.serviceClient = [[NGUserActiveStateClient alloc] init];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Blocks+NSOperation
-(void)getDataWithParams:(NSMutableDictionary*)params
                 handler:(void(^)(NGAPIResponseModal* responseInfo))completionHandler{
    
    [self.serviceClient customizeRequestParams:params];
    
    APIRequestModal *requestModal = [self.serviceClient getApiRequestObj];
    
    id jsonString = [[self.serviceClient getDataFormatter] convertFromDict:requestModal.requestParameters];
    requestModal.formattedRequestParameters = jsonString;
    
    [[self.serviceClient getAPICaller] getDataWithParams:requestModal handler:^(NGAPIResponseModal *responseInfo) {
        
        @try {
            id response = [[self.serviceClient getDataParser]  parseResponseDataFromServer:responseInfo];
            if(completionHandler){
            
                completionHandler(response);
            }
        }
        @catch (NSException *exception)
        {
            completionHandler(responseInfo);
            [NGGoogleAnalytics sendExceptionWithDescription:[NSString stringWithFormat:@"%@ %@",exception.name, exception.description] withIsFatal:YES];
        }
        
    }];
    
    [[NGOperationQueueManager sharedManager] addOperationToQueue:[self.serviceClient getAPICaller]];
}

@end
