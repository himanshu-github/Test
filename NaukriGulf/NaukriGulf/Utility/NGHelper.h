//
//  NGHelper.h
//  NaukriGulf
//
//  Created by Arun Kumar on 05/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NGUserDetails;


@interface NGHelper : NSObject


@property(nonatomic)CGSize screenSize;
@property(nonatomic) NSInteger appState;
@property (nonatomic, strong) NGUserDetails *usrObj;
@property (nonatomic, strong) NSMutableDictionary *appConfigDict;
@property (nonatomic, strong) NSArray *appStateConfigArr;
@property (nonatomic) BOOL isUserLoggedIn;
@property (nonatomic) BOOL isNetworkAvailable;
@property(nonatomic,strong) UIStoryboard *jobSearchstoryboard;
@property(nonatomic,strong) UIStoryboard *genericStoryboard;
@property(nonatomic,strong) UIStoryboard *jobsForYouStoryboard;
@property(nonatomic,strong) UIStoryboard *othersStoryboard;
@property(nonatomic,strong) UIStoryboard *editFlowStoryboard;
@property(nonatomic,strong) UIStoryboard *mNJStoryboard;
@property(nonatomic,strong) UIStoryboard *profileStoryboard;
@property(nonatomic, strong) NSMutableArray* valueSelectionLayerArray;
@property (nonatomic,readwrite) BOOL isAlertShowing;
@property(nonatomic,readwrite) BOOL isResmanViaApply;
@property(nonatomic,readwrite) BOOL isResmanViaUnregApply;
@property(nonatomic,readwrite) BOOL isResmanViaMailer;


@property(nonatomic,retain) NSString *resumeFormat;
@property(nonatomic,assign) BOOL serverSettingsRunning;

+(NGHelper *)sharedInstance;
-(void) serverSettingsISRunning;
@end
