//
//  TracerAPIModel.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TracerAPIModel : NSObject

@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain) NSString *requestParams;
@property(nonatomic,retain) NSString *headers;
@property(nonatomic,retain) NSString *methodType; //ENUM
@property(nonatomic,retain) NSString *startTime;
@property(nonatomic,retain) NSString *endTime;
@property(nonatomic,retain) NSString *difference;
@property(nonatomic,retain) NSString *response;
@property(nonatomic,retain) NSString *appVersion;
@property(nonatomic,retain) NSString *apiSuccess;
@property(nonatomic,retain) NSString *isNetworkPresent;
@property(nonatomic,retain) NSString *statusCode; //ENUM
@end
