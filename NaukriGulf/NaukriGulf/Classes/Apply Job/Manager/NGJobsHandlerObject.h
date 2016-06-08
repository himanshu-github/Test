//
//  NGJobsHandlerObject.h
//  NaukriGulf
//
//  Created by Rahul on 19/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGApplyFieldsModel.h"
#import "NGJobDetails.h"

@interface NGJobsHandlerObject : NSObject

@property (nonatomic,weak) id Controller;
@property (nonatomic,assign) int openJDLocation;
@property (nonatomic,strong) NGJobDetails *jobObj;
@property (nonatomic,strong) NSDate *viewLoadingStartTime;

// For Showing Registered / Un Registered Users
@property (nonatomic,assign) LoginApplyHandlerState applyState;

// For Displaying Experience / Non Experienced

@property (nonatomic,strong) NSString *expCount;
@property (nonatomic) BOOL isEmailRegistered;
@property (nonatomic,assign) NSString *applyModelEmail;

@property (nonatomic,strong) NGApplyFieldsModel *unregApplyModal;

@property (nonatomic,strong) NSMutableDictionary *dictForUnRegApply; // Carry the information added during Registration Time for NewUser
@property (nonatomic,strong) NSMutableDictionary *unRegSaveInfoDict; // New User Info added in Dict for Moving To Next Page

// Custom Questions Answer
@property (nonatomic, strong) NSMutableArray *cqData;



/**
 *  CQ page is cancelled by the user.
 */
@property (nonatomic) BOOL isCQCancelled;

@end
