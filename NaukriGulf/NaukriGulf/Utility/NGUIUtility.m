//
//  NGUIUtility.m
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGUIUtility.h"
#import "NGDocumentFetcher.h"
#import "NGQLDocumentPreviewViewController.h"
#import "NGApplyConfirmationViewController.h"
#import "NGViewController.h"


@implementation NGUIUtility
#define GENERIC_ALERT_VIEW 100
#define SESSION_EXPIRED_ALERT_VIEW 101
static NGErrorViewController *customErrorView;

+(void)removeAllViewControllerInstanceFromVCStackOfTypeName:(NSString*)vcNameToBeRemoved{
    IENavigationController *navController = (IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController;
    NSMutableArray *newVCArray = [[NSMutableArray alloc]initWithArray:navController.viewControllers];
    NSMutableIndexSet *indexSetToDelete = [[NSMutableIndexSet alloc] init];
    NSString *tmpVCName = @"";
    
    for (NSInteger i=0;i<newVCArray.count;i++) {
        tmpVCName = NSStringFromClass([(UIViewController*)[newVCArray fetchObjectAtIndex:i] class]);
        if ([tmpVCName isEqualToString:vcNameToBeRemoved]) {
            [indexSetToDelete addIndex:i];
        }
    }
    
    if (0 < indexSetToDelete.count) {
        [newVCArray removeObjectsAtIndexes:indexSetToDelete];
        [navController setViewControllers:newVCArray];
    }
}
+(void)removeViewControllerFromVCStackOfTypeName:(NSString*)vcNameToBeRemoved{
    IENavigationController *navController = (IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController;
    NSMutableArray *newVCArray = [[NSMutableArray alloc]initWithArray:navController.viewControllers];
    id topVC = navController.viewControllers.lastObject;
    if (topVC) {
        NSString *topVCName = NSStringFromClass([topVC class]);
        if ([vcNameToBeRemoved isEqualToString:topVCName]) {
            [newVCArray removeLastObject];
            
            [navController setViewControllers:newVCArray];
        }
    }
}

+(NSString*)renameFileInInboxDocDir : (NSString*) filePath {
    
    NSString *fileExtension = [[filePath componentsSeparatedByString:@"."] fetchObjectAtIndex:1];
    NSString *newFilename = [NSString stringWithFormat:@"Resume.%@",fileExtension];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    
    NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Inbox/%@",filePath]];
    NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:newFilename];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePathSrc]) {
        NSError *error = nil;
        [manager moveItemAtPath:filePathSrc toPath:filePathDst error:&error];
        if (error) {
            //over-write error handled
            if (516 == error.code) {
                //delete already exisiting file at destination
                [manager removeItemAtPath:filePathDst error:&error];
                
                //now move files
                [manager moveItemAtPath:filePathSrc toPath:filePathDst error:&error];
            }
        }
    } else {
    }
    
    [NGDocumentFetcher sharedInstance].fileExtensions = fileExtension;
    
    return newFilename;
}


+(void)previewDocumentOnWindowWithPath:(NSString *)filePath {
    
    NSString *newFileName = [NGUIUtility renameFileInInboxDocDir:filePath];
    
    [NGDirectoryUtility clearInboxDir];
    
    NGAppDelegate* delegate = [NGAppDelegate appDelegate];
    
    if([((IENavigationController*)delegate.container.centerViewController).topViewController isKindOfClass:[NGQLDocumentPreviewViewController class]]){
        
        [((IENavigationController*)delegate.container.centerViewController) popViewControllerAnimated:NO];
    }
    
    NGQLDocumentPreviewViewController *dPCntlr = [[NGQLDocumentPreviewViewController alloc] init];
    
    dPCntlr.arrayOfDocuments = [NSMutableArray arrayWithObjects:newFileName, nil];
    dPCntlr.showDownloadedFile = NO;
    
    dPCntlr.longPressMode = TRUE;
    
    BOOL isLoggedInUser =[NGHelper sharedInstance].isUserLoggedIn;
    if(NO == isLoggedInUser)
        {
            dPCntlr.showDownloadedFile = YES;
        }
    
    [((IENavigationController*)delegate.container.centerViewController) pushActionViewController:dPCntlr Animated:YES];
}

