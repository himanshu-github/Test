//
//  APIRequestModal.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/16/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "APIRequestModal.h"

@implementation APIRequestModal

-(id)init{
    self = [super init];
    if (self) {
        _otherParameters = [NSMutableDictionary dictionary];
        
        _httpHeadersArr = [[NSMutableArray alloc]init];
        [_httpHeadersArr addObject:@{@"Accept-Encoding": @"gzip"}];
        [_httpHeadersArr addObject:@{@"Accept": @"application/json"}];
        [_httpHeadersArr addObject:@{@"clientId": @"1f0n3"}];
        [_httpHeadersArr addObject:@{@"AppVersion": [NSString getAppVersion]}];
        _baseUrl = [NGConfigUtility getBaseURL];
    }
    
    return self;
}
-(void)setRequestMethod:(enum RequestMethodType)requestMethod{
    
    _requestMethod = requestMethod;
    
    if(_requestMethod == K_REQUEST_METHOD_POST || _requestMethod == K_REQUEST_METHOD_DELETE){
        
        [_httpHeadersArr addObject:@{@"Content-Type": @"application/json"}];
    }
    
    if (requestMethod ==  K_REQUEST_METHOD_PATCH){
        
        _requestMethod = K_REQUEST_METHOD_POST;
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"PATCH",@"X-HTTP-Method-Override", nil];
        
        [_httpHeadersArr addObject:dict];
        
    }else  if (requestMethod == K_REQUEST_METHOD_DELETE){
        
        _requestMethod = K_REQUEST_METHOD_POST;
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"DELETE",@"X-HTTP-Method-Override", nil];
        [_httpHeadersArr addObject:dict];
        
    }else  if (requestMethod == K_REQUEST_METHOD_PUT){
        
        _requestMethod = K_REQUEST_METHOD_POST;
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"PUT",@"X-HTTP-Method-Override", nil];
        [_httpHeadersArr addObject:dict];
        
    }
    else{
        _requestMethod = requestMethod;
    }
    
}
-(void)setAuthorisationHeaderNeeded:(BOOL)authorisationHeaderNeeded{
    if(authorisationHeaderNeeded){
        NSDictionary *dict = [NGSavedData getUserDetails];
        NSString *conmnj = [dict objectForKey:@"conmnj"];
        if (conmnj) {
            NSString *authStr = [NSString stringWithFormat:@"NAUKRIGULF id=%@,authsource=mobileapp",conmnj];
            [_httpHeadersArr addObject:@{@"Authorization": authStr}];
        }
        
    }
    
}


@end
