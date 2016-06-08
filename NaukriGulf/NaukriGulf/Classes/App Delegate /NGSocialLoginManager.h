//
//  NGSocialLoginManager.h
//  NaukriGulf
//
//  Created by Himanshu on 3/15/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@protocol NGSocialLoginManagerDelegate <NSObject>

-(void)getResmanModelWithGPlusLogin:(NGResmanDataModel*)resModel;
-(void)getResmanModelWithFacebookLogin:(NGResmanDataModel*)resmanModel;
-(void)errorInFacebookLogin;
-(void)errorInGplusLogin;

@end
@interface NGSocialLoginManager : NSObject

@property (nonatomic, strong) NSSet *grantedFBPermissions;

@property (nonatomic, strong) NSSet *declinedFBPermissions;

+(NGSocialLoginManager *)sharedInstance;
-(void) gPlusButtonPressed;
-(void) facebookButtonPressed;

@property (nonatomic, weak) id<NGSocialLoginManagerDelegate> delegate;
@property (nonatomic, strong) NGResmanDataModel *resmanModel;

@end
