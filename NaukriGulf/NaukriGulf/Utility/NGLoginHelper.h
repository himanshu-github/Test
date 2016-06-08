//
//  NGLoginHelper.h
//  NaukriGulf
//
//  Created by Swati Kaushik on 09/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NGMNJProfileModalClass;

@protocol LoginHelperDelegate
@optional
-(void)doneFetchingProfile:(NGMNJProfileModalClass*)profileModal;
@end
@interface NGLoginHelper : NSObject
+(NGLoginHelper *)sharedInstance;
+ (void)sendAppleWatchUserDetails;
-(void)showMNJHome;
@property (nonatomic,strong) NSString* conMnj;
@property (nonatomic,assign) id <LoginHelperDelegate> delegate;
@end
