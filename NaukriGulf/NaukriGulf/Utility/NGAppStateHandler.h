//
//  NGAppStateHandler.h
//  NaukriGulf
//
//  Created by Arun Kumar on 19/11/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol AppStateHandlerDelegate
-(void)setPropertiesOfVC:(id)vc;
@end

@class AppStateHandlerDelegate;

@interface NGAppStateHandler : NSObject

+(NGAppStateHandler *)sharedInstance;

-(UIViewController *)setAppState:(NSInteger)appState usingNavigationController:(UINavigationController *)navCntrllr animated:(BOOL)animated;
-(void)loadNativeRegistrationView;
@property(nonatomic) NSInteger appState;
@property(nonatomic,weak) id delegate;
@end
