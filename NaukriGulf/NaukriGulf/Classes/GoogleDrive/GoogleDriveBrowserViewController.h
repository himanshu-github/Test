//
//  GoogleDriveBrowserViewController.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 30/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoogleDriveBrowserDelegate;

@interface GoogleDriveBrowserViewController : UITableViewController

@property (nonatomic, weak) id <GoogleDriveBrowserDelegate> rootViewDelegate;
@property (nonatomic, weak) id commingFromVC;
@end

@protocol GoogleDriveBrowserDelegate <NSObject>

@optional

/// Sent to the delegate when there is a successful file download
- (void)googleDriveBrowser:(GoogleDriveBrowserViewController *)browser didDownloadFile:(NSString *)fileName ;

/// Sent to the delegate if DropboxBrowser failed to download file from Dropbox
- (void)googleDriveBrowser:(GoogleDriveBrowserViewController *)browser didFailToDownloadFile:(NSString *)fileName;

@end
