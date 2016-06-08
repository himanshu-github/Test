//
//  WebDataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "WebAPICaller.h"
#import "NGRecentSearchRequestModal.h"
#import "NGServerErrorDataModel.h"

enum K_ResponseCode {
    K_SUCCESS = 200,
    K_SUCESS_WITHOUT_BODY = 204,
    K_SUCESS_CREATE =201,
    K_ERROR = 400,
};

@interface WebAPICaller (){
    
    enum ResponseCode responseCode;
    void(^RequestCompletionHandler)(NGAPIResponseModal * responseInfo);
    NSURLConnection *theConnection;
    NSTimer* _timeOut;
}

@end

@implementation WebAPICaller


-(void) getDataWithParams:(APIRequestModal *)requestParams handler:(void (^)(NGAPIResponseModal *))completionHandler{

    self.apiRequestObj = requestParams;
    self.apiStartTime = [NSDate date];
    RequestCompletionHandler = completionHandler;
}

-(void) main{
    
    @autoreleasepool {
        
        id inputData = self.apiRequestObj.formattedRequestParameters;
        NSString *inputHeader = self.apiRequestObj.queryStringParameterKey;
        NSDictionary *otherParams = self.apiRequestObj.otherParameters;
        
        if ([NGDecisionUtility checkNetworkConnectivity])
        {
            @try {
                NSString *paramString = [[NSString alloc]init];
                if (inputHeader) {
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
                
                
                
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:self.apiRequestObj.isAPIHitFromiWatch?API_TIMEOUT_WATCHOS:API_TIMEOUT_IOS];
                
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
                
                //NSLog(@"Param = %@, url = %@, requestHeader = %@ ", paramString, theURL, theRequest.allHTTPHeaderFields);
                theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                if (theConnection)
                {
                    self.receivedData = [NSMutableData data];
                    

                    _timeOut = [NSTimer scheduledTimerWithTimeInterval:self.apiRequestObj.isAPIHitFromiWatch?API_TIMEOUT_WATCHOS:API_TIMEOUT_IOS
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
                    
                    if (!self.apiRequestObj.isBackgroundTask) {
                        [self showErrorInMainThreadWithTitle:@"Error" AndMessage:@"Connection could not be established"];
                    }
                    
                }
            }
            
            @catch (NSException *exception)
            {
                NGAPIResponseModal *responseData = [self createCustomResponseDataObject];
                responseData.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
                responseData.isNetworFailed = YES;
                [self traceAPIWithResponse:responseData];
                RequestCompletionHandler(responseData);
                
                
                [NGGoogleAnalytics sendExceptionWithDescription:[NSString stringWithFormat:@"%@ %@",exception.name, exception.description] withIsFatal:YES];
            }
        }else
        {
            NGAPIResponseModal *responseData = [self createCustomResponseDataObject];
            responseData.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
            [self traceAPIWithResponse:responseData];
            responseData.isNetworFailed = YES;
            RequestCompletionHandler(responseData);
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
    [self generateErrorMessageForCancel:[error localizedDescription] withCancelledRequest:NO];
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

 - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
        NSString *str = [self.apiRequestObj.baseUrl stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        if ([challenge.protectionSpace.host isEqualToString:str])
        {
			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
		}
	}
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - Response processing
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
                apiResponseModal.responseBodyType       = RESPONSE_BODY_TYPE_WITHOUT_BODY;
                [self saveErrorModalForServer:apiResponseModal withConnectionFailure:NO];
                apiResponseModal.isSuccess = NO;
            }
            break;
        }
        case K_RESPONSE_SUCESS_WITHOUT_BODY:{
            [self sendLoadTimeToGA:@"Success"];
            apiResponseModal.responseData = nil;
            apiResponseModal.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
            apiResponseModal.isSuccess = YES;;
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
            [self sendLoadTimeToGA:@"Error"];
            apiResponseModal.isSuccess = NO;
            
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
            
            [self sendLoadTimeToGA:@"Error"];
            apiResponseModal.isSuccess = NO;
            
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

#pragma mark Google Analytics

/**
 *  The method sends the API fetch time to Google Analytics.
 *
 *  @param status Denotes the status of API call like success, error.
 */
-(void)sendLoadTimeToGA:(NSString *)status{
    
    NSString *serviceName = @"";
    NSInteger serviceType = self.apiRequestObj.apiId;
    BOOL isTrackable = NO;
    switch (serviceType) {
        case SERVICE_TYPE_ALL_JOBS:
            serviceName = @"SRP Service Call";
            isTrackable = YES;
            break;
            
        case SERVICE_TYPE_JD:
            serviceName = @"Job Description Service Call";
            isTrackable = YES;
            break;
            
        case SERVICE_TYPE_SSA:
            isTrackable = YES;
            serviceName = @"SSA  Service Call";
            break;
            
        case SERVICE_TYPE_MODIFY_SSA:
            serviceName = @"Modified SSA";
            break;
            
        case SERVICE_TYPE_RECENT_SEARCH_COUNT:
            serviceName = @"resent Search Count";
            break;
            
        case SERVICE_TYPE_EMAIL_JOB:
            serviceName = @"Email Job";
            break;
        case SERVICE_TYPE_FEEDBACK:
            serviceName = @"Feedback";
            break;
            
        case SERVICE_TYPE_LOGIN:
            serviceName = @"Login";
            break;
            
        case SERVICE_TYPE_LOGOUT:
            serviceName = @"Logout";
            break;
            
        case SERVICE_TYPE_RECOMMENDED_JOBS:
            serviceName = @"Recommended Jobs";
            break;
            
        case SERVICE_TYPE_USER_DETAILS:
            isTrackable = YES;
            serviceName = @"MNJ Profile Page Service Call";
            break;
            
        case SERVICE_TYPE_UNREG_APPLY:
            isTrackable = YES;
            serviceName = @"UnReg Apply Service Call";
            break;
            
        case SERVICE_TYPE_LOGGED_IN_APPLY:
            isTrackable = YES;
            serviceName = @"Logged Apply Service Call";
            break;
            
        case SERVICE_TYPE_WHO_VIEWED_MY_CV:
            serviceName = @"Who viewed my CV";
            break;
        case SERVICE_TYPE_APPLIED_JOBS:
            serviceName = @"Applied Job";
            break;
        case SERVICE_TYPE_GET_NOTIFICATION:
            serviceName = @"Get Notification";
            break;
            
        case SERVICE_TYPE_RESET_NOTIFICATION:
            serviceName = @"Reset Notification";
            
            break;
            
        case SERVICE_TYPE_DELETE_PUSH_COUNT:
            serviceName = @"Delete push notification";
            
            break;
            
        case SERVICE_TYPE_UPDATE_RESUME:
            isTrackable = YES;
            serviceName = @"Update Resume Service Call";
            break;
            
        case SERVICE_TYPE_DELETE_RESUME:
            serviceName = @"Delete Resume";
            break;
        case SERVICE_TYPE_PROFILE_PHOTO:
            isTrackable = YES;
            serviceName = @"Photo Upload Service Call";
            break;
    }
    
    NSTimeInterval timeDifference = [self.apiEndTime timeIntervalSinceDate:self.apiStartTime];
    if(isTrackable){
        
        [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:serviceName withTimngLabel:status];
    }
    
    
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
