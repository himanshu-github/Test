//
//  NGApplyView.m
//  NaukriGulf
//
//  Created by Minni Arora on 10/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJDFooterView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Extensions.h"

float const animationDurations = .4f;

@interface NGJDFooterView ()
{
    NGWebJobViewController *webApplyView ;
    NGJDJobDetails *JobDesc;
    
    NGLoader *loader;
}
/**
 *  Checks if Job is Webjob.
 */
@property (nonatomic)  BOOL isWebJob;
/**
 *  Checks if Job is Already applied.
 */
@property (nonatomic)  BOOL isAlreadyApplied;
/**
 *  Checks if Job is not webJob still apply redirection is needed.
 */
@property (nonatomic)  BOOL isJobRedirection;


@property (weak, nonatomic) IBOutlet UIButton *applyJobBtn;
@property (weak, nonatomic) IBOutlet UIButton *notShortlistedBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

- (IBAction)shortlistTapped:(id)sender;
- (IBAction)shareTapped:(id)sender;

@end
@implementation NGJDFooterView

#pragma mark -
#pragma mark UIViewController Methods

-(void)viewDidLoad{
    [super viewDidLoad];

    [self showStaticBottom];
    [self.applyJobBtn addTarget:self action:@selector(applyTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (self.jobObj.jdURL==nil || self.jobObj.jdURL.length==0) {
        self.shareBtn.hidden = YES;
        
    }else{
        self.shareBtn.hidden = NO;
        
    }

    [self setAccessibilityLabels];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([loader isLoaderAvail]) {
        [loader hideAnimatior:self.view];
    }
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)shareTapped:(id)sender
{
    [self.delegate shareClicked:self.jobObj];
    
}

-(IBAction)shortlistTapped:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    if (btn.tag == 301) {
        
        [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        btn.tag = 103;
        [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:self.jobObj forStoring:YES];
    }
    else{
        
        [btn setImage:[UIImage imageNamed:@"unselected_dark"] forState:UIControlStateNormal];
        btn.tag = 301;
        [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:self.jobObj forStoring:NO];
    }
    
    NSString *saveJobBtnStatus = [NSString stringWithFormat:@"%d",btn.tag == 103];
    [UIAutomationHelper setAccessibiltyLabel:@"notShortlisted_btn" value:saveJobBtnStatus forUIElement:_notShortlistedBtn];
    
}


#pragma mark Private Mehtods
/**
 *  Sets accessibility labels of dynamic controls
 */
-(void)setAccessibilityLabels{
    
    [UIAutomationHelper setAccessibiltyLabel:@"applyJob_btn" value:_applyJobBtn.titleLabel.text forUIElement:_applyJobBtn];
    
    NSString *saveJobBtnStatus = [NSString stringWithFormat:@"%d",_notShortlistedBtn.tag == 103];
    [UIAutomationHelper setAccessibiltyLabel:@"notShortlisted_btn" value:saveJobBtnStatus forUIElement:_notShortlistedBtn];
    
    [UIAutomationHelper setAccessibiltyLabel:@"shareJob_btn" forUIElement:_shareBtn];
}
/**
 *  Displays contents of static footer view (apply or already applied or email this job).
 */

-(void)showStaticBottom{
    
    if(self.isAlreadyApplied)
    {
        self.applyJobBtn.enabled = FALSE;
        [self.notShortlistedBtn setHidden:TRUE];
        [self.applyJobBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.applyJobBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.applyJobBtn setTitle:@"Already Applied" forState:UIControlStateNormal];
        
 ;
        
    }else if (self.isWebJob){
        
        [self.notShortlistedBtn setHidden:FALSE];
        self.applyJobBtn.enabled = TRUE;
        [self.applyJobBtn setBackgroundColor:[UIColor colorWithRed:1/255.0 green:130/255.0 blue:206/255.0 alpha:1.0]];
        [self.applyJobBtn setTitle:@"Apply" forState:UIControlStateNormal];
        [self.applyJobBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    else{
        
        [self.notShortlistedBtn setHidden:FALSE];
        self.applyJobBtn.enabled = TRUE;
        [self.applyJobBtn setBackgroundColor:[UIColor colorWithRed:1/255.0 green:130/255.0 blue:206/255.0 alpha:1.0]];
       [self.applyJobBtn setTitle:@"Apply" forState:UIControlStateNormal];
              [self.applyJobBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
    if ([[DataManagerFactory getStaticContentManager] isShortlistedJob:self.jobObj.jobID ]) {
    
        self.notShortlistedBtn.tag = 103;
        [self.notShortlistedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else{
        [self.notShortlistedBtn setImage:[UIImage imageNamed:@"unselected_dark"] forState:UIControlStateNormal];
        self.notShortlistedBtn.tag =301;
    }
   
    [self.notShortlistedBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    
}


-(void) applyTapped:(id) sender{
    
    [AppTracer traceStartTime:TRACER_ACP];

    if(self.isJobRedirection && !webApplyView){
        [self enableFooter:FALSE];
        static dispatch_once_t onceTokenJDWebJobApplyTap;
        __weak NGJDFooterView *weakSelf = self;
        dispatch_once(&onceTokenJDWebJobApplyTap, ^{
            [weakSelf logUserActionForWebJobApply];
        });
        [self presentEmailView];
    }
    else if(self.isWebJob && !webApplyView) {
        [self enableFooter:FALSE];
        static dispatch_once_t onceTokenJDWebJobApplyTap;
        __weak NGJDFooterView *weakSelf = self;
        dispatch_once(&onceTokenJDWebJobApplyTap, ^{
            [weakSelf logUserActionForWebJobApply];
        });
        [self presentEmailView];
    }
    else{
        
//        NSLog(@"get called in apply");
//#warning testing
//        return;
        [self.delegate applyClicked:self.jobObj];
        
    }
}

-(void) enableFooter :(BOOL) isEnabled {
    
    self.applyJobBtn.enabled = isEnabled;
    self.notShortlistedBtn.enabled = isEnabled;
    self.shareBtn.enabled = isEnabled;
}



-(void)presentEmailView {
    
    
    webApplyView = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"WebJobView"];
    webApplyView.delegate = self;
    [webApplyView.view setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [((UIViewController*)_delegate).view addSubview:webApplyView.view];
    
    if(IS_IPHONE4||IS_IPHONE5)
        webApplyView.mailJobViewBottomConstrnt.constant = 55;
    else if (IS_IPHONE6)
        webApplyView.mailJobViewBottomConstrnt.constant = 55;
    else if (IS_IPHONE6_PLUS)
        webApplyView.mailJobViewBottomConstrnt.constant = 55+8;
    
    [webApplyView.view layoutIfNeeded];

    
    [UIView animateWithDuration:animationDurations delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         
         webApplyView.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
         [webApplyView.view layoutIfNeeded];

     } completion:nil];
}



-(void) setParams: (BOOL) isWebJob isAppliedJob:(BOOL) isAppliedJob andJobObj: (NGJobDetails *) jobObj andJD:(NGJDJobDetails *)JDObj{
    
    self.jobObj = jobObj;
    self.isWebJob = isWebJob;
    self.isAlreadyApplied=isAppliedJob;
    self.isJobRedirection = JDObj.isJobRedirection.intValue;
    JobDesc = JDObj;
}


-(void)sendEmail:(NSString*) email {
   
    loader = [[NGLoader alloc]initWithFrame:self.view.superview.frame];
    [loader showAnimation:[[UIApplication sharedApplication].windows fetchObjectAtIndex:0]];
    
    //NOTE:instead of using self.jobObj[srp object] we are using
    //detailed job object, becz in case of deeplinking, we are directly landing to jd page
    //hence not getting sprJD object, So this fix is to prevent crash on email this job
    //Permanent fix will be done in 3.2 version as per team discussion
    NSString *positionVal = [self getPosition];
    NSString *jobIdVal = [self getJobId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:email,@"useremail",positionVal,@"position",jobIdVal,@"jobId",nil];
    
    [params setCustomObject:self.xzMIS forKey:@"xz"];
    
    __weak NGJDFooterView *mySelfWeak = self;
    __weak NGLoader* loaderWeak = loader;

    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_EMAIL_JOB];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [loaderWeak hideAnimatior:mySelfWeak.view.superview];
            
            if (responseData.isSuccess) {
                [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"This job has been successfully emailed" animationTime:3 showAnimationDuration:0.5];
                
                [loaderWeak hideAnimatior:mySelfWeak.view.superview];
                
                [[NGDeepLinkingHelper sharedInstance] setDeeplinkingPage:NGDeeplinkingPageNone];
                
            }else{
                
                if ([responseData responseCode] == K_RESPONSE_ERROR) {
                    @try{
                        NSDictionary *errorDic = [[[responseData responseData] JSONValue] objectForKey:@"error"];
                        NSString *errorTitle = [errorDic objectForKey:@"message"];
                        NSArray *errorArray = (NSArray*)[errorDic objectForKey:@"validationErrorDetails"];
                        NSString *errorMessage = [[[errorArray firstObject] objectForKey:@"useremail"] objectForKey:@"message"];
                        if (errorMessage) {
                            [NGUIUtility showAlertWithTitle:errorTitle withMessage:@[@"Email Id is incorrect"] withButtonsTitle:@"Ok" withDelegate:nil];
                        }
                    }@catch(NSException *ex){
                        [NGUIUtility showAlertWithTitle:@"Error" withMessage:@[@"Some error occurred at server"] withButtonsTitle:@"Ok" withDelegate:nil];
                    }
                }
                else {
                    
                    [NGDecisionUtility checkForSessionExpire:responseData.responseCode];
                }
            }
        });
    }];
    [self closeTapped];
}


-(void) closeTapped {
    
    
        [UIView animateWithDuration:animationDurations delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^
         {
             [webApplyView.view setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
             
         }completion:^(BOOL finished) {
             
             [webApplyView.view removeFromSuperview];
             webApplyView = nil;

         }];
    
    
     [self enableFooter:TRUE];
 }

-(void) emailJobTappedWithEmail:(NSString *)emailId{
    

    emailId = [emailId trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([NGDecisionUtility  isValidEmail:emailId])
        
    {
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EMAIL_WEB_JOB withEventLabel:K_GA_EVENT_EMAIL_WEB_JOB withEventValue:nil];
        
        if (![[NGHelper sharedInstance] isUserLoggedIn]) {
            [NGSavedData saveEmailID:emailId];
            
        }
     
        [self sendEmail:emailId];
        
    }else{
   
        NSString *errorMessage ;
    
        if (!emailId.length) {
            
            errorMessage = @"Please enter a Email Id";
        }else{
            
            errorMessage = @"Please enter a valid Email Id";
        }
    
        [NGUIUtility showAlertWithTitle:@"Invalid Details!" withMessage:[NSArray arrayWithObject:errorMessage] withButtonsTitle:@"Ok" withDelegate:nil];
        
    }
}
-(NSString*)getPosition{
    return ((nil!=JobDesc.designation)?JobDesc.designation:@"");
}
-(NSString*)getJobId{
    return ((nil!=JobDesc.jobId)?JobDesc.jobId:@"");
}

-(void)logUserActionForWebJobApply{
    //NOTE:instead of using self.jobObj[srp object] we are using
    //detailed job object, becz in case of deeplinking, we are directly landing to jd page
    //hence not getting sprJD object, So this fix is to prevent crash on email this job
    //Permanent fix will be done in 3.2 version as per team discussion
    NSString *jobIdVal = [self getJobId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:jobIdVal,@"jobId",nil];
    [params setCustomObject:self.xzMIS forKey:@"xz"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_LOG_USER_ACTION];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData) {}];

}
-(void) applyWebJobTapped {
 
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_VIEW_ORINAL_WEB_JOB withEventLabel:K_GA_EVENT_VIEW_ORINAL_WEB_JOB withEventValue:nil];
    
    [self closeTapped];
    
    NGWebViewController *webView = (NGWebViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"webView"];
    
    webView.isCloseBtnHidden = NO;
    
    if(self.isJobRedirection)
    [webView setNavigationTitle:@"Apply to Job" withUrl:JobDesc.jobRedirectionUrl];
    else
    [webView setNavigationTitle:@"Apply to Job" withUrl:JobDesc.contactWebsite];
    
    IENavigationController *cntrllr = APPDELEGATE.container.centerViewController;
    
    [cntrllr pushActionViewController:webView Animated:YES];

    
}

-(void)dealloc{
    [[NGDeepLinkingHelper sharedInstance] setDeeplinkingPage:NGDeeplinkingPageNone];
}

@end
