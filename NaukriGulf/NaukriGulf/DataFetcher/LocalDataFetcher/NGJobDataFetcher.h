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

@interface NGJobDataFetcher : BaseLocalDataFetcher

/**
 *  This method is used to check if a job is shortlised or not.
 *
 *  @param jobID Denoted the ID of job.
 *
 *  @return Returns TRUE if job is shortlisted.
 */
-(BOOL) isShortlistedJob: (NSString *) jobID;

/**
 *  This method is used to save job in local database.
 *
 *  @param objArr  List of jobs (NGJobDetails object) to be saved.
 *  @param jobType type of job like applied job, recommended jobs.
 *  @param flag    Denotes if the job is to be saved or deleted.
 */
-(void) saveJobTuple:(NSArray *)objArr ofType:(NSString *)jobType forStoring:(BOOL)flag;

/**
 *  This method is used to get the jobs from local database.
 *
 *  @param jobType type of job like applied job, recommended jobs.
 *
 *  @return Returns the list of jobs (NGJobDetails object).
 */
- (NSArray *) getAllJobsOfType:(NSString *)jobType;

/**
 *  This method is used to delete all the jobs from local database.
 *
 *  @param jobType type of job like applied job, recommended jobs.
 */
-(void)deleteAllJobsWithJobType:(NSString *)jobType;

/**
 *  This method is used get all the shortlisted jobs.
 *
 *  @return Returns the list of all the shortlisted jobs.
 */
- (NSArray *) getAllSavedJobs;

/**
 *  This method is used to save the recommended jobs in local database.
 *
 *  @param jobs Represents the list of all the NGJobDetails objects which is to be saved.
 */
-(void)saveRecommendedJobs:(NSArray *)jobs;

/**
 *  This method is used to get all the recommended jobs from the local database.
 *
 *  @return Returns the list of all recommended jobs from the local database.
 */
- (NSArray *) getAllRecommendedJobs;

/**
 *  This method is used to delete all the recommended jobs from the local database.
 */
-(void)deleteAllRecommendedJobs;

/**
 *  Delete list of recommended jobs.
 *
 *  @param jobs list of jobs.
 */
-(void)deleteRecommendedJobs:(NSArray *)jobs;

/**
 *  This method is used to save the applied jobs in local database.
 *
 *  @param jobs Represents the list of all the NGJobDetails objects which is to be saved.
 */
-(void)saveAppliedJobs:(NSArray *)jobs;

/**
 *  This method is used to get all the applied jobs from the local database.
 *
 *  @return Returns the list of all applied jobs from the local database.
 */
- (NSArray *) getAllAppliedJobs;

/**
 *  This method is used to delete all the applied jobs from the local database.
 */
-(void)deleteAllAppliedJobs;


/**
 *  This method is used to check if a job is posted web job that need to be redirected to the client site for applying or not.
 *
 *  @param jobID Denoted the ID of job.
 *
 *  @return Returns TRUE if job is redirected.
 */
-(BOOL) isRedirectionJob: (NSString *) jobID;


@end
