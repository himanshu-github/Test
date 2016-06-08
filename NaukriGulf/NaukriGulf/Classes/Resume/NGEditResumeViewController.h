//
//  NGEditResumeViewController.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 27/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGUploadResumeViaEmailView.h"
#import "NGDocumentFetcher.h"

@interface NGEditResumeViewController : NGBaseViewController<UIGestureRecognizerDelegate, editResumeUploadViaEmailProtocol>

@property(nonatomic,readwrite) BOOL isResumeUploaded;

-(void) setUploadOrDownload:(BOOL) isUpload;

@end