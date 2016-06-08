//
//  WebDataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJobDataFetcher.h"
#import "SRPTuplesCoreData.h"
#import "JobDetailsCoreData.h"

@implementation NGJobDataFetcher
   

#pragma mark Saved Jobs Tuple

- (NSArray *) getAllJobsOfType:(NSString *)jobType{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    __block  NSMutableArray *savedJobsArr = nil;
    
    [temporaryContext performBlockAndWait:^{
   
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOBS];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobType == %@",jobType];
        [fetchRequest setPredicate:predicateID];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        
        NSArray *tempArray = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        
        savedJobsArr = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i<tempArray.count; i++) {
            SRPTuplesCoreData *stcdObj = (SRPTuplesCoreData*)[tempArray fetchObjectAtIndex:i];
            NGJobDetails *jdObj = [[NGJobDetails alloc]init];
            jdObj.designation = stcdObj.designation;
            jdObj.jobDescription = stcdObj.srpDescription;
            jdObj.cmpnyName = stcdObj.cmpnyName;
            jdObj.location = stcdObj.location;
            jdObj.jobID = stcdObj.jobID;
            jdObj.jdURL = stcdObj.jdURL;
            jdObj.latestPostDate = stcdObj.latestPostDate;
            jdObj.minExp = stcdObj.minExp ;
            jdObj.maxExp = stcdObj.maxExp ;
            jdObj.vacancy = [stcdObj.vacancy integerValue];
            jdObj.cmpnyID = stcdObj.cmpnyID;
            jdObj.isTopEmployer = [stcdObj.isTopEmployer integerValue];
            jdObj.isTopEmployerLite = [stcdObj.isTopEmployerLite integerValue];
            jdObj.isFeaturedEmployer = [stcdObj.isFeaturedEmployer integerValue];
            jdObj.isPremiumJob = [stcdObj.isPremiumJob integerValue];
            jdObj.isWebJob = [stcdObj.isWebJob integerValue];
            jdObj.isQuickWebJob = [stcdObj.isQuickWebJob integerValue];
            jdObj.logoURL = stcdObj.logoURL;
            jdObj.TELogoURL = stcdObj.tELogoURL;
            
            
            [savedJobsArr addObject:jdObj];
        }
    }];
    
    return savedJobsArr;
}




-(void) saveJobTuple:(NSArray *)objArr ofType:(NSString *)jobType forStoring:(BOOL)flag{
   
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOBS];
        
        if (flag) {
            NSError *error = nil;
            
            NSArray *tempArray = [self getAllJobsOfType:jobType];
            
            NSInteger storeLimit = [self getStoreLimitForJobType:jobType];
            
            
            //Count greater than store limit of jobs (configurable) then delete oldest one
            
            if (tempArray.count + objArr.count > storeLimit && tempArray.count > 0)
            {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobType == %@",jobType];
                [fetchRequest setPredicate:predicateID];
                [fetchRequest setEntity:entity];
                fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
                
                NSArray *tempArr = [temporaryContext executeFetchRequest:fetchRequest error:&error];
                
                NSInteger overLimit = tempArray.count + objArr.count - storeLimit;
                
                
                for (NSInteger i = 0; i<overLimit; i++) {
                    NSManagedObject *objTemp = [tempArr fetchObjectAtIndex:i];
                    
                    if (objTemp) {
                        
                        [temporaryContext deleteObject:objTemp];
                    }
                    
                }
                
                
            }
            
            for (NGJobDetails *obj in objArr) {
                [self saveJobToLocal:obj ofType:jobType withContext:temporaryContext];
            }
            
            if (![temporaryContext save:&error]) {
                //Error Handling
                NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
                sedm.serverExceptionErrorType =K_CORE_DATA_SAVE_EXCEPTION_ERROR;
                sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_JOBS];
                if(error.localizedDescription!=nil)
                    sedm.serverExceptionDescription = error.localizedDescription;
                else
                    sedm.serverExceptionDescription = @"NA";
                
                sedm.serverExceptionClassName = NSStringFromClass([self class]);
                sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
                sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

                [NGExceptionHandler logServerError:sedm];

                
            }else{
                
                [self saveMainContext];
            }
        }
        
        else{
            
            for (NGJobDetails *obj in objArr) {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                
                NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobID == %@ && jobType == %@",obj.jobID,jobType];
                
                [fetchRequest setPredicate:predicateID];
                [fetchRequest setEntity:entity];
                
                [fetchRequest setIncludesPropertyValues:NO];
                
                NSError *error = nil;
                
                NSArray *tempArray = [temporaryContext executeFetchRequest:fetchRequest error:&error];
                for (NSManagedObject *objTemp in tempArray) {
                    if (objTemp) {
                        [temporaryContext deleteObject:objTemp];
                    }
                    
                }
                
                if (![temporaryContext save:&error]) {
                    //Error Handling
                    NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
                    sedm.serverExceptionErrorType =K_CORE_DATA_SAVE_EXCEPTION_ERROR;
                    sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_JOBS];
                    if(error.localizedDescription!=nil)
                        sedm.serverExceptionDescription = error.localizedDescription;
                    else
                        sedm.serverExceptionDescription = @"NA";
                    
                    sedm.serverExceptionClassName = NSStringFromClass([self class]);
                    sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
                    sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

                    [NGExceptionHandler logServerError:sedm];

                }else{
                    
                    [self saveMainContext];
                }
            }
            
            
        }

        
    }];
    
    
}

