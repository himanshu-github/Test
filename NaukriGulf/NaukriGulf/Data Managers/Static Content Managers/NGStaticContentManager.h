//
//  NGStaticContentManager.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseStaticContentManager.h"
#import "NGServerErrorDataModel.h"
#import "NGMNJProfileModalClass.h"
#import "NGResmanDataModel.h"
#import "NGJobDetails.h"
#import "NGApplyFieldsModel.h"
/**
 *  The class used for getting static data like dropdown data from file or from local database.
 */
@interface NGStaticContentManager : BaseStaticContentManager



/**
 *  This method is used to get suggested strings fetched from the file.
 *
 *  @param key Denotes the ID for which the suggested strings are to be fetched.
 *
 *  @return Returns the list of suggested strings.
 */
-(NSArray *)getSuggestedStringsFromKey:(NSString*)key;

/**
 *  This method is used to get information about whether a job is shortlised or not.
 *
 *  @param jobID ID representing a particular job.
 *
 *  @return Return TRUE if the job is shortlisted.
 */
-(BOOL) isShortlistedJob: (NSString *) jobID;

/**
 *  This method is used to shortlist or unshortlist the job.
 *
 *  @param obj  The NGJobDetails object contains the informatiob about a job like jobID.
 *  @param flag Differentiate between shortlisting or unshortlisting of a job. Set To TRUE if a job is to be shortlisted.
 */
-(void) shorlistedJobTuple: (NGJobDetails *) obj forStoring: (BOOL)flag;

/**
 *  This method is used get all the shortlisted jobs.
 *
 *  @return Returns the list of all the shortlisted jobs.
 */
- (NSArray *) getAllSavedJobs;


/**
 *  This method is used to save the JD of a job once it is viewed.
 *
 *  @param obj The NGJDJobDetails object represents the JD of a job.
 */
-(void) storeViewedJobToLocal : (NGJDJobDetails *)obj;

/**
 *  This method is used to delete all the JD saved in local database.
 */
-(void)deleteAllJD;

/**
 *  This method is used to mark job (which is saved in local database) as applied.
 *
 *  @param jobID ID of a job to be marked as applied.
 */
-(void)markJobAsAlreadyApplied:(NSString*)jobID;


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
- (NSArray *)getAllRecommendedJobs;

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
 *  This method is used to save the profile viewers in the local database.
 *
 *  @param profileViews List of all profile viewers.
 */
-(void)saveProfileViews:(NSArray *)profileViews;

/**
 *  This method is used to get all the profile viewers from the local database.
 *
 *  @return Returns the list of all profile viewers.
 */
- (NSArray *) getAllProfileViews;

/**
 *  This method is used to delete all the profile viewers from the local database.
 */
-(void)deleteAllProfileViews;
/**
 *  This method is used to save user profile to local database.
 *
 *  @param modelObj The NGMNJProfileModalClass object represents the information about user's profile.
 */
-(void)saveMNJUserProfile:(NGMNJProfileModalClass *)modelObj;

/**
 *  This method is used to get user profile from local database.
 *
 *  @return Returns the NGMNJProfileModalClass object.
 */
-(NGMNJProfileModalClass *)getMNJUserProfile;

/**
 *  This method is used to delete user profile from local database.
 */
-(void)deleteMNJUserProfile;
-(void)saveException:(NSException*)exception withTopControllerName:(NSString*)controller;
-(void)saveErrorForServer:(NGServerErrorDataModel*)errorModal;
-(NSArray*)fetchSavedExceptions;
-(NSArray*)fetchSavedErrorsForServer;
- (void)deleteExceptions;
//apply Fields
-(void)saveApplyFields:(NGApplyFieldsModel*)modalFieldObj;
-(NGApplyFieldsModel*)getApplyFields;

//Resman fields

-(void)saveResmanFields:(NGResmanDataModel*)modalFieldObj;
-(NGResmanDataModel*) getResmanFields;

-(NSArray*) getSuggestedKeySkillsWithFrequency:(NSString*) key;
-(NSArray*) getSuggestedCompanyWithFrequency:(NSString*)key;
-(NSArray*) getSuggestedDesignationWithFrequency:(NSString*)key;

+(NSArray *)getNewDropDownData:(int) ddType;
-(NSInteger)isJobApplied:(NSString*)jobID;
-(BOOL) isRedirectionJobToWebView: (NSString *) jobID;

@end
