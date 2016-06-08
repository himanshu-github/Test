//
//  WebDataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJDdataFetcher.h"
#import "JobDetailsCoreData.h"

@implementation NGJDdataFetcher


#pragma mark JD swipe/prefetching

-(void)storeViewedJobToLocal:(NGJDJobDetails *)obj{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOB_DETAILS];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        [self saveViewedJobToLocal:obj withContext:temporaryContext];
        
        if (![temporaryContext save:&error]) {
            //NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType =K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_JOB_DETAILS];
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

    }];
    
    
}



-(NGJDJobDetails *) getJobFromLocal: (NSString *) jobID{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    __block NGJDJobDetails *jobObj = nil;
    [temporaryContext performBlockAndWait:^{
        
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOB_DETAILS];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobID == %@",jobID];
        
        [fetchRequest setPredicate:predicateID];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        
        NSArray *tempArray = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        
        if ([tempArray count] > 0) {
            
            JobDetailsCoreData *jobDetails = (JobDetailsCoreData *)tempArray[0];
            
            jobObj = [[NGJDJobDetails alloc] init];
            
            jobObj.jobId = jobDetails.jobID ;
            jobObj.industryType = jobDetails.industryType;
            jobObj.functionalArea = jobDetails.functionalArea ;
            jobObj.location = jobDetails.location ;
            jobObj.jobDescription = jobDetails.jobDescription;
            jobObj.designation = jobDetails.designation ;
            jobObj.companyName = jobDetails.companyName;
            jobObj.companyProfile = jobDetails.companyProfile;
            jobObj.minCtc = jobDetails.minCtc;
            jobObj.maxCtc = jobDetails.maxCtc ;
            jobObj.isCtcHidden = jobDetails.isCtcHidden;
            jobObj.vacancies = [jobDetails.vacancies integerValue];
            jobObj.latestPostedDate = jobDetails.latestPostedDate;
            jobObj.country = jobDetails.country ;
            jobObj.isWebjob = jobDetails.isWebjob;
            jobObj.isAlreadyApplied=jobDetails.isAlreadyApplied;
            jobObj.dcProfile = jobDetails.dcProfile ;
            jobObj.minExp = jobDetails.minExp ;
            jobObj.maxExp = jobDetails.maxExp;
            jobObj.education = jobDetails.education ;
            jobObj.nationality = jobDetails.nationality ;
            jobObj.gender = jobDetails.gender ;
            jobObj.contactName = jobDetails.contactName  ;
            jobObj.contactDesignation = jobDetails.contactDesignation  ;
            jobObj.contactEmail = jobDetails.contactEmail ;
            jobObj.contactWebsite = jobDetails.contactWebsite  ;
            jobObj.isEmailHiddden  = jobDetails.isEmailHiddden ;
            jobObj.keywords=jobDetails.keywords;
            jobObj.logoURL = jobDetails.logoURL;
            jobObj.showLogo = jobDetails.showLogo;
            jobObj.isJobRedirection = jobDetails.isJobRedirection;
            jobObj.jobRedirectionUrl = jobDetails.jobRedirectionUrl;

        }
    }];
    
    return jobObj;
    
}


-(void)deleteAllJD
{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
   
    [temporaryContext performBlock:^{
        
        NSError *error = nil;
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOB_DETAILS];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
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
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_JOB_DETAILS];
            if(error.localizedDescription!=nil)
                sedm.serverExceptionDescription = error.localizedDescription;
            else
                sedm.serverExceptionDescription = @"NA";
            
            sedm.serverExceptionClassName = NSStringFromClass([self class]);
            sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
            sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

            [NGExceptionHandler logServerError:sedm];
            return;
        } else{
            [self saveMainContext];
        }


    }];
 
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
    jobDetails.vacancies = [NSNumber numberWithInteger:obj.vacancies];
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
    jobDetails.logoURL = [obj getLogoUrl];
    jobDetails.showLogo = obj.showLogo;
    jobDetails.isJobRedirection = obj.isJobRedirection;
    jobDetails.jobRedirectionUrl = obj.jobRedirectionUrl;
    
}
-(void)markJobAsAlreadyApplied:(NSString*)jobID
{
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOB_DETAILS];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobID == %@",jobID];
        
        [fetchRequest setPredicate:predicateID];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        
        NSArray *tempArray = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        
        
        if ([tempArray count] > 0)
        {
            
            JobDetailsCoreData *jobDetails = (JobDetailsCoreData *)tempArray[0];
            
            jobDetails.isAlreadyApplied=@"true";
            
            if(![temporaryContext save:&error]){
                NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
                sedm.serverExceptionErrorType =K_CORE_DATA_SAVE_EXCEPTION_ERROR;
                sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_JOB_DETAILS];
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
    }];
}

-(NSInteger)isJobApplied:(NSString*)jobID{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    __block NSInteger isApplied;
    [temporaryContext performBlockAndWait:^{
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_JOB_DETAILS];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"jobID == %@",jobID];
        
        [fetchRequest setPredicate:predicateID];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        
        NSArray *tempArray = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        
        if ([tempArray count] > 0)
        {
            
            JobDetailsCoreData *jobDetails = (JobDetailsCoreData *)tempArray[0];
            
            isApplied = [jobDetails.isAlreadyApplied isEqualToString:@"true"]?1:0;
            
        }
        else isApplied = 0;
    }];
    return isApplied;
}

@end
