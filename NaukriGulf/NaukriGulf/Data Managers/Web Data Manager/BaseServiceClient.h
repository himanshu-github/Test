//
//  BaseServiceClient.h
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebAPICaller.h"
#import "NGJsonDataFormatter.h"
#import "NGNewMonkErrorDataFormatter.h"
#import "NGURLDataFormatter.h"
#import "NGPhotoUploadDataFormatter.h"
#import "BaseDataParser.h"
#import "NGPhotoDownloadAPICaller.h"
#import "NGRecentSearchRequestModal.h"
#import "APIRequestModal.h"
/**
 *  Base Class of Service Client. It is used to customize the parameters required to fetch data from the server for specific API. It also creates object of BaseAPICaller, BaseDataParser, BaseDataFormatter class.
 */
@interface BaseServiceClient : NSObject

/**
 *  Represents the object of BaseAPICaller class used to communicate with the server.
 */
@property (nonatomic, strong) id webAPICallerObj;

/**
 *  Represents the object of BaseDataFormatter class used to format request parameters in json/xml.
 */
@property (nonatomic, strong) id webDataFormatterObj;

/**
 *  Represents the object of BaseDataParser class used to parser the data received from the server.
 */
@property (nonatomic, strong) id dataParserObj;

/**
 *  Represents the parameters related to API like header, public/private key.
 */
@property (nonatomic, strong) NSMutableDictionary *apiParams;

@property (nonatomic, strong) NGRecentSearchRequestModal *apiParamsFarzi;
@property (nonatomic, strong) APIRequestModal *apiRequestObj;

/**
 *  Represents the request parameters of API.
 */
@property (nonatomic, strong) NSMutableDictionary *requestParams;

/**
 *  This method is used to customize the request parameters of API.
 *
 *  @param params Represents the request parameters.
 */
-(void)customizeRequestParams:(NSMutableDictionary *)params;

/**
 *  This method is used to get object of BaseAPICaller.
 *
 *  @return Returns the object of BaseAPICaller.
 */
-(WebAPICaller *)getAPICaller;

/**
 *  This method is used to get object of BaseDataFormatter.
 *
 *  @return Returns the object of BaseDataFormatter.
 */
-(id)getDataFormatter;

/**
 *  This method is used to get object of BaseDataParser.
 *
 *  @return Returns the object of BaseDataParser.
 */
-(id)getDataParser;

/**
 *  This method is used to get parameters related to API.
 *
 *  @return Returns the parameters related to API.
 */
-(NSMutableDictionary *)getApiParams;
-(NSMutableDictionary *)getApiParamsFarzi;
-(APIRequestModal *)getApiRequestObj;

/**
 *  This method is used to get request parameters of API.
 *
 *  @return Returns the request parameters of API.
 */
-(NSMutableDictionary *)getRequestParams;
-(NSMutableDictionary*)setProfilePageDeeplinkingSourceInParam:(NSMutableDictionary*)requestParams;
-(NSMutableDictionary*)setJDPageDeeplinkingSourceInParam:(NSMutableDictionary*)requestParams;
@end
