//
//  NGUIUtility.h
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGUIUtility : NSObject <UIAlertViewDelegate>

+(void)removeAllViewControllerInstanceFromVCStackOfTypeName:(NSString*)vcNameToBeRemoved;
+(void)removeViewControllerFromVCStackOfTypeName:(NSString*)vcNameToBeRemoved;
+(void)previewDocumentOnWindowWithPath:(NSString *)filePath;
+(void)previewDocumentWithPath:(NSString *)filePath inController:(UINavigationController *)nvc;
+(void)loadOpenWithTypeDocument;
+(void)showDeleteAlertWithMessage:(NSString *)message withDelegate:(id)delegate;
+ (void)showAlertWithTitle:(NSString*)title withMessage:(NSArray*)messageArray withButtonsTitle:(NSString *)btnTitles withDelegate:(id)delegate;
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)delegate;
+(void)displayHomePage;
+(void)makeUserLoggedOutOnSessionExpired:(BOOL)isSessionExpired;
+(void) modifyBadgeOnIcon: (NSInteger) badgeNumber;
+(NSInteger)getAllNotificationsCount;
+ (void)ratingPopUp;
+ (void)showRateUsView;
+(void)showShortlistedAnimationinView:(UIView *)view AtPosition:(CGPoint)p;
+(void)slideView:(UIView *)view toXPos:(float)xpos toYPos:(float)ypos duration:(float)d delay:(float)delay;
+(void)showShareActionSheetWithText:(NSString *)text url:(NSString *)urlStr image:(UIImage *)image inViewController:(UIViewController *)cntrllr;
+(void)removeAllViewControllersTillJobTupleSourceView;
+(void)removeAllViewControllersTillSplashScreen;
+(CGFloat)getAppVersionInFloat:(NSString *)appVersion;

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end
