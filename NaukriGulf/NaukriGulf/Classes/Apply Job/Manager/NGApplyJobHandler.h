//
//  NGApplyJobHandler.h
//  NaukriGulf
//
//  Created by Rahul on 19/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGJobsHandlerObject.h"
#import "NGCQHandler.h"

@class NGAppStateHandler;

@interface NGApplyJobHandler : NSObject<AppStateHandlerDelegate>

+ (NGApplyJobHandler *)sharedManager;

- (void) jobHandlerWithJobDescriptionPageApply:(NGJobsHandlerObject *)loginObj ;

- (void) jobHandlerWithNewUserApply:(NGJobsHandlerObject *)loginObj;

- (void) jobHandlerWithExperiencedUserApply:(NGJobsHandlerObject *)loginObj;

- (void) jobHandlerAppliedForFinalStep:(NGJobsHandlerObject *)loginObj;
@property(nonatomic,retain) NGJobsHandlerObject *loginObjForThisClass;
@end