+(void)previewDocumentWithPath:(NSString *)filePath inController:(IENavigationController *)nvc{
    
//    NGQLDocumentPreviewViewController *dPCntlr = [[NGQLDocumentPreviewViewController alloc] init];

    UIStoryboard * storyBoard =[UIStoryboard storyboardWithName:@"OthersStoryboard" bundle:nil];
    NGQLDocumentPreviewViewController *dPCntlr = [storyBoard instantiateViewControllerWithIdentifier:@"NGQLDocumentPreviewViewController"];

    dPCntlr.arrayOfDocuments = [NSMutableArray arrayWithObjects:filePath, nil];
    
    dPCntlr.showDownloadedFile = YES;
    
    [nvc pushActionViewController:dPCntlr Animated:YES];
    
//    UIStoryboard * storyBoard =[UIStoryboard storyboardWithName:@"OthersStoryboard" bundle:nil];
//    NGQLDocumentPreviewViewController *dPCntlr = [storyBoard instantiateViewControllerWithIdentifier:@"NGQLDocumentPreviewViewController"];
//    dPCntlr.arrayOfDocuments = [NSMutableArray arrayWithObjects:filePath, nil];
//    dPCntlr.showDownloadedFile = NO;
//    [(IENavigationController*)self.navigationController pushActionViewController:dPCntlr Animated:YES];
    
}

+(void)loadOpenWithTypeDocument
{
    NSString *longPressedFileName = [NGDirectoryUtility validatePathOfOpenWithTypeDocument];
    if (nil != longPressedFileName) {
        [NGUIUtility previewDocumentOnWindowWithPath:longPressedFileName];
    }
}

