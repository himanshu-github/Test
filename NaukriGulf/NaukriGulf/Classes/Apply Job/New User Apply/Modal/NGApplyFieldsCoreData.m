//
//  NGApplyFieldsCoreData.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/28/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGApplyFieldsCoreData.h"


@implementation NGApplyFieldsCoreData

@dynamic currentCompany;
@dynamic currentDesignation;
@dynamic emailId;
@dynamic gradCourse;
@dynamic gradspecialisation;
@dynamic mobileNumebr;
@dynamic name;
@dynamic pgCourse;
@dynamic pgSpecialisation;
@dynamic workEx;
@dynamic gender;
@dynamic doctCourse;
@dynamic doctSpecialization;
@dynamic country;
@dynamic city;
@dynamic nationality;
@dynamic fresher;

+(void)updateUnregApplyCoreDataFields:(NSDictionary*)dictUpdatedValues{
    
    NSManagedObjectContext *temporaryContext =  [NGDynamicCoreDataHelper privateMoc];
    __block NSArray *allObjects =[NSArray array];
    [temporaryContext performBlockAndWait:^{
        NSError* error = nil;
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([NGApplyFieldsCoreData class])inManagedObjectContext:temporaryContext];
        if(entity!=nil)
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            NSError *error;
            allObjects =  [temporaryContext executeFetchRequest:fetchRequest error:&error];
            
            NGApplyFieldsCoreData* objCoreData = [allObjects firstObject];
            NSArray* arrUpdatedDD = [dictUpdatedValues objectForKey:@"updated_dropdown"];
            for(NSNumber *updatedID in arrUpdatedDD)
            {
                if(updatedID.intValue == DDC_NATIONALITY)
                    objCoreData.nationality = [DDBase updateUNRegModel:
                                              [[NSMutableDictionary alloc] initWithDictionary:objCoreData.nationality] havingType:DDC_NATIONALITY];
                
                else if(updatedID.intValue == DDC_COUNTRY)
                    objCoreData.country = [DDBase updateUNRegModel:
                                               [[NSMutableDictionary alloc] initWithDictionary:objCoreData.country] havingType:DDC_COUNTRY];
                
                else if(updatedID.intValue == DDC_CITY)
                    objCoreData.city = [DDBase updateUNRegModel:
                                                [[NSMutableDictionary alloc] initWithDictionary:objCoreData.city] havingType:DDC_CITY];
                
                else if(updatedID.intValue == DDC_UGCOURSE)
                    objCoreData.gradCourse = [DDBase updateUNRegModel:
                                                [[NSMutableDictionary alloc] initWithDictionary:
                                                 objCoreData.gradCourse] havingType:DDC_UGCOURSE];
                
                else if(updatedID.intValue == DDC_UGSPEC){
                    
                    NSString* myId = [objCoreData.gradCourse objectForKey:KEY_ID] ;
                    DDBase* objBase = [[NGDatabaseHelper searchForType:KEY_ID havingValue:myId
                                                             andDDType:DDC_UGCOURSE] firstObject];
                    NSSet * set =[objBase valueForKey:@"specs"];
                    NSArray *allChild = set.allObjects;
                    objCoreData.gradspecialisation = [DDBase updateUNRegModel:
                                                    [[NSMutableDictionary alloc] initWithDictionary:
                                                     objCoreData.gradspecialisation] havingType:DDC_UGSPEC inArray:allChild];
                    
                    
                }
                else if(updatedID.intValue == DDC_PGCOURSE)
                    objCoreData.pgCourse = [DDBase updateUNRegModel:
                                                  [[NSMutableDictionary alloc] initWithDictionary:
                                                   objCoreData.pgCourse] havingType:DDC_PGCOURSE];
                
                
                else if(updatedID.intValue == DDC_PGSPEC)
                {
                    NSString* myId = [objCoreData.pgCourse objectForKey:KEY_ID] ;
                    DDBase* objBase = [[NGDatabaseHelper searchForType:KEY_ID havingValue:myId
                                                             andDDType:DDC_PGCOURSE] firstObject];
                    NSSet * set =[objBase valueForKey:@"specs"];
                    NSArray *allChild = set.allObjects;
                    objCoreData.pgSpecialisation = [DDBase updateUNRegModel:
                                        [[NSMutableDictionary alloc] initWithDictionary:
                                         objCoreData.pgSpecialisation] havingType:DDC_PGSPEC inArray:allChild];
                }
                
                else if(updatedID.intValue == DDC_PPGCOURSE)
                    objCoreData.doctCourse = [DDBase updateUNRegModel:
                                                [[NSMutableDictionary alloc] initWithDictionary:
                                                 objCoreData.doctCourse] havingType:DDC_PPGCOURSE];
                
                else if(updatedID.intValue == DDC_PPGSPEC){

                    NSString* myId = [objCoreData.doctCourse objectForKey:KEY_ID] ;
                    DDBase* objBase = [[NGDatabaseHelper searchForType:KEY_ID havingValue:myId
                                                             andDDType:DDC_PPGCOURSE] firstObject];
                    NSSet * set =[objBase valueForKey:@"specs"];
                    NSArray *allChild = set.allObjects;
                    objCoreData.doctSpecialization = [DDBase updateUNRegModel:
                                                      [[NSMutableDictionary alloc] initWithDictionary:
                                                       objCoreData.doctSpecialization] havingType:DDC_PPGSPEC inArray:allChild];
                }
                
            }
            
            
        }
        
        if (![temporaryContext save:&error]) {
            
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType =K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([self class])];
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
            [NGCoreDataHelper saveDataContext];

        
        
    }];
}
@end
