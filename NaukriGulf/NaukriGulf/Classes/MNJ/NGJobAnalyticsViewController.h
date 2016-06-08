//
//  NGJobAnalyticsViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 21/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGJobTupleCustomCell.h"

typedef enum {
   
    SAVED_JOBS = 1,
    
    RECOMMENDED_JOBS = 2,
    
    APPLIED_JOBS = 3

} JobsForYouTab;

/**
 *  NGJobAnalyticsViewController controller list  Saved Jobs, Recommended Jobs, Applied Jobs
 *  Conforms the removeShortListedJobDelegate and UIScrollViewDelegate
 */
@interface NGJobAnalyticsViewController : NGBaseViewController<JobTupleCellDelegate,UIScrollViewDelegate>

/**
 *   Display the view according to index
 */
@property (nonatomic) NSInteger selectedTabIndex;
/**
 *  array for displaying the savedJobs available
 */
@property (strong, nonatomic) NSMutableArray *savedJobsArr;
/**
 *  array for displaying the appliedJobs
 */
@property (strong, nonatomic) NSMutableArray *appliedJobsArr;
/**
 *  Bool for apiHitCheck from iWatch/iPhone
 */
@property BOOL isAPIHitFromiWatch;

-(void)synchSavedJobHavingIndex:(NSString*)jobId forStoring:(BOOL)store;
-(void)myRecoJobs:(void (^)(NGAPIResponseModal* modal))callback;
@end
