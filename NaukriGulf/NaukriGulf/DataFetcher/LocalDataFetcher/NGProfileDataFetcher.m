//
//  WebDataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGProfileDataFetcher.h"
#import "ProfileViewCoreData.h"
#import "NGProfileViewDetails.h"
#import "NGMNJProfileCoreData.h"
#import "NGProjectDetailCoreData.h"
#import "NGITSkillDetailCoreData.h"
#import "NGWorkExpDetailCoreData.h"
#import "NGEducationDetailCoreData.h"


@implementation NGProfileDataFetcher
   


#pragma mark WhoViewMyCV
-(void) saveProfileViewTuple:(NSArray *)profileViewArray
{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
        
    NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_PROFILE_VIEWS];

        NSError *error = nil;
        
        NSArray *tempArray = [self getAllProfileViews];
        
       NSInteger storeLimit = MAX_PRFOILE_VIEWS_ALLOWED;
    
        //Count greater than store limit of jobs (configurable) then delete oldest one
        
        if (tempArray.count + profileViewArray.count > storeLimit && tempArray.count>0)
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
           
            [fetchRequest setEntity:entity];
            
            NSArray *tempArr = [temporaryContext executeFetchRequest:fetchRequest error:&error];
            
            NSInteger overLimit = tempArray.count + profileViewArray.count - storeLimit;
            
            
            for (NSInteger i = 0; i<overLimit; i++) {
                NSManagedObject *objTemp = [tempArr fetchObjectAtIndex:i];
                if (objTemp) {
                    
                    [temporaryContext deleteObject:objTemp];
                    
                }
                
            }
            
            
        }
        
        for (NGProfileViewDetails *obj in profileViewArray)
        {
            
            ProfileViewCoreData* profileViewCD = [NSEntityDescription
                                           insertNewObjectForEntityForName:ENTITY_PROFILE_VIEWS
                                           inManagedObjectContext:temporaryContext];

            profileViewCD.compName=obj.compName;
            profileViewCD.indType=obj.indType;
            profileViewCD.compLocation=obj.compLocation;
            profileViewCD.profileViewedDate=obj.profileViewedDate;
            
        }
        
        if (![temporaryContext save:&error]) {
            //Error Handling
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([ProfileViewCoreData class])];
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


- (NSArray *) getAllProfileViews{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    __block NSMutableArray *savedProfileViews = nil;
    
    [temporaryContext performBlockAndWait:^{
 
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_PROFILE_VIEWS];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        
        NSArray *tempArray = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        
        savedProfileViews = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i<tempArray.count; i++)
        {
            
            ProfileViewCoreData *profileView = (ProfileViewCoreData*)[tempArray fetchObjectAtIndex:i];
            NGProfileViewDetails *profileViewObj = [[NGProfileViewDetails alloc]init];
            
            profileViewObj.compName=profileView.compName;
            profileViewObj.compLocation=profileView.compLocation;
            profileViewObj.indType=profileView.indType;
            profileViewObj.profileViewedDate=profileView.profileViewedDate;
            [savedProfileViews addObject:profileViewObj];
        }
        
        savedProfileViews=[self sortprofileViewsBasedOnProfileViewedDate:savedProfileViews];

    }];
    
    return savedProfileViews;
}


-(NSMutableArray*)sortprofileViewsBasedOnProfileViewedDate:(NSArray*)array
{
    NGProfileViewDetails *profileViewObj;
    
    NSMutableArray* profileArrayTemp=[[NSMutableArray alloc]init];
    
    for(profileViewObj in array)
    {
        
        NSMutableDictionary* dictFprProfileViews=[[NSMutableDictionary alloc] init];
    
        [dictFprProfileViews setValue:[self convertStringToDate:profileViewObj.profileViewedDate] forKey:@"ProflieViewedDate"];
        [dictFprProfileViews setValue:profileViewObj forKey:@"ProfileViewDetail"];
        [profileArrayTemp addObject:dictFprProfileViews];
    
    }
    
   NSSortDescriptor *sortProfileViewedDate=[NSSortDescriptor sortDescriptorWithKey:@"ProflieViewedDate" ascending:YES];
   profileArrayTemp=(NSMutableArray*)[profileArrayTemp sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortProfileViewedDate]];
    
   
    NSMutableArray* profileViewedUpdatedArray=[[NSMutableArray alloc] init];
    
    for (int i=0; i<profileArrayTemp.count; i++)
    {
        [profileViewedUpdatedArray addObject:[[profileArrayTemp fetchObjectAtIndex:i] valueForKey:@"ProfileViewDetail"]];
    }
     return profileViewedUpdatedArray;
}