-(void)deleteAllJobsWithJobType:(NSString *)jobType{
   
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
  
        NSError *error = nil;
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOBS];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobType == %@",jobType];
        [fetchRequest setPredicate:predicateID];
        [fetchRequest setEntity:entity];
        
        NSArray *tempArr = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        
        for (NSInteger i = 0; i<tempArr.count; i++) {
            NSManagedObject *objTemp = [tempArr fetchObjectAtIndex:i];
            if (objTemp) {
                
                [temporaryContext deleteObject:objTemp];
            }
            
        }
            if (![temporaryContext save:&error]) {
                
                NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
                sedm.serverExceptionErrorType =K_CORE_DATA_SAVE_EXCEPTION_ERROR;
                sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_JOBS];
                if(error.localizedDescription!=nil)
                    sedm.serverExceptionDescription = error.localizedDescription;
                else
                    sedm.serverExceptionDescription = @"NA";
                
                sedm.serverExceptionClassName = NSStringFromClass([self class]);
                sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
                sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

                [NGExceptionHandler logServerError:sedm];
                return;
            }else{
                
                [self saveMainContext];
            }
        
    }];

}


#pragma mark Shortlisted Jobs

-(BOOL) isShortlistedJob: (NSString *) jobID
{
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    __block BOOL isShortListed = FALSE;
    
    [temporaryContext performBlockAndWait:^{
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOBS];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobID == %@ && jobType = %@",jobID,JOB_TYPE_SHORTLISTED];
        [fetchRequest setPredicate:predicateID];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        
        NSArray *tempArray = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        if ([tempArray count] == 0) {
            isShortListed = NO;
        }
        else{
            isShortListed = YES;
        }
        
 }];
    
       return isShortListed;
    
}
#pragma mark- Job Redirection
-(BOOL) isRedirectionJob: (NSString *) jobID
{
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    __block BOOL isRedirected = FALSE;
    
    [temporaryContext performBlockAndWait:^{
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOB_DETAILS];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobID == %@ && isJobRedirection == %@",jobID,@"1"];
        [fetchRequest setPredicate:predicateID];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        
        NSArray *tempArray = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        if ([tempArray count] == 0) {
            isRedirected = NO;
        }
        else{
            isRedirected = YES;
        }
        
    }];
    
    return isRedirected;
    
}

- (NSArray *) getAllSavedJobs
{
    return [self getAllJobsOfType:JOB_TYPE_SHORTLISTED];
}
#pragma mark Shortlisted Jobs
-(void)saveRecommendedJobs:(NSArray *)jobs{
    
   [self saveJobTuple:jobs ofType:JOB_TYPE_RECOMMENDED forStoring:TRUE];
    
}

- (NSArray *) getAllRecommendedJobs{
   
    return [self getAllJobsOfType:JOB_TYPE_RECOMMENDED];
}

-(void)deleteAllRecommendedJobs{
    [self deleteAllJobsWithJobType:JOB_TYPE_RECOMMENDED];
}

-(void)deleteRecommendedJobs:(NSArray *)jobs{
    
    [self saveJobTuple:jobs ofType:JOB_TYPE_RECOMMENDED forStoring:FALSE];
}
#pragma mark Applied jobs
-(void)saveAppliedJobs:(NSArray *)jobs{
    
    [self saveJobTuple:jobs ofType:JOB_TYPE_APPLIED forStoring:TRUE];
    
}

- (NSArray *) getAllAppliedJobs{
    
    return [self getAllJobsOfType:JOB_TYPE_APPLIED];
    
}

