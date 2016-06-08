//
//  APIRequestModal.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/16/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequestModal : NSObject
@property (nonatomic, strong) NSMutableDictionary *otherParameters;
@property (nonatomic, strong) NSString *queryStringParameterKey;
@property (nonatomic) enum RequestMethodType requestMethod;
@property (nonatomic) BOOL isBackgroundTask;
@property (nonatomic) BOOL authorisationHeaderNeeded;
@property (nonatomic, strong) NSString *apiUrl;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, readwrite) enum ServiceType apiId;
@property (nonatomic, strong) NSDictionary *requestParameters;
@property (nonatomic, strong) NSMutableArray *httpHeadersArr;
@property (nonatomic, strong) NSDictionary *formattedRequestParameters;
@property (nonatomic, assign) bool isAPIHitFromiWatch;

@end