+ (void)showAlertWithTitle:(NSString*)title withMessage:(NSArray*)messageArray withButtonsTitle:(NSString *)btnTitles withDelegate:(id)delegate {
    
    if([APPDELEGATE.window viewWithTag:1234]){
        
        return;
    }
    customErrorView = [[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"ErrorView"];
    customErrorView.view.tag = 1234;
    [APPDELEGATE.window addSubview:customErrorView.view];
    [customErrorView showErrorScreenWithTitle:title withMessage:messageArray withButtonsTitle:btnTitles withDelegate:delegate];
    
}


+(void)showDeleteAlertWithMessage:(NSString *)message withDelegate:(id)delegate{
    
    message = [message trimCharctersInSet :
               [NSCharacterSet whitespaceCharacterSet]];
    if([message length]){
        
        [[self class] showDeleteScreenWithTitle:nil withMessage:[NSArray arrayWithObjects:message, nil] withButtonsTitle:@"Delete,Cancel" withDelegate:delegate];
    }
}


+ (void)showDeleteScreenWithTitle:(NSString *)title withMessage:(NSArray *)message withButtonsTitle:(NSString *)btnTitles withDelegate:(id)delegate{
    
    customErrorView = [[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"ErrorView"];
    [APPDELEGATE.window addSubview:customErrorView.view];
    [customErrorView showDeleteScreenWithTitle:title withMessage:message withButtonsTitle:btnTitles withDelegate:delegate];
    
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)delegate
{
    
    if (!delegate) {
        delegate = self;
    }
    if (![NGHelper sharedInstance].isAlertShowing) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg  delegate: delegate cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert.tag = GENERIC_ALERT_VIEW;
        [NGHelper sharedInstance].isAlertShowing = TRUE;
        [alert show];
        
    }
    
}

+(void)displayHomePage{
    NGAppDelegate *delegate = [NGAppDelegate appDelegate];
    
    delegate.container.leftMenuViewController.view.alpha=0;
    delegate.container.leftMenuViewController.view.hidden = YES;
    delegate.container.leftMenuViewController = nil;
    
    delegate.container.rightMenuViewController.view.alpha=0;
    delegate.container.rightMenuViewController.view.hidden = YES;
    delegate.container.rightMenuViewController = nil;
    
    
    
    [[NGAnimator sharedInstance]popToRootViewControllerWithFlipAnimationwithNavigationController:(UINavigationController *)delegate.container.centerViewController];
}

+(void)makeUserLoggedOutOnSessionExpired:(BOOL)isSessionExpired{
    
    [NGSavedData setProfileStatusForCheck:@"true"];
    
    [NGSavedData clearAllCookies];
    
    NGStaticContentManager* staticContentMngr = [DataManagerFactory getStaticContentManager];
    [staticContentMngr deleteAllRecommendedJobs];
    [staticContentMngr deleteAllProfileViews];
    [staticContentMngr deleteMNJUserProfile];
    [staticContentMngr deleteAllJD];
    
    [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME];
    [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];

    [NGSavedData deleteViewedDateForProfile];
    
    [[NGLocalNotificationHelper sharedInstance] cancelLocalNotificationsForLoggedInUser];
    
    [[NGNotificationWebHandler sharedInstance] deletePushNotificationCount];
    
    [NGUIUtility modifyBadgeOnIcon:[self getAllNotificationsCount]];
    
    [NGHelper sharedInstance].isUserLoggedIn = FALSE;
    [NGSpotlightSearchHelper sharedInstance].isComingFromSpotlightSearch = NO;

    
    if (isSessionExpired) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops !!!" message:@"Your session has expired"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert.tag = SESSION_EXPIRED_ALERT_VIEW;
        [alert show];
        
    }else{
        [NGUIUtility displayHomePage];
    }
}
+ (void) modifyBadgeOnIcon: (NSInteger) badgeNumber {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: badgeNumber];
}

+ (NSInteger)getAllNotificationsCount{
    NSInteger count = 0;
    
    NSDictionary *dict = [NGSavedData getBadgeInfo];
    
    //Problem was that not loggedin user is getting notifications, as server is using device token to
    //map that user for Job alert or other notifications.
    if (![NGHelper sharedInstance].isUserLoggedIn) {
        NSInteger badgeNum = [[dict objectForKey:KEY_BADGE_TYPE_PROD]integerValue];
        return badgeNum>0?1:0;
    }
    
    for (NSString *badgeType in dict.allKeys) {
        NSInteger badgeNum = [[dict objectForKey:badgeType]integerValue];
        
        if (badgeNum>0) {
            count++;
        }
    }
    
    return count;
}