-(void)deleteAllAppliedJobs{
    
    [self deleteAllJobsWithJobType:JOB_TYPE_APPLIED];
}

#pragma mark Helper Functions

-(NSInteger)getStoreLimitForJobType:(NSString *)jobType{
    if ([jobType isEqualToString:JOB_TYPE_SHORTLISTED]) {
        return MAX_SHORTLISTED_ALLOWED;
    }else if ([jobType isEqualToString:JOB_TYPE_RECOMMENDED]){
        return MAX_RECOMMENDED_ALLOWED;
    }
    
    return 25;
}


-(void) saveJobToLocal:(NGJobDetails *) obj ofType:(NSString *)jobType withContext: (NSManagedObjectContext *) context
{
    
    SRPTuplesCoreData *srpTuple = [NSEntityDescription
                                   insertNewObjectForEntityForName:ENTITY_JOBS
                                   inManagedObjectContext:context];
    
    //Core Data Save
    srpTuple.designation = obj.designation;
    srpTuple.srpDescription = obj.description;
    srpTuple.cmpnyID = obj.cmpnyID;
    srpTuple.cmpnyName = obj.cmpnyName;
    srpTuple.location = obj.location;
    srpTuple.jobID = obj.jobID;
    srpTuple.jdURL = obj.jdURL;
    srpTuple.latestPostDate = [NSString stringWithFormat:@"%@",obj.latestPostDate];
    srpTuple.minExp = obj.minExp;
    srpTuple.maxExp = obj.maxExp;
    srpTuple.vacancy = [NSNumber numberWithInteger:obj.vacancy];
    srpTuple.isTopEmployer = [NSNumber numberWithInteger:obj.isTopEmployer];
    srpTuple.isTopEmployerLite = [NSNumber numberWithInteger:obj.isTopEmployerLite];
    srpTuple.isFeaturedEmployer = [NSNumber numberWithInteger:obj.isFeaturedEmployer];
    srpTuple.isPremiumJob = [NSNumber numberWithInteger:obj.isPremiumJob];
    srpTuple.isWebJob = [NSNumber numberWithInteger:obj.isWebJob];
    srpTuple.isQuickWebJob = [NSNumber numberWithInteger:obj.isQuickWebJob];
    srpTuple.createdAt = [NSDate date];
    srpTuple.jobType = jobType;
    srpTuple.logoURL = obj.logoURL;
    srpTuple.tELogoURL = obj.TELogoURL;
    
}

-(void) saveViewedJobToLocal : (NGJDJobDetails *)obj withContext: (NSManagedObjectContext *) context{
    
    JobDetailsCoreData *jobDetails = [NSEntityDescription
                                      insertNewObjectForEntityForName:ENTITY_JOB_DETAILS
                                      inManagedObjectContext:context];
    
    jobDetails.jobID = obj.jobId;
    jobDetails.industryType = obj.industryType;
    jobDetails.functionalArea = obj.functionalArea;
    jobDetails.location = obj.location;
    jobDetails.jobDescription = [NSString stripHTMLTagWithItsValue: obj.jobDescription];
    jobDetails.designation = obj.designation;
    jobDetails.companyName = obj.companyName;
    jobDetails.companyProfile = [NSString stripHTMLTagWithItsValue: obj.companyProfile];
    jobDetails.minCtc = obj.minCtc;
    jobDetails.maxCtc = obj.maxCtc;
    jobDetails.isCtcHidden = obj.isCtcHidden;
    jobDetails.vacancies = [NSNumber numberWithInteger:
                            obj.vacancies];
    jobDetails.latestPostedDate = obj.latestPostedDate;
    jobDetails.country = obj.country;
    jobDetails.isWebjob = obj.isWebjob;
    jobDetails.isAlreadyApplied=obj.isAlreadyApplied;
    jobDetails.dcProfile = obj.dcProfile;
    jobDetails.minExp = obj.minExp;
    jobDetails.maxExp = obj.maxExp;
    jobDetails.education = obj.education;
    jobDetails.nationality = obj.nationality;
    jobDetails.gender = obj.gender;
    jobDetails.contactName = obj.contactName;
    jobDetails.contactDesignation = obj.contactDesignation;
    jobDetails.contactEmail = obj.contactEmail;
    jobDetails.contactWebsite = obj.contactWebsite;
    jobDetails.isEmailHiddden = obj.isEmailHiddden;
    jobDetails.createdAt = [NSDate date];
    jobDetails.keywords=obj.keywords;
    jobDetails.logoURL = obj.logoURL;
}


@end
