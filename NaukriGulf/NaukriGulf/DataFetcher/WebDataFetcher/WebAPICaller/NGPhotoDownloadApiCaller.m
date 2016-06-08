//
//  NGPhotoDownloadApiCaller.m
//  NaukriGulf
//
//  Created by Arun Kumar on 10/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGPhotoDownloadApiCaller.h"
#import "NGServerErrorDataModel.h"

@interface NGPhotoDownloadApiCaller (){
    enum ResponseCode responseCode;
    BOOL isLogOn;
    void(^RequestCompletionHandler)(NGAPIResponseModal * responseInfo);
    
    NSURLConnection *theConnection;
    NSTimer* _timeOut;
}

@end

@implementation NGPhotoDownloadApiCaller
-(void)getDataWithParams:(APIRequestModal *)requestParams handler:(void (^)(NGAPIResponseModal *))completionHandler{
    
    self.apiRequestObj = requestParams;
    self.apiStartTime = [NSDate date];
    RequestCompletionHandler = completionHandler;
}

-(void)main{
    @autoreleasepool {
        
        id inputData = self.apiRequestObj.requestParameters;
        NSString *inputHeader = self.apiRequestObj.queryStringParameterKey;
        NSDictionary *otherParams = self.apiRequestObj.otherParameters;
        
        if ([[NGHelper sharedInstance]isNetworkAvailable])
        {
            @try {
                NSString *paramString = [[NSString alloc]init];
                if (inputHeader) { //For Recent
                    paramString = [NSString stringWithFormat:@"%@=%@",inputHeader,inputData];
                } else
                    paramString = inputData;
                
                for (NSString *keys in otherParams.allKeys) {
                    paramString = [paramString stringByAppendingFormat:@"&%@=%@",keys,[otherParams objectForKey:keys]];
                }
                
                NSString *URLstr = [NSString stringWithFormat:@"%@%@",self.apiRequestObj.baseUrl,self.apiRequestObj.apiUrl];
                if (self.apiRequestObj.requestMethod==K_REQUEST_METHOD_GET  && [[paramString trimCharctersInSet :[NSCharacterSet characterSetWithCharactersInString:@"{}\n"]] length]>0) {
                    URLstr = [URLstr stringByAppendingFormat:@"?%@",paramString];
                }
                
                URLstr = [URLstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *theURL = [NSURL URLWithString:URLstr];
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30.0];
                
                [theRequest setHTTPMethod:[NSString getRequestMethodNameWithType:self.apiRequestObj.requestMethod]];
                
                for (NSDictionary *headerDict in self.apiRequestObj.httpHeadersArr) {
                    for (NSString *headerKey in headerDict.allKeys) {
                        [theRequest setValue:[headerDict objectForKey:headerKey] forHTTPHeaderField:headerKey];
                    }
                }
                
                NSData *requestdata = [paramString  dataUsingEncoding:NSUTF8StringEncoding];
                
                [theRequest setHTTPBody:requestdata];
                
                if (self.apiRequestObj.requestMethod==K_REQUEST_METHOD_GET) {
                    NSData *requestdata = [[@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  dataUsingEncoding:NSUTF8StringEncoding];
                    
                    [theRequest setHTTPBody:requestdata];
                }
                
                theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                if (theConnection)
                {
                    self.receivedData = [NSMutableData data];
                    
                    _timeOut = [NSTimer scheduledTimerWithTimeInterval:15.0
                                                                target:self selector:@selector(cancelRequest) userInfo:nil repeats:NO];
                    CFRunLoopRun();
                }
                else
                {
                    NGAPIResponseModal *requestInfo = [self createCustomResponseDataObject];
                    requestInfo.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
                    requestInfo.isNetworFailed = YES;
                    [self traceAPIWithResponse:requestInfo];
                    RequestCompletionHandler(requestInfo);
                    
                    if (!self.apiRequestObj.isBackgroundTask) {
                        [self showErrorInMainThreadWithTitle:@"Error" AndMessage:@"Connection could not be established"];
                    }
                    
                }
            }
            
            @catch (NSException *exception)
            {
                NGAPIResponseModal *requestInfo = [self createCustomResponseDataObject];
                requestInfo.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
                requestInfo.isNetworFailed = YES;
                [self traceAPIWithResponse:requestInfo];
                RequestCompletionHandler(requestInfo);
                
                [NGGoogleAnalytics sendExceptionWithDescription:[NSString stringWithFormat:@"%@ %@",exception.name, exception.description] withIsFatal:YES];
            }
        }
        
        else
        {
            NGAPIResponseModal *responseInfo = [self createCustomResponseDataObject];
            responseInfo.isNetworFailed = TRUE;
            responseInfo.isSuccess = FALSE;
            [self traceAPIWithResponse:responseInfo];
            RequestCompletionHandler(responseInfo);
            
        }
    }
}


-(void)cancelRequest{
    
    if (self.isCancelled) {
        
        if (_timeOut != nil) {
            [_timeOut invalidate];
            _timeOut = nil;
        }
        [self generateErrorMessageForCancel:K_REQUEST_TIME_OUT withCancelledRequest:YES];
        return;
    }
    
    if (_timeOut != nil) {
        [_timeOut invalidate];
        _timeOut = nil;
    }
    
    if (theConnection != nil) {
        [self generateErrorMessageForCancel:K_REQUEST_TIME_OUT withCancelledRequest:NO];
        [theConnection cancel];
        theConnection = nil;
    }
    CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.isCancelled) {
        
        if (_timeOut != nil) {
            [_timeOut invalidate];
            _timeOut = nil;
        }
        [self generateErrorMessageForCancel:K_REQUEST_TIME_OUT withCancelledRequest:YES];
        return;
    }
    
    responseCode = (enum ResponseCode)[(NSHTTPURLResponse*)response statusCode];
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.isCancelled) {
        
        if (_timeOut != nil) {
            [_timeOut invalidate];
            _timeOut = nil;
        }
        [self generateErrorMessageForCancel:K_REQUEST_TIME_OUT withCancelledRequest:YES];
        return;
    }
    
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.isCancelled) {
        
        if (_timeOut != nil) {
            [_timeOut invalidate];
            _timeOut = nil;
        }
        [self generateErrorMessageForCancel:K_REQUEST_TIME_OUT withCancelledRequest:YES];
        return;
    }

    
    if (!self.isBackgroundTask) {
        [self showErrorInMainThreadWithTitle:@"Error" AndMessage:[error localizedDescription]];
    }
    
    [self generateErrorMessageForCancel:K_REQUEST_TIME_OUT withCancelledRequest:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.isCancelled) {
        
        if (_timeOut != nil) {
            [_timeOut invalidate];
            _timeOut = nil;
        }
        [self generateErrorMessageForCancel:K_REQUEST_TIME_OUT withCancelledRequest:YES];
        return;
    }

    if (_timeOut != nil) {
        [_timeOut invalidate];
        _timeOut = nil;
    }
    self.apiEndTime = [NSDate date];
    [self processServerResponse];
    CFRunLoopStop(CFRunLoopGetCurrent());
    
}
- (void)generateErrorMessageForCancel:(NSString*)errorStr withCancelledRequest:(BOOL)isRequestCancelled{
    
    self.apiEndTime = [NSDate date];
    
    NGAPIResponseModal *responseInfo = [self createCustomResponseDataObject];
    responseInfo.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
    responseInfo.isRequestCancelled = isRequestCancelled;
    
    [self callErrorMethodInBackGroundThreard:responseInfo];
    [self saveErrorModalForServer:responseInfo withConnectionFailure:YES];

}


