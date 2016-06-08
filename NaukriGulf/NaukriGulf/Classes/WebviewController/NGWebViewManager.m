//
//  NGWebViewManager.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 22/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGWebViewManager.h"

@interface NGWebViewManager(){
    UIWebView *webView;
    
}
@end

@implementation NGWebViewManager

+ (instancetype)sharedInstance{
    static NGWebViewManager *webViewManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webViewManager = [NGWebViewManager new];
    });
    return webViewManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        webView = [[UIWebView alloc] init];
        
        //set default settings here
        [webView setScalesPageToFit:YES];
        [webView setAutoresizesSubviews:YES];
        [webView setKeyboardDisplayRequiresUserAction:YES];
        [webView setMediaPlaybackAllowsAirPlay:YES];
        [webView setMediaPlaybackRequiresUserAction:YES];
        [webView setDataDetectorTypes:UIDataDetectorTypePhoneNumber];
    }
    return self;
}
- (id)webViewObject{
    if (webView) {
        return webView;
    }
    return nil;
}

- (void)setDelegate:(id)paramDelegate{
    if (webView) {
        [webView setDelegate:paramDelegate];
    }
}
- (void)setWebViewFrame:(CGRect)paramWebViewFrame{
    paramWebViewFrame.origin.y = 0;
    if (webView) {
        [webView setFrame:paramWebViewFrame];
    }
}
- (void)loadBlankPage{
    if (webView) {
        [webView loadHTMLString:@"" baseURL:nil];
    }
}
@end
