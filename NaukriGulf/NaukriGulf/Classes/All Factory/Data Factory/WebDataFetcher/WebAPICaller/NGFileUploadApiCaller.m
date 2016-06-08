//
//  NGFileUploadApiCaller.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 13/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGFileUploadApiCaller.h"
#import "TracerHelper.h"

enum K_ResponseCode {
    K_SUCCESS = 200,
    K_SUCESS_WITHOUT_BODY = 204,
    K_SUCESS_CREATE =201,
    K_ERROR = 400,
};

@interface NGFileUploadApiCaller (){
    
    enum ResponseCode responseCode;
    void(^RequestCompletionHandler)(NGAPIResponseModal * responseInfo);
    NSURLConnection *theConnection;
    NSTimer* _timeOut;
    
    NSString *fileExtension;
    
    NGFileUploadType fileUploadType;
}
@end


@implementation NGFileUploadApiCaller
-(void) getDataWithParams:(APIRequestModal *)requestParams handler:(void (^)(NGAPIResponseModal *))completionHandler{
    
    self.apiRequestObj = requestParams;
    [AppTracer traceAPI:requestParams];
    self.apiStartTime = [NSDate date];
    RequestCompletionHandler = completionHandler;
}

-(void)main{
    
    @autoreleasepool {
        
        fileUploadType = [[self.apiRequestObj.requestParameters objectForKey:K_FILE_UPLOAD_TYPE_KEY] unsignedIntegerValue];
        
        
        if ([[NGHelper sharedInstance]isNetworkAvailable])
        {
            @try {
                NSMutableURLRequest *urlRequestObject = nil;
                
                if (NGFileUploadTypeResume == fileUploadType) {
                    urlRequestObject = [self resumeUploadURLRequestObject];
                }else if (NGFileUploadTypePhoto == fileUploadType){
                    urlRequestObject = [self photoUploadURLRequestObject];
                }else{
                    NGAPIResponseModal *responseData = [self createCustomResponseDataObject];
                    responseData.statusMessage = @"Invalid Server Request Error";
                    responseData.isNetworFailed = NO;
                    RequestCompletionHandler(responseData);
                }
                
                theConnection=[[NSURLConnection alloc] initWithRequest:urlRequestObject
                               
                                                              delegate:self];
                if (theConnection)
                {
                    self.receivedData = [NSMutableData data];
                    _timeOut = [NSTimer scheduledTimerWithTimeInterval:180.0
                                                                target:self selector:@selector(cancelRequest) userInfo:nil repeats:NO];
                    CFRunLoopRun();
                }
                
                else
                    
                {
                    NGAPIResponseModal *responseData = [self createCustomResponseDataObject];
                    responseData.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
                    responseData.isNetworFailed = YES;
                    RequestCompletionHandler(responseData);
                    
                    if (!self.isBackgroundTask) {
                        [self showErrorInMainThreadWithTitle:@"Error" AndMessage:@"Connection could not be established"];
                    }
                }
            }
            @catch (NSException *exception)
            {
                NGAPIResponseModal *responseData = [self createCustomResponseDataObject];
                responseData.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
                responseData.isNetworFailed = YES;
                RequestCompletionHandler(responseData);
                
                if (!self.apiRequestObj.isBackgroundTask) {
                    //Commented as per disscussion with team
                    //                [self showErrorInMainThreadWithTitle:@"Communication Error" AndMessage:[NSString stringWithFormat:@"Exception:: %@: %@",[exception name], [exception reason]]];
                }
                
                [NGGoogleAnalytics sendExceptionWithDescription:[NSString stringWithFormat:@"%@ %@",exception.name, exception.description] withIsFatal:YES];
            }
        }
        else
        {
            NGAPIResponseModal *responseInfo = [self createCustomResponseDataObject];
            responseInfo.isNetworFailed = TRUE;
            responseInfo.isSuccess = FALSE;
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

- (void)generateErrorMessageForCancel:(NSString*)errorStr withCancelledRequest:(BOOL)isRequestCancelled{
    
    // NSLog(@"connection failed url: %@",self.apiRequestObj.apiUrl);
    
    self.apiEndTime = [NSDate date];
    
    NGAPIResponseModal *responseInfo = [self createCustomResponseDataObject];
    responseInfo.statusMessage = K_CONNECTION_ESTABLISH_EROR_MSG;
    responseInfo.isRequestCancelled = isRequestCancelled;
    
    [self callErrorMethodInBackGroundThreard:responseInfo];
}


-(void)callErrorMethodInBackGroundThreard:(NGAPIResponseModal *)requestInfoData{
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
    
    if (!self.isBackgroundTask) {
        [self showErrorInMainThreadWithTitle:@"Error" AndMessage:[error localizedDescription]];
    }
    
    [self generateErrorMessageForCancel:[error localizedDescription] withCancelledRequest:NO];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"response[%@],  Cancelled **** = %d",self.apiRequestObj.apiUrl, self.isCancelled);
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

-(NGAPIResponseModal *)createCustomResponseDataObject{
    
    NGAPIResponseModal *apiRequestModal   = [[NGAPIResponseModal alloc] init];
    apiRequestModal.responseCode         = responseCode;
    apiRequestModal.requestMethod        = self.apiRequestObj.requestMethod;
    apiRequestModal.serviceType          = self.apiRequestObj.apiId;
    apiRequestModal.isBackgroudTask      = self.isBackgroundTask;
    
    return apiRequestModal;
}
-(void)processServerResponse{
    
    NSString *responseString = [[NSString alloc] initWithData:self.receivedData  encoding:NSUTF8StringEncoding];
    
        NSLog(@"response = %@",responseString);
    
    NGAPIResponseModal *apiResponseInfo = [self createCustomResponseDataObject];
    apiResponseInfo.responseBodyType     = RESPONSE_BODY_TYPE_WITH_BODY;
    apiResponseInfo.validJson            = K_JSON_TYPE_INVALID;
    
    switch (responseCode)
    {
        case K_RESPONSE_SUCCESS:
        case K_RESPONSE_SUCESS_WITHOUT_BODY:
        case K_RESPONSE_CREATE_SUCCESS:
        {
            apiResponseInfo.isSuccess = YES;
            apiResponseInfo.responseData = responseString;
            
            break;
        }
            
        case K_RESPONSE_ERROR:
        case K_RESPONSE_AUTH_TOKEN_EXPIRED_ERROR:
        {
            apiResponseInfo.isSuccess = NO;
            [self sendLoadTimeToGA:@"Error"];
            apiResponseInfo.responseData = nil;
            apiResponseInfo.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
            
            break;
        }
        default:{
            
            apiResponseInfo.isSuccess = NO;
            [self sendLoadTimeToGA:@"Error"];
            apiResponseInfo.responseData = nil;
            apiResponseInfo.responseBodyType     = RESPONSE_BODY_TYPE_WITHOUT_BODY;
            break;
        }
    }
    RequestCompletionHandler(apiResponseInfo);
    
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([challenge.protectionSpace.host isEqualToString:self.apiRequestObj.baseUrl])
        {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    /*
     
     */
}


#pragma mark Google Analytics

/**
 *  The method sends the API fetch time to Google Analytics.
 *
 *  @param status Denotes the status of API call like success, error.
 */

-(void)sendLoadTimeToGA:(NSString *)status{
    
    NSTimeInterval timeDifference = [self.apiEndTime timeIntervalSinceDate:self.apiStartTime];
    [NGGoogleAnalytics sendLoadTime:timeDifference withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:@"Resume Upload Service Call" withTimngLabel:status];
}

- (void)showErrorInMainThreadWithTitle:(NSString*)paramTitle AndMessage:(NSString*)paramMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        NSString *newParamMsg = [NSString stringWithFormat:@"%@ %@",paramMsg,self.apiRequestObj.apiUrl];
        [[NGHelper sharedInstance]showAlertWithTitle:paramTitle message:paramMsg delegate:nil];
    });
}
-(NSString*)fileKey{
    
    uint64_t number1 = arc4random_uniform(9000000000000) + 1000000000000;
    NSString *formKey = @"";
    if (NGFileUploadTypeResume == fileUploadType) {
        formKey = @"F53be2383a1291";
    }else if (NGFileUploadTypePhoto == fileUploadType){
        formKey = @"F53be23fd7ddd2";
    }else{
        //dummy
    }
    
    NSString* randomStr = [NSString stringWithFormat:@"%@[U%llu]",formKey,number1];
    return randomStr;
}
-(NSMutableURLRequest*)resumeUploadURLRequestObject{
    
    id inputData = self.apiRequestObj.formattedRequestParameters;
    NSString *inputHeader = self.apiRequestObj.queryStringParameterKey;
    NSDictionary *otherParams = self.apiRequestObj.otherParameters;
    
    NSString *paramString = [[NSString alloc]init];
    if (inputHeader) {
        paramString = [NSString stringWithFormat:@"%@=%@",inputHeader,inputData];
    } else
        paramString = inputData;
    
    NSString *URLstr = [NSString stringWithFormat:@"%@%@",self.apiRequestObj.baseUrl,self.apiRequestObj.apiUrl];
    if (self.apiRequestObj.requestMethod==K_REQUEST_METHOD_GET  && [[paramString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}\n"]] length]>0) {
        URLstr = [URLstr stringByAppendingFormat:@"?%@",paramString];
    }
    
    URLstr = [URLstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *theURL = [NSURL URLWithString:URLstr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:180.0];
    
    [theRequest setHTTPMethod:[NGHelper getRequestMethodNameWithType:self.apiRequestObj.requestMethod]];
    
    NSMutableData *body = [NSMutableData data];
    
    fileExtension = [inputData objectForKey:K_KEY_RESUME_EXTENSION];
    
    NSString* fileDetailStr;
    
    
    //get file key from fileKey method , on basis of which module is calling it
    //plus app id also
    fileDetailStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[self fileKey],[NSString stringWithFormat:@"Resume.%@",fileExtension]];
    
    //old method of sending resume/photo
    //                fileDetailStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"CV\"; filename=\"%@\"\r\n",[NSString stringWithFormat:@"Resume.%@",fileExtension]];
    
    for (NSDictionary *headerDict in self.apiRequestObj.httpHeadersArr) {
        
        for (NSString *headerKey in headerDict.allKeys) {
            
            [theRequest setValue:[headerDict objectForKey:headerKey]
              forHTTPHeaderField:headerKey];
            
        }
    }
    
    /*}*/
    
    
    
    NSString *filePath = [NSString stringWithFormat:@"%@.%@",[inputData objectForKey:K_KEY_RESUME_UPLOAD],fileExtension];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    for (NSString *keys in otherParams.allKeys) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",keys] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[otherParams objectForKey:keys] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSData *resumeData = [NSData dataWithContentsOfFile:filePath];
    
    [body appendData: [fileDetailStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:resumeData];
    
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    [theRequest setHTTPBody:body];
    
    return theRequest;
    
}

-(NSMutableURLRequest*)photoUploadURLRequestObject{
    id inputData = self.apiRequestObj.requestParameters;
    NSDictionary *otherParams = self.apiRequestObj.otherParameters;
    
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
    
    //            NSLog(@"Headers = %@",[theRequest allHTTPHeaderFields]);
    
    NSMutableData *body = [NSMutableData data];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    UIImage *image = [inputData objectForKey:@"PHOTO"];
    NSData *imageData = UIImageJPEGRepresentation(image, 10);
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[self fileKey] ,@"Profile.jpg"]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    for (NSString *keys in otherParams.allKeys) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",keys] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[otherParams objectForKey:keys] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set request body
    [theRequest setHTTPBody:body];
    
    return theRequest;
}

@end
