//
//  NGJDViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 05/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "NGJDFooterView.h"
#import "TTTAttributedLabel.h"

@protocol simJobDelegate  <NSObject>

@optional
-(void)changeTitleTo:(NSString*)title;
@end



/**
 *  The class configures and displays data in different sections of Job descrption page.
    Conforms the UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate,WebDataManagerDelegate,TTTAttributedLabelDelegate.

 */
@interface NGJDViewController : NGBaseViewController <UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate,TTTAttributedLabelDelegate>

/**
 *  Represent the JobID.
 */
@property (nonatomic,strong)NSString *jobID;

@property (nonatomic,strong) NGJDJobDetails *jobObj;

/**
 *  The Footer view.
 */
@property (strong, nonatomic) NGJDFooterView *applyView;
@property(nonatomic,weak) id <simJobDelegate> simJobDelegate;

@property (nonatomic, strong) id viewCtrller;
@property (nonatomic,strong)NGJobDetails *srpJobObj;
@property(nonatomic,strong) NSMutableArray* simJobs;

/**
 *  Specifies location(page/form) from where job descrption page is opened,
 this is being used in MIS.
 */
@property (nonatomic) NSInteger openJDLocation;

/**
 *  MIS service parameter
 */
@property (nonatomic, strong)NSString *srchIDMIS;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,assign) NSInteger selectedIndex;

@property (weak, nonatomic) IBOutlet UITableView *jdTableView;

@end
