//
//  NGLoginHelperTest.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGLoginHelper.h"

@protocol NGLoginHelperTestDelegate <NSObject>
-(void)successfullyLoginTest;
-(void)successfullyLogoutTest;
-(void)errorInLoginTest;
-(void)errorInLogoutTest;

@optional
-(void)successfullyLoginTestWithProfileModal:(NGMNJProfileModalClass *)profileModal;
@end

@interface NGLoginHelperTest : NSObject<LoginHelperDelegate>


+(instancetype)sharedInstance;
@property(nonatomic,assign) id<NGLoginHelperTestDelegate>delegate;
- (void)makeUserLogIn;
- (void)makeUserLogOut;
-(NSString*)defaultTestUserId;
@end
