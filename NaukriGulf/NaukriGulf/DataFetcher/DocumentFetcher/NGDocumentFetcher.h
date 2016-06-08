//
//  NGDocumentFetcher.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 30/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropboxBrowserViewController.h"
#import "GoogleDriveBrowserViewController.h"



NS_ENUM(NSUInteger, NGResumeTransferStatus){
    kResumeTransferStatusNone,
    kResumeTransferStatusUploading,
    kResumeTransferStatusDownloading
};

@interface NGDocumentFetcher : NSObject<UIActionSheetDelegate, DropboxBrowserDelegate,
                                GoogleDriveBrowserDelegate, UIDocumentPickerDelegate>

+(instancetype)sharedInstance;

-(void)showOptions;

-(void) uploadResumeFileOnServer;

@property(nonatomic,strong) NSString *fileExtensions;
@property(nonatomic) BOOL bIsCloudFile;

@property(nonatomic,weak) id commingFromVC;
@property(nonatomic,readwrite) enum NGResumeTransferStatus resumeTransferStatus;

-(void)showDropBoxOption;
-(void)showGoogleDriveOption;
-(void)showiCloudDriveOption;

-(void)icloudFileExtention:(NSString*)strFileExtension;

@end