-(NSDate*)convertStringToDate:(NSString*)str{
    return [NGDateManager dateFromString:str WithDateFormat:@"dd MMM yyyy"];
}


-(void)deleteAllProfileViews
{
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
 
        
        NSError *error = nil;
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_PROFILE_VIEWS];
        
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
                sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
                sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_PROFILE_VIEWS];
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



#pragma mark MNJ User Profile

-(void)saveMNJUserProfile:(NGMNJProfileModalClass *)modelObj{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_MNJ_USER_PROFILE];
        NSError *error = nil;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        
        NSArray *profile = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        NGMNJProfileCoreData* profileObj = nil;
        if(profile && profile.count>0)
            profileObj = [profile fetchObjectAtIndex:0];
        else
            profileObj = [NSEntityDescription
                          insertNewObjectForEntityForName:ENTITY_MNJ_USER_PROFILE
                          inManagedObjectContext:temporaryContext];
        
            profileObj.name = modelObj.name;
            profileObj.resID = modelObj.resID;
            profileObj.username = modelObj.username;
            profileObj.gender = modelObj.gender;
            profileObj.dateOfBirth = modelObj.dateOfBirth;
            profileObj.mphone = modelObj.mphone;
            profileObj.rphone = modelObj.rphone;
            profileObj.city = modelObj.city;
            profileObj.nationality = modelObj.nationality;
            profileObj.country = modelObj.country;
            profileObj.keySkills = modelObj.keySkills;
            profileObj.headline = modelObj.headline;
            profileObj.workLevel = modelObj.workLevel;
            profileObj.absoluteSalary = modelObj.salary;
            profileObj.currency = modelObj.currency;
            profileObj.salary = modelObj.salary_range;
            profileObj.fArea = modelObj.fArea;
            profileObj.industryType = modelObj.industryType;
            profileObj.isDrivingLicense = [NSNumber numberWithBool:modelObj.isDrivingLicense];
            profileObj.dlStr = modelObj.dlStr;
            profileObj.dlCountry = modelObj.dlCountry;
            profileObj.noticePeriod = modelObj.noticePeriod;
            profileObj.visaStatus = modelObj.visaStatus;
            profileObj.visaExpiryDate = modelObj.visaExpiryDate;
            profileObj.employmentType = modelObj.employmentType;;
            profileObj.employmentStatus = modelObj.employmentStatus;
            profileObj.preferredWorkLocation = modelObj.preferredWorkLocation;
            profileObj.maritalStatus = modelObj.maritalStatus;
            profileObj.languagesKnown = modelObj.languagesKnown;
            profileObj.religion = modelObj.religion;
            profileObj.totalExpYears = modelObj.totalExpYears;
            profileObj.totalExpMonths = modelObj.totalExpMonths;
            profileObj.currentDesignation = modelObj.currentDesignation;
        
            profileObj.ppgYear = modelObj.ppgYear;
            profileObj.ugCourse = modelObj.ugCourse;
            profileObj.ugSpecialization = modelObj.ugSpecialization;
            profileObj.ugCountry = modelObj.ugCountry;
            profileObj.ugYear = modelObj.ugYear;
            profileObj.pgCourse = modelObj.pgCourse;
            profileObj.pgSpecialization = modelObj.pgSpecialization;
            profileObj.pgCountry = modelObj.pgCountry;
            profileObj.pgYear = modelObj.pgYear;
            profileObj.ppgCourse = modelObj.ppgCourse;
            profileObj.ppgSpecialization = modelObj.ppgSpecialization;
            profileObj.ppgCountry = modelObj.ppgCountry;
            profileObj.ppgYear = modelObj.ppgYear;

        
        profileObj.attachedCvFormat = modelObj.attachedCvFormat;
        profileObj.attachedCvModDate = modelObj.attachedCvModDate;

        
            [profileObj removeProjectList:profileObj.projectList];
            for (NGProjectDetailModel* projDetailModal in modelObj.projectsList) {
                NGProjectDetailCoreData* coreDataObj = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_PROJECT_LIST inManagedObjectContext:temporaryContext];
                coreDataObj.title = projDetailModal.title;
                coreDataObj.client = projDetailModal.client;
                coreDataObj.designation = projDetailModal.designation;
                coreDataObj.location = projDetailModal.location;
                coreDataObj.startDate = projDetailModal.startDate;
                coreDataObj.endDate = projDetailModal.endDate;
                coreDataObj.site = projDetailModal.site;
                [profileObj addProjectListObject:coreDataObj];
            }
            
            [profileObj removeItSkillList:profileObj.itSkillList];
            for (NGITSkillDetailModel* itSkillDetailModal in modelObj.IT_SkillsList) {
                NGITSkillDetailCoreData* coreDataObj = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_IT_SKILL_LIST inManagedObjectContext:temporaryContext];
                coreDataObj.name = itSkillDetailModal.name;
                coreDataObj.experience = itSkillDetailModal.experience;
                coreDataObj.lastUsed = itSkillDetailModal.lastUsed;
                [profileObj addItSkillListObject:coreDataObj];
            }
            
            [profileObj removeWorkExpList:profileObj.workExpList];
            for (NGWorkExpDetailModel* workExpModal in modelObj.workExpList) {
                NGWorkExpDetailCoreData* coreDataObj = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_WORK_EXPERIENCE_LIST inManagedObjectContext:temporaryContext];
                
                coreDataObj.designation = workExpModal.designation;
                coreDataObj.startDate = workExpModal.startDate;
                coreDataObj.endDate = workExpModal.endDate;
                coreDataObj.organization = workExpModal.organization;
                coreDataObj.jobProfile = workExpModal.jobProfile;
                coreDataObj.workExpID = workExpModal.workExpID;
                [profileObj addWorkExpListObject:coreDataObj];
            }
            
            
            
            [profileObj removeEducationList:profileObj.educationList];
            for (NGEducationDetailModel* educationModal in modelObj.educationList) {
                NGEducationDetailCoreData* coreDataObj = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_EDUCATION_LIST inManagedObjectContext:temporaryContext];
                coreDataObj.course = educationModal.course;
                coreDataObj.specialization = educationModal.specialization;
                coreDataObj.country = educationModal.country;
                coreDataObj.year = educationModal.year;
                coreDataObj.type = educationModal.type;
                [profileObj addEducationListObject:coreDataObj];
            }

            
            //profileObj.profileData = [NSKeyedArchiver archivedDataWithRootObject:modelObj];
        
        
        if (![temporaryContext save:&error]) {
            
            //Error Handling
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([ProfileViewCoreData class])];
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