-(void)callErrorMethodInBackGroundThreard:(NGAPIResponseModal *)requestInfoData{
    [self traceAPIWithResponse:requestInfoData];
    RequestCompletionHandler(requestInfoData);
    CFRunLoopStop(CFRunLoopGetCurrent());
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([challenge.protectionSpace.host isEqualToString:[NGConfigUtility getBaseURL]])
        {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


#pragma mark - Response processing
-(void)processServerResponse{
    
    NGAPIResponseModal *apiResponseModal = [self createCustomResponseDataObject];
    apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITH_BODY;
    apiResponseModal.validJson            = K_JSON_TYPE_INVALID;
    
    switch (responseCode)
    {
        case K_RESPONSE_SUCCESS:{
            
            apiResponseModal.isSuccess=YES;
            
            if (apiResponseModal.serviceType == SERVICE_TYPE_PROFILE_PHOTO) {
                
                [NGDirectoryUtility savePhotoWithName:USER_PROFILE_PHOTO_NAME data:self.receivedData];
                
            }else if(apiResponseModal.serviceType == SERVICE_TYPE_DOWNLOAD_RESUME){
                
                [NGDirectoryUtility saveResumeWithName:@"Resume" data:self.receivedData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_PHOTO object:nil];
            });
            
            break;
        }
            
            
        case K_RESPONSE_IP_BLOCK_ERROR1:
        {
            [self sendLoadTimeToGA:@"Error"];
            apiResponseModal.isSuccess = NO;
            apiResponseModal.responseData = nil;
            apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
            [[NSNotificationCenter defaultCenter] postNotificationName:BLOCK_IP_NOTIFICATION_OBSERVER object:nil];
            [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            break;
        }
        case K_RESPONSE_IP_BLOCK_ERROR2:
        {
            [self sendLoadTimeToGA:@"Error"];
            apiResponseModal.isSuccess = NO;
            apiResponseModal.responseData = nil;
            apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
            [[NSNotificationCenter defaultCenter] postNotificationName:BLOCK_IP_NOTIFICATION_OBSERVER object:nil];
            [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            break;
        }

        default:{
            [self sendLoadTimeToGA:@"Error"];
            apiResponseModal.isSuccess=NO;
            apiResponseModal.responseData = nil;
            apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
            [NGSavedData saveUserDetails:@"PhotoURL" withValue:@""];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_PHOTO object:nil];
            });

            [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];
            
            break;
        }
    }
        
    [self traceAPIWithResponse:apiResponseModal];
    RequestCompletionHandler(apiResponseModal);
    
}
-(void)saveErrorModalForServer:(NGAPIResponseModal*)apiResponseInfo withConnectionFailure:(BOOL)isTimeOut{
    
    if(apiResponseInfo.responseCode >=300 || apiResponseInfo.responseCode <200){

    NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
        if(isTimeOut)
            sedm.serverExceptionErrorType = K_TIME_OUT_ERROR;
        else
            sedm.serverExceptionErrorType = K_API_EXCEPTION_ERROR;
        
        sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"%@ - %d",[NGConfigUtility getAPIURLWithServiceType:self.apiRequestObj.apiId],apiResponseInfo.responseCode];
    
    sedm.serverExceptionApiURL = self.apiRequestObj.apiUrl;
    sedm.serverExceptionClassName = NSStringFromClass([self class]);
    sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
    sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

        
    NSString *stackTrace = [NSString stringWithFormat:@"#SERVEREXCEPTION: #ExceptionType:%@ TimeStamp:%@ #ApiURL:%@ #ClassName:%@ #MethodName:%@ #SignalType:%@ #SignalStrength:%@ #AppVersion:%@ #ResponseCode:%@ #UserId:%@\n\n",
                                  sedm.serverExceptionErrorType,
                                  sedm.serverExceptionTimeStamp,
                                  sedm.serverExceptionApiURL,
                                  sedm.serverExceptionClassName,
                                  sedm.serverExceptionMethodName,
                                  sedm.serverErrorSignalType,
                                  sedm.serverErrorSignalStrength,
                                  [NSString getAppVersion],
                                  [NSString stringWithFormat:@"%d",apiResponseInfo.responseCode],
                                  sedm.serverErrorUserId];
    sedm.serverExceptionDescription =stackTrace;
        
        
    [NGExceptionHandler logServerError:sedm];
}

}

