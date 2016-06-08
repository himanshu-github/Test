//
//  NGJDParentViewController.h
//  NaukriGulf
//
//  Created by Minni Arora on 11/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGJDViewController.h"

/**
 *  This class displays the complete Job descrption.
    The  bottom/footer section (apply,already applied,email this job) is updated based on the job details.
    Conforms the footerViewDelegate & UIScrollViewDelegate.

 */

@interface NGJDParentViewController : NGBaseViewController <footerViewDelegate,simJobDelegate, UIScrollViewDelegate>

/**
 *  Array that contains all the jobs of SRP page.
 */

@property (strong, nonatomic) NSMutableArray *allJobsArr;

@property (nonatomic,strong) NGJDJobDetails *jobObj;
@property (nonatomic, strong) NGJobDetails *jobDetailObj;

/**
 *  Represent the JobID.
 */
@property (nonatomic,strong)NSString *jobID;


/**
 *  Represent the selectedIndex of Job.
 */
@property (nonatomic)NSInteger selectedIndex;

/**
 *  No of jobs downloaded.
 */
@property (nonatomic) NSInteger jobDownloadOffset;
/**
 *  Total number of jobs.
 */
@property (nonatomic) NSInteger totalJobsCount;

@property (strong, nonatomic) IBOutlet UIView *scrollViewParent;

/**
 *  Dictionary contains downloaded jobs offset.
 */

@property (strong, nonatomic) NSMutableDictionary *paramsDict;

@property (strong, nonatomic) NSMutableArray *pagesArr;

/**
 *  Specifies location(page/form) from where job descrption page is opened,
    this is being used in MIS.
 */
@property (nonatomic) int openJDLocation;
/**
 *  MIS service parameter
 */
@property (nonatomic, strong)NSString *srchIDMIS;
@property (nonatomic, strong)NSDate *viewLoadingStartTime;


- (void)initSetup;//to reset the values of JD

@end
