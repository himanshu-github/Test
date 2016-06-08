//
//  NGCustomQuestionViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 07/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGCQSingleSelectionAnswerCell.h"
#import "NGCQMultipleChoiceAnswerCell.h"

typedef enum
{
    MS,YN,MM,TA
    
} qType;


@interface NGCustomQuestionViewController : NGBaseViewController<UIGestureRecognizerDelegate,checkMarkOptionDelegate,multipleCheckMarkOptionDelegate,UIScrollViewDelegate>
@property (strong,nonatomic) NGJobDetails *jobObj;

@property (nonatomic,strong) NSArray* cqArray;
@property (assign) LoginApplyHandlerState applyHandlerState;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int openJDLocation;
@property (nonatomic) BOOL bIsRegistredEmailId;

@property (strong,nonatomic) NSMutableArray* cqArrayWithUnRegServiceFormat;


@end