-(NGMNJProfileModalClass *)getMNJUserProfile{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    __block NGMNJProfileModalClass *objModel = [[NGMNJProfileModalClass alloc] init];
    objModel.projectsList = (NSMutableArray<NGProjectDetailModel> *)[NSMutableArray array];
    objModel.IT_SkillsList = (NSMutableArray<NGITSkillDetailModel> *)[NSMutableArray array];
    objModel.workExpList = (NSMutableArray<NGWorkExpDetailModel> *)[NSMutableArray array];
    objModel.currentWorkExp = (NSMutableArray<NGWorkExpDetailModel> *)[NSMutableArray array];
    objModel.educationList = (NSMutableArray<NGEducationDetailModel> *)[NSMutableArray array];
    
    
    
    [temporaryContext performBlockAndWait:^{
        
        NSError *error = nil;
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_MNJ_USER_PROFILE];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        
        NSArray *profile = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        if (profile && profile.count > 0) {
            NGMNJProfileCoreData *profileObj = [profile fetchObjectAtIndex:0];
            
            objModel.name = profileObj.name;
            objModel.resID = profileObj.resID;
            objModel.username = profileObj.username;
            objModel.gender = profileObj.gender;
            objModel.dateOfBirth = profileObj.dateOfBirth;
            objModel.mphone = profileObj.mphone;
            objModel.rphone = profileObj.rphone;
            objModel.city = profileObj.city;
            objModel.nationality = profileObj.nationality;
            objModel.country = profileObj.country;
            objModel.keySkills = profileObj.keySkills;
            objModel.headline = profileObj.headline;
            objModel.workLevel = profileObj.workLevel;
            objModel.salary = profileObj.absoluteSalary;
            objModel.currency = profileObj.currency;
            objModel.salary_range = profileObj.salary;
            objModel.fArea = profileObj.fArea;
            objModel.industryType = profileObj.industryType;
            objModel.isDrivingLicense = profileObj.isDrivingLicense.boolValue;
            objModel.dlStr = profileObj.dlStr;
            objModel.dlCountry = profileObj.dlCountry;
            objModel.noticePeriod = profileObj.noticePeriod;
            objModel.visaStatus = profileObj.visaStatus;
            objModel.visaExpiryDate = profileObj.visaExpiryDate;
            objModel.employmentType = profileObj.employmentType;;
            objModel.employmentStatus = profileObj.employmentStatus;
            objModel.preferredWorkLocation = profileObj.preferredWorkLocation;
            objModel.maritalStatus = profileObj.maritalStatus;
            objModel.languagesKnown = profileObj.languagesKnown;
            objModel.religion = profileObj.religion;
            objModel.totalExpYears = profileObj.totalExpYears;
            objModel.totalExpMonths = profileObj.totalExpMonths;
            objModel.currentDesignation = profileObj.currentDesignation;
            
            
            
            objModel.ppgYear = profileObj.ppgYear;
            objModel.ugCourse = profileObj.ugCourse;
            objModel.ugSpecialization = profileObj.ugSpecialization;
            objModel.ugCountry = profileObj.ugCountry;
            objModel.ugYear = profileObj.ugYear;
            objModel.pgCourse = profileObj.pgCourse;
            objModel.pgSpecialization = profileObj.pgSpecialization;
            objModel.pgCountry = profileObj.pgCountry;
            objModel.pgYear = profileObj.pgYear;
            objModel.ppgCourse = profileObj.ppgCourse;
            objModel.ppgSpecialization = profileObj.ppgSpecialization;
            objModel.ppgCountry = profileObj.ppgCountry;
            objModel.ppgYear = profileObj.ppgYear;
            
            
            objModel.attachedCvFormat = profileObj.attachedCvFormat;
            objModel.attachedCvModDate = profileObj.attachedCvModDate;

            
            
            
            for (NGProjectDetailCoreData* coreDataObj in profileObj.projectList) {
                NGProjectDetailModel* projDetailModal = [[NGProjectDetailModel alloc]init];
                projDetailModal.title = coreDataObj.title;
                projDetailModal.client = coreDataObj.client;
                projDetailModal.designation = coreDataObj.designation;
                projDetailModal.location = coreDataObj.location;
                projDetailModal.startDate = coreDataObj.startDate;
                projDetailModal.endDate = coreDataObj.endDate;
                projDetailModal.site = coreDataObj.site;
                [objModel.projectsList addObject:projDetailModal];
            }
            
            for (NGITSkillDetailCoreData* coreDataObj in profileObj.itSkillList) {
                NGITSkillDetailModel* itSKillModel = [[NGITSkillDetailModel alloc]init];
                itSKillModel.name = coreDataObj.name;
                itSKillModel.experience = coreDataObj.experience;
                itSKillModel.lastUsed = coreDataObj.lastUsed;
                [objModel.IT_SkillsList addObject:itSKillModel];
            }
            
            for (NGWorkExpDetailCoreData* coreDataObj in profileObj.workExpList) {
                NGWorkExpDetailModel* workExpModal = [[NGWorkExpDetailModel alloc]init];
                workExpModal.designation = coreDataObj.designation;
                workExpModal.startDate = coreDataObj.startDate;
                workExpModal.endDate = coreDataObj.endDate;
                workExpModal.organization = coreDataObj.organization;
                workExpModal.jobProfile = coreDataObj.jobProfile;
                workExpModal.workExpID = coreDataObj.workExpID;
                [objModel.workExpList addObject:workExpModal];
            }
            
            
            
            for (NGEducationDetailCoreData* coreDataObj in profileObj.educationList) {
                NGEducationDetailModel* educationModal = [[NGEducationDetailModel alloc]init];
                educationModal.course = coreDataObj.course;
                educationModal.specialization = coreDataObj.specialization;
                educationModal.country = coreDataObj.country;
                educationModal.year = coreDataObj.year;
                educationModal.type = coreDataObj.type;
                [objModel.educationList addObject:educationModal];
            }
            

            //objModel = [NSKeyedUnarchiver unarchiveObjectWithData:profileObj.profileData];
            
        }

    }];
    
    return objModel;
}

-(void)deleteMNJUserProfile{
    
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
        
        NSError *error = nil;
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_MNJ_USER_PROFILE];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        
        NSArray *tempArr = [temporaryContext executeFetchRequest:fetchRequest error:&error];
        
        for (NSInteger i = 0; i<tempArr.count; i++) {
            
            NGMNJProfileCoreData *objTemp = [tempArr fetchObjectAtIndex:i];
            if (objTemp) {
                [temporaryContext deleteObject:objTemp];
            }
            
        }
        
        if (![temporaryContext save:&error]) {
            
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([NGMNJProfileCoreData class])];
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

@end
