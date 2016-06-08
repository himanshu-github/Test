//
//  NGEditResumeViewController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 27/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGEditResumeViewController.h"

@interface NGEditResumeViewController (){
    
    
    __weak IBOutlet NSLayoutConstraint *uploadViewTopConstrnt;
    __weak IBOutlet UILabel *lblActionType;
    BOOL isNeedToDisableCancelButton;
}

- (IBAction)emailUploadClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *helpText;

- (IBAction)editResumeClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *textButton;

@property (weak, nonatomic) IBOutlet UILabel *resumeName;

@end

@implementation NGEditResumeViewController

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
    if(![NGHelper sharedInstance].isUserLoggedIn)
        [[self.view viewWithTag:900]setHidden:YES];
    [self setResumeHelpText];
    
    [self addNavigationBarTitleWithCancelAndSaveButton:@"CV Attachment" withLeftNavTilte:K_NAVBAR_LEFT_TITLE_CANCEL withRightNavTitle:nil];
    
    if(IS_IPHONE4){
        
        uploadViewTopConstrnt.constant = uploadViewTopConstrnt.constant+50;
    }
    

    self.isSwipePopDuringTransition = NO;
    self.isSwipePopGestureEnabled = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    if(self.isSwipePopDuringTransition)
        return;
    
    
    [self listenForAppNotification:UIApplicationWillEnterForegroundNotification WithAction:YES];
    
    isNeedToDisableCancelButton = NO;
    
    if(self.isResumeUploaded == FALSE){
        [lblActionType setText:@"Upload"];
        [self.ImageBtn setImage:[UIImage imageNamed:@"upload_resume"] forState:UIControlStateNormal];
        [self.resumeName setHidden:TRUE];
    }else{
        [lblActionType setText:@"Preview"];
        [self.ImageBtn setImage:[UIImage imageNamed:@"preview"] forState:UIControlStateNormal];
        [self.resumeName setHidden:FALSE];
        
        self.resumeName.text = [NSString stringWithFormat:@"CV.%@",[NGHelper sharedInstance].resumeFormat];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.translucent = NO;
    [NGDecisionUtility checkNetworkStatus];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self hideAnimator];
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeUploadedWithNotification:) name:K_NOTIFICATION_RESUME_UPLOAD object:nil];
}
-(void)resumeUploadedWithNotification:(NSNotification*)paramNotification{
    if ([K_NOTIFICATION_RESUME_UPLOAD isEqualToString:paramNotification.name]) {
        
        NSString *selfClassName = NSStringFromClass([self class]);
        NSString *notificationForObject = [paramNotification.userInfo objectForKey:CV_UPLOAD_FOR_OBJECT_KEY];
        if ([selfClassName isEqualToString:notificationForObject]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(unloadEditResumeVC:) withObject:nil afterDelay:1.0f];
            });
        }
    }
}
-(void)unloadEditResumeVC:(id)paramContext{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
    
    IENavigationController *navCntl = ((IENavigationController *)[NGAppDelegate appDelegate].container.centerViewController);
    //sometimes due to pop user reached to dashboard (due to pop of viewcontrollers) which is not correct
    //hence first check the top viewcontroller first and then do pop
    id topViewControllerOfNow = [navCntl topViewController];
    if ([topViewControllerOfNow isKindOfClass:[NGEditResumeViewController class]]) {
        
        [navCntl popActionViewControllerAnimated:YES];
    }
}
-(void) setUploadOrDownload:(BOOL) isUpload {
    
    self.isResumeUploaded = isUpload;
    [self viewWillAppear:TRUE];
}
-(void)setResumeHelpText{
    
    
    NSMutableAttributedString *string ;
    
    string = [[NSMutableAttributedString alloc] initWithString:@"Supported Formats DOC, DOCX, PDF, RTF Max Size 500kb\n\t\t\t\t\t"];
    
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,17)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(17,21)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(37,10)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(47, 5)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70/255.0 green:101/255.0 blue:130/255.0 alpha:1.0 ] range:NSMakeRange(54, [string length]-54)];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue" size:12]
                   range:NSMakeRange(54, [string length]-54)];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue" size:11]
                   range:NSMakeRange(0, 53)];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[string string] length])];
    [self.helpText setAttributedText:string];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editResumeClicked:(id)sender {
    
    if(self.isResumeUploaded ==  FALSE) {
        
        [self uploadlatestResumeClicked:sender];
        
    }
    else{
        [self showAnimator];
        
        [self downLoadResume];
    }
}