+ (void)ratingPopUp{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:K_KEY_ALLOW_RATING];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [NGGoogleAnalytics sendScreenReport:K_GA_EVENT_RATING_LAYER];
    
    float borderWidth = 0.3;
    UIColor* borderColor = [UIColor lightGrayColor];
    int alertOriginX = 9;
    int alertOriginY = 90;
    int alertViewHeight = 398;
    int buttonHeight = 68;
    
    if (IS_IPHONE4){
        
        alertOriginY = 50;
        alertViewHeight += 32;
        buttonHeight = 60;
        
    }else if(IS_IPHONE6){
        
        alertOriginX = 42;
        alertOriginY = 150;
        alertViewHeight += 32;
        buttonHeight = 60;
        
    }else if (IS_IPHONE6_PLUS){
        
        alertOriginY = 190;
        alertViewHeight += 32;
        buttonHeight = 60;
        alertOriginX = 55;
        
    }
    
    float fontSize = 15.0;
    
    UIView* viewBG = [[UIView alloc] init];
    [viewBG setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    [viewBG setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
    [viewBG setTag:9999];
    
    UIView* alertBg = [[UIView alloc] init];
    [alertBg setFrame:CGRectMake(alertOriginX, alertOriginY, 300, alertViewHeight)];
    [alertBg setBackgroundColor:[UIColor whiteColor]];
    
    
    UIImageView* imagePhone = [[UIImageView alloc] init];
    [imagePhone setImage:[UIImage imageNamed:@"rateus"]];
    [imagePhone setFrame:CGRectMake(130, 25, 45, 45)];
    [imagePhone setBackgroundColor:[UIColor clearColor]];
    [alertBg addSubview:imagePhone];
    
    CGRect rectBg = alertBg.frame;
    
    UILabel* lblTitle = [[UILabel alloc] init];
    [lblTitle setFrame:CGRectMake(0, imagePhone.frame.origin.y+imagePhone.frame.size.height+10,
                                  alertBg.frame.size.width, 65)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    
    [lblTitle setText:@"If you have enjoyed using this \n App, please spend few seconds \n to give us a Thumbs Up"];
    [lblTitle setNumberOfLines:0];
    [lblTitle getAttributedHeightOfText:lblTitle.text havingLineSpace:K_TEXT_LINE_SPACING];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:14]];
    [alertBg addSubview:lblTitle];
    
    
    NGButton* btnLove = [NGButton buttonWithType:UIButtonTypeCustom];
    [btnLove setBackgroundColor:[UIColor clearColor]];
    [btnLove setFrame:CGRectMake(0, lblTitle.frame.origin.y+lblTitle.frame.size.height + 32,
                                 rectBg.size.width, buttonHeight)];
    [btnLove setTitle:@"I Love it!" forState:UIControlStateNormal];
    [btnLove addTarget:self action:@selector(onLoveClick) forControlEvents:
     UIControlEventTouchUpInside];
    [btnLove.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_REGULAR size:fontSize]];
    [btnLove.layer setBorderColor:borderColor.CGColor];
    [btnLove.layer setBorderWidth:borderWidth];
    [btnLove setTitleColor:Clr_Blue_SearchJob forState:UIControlStateNormal];
    [alertBg addSubview:btnLove];
    
    UIButton* btnImprove = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnImprove setBackgroundColor:[UIColor clearColor]];
    [btnImprove setFrame:CGRectMake(0, btnLove.frame.origin.y +
                                    btnLove.frame.size.height-1,rectBg.size.width, buttonHeight)];
    [btnImprove setTitle:@"Need Some Improvements" forState:UIControlStateNormal];
    [btnImprove addTarget:self action:@selector(onImproveClick) forControlEvents:
     UIControlEventTouchUpInside];
    [btnImprove.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:fontSize+1]];
    [btnImprove.layer setBorderColor:borderColor.CGColor];
    [btnImprove.layer setBorderWidth:0];
    [btnImprove setTitleColor:Clr_Blue_SearchJob forState:UIControlStateNormal];
    [alertBg addSubview:btnImprove];
    
    UIButton* btnLater = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLater setBackgroundColor:[UIColor clearColor]];
    [btnLater setFrame:CGRectMake(0, btnImprove.frame.origin.y + btnImprove.frame.size.height-1,
                                  rectBg.size.width, buttonHeight)];
    [btnLater.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnLater.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:fontSize]];
    [btnLater setTitle:@"Remind me Later" forState:UIControlStateNormal];
    [btnLater addTarget:self action:@selector(onRemindLater)
       forControlEvents:UIControlEventTouchUpInside];
    [btnLater.layer setBorderColor:borderColor.CGColor];
    [btnLater.layer setBorderWidth:borderWidth];
    [btnLater setTitleColor:Clr_Blue_SearchJob forState:UIControlStateNormal];
    [alertBg addSubview:btnLater];
    
    
    CGRect frame = alertBg.frame;
    frame.size.height =  btnImprove.frame.origin.y + btnImprove.frame.size.height-1+buttonHeight;
    [alertBg setFrame:frame];
    
    
    [viewBG addSubview:alertBg];
    [[APPDELEGATE window] addSubview:viewBG];
    imagePhone = nil;
    lblTitle = nil;
    alertBg = nil;
    viewBG = nil;
    
}
+ (void)removeRateUsScreen{
    
    NSArray *subViewArray = [[APPDELEGATE window] subviews];
    for (UIView* viewBg in subViewArray)
    {
        if (viewBg.tag == 9999)
            [viewBg removeFromSuperview];
        
    }
}

