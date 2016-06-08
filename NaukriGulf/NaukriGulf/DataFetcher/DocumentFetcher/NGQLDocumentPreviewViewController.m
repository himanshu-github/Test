//
//  NGQLDocumentPreviewViewController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 11/03/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGQLDocumentPreviewViewController.h"
#import "NGDocumentFetcher.h"

@interface NGQLDocumentPreviewViewController (){
    NGLoader* loader;
    __weak IBOutlet UIWebView *webView;
    BOOL isCloudDocDownloaded;
    
}
@property(nonatomic,strong)NSMetadataQuery *fileDownloadMonitorQuery;

@end

@implementation NGQLDocumentPreviewViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self addNavigationBarWithBackBtnWithTitle:@"Preview"];
    
    self.btnRight = nil;
    
    self.btnRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CVTransferStatusNotificationReceived:) name:CV_TRANSFER_STATUS_NOTIFICATION object:nil];

    
    isCloudDocDownloaded = NO;
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = self.btnRight;
    [self listenForNotification:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [self listenForNotification:NO];
}
-(void) viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self showAnimator];
    [self loadURL];
}

-(void)addNavigationBarWithBackBtnWithTitle:(NSString *)navigationTitle{
    self.title = navigationTitle;
    [self customizeNavigationTitleFont];
    
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.3"))
    {
        [self addBackButtonWithBackImageOnNavigationBar];
    }
}

