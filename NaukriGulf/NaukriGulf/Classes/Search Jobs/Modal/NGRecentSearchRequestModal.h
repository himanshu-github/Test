//
//  NGRecentSearchRequestModal.h
//  NaukriGulf
//
//  Created by bazinga on 22/05/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGRecentSearchRequestModal : NSObject


@property(nonatomic,strong) NSDictionary * otherParameters;
@property(nonatomic,strong) NSString * queryStringParameterKey;
@property(nonatomic,strong) NSNumber * requestMethod;
@property(nonatomic,strong) NSNumber * isBackgroundTask;
@property(nonatomic,strong) NSString * apiUrl;
@property(nonatomic,strong) NSNumber * apiId;
@property(nonatomic,strong) NSString * requestFormatType;
@property(nonatomic,strong) NSString * responseFormatType;
@property(nonatomic,strong) NSDictionary * requestParameters;


@end