+ (void)showRateUsView {
    
    if (![NGSavedData allowRateUs])
        return;
    else
        [NGUIUtility ratingPopUp];
}


+ (void)openbrowser_in_background:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

+ (void)onImproveClick{
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY
                                  withEventAction:K_GA_EVENT_RATING_PROBLEM
                                   withEventLabel:K_GA_EVENT_RATING_PROBLEM
                                   withEventValue:nil];
    [NGUIUtility removeRateUsScreen];
    
    NGAppDelegate* delegate=[NGAppDelegate appDelegate];
    
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_FEEDBACK usingNavigationController:delegate.container.centerViewController animated:NO];
    
    
    
}

+ (void)onRemindLater{
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY
                                  withEventAction:K_GA_EVENT_RATING_REMIND_LATER
                                   withEventLabel:K_GA_EVENT_RATING_REMIND_LATER
                                   withEventValue:nil];
    [NGUIUtility removeRateUsScreen];
    [NGSavedData saveRemindMeLaterDate];
    
}
+(void)onLoveClick{
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY
                                  withEventAction:K_GA_EVENT_RATING_LOVE
                                   withEventLabel:K_GA_EVENT_RATING_LOVE
                                   withEventValue:nil];
    [self removeRateUsScreen];
    
    NSString* str = @"";
    
    str = [appReviewURLIOS7 stringByReplacingOccurrencesOfString:@"APP_ID"
                                                      withString:[NSString stringWithFormat:@"%@",appID]];
    [NSThread detachNewThreadSelector:@selector(openbrowser_in_background:) toTarget:self withObject:str];
    return;
    
}

+(void)showShortlistedAnimationinView:(UIView *)view AtPosition:(CGPoint)p
{
    float xOriginFactor = 210;
    
    if(IS_IPHONE4||IS_IPHONE5)
        xOriginFactor = 210;
    else if (IS_IPHONE6)
        xOriginFactor = 210+55;
    else if (IS_IPHONE6_PLUS)
        xOriginFactor = 210+55+39;
    
    NSMutableDictionary* dictionaryForLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                           [NSValue valueWithCGRect:CGRectMake(p.x+xOriginFactor, p.y+43, 85, 35)],KEY_FRAME,
                                           [NSNumber numberWithInt:200],KEY_TAG,
                                           nil];
    NGLabel *lbl = (NGLabel*)[NGViewBuilder createView:dictionaryForLbl];
    lbl.layer.cornerRadius = 5.0;
    lbl.layer.masksToBounds = YES;
    
    NSMutableDictionary* dictionaryForLblStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor blackColor],KEY_BACKGROUND_COLOR,
                                                [NSNumber numberWithInt:1],KEY_LABEL_NO_OF_LINES,
                                                [NSNumber numberWithInteger:NSTextAlignmentCenter],kEY_LABEL_ALIGNMNET,
                                                @"Shortlisted",KEY_LABEL_TEXT,                                                                                                [UIColor whiteColor],KEY_TEXT_COLOR,
                                                FONT_STYLE_HELVITCA_NEUE_LIGHT,KEY_FONT_FAMILY,FONT_SIZE_15,KEY_FONT_SIZE,nil];
    
    [lbl setLabelStyle:dictionaryForLblStyle];
    [view addSubview:lbl];
    
    
    
    [UIView animateWithDuration:0.8f delay:0.3f options:UIViewAnimationOptionAllowUserInteraction  animations:^
     {
         lbl.frame = CGRectMake(lbl.frame.origin.x, 0, lbl.frame.size.width, lbl.frame.size.height);
         lbl.alpha = 0.0f;
         
     } completion:^(BOOL finished)
     {
         
         [lbl removeFromSuperview];
     }];
}

