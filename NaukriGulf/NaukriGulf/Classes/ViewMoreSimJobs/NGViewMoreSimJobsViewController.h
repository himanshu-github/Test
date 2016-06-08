//
//  NGViewMoreSimJobsViewController.h
//  NaukriGulf
//
//  Created by Himanshu on 9/30/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGJobTupleCustomCell.h"

@interface NGViewMoreSimJobsViewController  : NGBaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

/**
 *  Contains all the job items
 */
@property (strong, nonatomic) NSMutableArray *allJobsArr;

/**
 *  Number of jobs alredy downloaded
 */

@property (nonatomic) NSInteger jobDownloadOffset;

/**
 *  Total number of Jobs
 */
@property (nonatomic) NSInteger totalJobsCount;

/**
 *  Dictionary with information of search parameters/fields selected on the search form
 */
@property (strong, nonatomic) NSMutableDictionary *paramsDict;
/**
 *  Start time of Page load
 */
@property (strong,nonatomic) NSDate *startTime;
/**
 *  Paramter required in MIS service logging
 */
@property (nonatomic, strong)NSString *srchIDMIS;

@end