-(void)downLoadResume{
    NGDocumentFetcher *docFetcher = [NGDocumentFetcher sharedInstance];
    if (kResumeTransferStatusNone == docFetcher.resumeTransferStatus) {
        docFetcher.resumeTransferStatus = kResumeTransferStatusDownloading;
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DOWNLOAD_RESUME];
        __weak NGEditResumeViewController *weakSelf = self;
        [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseInfo) {
            if (!responseInfo.isRequestCancelled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideAnimator];
                    
                    if (responseInfo.isSuccess) {
                        isNeedToDisableCancelButton = YES;
                        [NGUIUtility previewDocumentWithPath:[weakSelf getFilePathForResume] inController:weakSelf.navigationController];
                    }else{
                        
                        NSString *errMsg = responseInfo.statusMessage;
                        if (nil != responseInfo.parsedResponseData) {
                            errMsg = [errMsg stringByAppendingFormat:@" %@",responseInfo.parsedResponseData];
                        }
                        
                        [weakSelf showMessage:errMsg isError:YES];
                        
                    }
                    //using single direct due to block holding ref of above object
                    [NGDocumentFetcher sharedInstance].resumeTransferStatus = kResumeTransferStatusNone;
                });
            }else{
                //using single direct due to block holding ref of above object
                [NGDocumentFetcher sharedInstance].resumeTransferStatus = kResumeTransferStatusNone;
            }
        }];
    }
}
-(void) showMessage:(NSString *)msg isError:(BOOL)paramIsError{
    if (paramIsError) {
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:msg animationTime:3 showAnimationDuration:0.5];
    }else{
        [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:msg animationTime:3 showAnimationDuration:0.5];
    }
}
- (IBAction)uploadlatestResumeClicked:(id)sender {
    
    NGDocumentFetcher *documentFetcherInstance= [NGDocumentFetcher sharedInstance];
    documentFetcherInstance.commingFromVC = self;
    [documentFetcherInstance showOptions];
    
}

-(NSString*) getFilePathForResume {
    
    NSString *Filename = [NSString stringWithFormat:@"Resume.%@",[NGHelper sharedInstance].resumeFormat];
    
    return Filename;
}


- (IBAction)emailUploadClicked:(id)sender {
    
    NSInteger heightOfEduView = 407;
    NSInteger widthOfEduView = 287;
    
    UIView * bgView = [[UIView alloc] init];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:bgView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView  attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:.3];
    [bgView setTag:1010];
    
    NGUploadResumeViaEmailView *view = [[NGUploadResumeViaEmailView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.delegate = self;
    [self.view addSubview:view];
    
    __block NSLayoutConstraint* leading = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeLeading multiplier:1.0 constant:SCREEN_WIDTH];
    [self.view addConstraint:leading];
    
    
    //44 nav height and 50 bottom button height
    NSInteger yOfEduView = IS_IPHONE4?4:(((SCREEN_HEIGHT-44-50)-heightOfEduView)/2);
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:yOfEduView]];
    
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:heightOfEduView]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:widthOfEduView]];
    
    
    view.leadingConstraint= leading;
    [self.view layoutIfNeeded];
    
    
    NSInteger newXOfEduView = (SCREEN_WIDTH - widthOfEduView)/2;
    [UIView animateWithDuration:0.5f animations:^{
        view.leadingConstraint.constant = newXOfEduView;
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished) {}
     ];
}
-(void)saveButtonPressed{
    //dummy implementation
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_NOTIFICATION_RESUME_UPLOAD object:nil];
}
-(void)cancelButtonTapped:(id)sender{
    if (!isNeedToDisableCancelButton) {
        NSArray* serviceArr = @[[NSNumber numberWithInt:SERVICE_TYPE_DOWNLOAD_RESUME]];
        [[NGOperationQueueManager sharedManager] cancelOperation:serviceArr];
        
        [super cancelButtonTapped:sender];
    }else{
        [self performSelector:@selector(enableCancelButtonForReuse) withObject:nil afterDelay:2.0f];
    }
}
-(void)enableCancelButtonForReuse{
    isNeedToDisableCancelButton = NO;
}
@end