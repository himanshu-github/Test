//
//  NGWebViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 11/18/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGWebViewController.h"
#import "NGWebViewManager.h"

@interface NGWebViewController ()<UIWebViewDelegate,LoginHelperDelegate>{
    
    IBOutlet UIWebView *mWebView;
    
    NSString *mUrlString;
    
    NSString *mNavigationBarTitle;
    
    BOOL multipleMessageVisibilityStatus;
    
    NSString* authID;
    
    IBOutlet UIView *webViewContainerView;
    
    BOOL isRegistered;
}

@end

@implementation NGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    multipleMessageVisibilityStatus = NO;
    if (self.isCloseBtnHidden) {
        [self setNavigationBarWithTitle:mNavigationBarTitle];
        [self.navigationItem setHidesBackButton:YES];
    }else{
        [self addNavigationBarWithCloseBtnWithTitle:mNavigationBarTitle];
    }
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        self.automaticallyAdjustsScrollViewInsets= NO;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
    

    
}
-(void)viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    [self loadWebViewWithUrl:mUrlString];
    NSLog(@"Webjob url hit   %@",mUrlString);
    

    isRegistered = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillDisappear:animated];
    
    [mWebView loadHTMLString:@"" baseURL:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // Remove and disable all URL Cache, but doesn't seem to affect the memory
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  Sets the url string and navigation title
 *
 *  @param title title for nav bar
 *  @param url   url to load on web view
 */
-(void) setNavigationTitle:(NSString*)title withUrl:(NSString*) url {
    
    mNavigationBarTitle = title;
    
    mUrlString = url;
    
}

/**
 *  Loads the web view with url
 *
 *  @param aUrl url to load on screen
 */
-(void)loadWebViewWithUrl: (NSString *) aUrl {
    
    NSString *fullURL = aUrl;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [mWebView loadRequest:requestObj];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self showAnimator];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideAnimator];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self hideAnimator];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //This method called twice for every request and hence execute mnj code two times
    //which ultimatly increase time in loading html pages
    
    NSString *urls = [request.URL absoluteString];
    [self checkForConMnj:urls];
    return YES;
}
-(void)checkForConMnj:(NSString*)url{
    
    NSString* prefixStr = @"http://loginurl/";
    NSRange range = [url rangeOfString:prefixStr];
    if(range.location != NSNotFound)
    {
        NSString* conmnj = [[[url substringFromIndex:range.length] componentsSeparatedByString:@"/"]objectAtIndex:0];
        if(conmnj.length>0){
            [NGLoginHelper sharedInstance].delegate = self;
            [NGLoginHelper sharedInstance].conMnj = conmnj;
        }
        
    }
}
#pragma mark - LoginHelper delegate
-(void)doneFetchingProfile:(NGMNJProfileModalClass *)profileModal{
    isRegistered = YES;
}
-(void)closeButtonClicked:(id)sender{
    //baseviewcontroller method override
    //NOTE:Bug fix as per discussion with team
    if (isRegistered) {
        [[NGLoginHelper sharedInstance]showMNJHome];
        [NGLoginHelper sharedInstance].delegate = nil;
    }else{
        [super closeButtonClicked:sender];
    }
}
@end
