//
//  NGConfigUtility.h
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGConfigUtility : NSObject

+(NSString *)getAppConfigFilePath;
+(NSString *)getBaseURL;
+(NSString *)getBaseURLWithServiceType:(NSInteger)baseURLType;
+(NSInteger)getJobDownloadLimit;
+(NSString *)getAPIURLWithServiceType:(NSInteger)serviceType;
+(NSArray *)getAppDropDownArray;
+(NSString *)getAppDropDownFileName:(int) index;
+(NSMutableDictionary *)getAppConfigDictionary;
+(NSArray *)getAppStateConfigDictionary;
+ (NSString *)getDeviceModel;

@end