-(void)customizeNavigationTitleFont{
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
      [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:19.0], NSFontAttributeName,nil]];
    self.navigationController.navigationBar.translucent = NO;
}
-(void) addBackButtonWithBackImageOnNavigationBar {
    UIButton *navigationBarLeftBtn1  = [self createButtonWithFrame:CGRectMake(0, 0, 50, 50) withImage:@"back"];
    [self setNavigationLeftButtonEdgeInsetForNavBtn:navigationBarLeftBtn1];
    [navigationBarLeftBtn1 addTarget:self action:@selector(navBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [self createBarButtonItemWithButton:navigationBarLeftBtn1];
}
-(UIBarButtonItem *)createBarButtonItemWithButton:(UIButton *)button{
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barBtnItem;
    
}
-(UIButton *)createButtonWithFrame:(CGRect)btnFrame withImage:(NSString *)imageName{
    
    UIButton* tempButton = [[UIButton alloc] initWithFrame:btnFrame];
    [tempButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    tempButton.exclusiveTouch = YES;
    return tempButton;
}
-(void)setNavigationLeftButtonEdgeInsetForNavBtn:(UIButton*)paramNavButton{
   
    [paramNavButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [paramNavButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
}


-(void)CVTransferStatusNotificationReceived:(NSNotification*)paramNotification{
    if([CV_TRANSFER_STATUS_NOTIFICATION isEqualToString:paramNotification.name]){
        [self hideAnimator];
    }
}

-(void)actionButtonTapped:(id)sender{
    
    if (NO == self.showDownloadedFile) {
        if((!isCloudDocDownloaded)&&_isCloudDocument){
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"CV download is in progress. Please wait for it to complete." animationTime:3 showAnimationDuration:0.5];
            return;
        }
        [self showAnimator];
        [[NGDocumentFetcher sharedInstance] uploadResumeFileOnServer];
        
    }else{
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Document already uploaded , this is only a preview." animationTime:3 showAnimationDuration:0.5];
    }
}
- (void)navBackButtonClicked:(UIButton*)sender{
    NSArray* serviceArr = @[[NSNumber numberWithInt:SERVICE_TYPE_UPLOAD_RESUME]];
    [[NGOperationQueueManager sharedManager] cancelOperation:serviceArr];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hideAnimator{
    
    if ([loader isLoaderAvail]){
        [loader hideAnimatior:self.view];
        loader = nil;
    }
    
}
-(void)showAnimator{
    
    if(!loader){
        
        loader = [[NGLoader alloc] initWithFrame:self.view.frame];
        
    }
    [loader showAnimation:self.view];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CV_TRANSFER_STATUS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

}
-(void)listenForNotification:(BOOL)paramSwitch{
    if (paramSwitch) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedQLDocumentPreviewNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

        
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

        
    }
}
-(void)receivedQLDocumentPreviewNotification:(NSNotification*)paramNotification{
    if (nil != paramNotification) {
        
        if ([UIApplicationWillEnterForegroundNotification isEqualToString:paramNotification.name]) {
            [self hideAnimator];
        }
    }
}
#pragma mark- Did Become Active
-(void)appDidBecomeActive:(NSNotification*)notification{

    NSLog(@"appDidBecomeActive");
    if (_isCloudDocument && !isCloudDocDownloaded) {
        NSLog(@"again download doc");
        [self showAnimator];
        [self loadURL];
    }


}
#pragma mark - UIWebView Delegates
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideAnimator];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}


-(void)loadURL{
    
    if (_isCloudDocument) {
        
        [NGDocumentFetcher sharedInstance].bIsCloudFile = YES;
        [NGDirectoryUtility deleteOldResumeIfPresent];
        [_myURL startAccessingSecurityScopedResource];
        NSString* fileName = [_myURL lastPathComponent];
        
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        __block NSError *error;
        __weak typeof(self) weakSelf = self;

        NSLog(@"**************");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // read info from the URL using the code above
            NSLog(@"&&&&&&&&&&&&");
            [fileCoordinator coordinateReadingItemAtURL:_myURL options:0 error:&error byAccessor:^(NSURL *newURL) {
                isCloudDocDownloaded = YES;

                NSLog(@"^^^^^^^^^^^^^^^^");
                dispatch_async(dispatch_get_main_queue(), ^{
                    // handle data read from the URL
                    NSData *data = [NSData dataWithContentsOfURL:newURL];
                    if (!error) {
                        
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        
                        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                       NSUserDomainMask, YES) objectAtIndex:0];
                        NSString *localPath = [documentsPath stringByAppendingPathComponent:fileName];
                        
                        if ([fileManager fileExistsAtPath:localPath isDirectory:NO]) {
                            [fileManager removeItemAtPath:localPath error:nil];
                        }
                        
                        [data writeToFile:localPath atomically:YES];
                        [NGDirectoryUtility addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:localPath]];
                        
                        NSString* resumePath =  [self renameFileInDocDir:fileName];
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
                        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:resumePath];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf loadWebview:documentsDirectory];
                        });

                        
                    }else{
                        
                        [NGUIUtility showAlertWithTitle:@"Oops!" withMessage:[NSArray arrayWithObject:@"Error occured while downloading the file."] withButtonsTitle:@"OK" withDelegate:nil];
                        
                        [weakSelf showErrorBannerWithMsg:@"Some error occurred, unable to download file from Google drive!!!"];
                        
                    }
                    [_myURL stopAccessingSecurityScopedResource];

                });

            }];
        });
        
        
    }else{
        
        [NGDocumentFetcher sharedInstance].bIsCloudFile = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[self.arrayOfDocuments fetchObjectAtIndex:0]];
        
        [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:documentsDirectory]]];
    }
    
}
-(void)loadWebview:(NSString*)documentsDirectory{
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:documentsDirectory]]];
}
-(NSString*) renameFileInDocDir : (NSString*) filePath {
    
    NSString *fileExtension = [[filePath componentsSeparatedByString:@"."] fetchObjectAtIndex:1];
    [[NGDocumentFetcher sharedInstance] icloudFileExtention:fileExtension];
    NSString *newFilename = [NSString stringWithFormat:@"Resume.%@",fileExtension];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    
    NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:filePath];
    NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:newFilename];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePathSrc]) {
        NSError *error = nil;
        [manager moveItemAtPath:filePathSrc toPath:filePathDst error:&error];
        if (error) {
            //            NSLog(@"There is an Error: %@", error);
        }
    } else {
        //        NSLog(@"File %@ doesn't exists", filePath);
    }
    
    return newFilename;
}
-(void)showErrorBannerWithMsg:(NSString*)paramMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:paramMsg animationTime:3 showAnimationDuration:0.5];
    });
}


@end