+ (void)slideView:(UIView *)view toXPos:(float)xpos toYPos:(float)ypos duration:(float)d delay:(float)delay{
    [UIView animateWithDuration:d delay:delay options:UIViewAnimationOptionAllowUserInteraction  animations:^
     {
         view.frame = CGRectMake(xpos, ypos, view.frame.size.width, view.frame.size.height);
         
     } completion:^(BOOL finished)
     {
         
     }];
}

+ (void)showShareActionSheetWithText:(NSString *)text url:(NSString *)urlStr image:(UIImage *)image inViewController:(UIViewController *)cntrllr{
    
    
    NSURL *postURL = [NSURL URLWithString:urlStr];
    
    NSMutableArray *activityItems = [[NSMutableArray array ] init];
    
    
    if (![text isEqualToString:@""]) {
        [activityItems addObject:text];
    }
    
    if (image) {
        [activityItems addObject:image];
    }
    
    if (![urlStr isEqualToString:@""]) {
        [activityItems addObject:postURL];
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [cntrllr presentViewController:activityViewController animated:YES completion:nil];
}

+ (void)removeAllViewControllersTillJobTupleSourceView{
    UINavigationController *navController = APPDELEGATE.container.centerViewController;
    
    
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:[navController viewControllers]];
    
    NSArray *viewControllersInList = [vcArr copy];
    
    NSInteger jdIndex = -1;
    
    for (id vc in viewControllersInList)
    {
        jdIndex++;
        
        if ([vc isKindOfClass:[NGApplyConfirmationViewController class]])
            break;
        
        if ([vc isKindOfClass:[NGJDParentViewController class]])
            break;
    }
    
    for (NSInteger i = viewControllersInList.count-2; i>=jdIndex; i--) {
        id vc = [viewControllersInList objectAtIndex:i];
        [vcArr removeObject:vc];
    }
    
    [navController setViewControllers:vcArr];
}

+ (void)removeAllViewControllersTillSplashScreen{

    UINavigationController *navController = APPDELEGATE.container.centerViewController;
    
    
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:[navController viewControllers]];
    
    [vcArr removeAllObjects];
    
 
    NGViewController *viewController = [[NGHelper sharedInstance].jobSearchstoryboard
                                        instantiateViewControllerWithIdentifier:@"Splash"];
    
    [vcArr addObject:viewController];
    [navController setViewControllers:vcArr];
    
}
+(CGFloat)getAppVersionInFloat:(NSString *)appVersion
{
    CGFloat versionNumber;
    NSArray *versionItems = [appVersion componentsSeparatedByString:@"."];
    
    if (versionItems.count >= 3){
        NSInteger major = [[versionItems objectAtIndex:0] integerValue];
        NSInteger minor = [[versionItems objectAtIndex:1] integerValue];
        NSInteger bug = [[versionItems objectAtIndex:2] integerValue];
        
        versionNumber = [[NSString stringWithFormat:@"%ld.%ld%ld",(long)major,(long)minor,(long)bug] floatValue];
    }
    else{
        versionNumber = [appVersion floatValue];
    }
    
    return versionNumber;
}

#pragma mark UIAlertView Delegate

+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case GENERIC_ALERT_VIEW:
            [NGHelper sharedInstance].isAlertShowing = false;
            break;
        case SESSION_EXPIRED_ALERT_VIEW: [NGUIUtility displayHomePage];
            [NGHelper sharedInstance].isAlertShowing = false;
            break;
        default:
            break;
    }
    
}
#pragma mark- Download image url
+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

@end