-(NGAPIResponseModal *)createCustomResponseDataObject{
    
    NGAPIResponseModal *apiRequestModal   = [[NGAPIResponseModal alloc] init];
    apiRequestModal.responseCode         = responseCode;
    apiRequestModal.requestMethod        = self.apiRequestObj.requestMethod;
    apiRequestModal.serviceType          = self.apiRequestObj.apiId;
    apiRequestModal.isBackgroudTask      = self.isBackgroundTask;
    
    return apiRequestModal;
}
#pragma mark Google Analytics

/**
 *  The method sends the API fetch time to Google Analytics.
 *
 *  @param status Denotes the status of API call like success, error.
 */
-(void)sendLoadTimeToGA:(NSString *)status{
    
    NSTimeInterval timeDifference = [self.apiEndTime timeIntervalSinceDate:self.apiStartTime];
    [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"Photo Download Service Call" withTimngLabel:status];
}
- (void)showErrorInMainThreadWithTitle:(NSString*)paramTitle AndMessage:(NSString*)paramMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NGUIUtility showAlertWithTitle:paramTitle message:paramMsg delegate:nil];
    });
}
#pragma mark - Api Tracer
-(void) traceAPIWithResponse:(NGAPIResponseModal*) responseModel{
    
    NSMutableDictionary *tracerDict = [[NSMutableDictionary alloc] init];
    [tracerDict setCustomObject:self.apiRequestObj forKey:@"apiRequest"];
    [tracerDict setCustomObject:self.apiEndTime forKey:@"apiEndTime"];
    [tracerDict setCustomObject:[NSString stringWithFormat:@"%f",[self.apiEndTime timeIntervalSinceDate:self.apiStartTime]] forKey:@"timeDiff"];
    [tracerDict setCustomObject:self.apiStartTime forKey:@"apiStartTime"];
    [tracerDict setCustomObject:responseModel forKey:@"apiResponse"];
    [AppTracer traceAPI:[self getTracerApiModel:tracerDict]];
}



