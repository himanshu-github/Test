//
//  NGSRPViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 05/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGFilterViewController.h"
#import "NGSSAView.h"
#import "NGJobTupleCustomCell.h"
#import "NGVacancyCustomCell.h"

/**
 *  The class lists the Searched results based on the search parameters on the search form.
    The class also provides option for filetering the search creteria and shortlisting of any job.
    User can save these search parameters for their job alerts.
 
 
 Conforms the UIScrollViewDelegate ,FilterDelegate,UITableViewDataSource,UITableViewDelegate & JobTupleCellDelegate
 */

@interface NGSRPViewController : NGBaseViewController<UIScrollViewDelegate, FilterDelegate,UITableViewDataSource,UITableViewDelegate,JobTupleCellDelegate>

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
 *  Total number of Vacancies
 */
@property (nonatomic) NSInteger totalVacanciesCount;

/**
 *  Top view which handles custom ToolBar
 */
@property (strong, nonatomic) UIView *topView;

/**
 *  Dictionary with information of search parameters/fields selected on the search form
 */
@property (strong, nonatomic) NSMutableDictionary *paramsDict;


/**
 *  Dictionary with list of Clusters and subclusters
 */

@property (strong,nonatomic) NSMutableDictionary *clusterDict;

/**
 *  Dictionary with list of selected clusters
 */
@property (strong,nonatomic) NSMutableDictionary *selectedClusterDict;

/**
 *  Start time of Page load
 */
@property (strong,nonatomic) NSDate *startTime;

/**
 *  View for SSA view
 */
@property (strong, nonatomic)NGSSAView *ssaView;

/**
 *  Paramter required in MIS service logging
 */
@property (nonatomic, strong)NSString *srchIDMIS;


@end
