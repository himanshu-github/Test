//
//  NGShortlistedJobsViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 26/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGShortlistedJobsViewController.h"
#import "NGJobTupleCustomCell.h"

/**
 *  NGShortlistedJobsViewController is used for displaying the shortlisted Jobs and is subclass of NGBaseViewController
 *  Conforms  removeShortListedJobDelegate
 */
@interface NGShortlistedJobsViewController : NGBaseViewController<JobTupleCellDelegate>

@property (strong, nonatomic) NSMutableArray *savedJobsArr;

@end
