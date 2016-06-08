//
//  NGUnregApplyAPICaller.m
//  NaukriGulf
//
//  Created by Swati Kaushik on 30/06/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGUnregApplyAPICaller.h"
#import "NGServerErrorDataModel.h"

@interface NGUnregApplyAPICaller()
{
    enum ResponseCode responseCode;
    void(^RequestCompletionHandler)(NGAPIResponseModal * responseInfo);
    NSURLConnection *theConnection;
    NSTimer* _timeOut;
    
    BOOL isLogOn;
}
@end
@implementation NGUnregApplyAPICaller
-(void) getDataWithParams:(APIRequestModal *)requestParams handler:(void (^)(NGAPIResponseModal *))completionHandler{
    
    self.apiRequestObj = requestParams;
    self.apiStartTime = [NSDate date];
    RequestCompletionHandler = completionHandler;
    
}
-(void) main{
    
    @autoreleasepool {
    
    NSDictionary *otherParams = self.apiRequestObj.otherParameters;
    
    if ([[NGHelper sharedInstance]isNetworkAvailable])
    {
        @try {
            
            NSString *URLstr = [NSString stringWithFormat:@"%@%@",self.apiRequestObj.baseUrl,self.apiRequestObj.apiUrl];

            URLstr = [URLstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *theURL = [NSURL URLWithString:URLstr];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
            [theRequest setHTTPMethod:@"POST"];
            
            
            for (NSDictionary *headerDict in self.apiRequestObj.httpHeadersArr) {
                for (NSString *headerKey in headerDict.allKeys) {
                    if(![headerKey isEqualToString:@"Content-Type"])
                        [theRequest setValue:[headerDict objectForKey:headerKey] forHTTPHeaderField:headerKey];
                }
            }
            
            NSMutableData *body = [NSMutableData data];
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            if([[otherParams objectForKey:@"isCV"]integerValue]==1){
                //attach CV here
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"CV\"; filename=\"%@\"\r\n",[otherParams objectForKey:@"CVFileName"]]dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
            NSString *inputKey = self.apiRequestObj.queryStringParameterKey;
            NSString *jsonStr = (NSString*)self.apiRequestObj.formattedRequestParameters;

            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",inputKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
            [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            
            // set request body
            [theRequest setHTTPBody:body];
            
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
                NGAPIResponseModal *responseData = [self createCustomResponseDataObject];
                responseData.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
                responseData.isNetworFailed = YES;
                [self traceAPIWithResponse:responseData];
                RequestCompletionHandler(responseData);
                
                if (!self.isBackgroundTask) {
                    [self showErrorInMainThreadWithTitle:@"Error" AndMessage:@"Connection could not be established"];
                }
                
            }
            
        }
        
        @catch (NSException *e)
        {
            NGAPIResponseModal *responseData = [self createCustomResponseDataObject];
            responseData.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
            responseData.isNetworFailed = YES;
            [self traceAPIWithResponse:responseData];
            RequestCompletionHandler(responseData);
            
            [NGGoogleAnalytics sendExceptionWithDescription:@"exception Occured" withIsFatal:YES];
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
    
    NGAPIResponseModal *responseData = [self createCustomResponseDataObject];
    responseData.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
    RequestCompletionHandler(responseData);
    
    if (!self.apiRequestObj.isBackgroundTask) {
        [self showErrorInMainThreadWithTitle:@"Error" AndMessage:[error localizedDescription]];
    }
    
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
-(void)processServerResponse{
    NSString *responseString = [[NSString alloc] initWithData:self.receivedData  encoding:NSUTF8StringEncoding];
    
    NGAPIResponseModal *apiResponseModal = [self createCustomResponseDataObject];
    apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITH_BODY;
    apiResponseModal.validJson            = K_JSON_TYPE_INVALID;
    
    switch (responseCode)
    {
        case K_RESPONSE_SUCCESS:{
            
            if ([NGDecisionUtility isValidJSON:responseString])
            {
                apiResponseModal.responseData = responseString;
                apiResponseModal.validJson            = K_JSON_TYPE_VALID;
                apiResponseModal.isSuccess = YES;
            }
            else{
                apiResponseModal.responseData = nil;
                apiResponseModal.isSuccess = NO;
                apiResponseModal.responseBodyType       = RESPONSE_BODY_TYPE_WITHOUT_BODY;
                [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            }
            break;
        }
        case K_RESPONSE_SUCESS_WITHOUT_BODY:{
            apiResponseModal.isSuccess = YES;
            [self sendLoadTimeToGA:@"Success"];
            apiResponseModal.responseData = nil;
            apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
            break;
        }
        case K_RESPONSE_CREATE_SUCCESS:{
            [self sendLoadTimeToGA:@"Success"];
            apiResponseModal.isSuccess = YES;
            
            if ([NGDecisionUtility isValidJSON:responseString]){
                apiResponseModal.responseData = responseString;
                apiResponseModal.validJson            = K_JSON_TYPE_VALID;
            }
            else{
                apiResponseModal.responseData = nil;
                apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
            }
            break;
        }
            
        case K_RESPONSE_ERROR:
        {
            apiResponseModal.isSuccess = NO;
            [self sendLoadTimeToGA:@"Error"];
            if ([NGDecisionUtility isValidJSON:responseString]){
                
                apiResponseModal.responseData = responseString;
                apiResponseModal.validJson            = K_JSON_TYPE_VALID;
                [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            }
            else{
                
                apiResponseModal.responseData = nil;
                apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
                [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            }
            
            break;
        }
        case K_RESPONSE_AUTH_TOKEN_EXPIRED_ERROR:
        {
            apiResponseModal.isSuccess = NO;
            [self sendLoadTimeToGA:@"Error"];
            if ([NGDecisionUtility isValidJSON:responseString]){
                
                apiResponseModal.responseData = responseString;
                apiResponseModal.validJson            = K_JSON_TYPE_VALID;
                [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            }
            else{
                
                apiResponseModal.responseData = nil;
                apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
                [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            }
            
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
            
            apiResponseModal.isSuccess = NO;
            [self sendLoadTimeToGA:@"Error"];
            if ([NGDecisionUtility isValidJSON:responseString]){
                
                apiResponseModal.responseData = responseString;
                apiResponseModal.validJson            = K_JSON_TYPE_VALID;
                [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            }
            else{
                
                apiResponseModal.responseData = nil;
                apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
                [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];

            }
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

        
        NSString *stackTrace =   [NSString stringWithFormat:@"#SERVEREXCEPTION: #ExceptionType:%@ TimeStamp:%@ #ApiURL:%@ #ClassName:%@ #MethodName:%@ #SignalType:%@ #SignalStrength:%@ #AppVersion:%@ #ResponseCode:%@ #UserId:%@",
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

#pragma mark Google Analytics

/**
 *  The method sends the API fetch time to Google Analytics.
 *
 *  @param status Denotes the status of API call like success, error.
 */
-(void)sendLoadTimeToGA:(NSString *)status{
    
    NSTimeInterval timeDifference = [self.apiEndTime timeIntervalSinceDate:self.apiStartTime];
     [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"UnReg Apply Service Call" withTimngLabel:status];
}
- (void)showErrorInMainThreadWithTitle:(NSString*)paramTitle AndMessage:(NSString*)paramMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NGUIUtility showAlertWithTitle:paramTitle message:paramMsg delegate:nil];
    });
}
#pragma mark- API Tracer
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
