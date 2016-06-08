//
//  NGUnregApplyFieldsDataFetcher.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/28/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGUnregApplyFieldsDataFetcher.h"
#import "NGApplyFieldsCoreData.h"

@implementation NGUnregApplyFieldsDataFetcher


-(void)saveApplyFields:(NGApplyFieldsModel*)modalFieldObj{
    
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
        
        NSError* error = nil;
        
        NGApplyFieldsCoreData* applyFieldsCoreData = [self fetchUnregApplyFieldsInContext:temporaryContext];
        if (!applyFieldsCoreData)
            applyFieldsCoreData = [NSEntityDescription insertNewObjectForEntityForName:
                                   ENTITY_APPLY_FIELDS inManagedObjectContext:temporaryContext];
        
        
        applyFieldsCoreData.name = modalFieldObj.name;
        applyFieldsCoreData.emailId = modalFieldObj.emailId;
        applyFieldsCoreData.mobileNumebr = modalFieldObj.mobileNumber;
        applyFieldsCoreData.gender = modalFieldObj.gender;
        applyFieldsCoreData.workEx = modalFieldObj.workEx;
        
        applyFieldsCoreData.currentDesignation = modalFieldObj.currentDesignation;
        
        applyFieldsCoreData.gradCourse = modalFieldObj.gradCourse;
        applyFieldsCoreData.gradspecialisation = modalFieldObj.gradspecialisation;
        applyFieldsCoreData.pgCourse = modalFieldObj.pgCourse;
        applyFieldsCoreData.pgSpecialisation = modalFieldObj.pgSpecialisation;
        applyFieldsCoreData.doctCourse = modalFieldObj.doctCourse;
        applyFieldsCoreData.doctSpecialization = modalFieldObj.doctspecialisation;
        
        applyFieldsCoreData.country = modalFieldObj.country;
        applyFieldsCoreData.city = modalFieldObj.city;
        applyFieldsCoreData.nationality = modalFieldObj.nationality;
        
        applyFieldsCoreData.fresher = [NSNumber numberWithBool:modalFieldObj.isFresher];
        
        if (![temporaryContext save:&error]) {
            
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",ENTITY_APPLY_FIELDS];
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
            [NGSavedData setApplyDataCached:YES];
            [NGSavedData saveUnregApplyFieldsDataDate:[NSDate date]];
            [self saveMainContext];
        }

    }];
    
   }


-(NGApplyFieldsCoreData*)fetchUnregApplyFieldsInContext : (NSManagedObjectContext*) context{
    
    __block NGApplyFieldsCoreData *applyData;
   
    if(!context){
        context = [self privateMoc];
    }
    
    [context performBlockAndWait:^{

        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_APPLY_FIELDS];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        NSArray* fetchedObj = [context executeFetchRequest:fetchRequest error:nil];
        if(fetchedObj.count)
            applyData = [fetchedObj fetchObjectAtIndex:0];

    }];
    
     return applyData;
}


-(NGApplyFieldsModel*)getApplyFields{
    
    NGApplyFieldsCoreData* applyFieldObj = [self fetchUnregApplyFieldsInContext:nil];
    if (applyFieldObj)
    {
        
        NGApplyFieldsModel *applyModal = [[NGApplyFieldsModel alloc] init];
       
        applyModal.name = applyFieldObj.name;
        applyModal.emailId = applyFieldObj.emailId;
        applyModal.mobileNumber = applyFieldObj.mobileNumebr;
        applyModal.workEx = applyFieldObj.workEx;
        applyModal.gender = applyFieldObj.gender;
        applyModal.currentDesignation = applyFieldObj.currentDesignation;
        applyModal.gradCourse = applyFieldObj.gradCourse;
        applyModal.gradspecialisation = applyFieldObj.gradspecialisation;
        applyModal.pgCourse = applyFieldObj.pgCourse;
        applyModal.pgSpecialisation = applyFieldObj.pgSpecialisation;
        applyModal.doctCourse = applyFieldObj.doctCourse;
        applyModal.doctspecialisation = applyFieldObj.doctSpecialization;
        applyModal.country = applyFieldObj.country;
        applyModal.city = applyFieldObj.city;
        applyModal.nationality = applyFieldObj.nationality;
        applyModal.isFresher = [applyFieldObj.fresher boolValue];
        
        return applyModal;
    }
    return nil;
}



@end
