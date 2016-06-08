//
//  NGWebViewManager.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 22/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface NGWebViewManager : NSObject

+ (instancetype)sharedInstance;
- (id)webViewObject;
- (void)setDelegate:(id)paramDelegate;
- (void)setWebViewFrame:(CGRect)paramWebViewFrame;
- (void)loadBlankPage;
@end
