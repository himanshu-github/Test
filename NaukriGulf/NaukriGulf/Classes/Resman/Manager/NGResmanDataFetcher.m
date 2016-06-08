//
//  NGResmanDataFetcher.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/14/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanDataFetcher.h"
#import "ResmanCoreData.h"
@implementation NGResmanDataFetcher

-(void)saveResmanFields:(NGResmanDataModel*)modalFieldObj {
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
        
        NSError* error = nil;
        
        ResmanCoreData *resmanCoreData = [self fetchResmanFieldsInContext:temporaryContext];
        if (!resmanCoreData)
            resmanCoreData = [NSEntityDescription insertNewObjectForEntityForName:
                              ENTITY_RESMAN_FIELDS inManagedObjectContext:temporaryContext];
        
        resmanCoreData.userName = modalFieldObj.userName;
        resmanCoreData.password = modalFieldObj.password;
        resmanCoreData.preferredLoc = modalFieldObj.preferredLoc;
        resmanCoreData.availabilityToJoin = modalFieldObj.availabilityToJoin;
        resmanCoreData.totalExp = modalFieldObj.totalExp;
        resmanCoreData.designation = modalFieldObj.designation;
        resmanCoreData.company = modalFieldObj.company;
        resmanCoreData.isFresher = [NSNumber numberWithBool:modalFieldObj.isFresher];
        resmanCoreData.currentSalary = modalFieldObj.currentSalary;
        resmanCoreData.industry = modalFieldObj.industry;
        resmanCoreData.functionalArea = modalFieldObj.functionalArea;
        resmanCoreData.highestEducation = modalFieldObj.highestEducation;
        resmanCoreData.ppgCourse = modalFieldObj.ppgCourse;
        resmanCoreData.ppgSpec = modalFieldObj.ppgSpec;
        resmanCoreData.pgCourse = modalFieldObj.pgCourse;
        resmanCoreData.pgSpec = modalFieldObj.pgSpec;
        resmanCoreData.ugCourse = modalFieldObj.ugCourse;
        resmanCoreData.ugSpec = modalFieldObj.ugSpec;
        resmanCoreData.prevDesignation = modalFieldObj.prevDesignation;
        resmanCoreData.previousCompany = modalFieldObj.previousCompany;
        resmanCoreData.visaStatus = modalFieldObj.visaStatus;
        resmanCoreData.visaValidity = modalFieldObj.visaValidity;
        resmanCoreData.isHoldingDL = [NSNumber numberWithBool:modalFieldObj.isHoldingDL];
        resmanCoreData.dlIssuedBy = modalFieldObj.dlIssuedBy;
        resmanCoreData.gender = modalFieldObj.gender;
        resmanCoreData.name = modalFieldObj.name;
        resmanCoreData.mobileNum =modalFieldObj.mobileNum;
        resmanCoreData.countryCode = modalFieldObj.countryCode;
        resmanCoreData.nationality=modalFieldObj.nationality;
        resmanCoreData.city = modalFieldObj.city;
        resmanCoreData.alertSetting = modalFieldObj.alertSetting;
        resmanCoreData.country = modalFieldObj.country;
        resmanCoreData.isOtherCity = [NSNumber numberWithBool:modalFieldObj.isOtherCity];
        resmanCoreData.isCVUploaded = [NSNumber numberWithBool:modalFieldObj.isCVUploaded];
        resmanCoreData.cvHeadline = modalFieldObj.cvHeadline;
        resmanCoreData.keySkills = modalFieldObj.keySkills;
        resmanCoreData.currency = modalFieldObj.currency;
        resmanCoreData.dob = modalFieldObj.dob;
        resmanCoreData.alternateEmail = modalFieldObj.alternateEmail;
        resmanCoreData.religion = modalFieldObj.religion;
        resmanCoreData.otherReligion = modalFieldObj.otherReligion;
        resmanCoreData.maritalStatus = modalFieldObj.maritalStatus;
        resmanCoreData.languages = modalFieldObj.languages;
        resmanCoreData.isDLPresent = [NSNumber numberWithBool:modalFieldObj.isDlPresent];
        if (![temporaryContext save:&error]) {
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_RESMAN_FIELDS];
            if(error.localizedDescription!=nil)
                sedm.serverExceptionDescription = error.localizedDescription;
            else
                sedm.serverExceptionDescription = @"NA";
            
            sedm.serverExceptionClassName = NSStringFromClass([self class]);
            sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
            sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

            [NGExceptionHandler logServerError:sedm];

        }
        else
        {
            [self saveMainContext];
        }
        
    }];
    
    
    
}