-(TracerAPIModel*) getTracerApiModel:(NSDictionary*) tracerApiDict{
    
    APIRequestModal *requestObj = [tracerApiDict objectForKey:@"apiRequest"];
    NGAPIResponseModal *responseObj = [tracerApiDict objectForKey:@"apiResponse"];
    TracerAPIModel *tracerApiModel = [[TracerAPIModel alloc] init];
    
    tracerApiModel.url = requestObj.apiUrl?requestObj.apiUrl:nil;
    tracerApiModel.requestParams = requestObj.requestParameters?[NSString stringWithFormat:@"%@",requestObj.requestParameters]:nil;
    tracerApiModel.headers =  requestObj.httpHeadersArr.count?[NSString stringWithFormat:@"%@",requestObj.httpHeadersArr]:nil;
    tracerApiModel.startTime= [tracerApiDict objectForKey:@"apiStartTime"];
    tracerApiModel.endTime= [tracerApiDict objectForKey:@"apiEndTime"];
    tracerApiModel.difference = [tracerApiDict objectForKey:@"timeDiff"];
    tracerApiModel.response = responseObj.responseData?[NSString stringWithFormat:@"%@",responseObj.responseData?responseObj.responseData:nil]:nil;
    tracerApiModel.apiSuccess = responseObj.isSuccess?@"API_SUCCESS":@"API_FAILURE";
    tracerApiModel.methodType = [NSString getRequestMethodNameWithType:self.apiRequestObj.requestMethod];
    tracerApiModel.statusCode = [NSString stringWithFormat:@"%d",responseObj.responseCode];
    return tracerApiModel;
    
    
}

@end
