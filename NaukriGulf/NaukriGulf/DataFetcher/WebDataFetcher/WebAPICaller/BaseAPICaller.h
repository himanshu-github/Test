//
//  DataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import "NGAPIResponseModal.h"
#import "APIRequestModal.h"

#define PRIVATE_KEY_JOB_SEARCH @"jdslfjewiui7897898^*&^*&jfklkldsklsjf"
#define PRIVATE_KEY_MNJ @"0@!6gjewiui9375h35^*&^*&jfk10s0dj#@~0"

#define PUBLIC_KEY_JOB_SEARCH @"734fkjs^%^&kjhjskjfjs^%^&*(^*&(123sdf"
#define PUBLIC_KEY_MNJ @"786jkfs^%^&kjhjskjfjs^%^&*(@!$d97dl2^"

/**
 *  Base Class of API Caller. The class is used to communicate with the server.
 
    Conforms to NSURLConnectionDelegate protocol.
 */
@interface BaseAPICaller : NSOperation <NSURLConnectionDelegate>

/**
 *  The binary data received from the server.
 */
@property(strong,nonatomic) NSMutableData *receivedData;

/**
 *  The time when API starts communicating with the server.
 */
@property(strong,nonatomic) NSDate *apiStartTime;

/**
 *  The time when API receives the data from the server.
 */
@property(strong,nonatomic) NSDate *apiEndTime;

/**
 *  Denotes if the API is a asyncronous call.
 */
@property (nonatomic) BOOL isBackgroundTask;

@property (nonatomic, strong) APIRequestModal *apiRequestObj;

/**
 *  The method is used to get fetch data from the server.
 *
 *  @param requestParams Denotes the request parameters.
 */

-(void)getDataWithParams:(APIRequestModal *)requestParams
                 handler:(void(^)(NGAPIResponseModal* responseInfo))completionHandler;



@end
