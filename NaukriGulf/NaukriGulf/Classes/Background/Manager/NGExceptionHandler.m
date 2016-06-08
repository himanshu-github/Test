//
//  NGExceptionHandler.m
//  Naukri
//
//  Created by Arun Kumar on 3/25/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGExceptionHandler.h"
#import "NGExceptionCoreData.h"
#import "NGServerErrorCoreData.h"
#import "NGServerErrorDataModel.h"

@implementation NGExceptionHandler

+ (void)initiateExceptionLoggingTimer
{
    [NSTimer scheduledTimerWithTimeInterval:K_ERROR_LOGGER_TIMER target:self selector:@selector(sendExceptionToNewMonkServer) userInfo:nil repeats:YES];
    [self sendExceptionToNewMonkServer];

}

+(void)logException:(NSException *)exception withTopView:(NSString*)controller{
    
    NGStaticContentManager* staticContentManager = [[NGStaticContentManager alloc]init];
    [staticContentManager saveException:exception withTopControllerName:controller];
}


+(void)logServerError:(NGServerErrorDataModel *)errorModal{
    
    NGStaticContentManager* staticContentManager = [[NGStaticContentManager alloc]init];
    [staticContentManager saveErrorForServer:errorModal];
    
}

+(void)sendExceptionToNewMonkServer{
    
    NSLog(@"%i",[(NSString*)([[NSBundle mainBundle] infoDictionary][@"isDebugMode"]) boolValue]);
    
    if(![(NSString*)([[NSBundle mainBundle] infoDictionary][@"isDebugMode"]) boolValue]){

    NSArray* logsArray = [[[NGStaticContentManager alloc]init]fetchSavedExceptions];
    NSArray* errorsArray = [[[NGStaticContentManager alloc]init]fetchSavedErrorsForServer];
    if(logsArray.count + errorsArray.count == 0)
        return;
    
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    
    NSString *uID = @"";
    if (objModel) {
        ValidatorManager *vManager = [ValidatorManager sharedInstance];
        if(0>=[vManager validateValue:objModel.username withType:ValidationTypeString].count){
            uID = objModel.username;
        }
        vManager = nil;
    }
   
    
    NSMutableDictionary *errDict  = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               @"app",K_NEW_MONK_EXCEPTION_SOURCE,
                                               @"2",K_NEW_MONK_EXCEPTION_APPID,
                                               uID,K_NEW_MONK_EXCEPTION_UID,
                                               [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                [NSMutableDictionary
                                                 dictionaryWithObjectsAndKeys:@"ios",@"name",[UIDevice currentDevice].systemVersion,@"version", nil],K_NEW_MONK_EXCEPTION_OS,
                                                [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString getAppVersion],@"version", nil],K_NEW_MONK_EXCEPTION_APP,
                                                [NSMutableDictionary dictionaryWithObjectsAndKeys:[NGConfigUtility getDeviceModel],@"name", nil],K_NEW_MONK_EXCEPTION_DEVICE,
                                                nil],K_NEW_MONK_EXCEPTION_ENVIRONMENT,
                                               nil];
    
    NSMutableArray* errArr = [[NSMutableArray alloc]init];
    for (NGExceptionCoreData* exception in logsArray)
    {
        
        [errArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                           exception.exceptionName,K_NEW_MONK_EXCEPTION_TAG,
                           exception.timeStamp,K_NEW_MONK_EXCEPTION_TIME_STAMP,
                           exception.exceptionType,K_NEW_MONK_EXCEPTION_TYPE,
                           exception.exceptionName,K_NEW_MONK_EXCEPTION_MESSAGE,
                           exception.exceptionDebugDescription,K_NEW_MONK_EXCEPTION_STACK_TRACE,
                           exception.exceptionTag?exception.exceptionTag:@"NA",K_NEW_MONK_EXCEPTION_FILE,
                           nil]];
    }
    
    for (NGServerErrorCoreData* errorServer in errorsArray)
    {
        [errArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                           errorServer.errorTag,K_NEW_MONK_EXCEPTION_TAG,
                           errorServer.timeStamp,K_NEW_MONK_EXCEPTION_TIME_STAMP,
                           errorServer.errorType,K_NEW_MONK_EXCEPTION_TYPE,
                           errorServer.errorName,K_NEW_MONK_EXCEPTION_MESSAGE,
                           errorServer.errorDesription,K_NEW_MONK_EXCEPTION_STACK_TRACE,
                           nil]];
    }

    
    [errDict setObject:errArr forKey:K_NEW_MONK_EXCEPTION];

    NGWebDataManager* dataManager = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_ERROR_LOGGING];
    
    [dataManager getDataWithParams:errDict handler:^(NGAPIResponseModal *responseData){
            if(responseData.isSuccess){
                [[[NGStaticContentManager alloc]init]deleteExceptions];
            }else{
                
            }
    }];
    }
}
@end