-(ResmanCoreData*)fetchResmanFieldsInContext : (NSManagedObjectContext*) context{
    
    __block ResmanCoreData *resmanData;
    
    if(!context){
        context = [self privateMoc];
    }
    
    [context performBlockAndWait:^{
        
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_RESMAN_FIELDS];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        NSArray* fetchedObj = [context executeFetchRequest:fetchRequest error:nil];
        if(fetchedObj.count)
            resmanData = [fetchedObj fetchObjectAtIndex:0];
        
    }];
    
    return resmanData;
}


-(NGResmanDataModel*)getResmanFields{
    
    ResmanCoreData* resmanCoreData = [self fetchResmanFieldsInContext:nil];
    
    if (resmanCoreData)
    {
        
        NGResmanDataModel *resmanModal = [[NGResmanDataModel alloc] init];
        resmanModal.userName = resmanCoreData.userName;
        resmanModal.password = resmanCoreData.password;
        resmanModal.preferredLoc = resmanCoreData.preferredLoc;
        resmanModal.availabilityToJoin = resmanCoreData.availabilityToJoin;
        resmanModal.totalExp = resmanCoreData.totalExp;
        resmanModal.designation = resmanCoreData.designation;
        resmanModal.company = resmanCoreData.company;
        resmanModal.isFresher = [resmanCoreData.isFresher boolValue];
        resmanModal.currentSalary = resmanCoreData.currentSalary;
        resmanModal.industry = resmanCoreData.industry;
        resmanModal.functionalArea = resmanCoreData.functionalArea;
        resmanModal.highestEducation = resmanCoreData.highestEducation;
        resmanModal.ppgCourse = resmanCoreData.ppgCourse;
        resmanModal.ppgSpec = resmanCoreData.ppgSpec;
        resmanModal.pgCourse = resmanCoreData.pgCourse;
        resmanModal.pgSpec = resmanCoreData.pgSpec;
        resmanModal.ugCourse = resmanCoreData.ugCourse;
        resmanModal.ugSpec = resmanCoreData.ugSpec;
        resmanModal.prevDesignation = resmanCoreData.prevDesignation;
        resmanModal.previousCompany = resmanCoreData.previousCompany;
        resmanModal.visaStatus = resmanCoreData.visaStatus;
        resmanModal.visaValidity = resmanCoreData.visaValidity;
        resmanModal.isHoldingDL = [resmanCoreData.isHoldingDL boolValue];
        resmanModal.dlIssuedBy = resmanCoreData.dlIssuedBy;
        resmanModal.gender = resmanCoreData.gender;
        resmanModal.name = resmanCoreData.name;
        resmanModal.mobileNum =resmanCoreData.mobileNum;
        resmanModal.countryCode = resmanCoreData.countryCode;
        resmanModal.nationality=resmanCoreData.nationality;
        resmanModal.city = resmanCoreData.city;
        resmanModal.alertSetting = resmanCoreData.alertSetting;
        resmanModal.country = resmanCoreData.country;
        resmanModal.isOtherCity = [resmanCoreData.isOtherCity boolValue];
        resmanModal.isCVUploaded = [resmanCoreData.isCVUploaded boolValue];
        resmanModal.cvHeadline = resmanCoreData.cvHeadline;
        resmanModal.keySkills = resmanCoreData.keySkills;
        resmanModal.currency = resmanCoreData.currency;
        resmanModal.dob = resmanCoreData.dob;
        resmanModal.alternateEmail = resmanCoreData.alternateEmail;
        resmanModal.religion = resmanCoreData.religion;
        resmanModal.otherReligion = resmanCoreData.otherReligion;
        resmanModal.maritalStatus = resmanCoreData.maritalStatus;
        resmanModal.languages = resmanCoreData.languages;
        resmanModal.isDlPresent = resmanCoreData.isDLPresent.boolValue;
        
        return resmanModal;
    }
    return nil;

    
}

@end