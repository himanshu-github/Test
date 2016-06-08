//
//  NGAPIResponseModal.h
//  NaukriGulf
//
//  Created by bazinga on 22/05/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGAPIResponseModal : NSObject

@property(nonatomic,strong) NSString * responseData;
@property(nonatomic,strong)  id parsedResponseData;
@property(nonatomic,strong) NSString * statusMessage;
@property(nonatomic) BOOL  isBackgroudTask;
@property(nonatomic,assign) enum ServiceType serviceType;
@property(nonatomic,assign) enum RequestMethodType requestMethod;
@property(nonatomic,assign) enum ResponseCode responseCode;
@property(nonatomic,assign) enum SubResponseCode subResponseCode;
@property(nonatomic,assign) enum ResponseBodyType responseBodyType;
@property(nonatomic,assign) enum JsonType validJson;
@property(nonatomic) BOOL  isRequestCancelled;
@property(nonatomic) BOOL isSuccess;
@property (nonatomic) BOOL isNetworFailed;

@end
