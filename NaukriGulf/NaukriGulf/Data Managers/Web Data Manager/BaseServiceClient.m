//
//  BaseServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseServiceClient.h"

@implementation BaseServiceClient

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
}

#pragma mark Getter Methods

-(id)getDataFormatter{
    return self.webDataFormatterObj;
}

-(WebAPICaller *)getAPICaller{
    return self.webAPICallerObj;
}


-(id)getDataParser{
    return self.dataParserObj;
}

-(NSMutableDictionary *)getApiParams{
    return self.apiParams;
}

-(NGRecentSearchRequestModal *)getApiParamsFarzi{
    return self.apiParamsFarzi;
}

-(NSMutableDictionary *)getRequestParams{
    return self.requestParams;
}

-(APIRequestModal *)getApiRequestObj{
    return self.apiRequestObj;
}

-(NSMutableDictionary*)setProfilePageDeeplinkingSourceInParam:(NSMutableDictionary*)requestParams{
    @try {
        if (NGDeeplinkingPageProfile == [[NGDeepLinkingHelper sharedInstance] deeplinkingPage]) {
            NSString *deeplinkingSourceVal = [[NGDeepLinkingHelper sharedInstance] deeplinkingSource];
            if (nil != deeplinkingSourceVal) {
                
                if (nil == requestParams) {
                    requestParams = [[NSMutableDictionary alloc] init];
                }
                
                [requestParams setCustomObject:deeplinkingSourceVal forKey:K_SOURCE_KEY_FOR_API_PARAMS];
            }
        }
    }
    @catch (NSException *exception) {
    }
    return requestParams;
}
-(NSMutableDictionary*)setJDPageDeeplinkingSourceInParam:(NSMutableDictionary*)requestParams{
    @try {
        if (NGDeeplinkingPageJD == [[NGDeepLinkingHelper sharedInstance] deeplinkingPage]) {
            NSString *deeplinkingSourceVal = [[NGDeepLinkingHelper sharedInstance] deeplinkingSource];
            if (nil != deeplinkingSourceVal) {
                
                if (nil == requestParams) {
                    requestParams = [[NSMutableDictionary alloc] init];
                }
                
                [requestParams setCustomObject:deeplinkingSourceVal forKey:K_SOURCE_KEY_FOR_API_PARAMS];
            }
        }
    }
    @catch (NSException *exception) {
    }
    return requestParams;
}
@end
