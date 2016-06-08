//
//  NGQLDocumentPreviewViewController.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 11/03/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@interface NGQLDocumentPreviewViewController : NGBaseViewController
@property (nonatomic, strong)NSMutableArray *arrayOfDocuments;
@property(nonatomic,readwrite) BOOL longPressMode;
@property(nonatomic,readwrite)BOOL showDownloadedFile;
@property(nonatomic,strong) UIBarButtonItem *btnRight;
@property(nonatomic, strong) NSURL* myURL;
@property(nonatomic) BOOL isCloudDocument;
@end
