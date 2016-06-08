//
//  WebDataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseLocalDataFetcher.h"

/**
 *  The class used to fetch data from the local database.
 */

@interface NGJDdataFetcher : BaseLocalDataFetcher

/**
 *  This method is used to save JD to local database.
 *
 *  @param obj The NGJDJobDetails object having information about JD.
 */
-(void) storeViewedJobToLocal : (NGJDJobDetails *)obj;

/**
 *  This method is used to delete all the JD.
 */
-(void)deleteAllJD;

/**
 *  This method is used to get JD from the local database.
 *
 *  @param jobID Denotes the ID of job.
 *
 *  @return Returns the NGJDJobDetails object having information about JD.
 */
-(NGJDJobDetails *) getJobFromLocal: (NSString *) jobID;

/**
 *  This method is used to mark job as applied.
 *
 *  @param jobID Denotes the ID of job.
 */
-(void)markJobAsAlreadyApplied:(NSString*)jobID;
-(NSInteger)isJobApplied:(NSString*)jobID;

@end
