//
//  NGDirectoryUtility.h
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGDirectoryUtility : NSObject

+(void)clearInboxDir;
+(NSString*)validatePathOfOpenWithTypeDocument;
+(void)saveResumeWithName:(NSString *)name data:(NSData *)data;
+(void) deleteOldResumeIfPresent;
+(unsigned long long)fileSizeAtPath:(NSString*)paramFilePath;
+(void)deletePhotoWithName:(NSString *)name;
+(void)savePhotoWithName:(NSString *)name data:(NSData *)data;
+(void)saveImage:(UIImage*)image WithName:(NSString *)name;
+(void)deeplinkingFileLogger:(NSString*)msg;
+ (NSDictionary*)autoEmailCorrectionSuggesters;
+(NSString *)getDocumentDirectoryPath;
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;


@end
