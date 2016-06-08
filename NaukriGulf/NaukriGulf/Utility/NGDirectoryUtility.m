//
//  NGDirectoryUtility.m
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGDirectoryUtility.h"
#define DEEPLINKING_DOC_DIRECTORY_FOLDER_NAME @"Deeplinking Logs"

@implementation NGDirectoryUtility


+(void)clearInboxDir{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    NSString* inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
    NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:inboxPath error:nil];
    
    for (NSString *fileNames in dirFiles) {
        NSString *fullPath = [inboxPath stringByAppendingPathComponent:fileNames];
        
        NSError *error;
        [filemgr removeItemAtPath:fullPath error:&error];
    }
}

+(NSString*)validatePathOfOpenWithTypeDocument{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    NSString* inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
    NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:inboxPath error:nil];
    NSString *longPressedFileName;
    
    if([dirFiles count] > 0) {
        
        longPressedFileName = [dirFiles fetchObjectAtIndex:0];
    }
    
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    BOOL isValidString = (0 >= [vManager validateValue:longPressedFileName withType:ValidationTypeString].count);
    if(isValidString) {
        return longPressedFileName;
        
    }
    return nil;
}

+(void)saveResumeWithName:(NSString *)name data:(NSData *)data{
    
    [NGDirectoryUtility deleteOldResumeIfPresent];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",name,[NGHelper sharedInstance].resumeFormat]];
    
    NSError *error = nil;
    if ([data writeToFile:file options:NSDataWritingAtomic error:&error]) {
        // file saved
        [NGDirectoryUtility addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:file]];

    }
}
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}
+(void) deleteOldResumeIfPresent{
    
    [NGDirectoryUtility deleteFileForFormat:@"rtf"];
    [NGDirectoryUtility deleteFileForFormat:@"docx"];
    [NGDirectoryUtility deleteFileForFormat:@"doc"];
    [NGDirectoryUtility deleteFileForFormat:@"pdf"];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    
}
+(void) deleteFileForFormat:(NSString*) extension{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Resume.%@",extension]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [manager removeItemAtPath:filePath error:&error];
        if (error) {
        }
    } else {
    }
    
}

+(unsigned long long)fileSizeAtPath:(NSString*)paramFilePath{
    unsigned long long fileSizeToReturn=0;
    NSError *attributesError;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:paramFilePath error:&attributesError];
    
    if(nil == attributesError){
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        fileSizeToReturn = [fileSizeNumber longLongValue];
    }
    return fileSizeToReturn;
}


+(void)deletePhotoWithName:(NSString *)name{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) fetchObjectAtIndex:0];
    
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir,name];
    NSError *error = nil;
    if ([[NSFileManager defaultManager]fileExistsAtPath:pngFilePath]) {
        [[NSFileManager defaultManager]removeItemAtPath:pngFilePath error:&error];
        [NGSavedData saveUserDetails:@"photoUploadDate" withValue:@""];
    }
}

+(void)saveImage:(UIImage*)image WithName:(NSString *)name{
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) fetchObjectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir,name];
    if(image)
    {
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:pngFilePath atomically:YES];
        [NGDirectoryUtility addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:pngFilePath]];

    }
    else if([[NSFileManager defaultManager]fileExistsAtPath:pngFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:pngFilePath error:nil];
    }
    
    if (pngFilePath) {
        [NGSavedData saveUserDetails:@"PhotoURL" withValue:pngFilePath];
    }
}
+(void)savePhotoWithName:(NSString *)name data:(NSData *)data{
    UIImage *image = [UIImage imageWithData:data];
    [self saveImage:image WithName:name];
}

+ (void)deeplinkingFileLogger:(NSString*)msg{
    
    NSString *fileData= [NSString stringWithFormat:@"\n\n\nTime : %@ \nLogString:%@",[[NSDate date] descriptionWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_IN"]],msg];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",DEEPLINKING_DOC_DIRECTORY_FOLDER_NAME,@"DeeplinkingLogs"]];
    
    [NGDirectoryUtility writeLogsToFile:fileData toFile:fileName];
}
+(void) writeLogsToFile : (NSString*) fileData toFile:(NSString*) fileName{
    
    @synchronized(@"FileLocker"){
        
        [NGDirectoryUtility createDeepLinkingFolder];
        if(![[NSFileManager defaultManager] fileExistsAtPath:fileName]){
            
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
        }
        
        
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
        [file seekToEndOfFile];
        [file writeData:[fileData dataUsingEncoding:NSUTF8StringEncoding]];
        [file closeFile];
    }
}

+(void) createDeepLinkingFolder {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *deeplinkPath = [documentsDirectory stringByAppendingPathComponent:DEEPLINKING_DOC_DIRECTORY_FOLDER_NAME];
    if(![[NSFileManager defaultManager] fileExistsAtPath:deeplinkPath ]){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:deeplinkPath withIntermediateDirectories:FALSE attributes:nil error:nil];
    }
    
}

+ (NSDictionary*)autoEmailCorrectionSuggesters{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:K_EMAIL_AUTO_CORRECT_SUGGESTER_FILENAME ofType:@"json"];
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSDictionary *objDictionary  = [jsonString JSONValue];
    
    return objDictionary;
}

+(NSString *)getDocumentDirectoryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    return documentsDirectory;
}


@end
