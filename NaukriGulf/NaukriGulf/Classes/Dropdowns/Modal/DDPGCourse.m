//
//  DDPFCourse.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDPGCourse.h"
#import "DDPGSpec.h"


@implementation DDPGCourse

@dynamic specs;

+(DDPGCourse*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    static int i = 0;

    DDPGCourse *obj = [NSEntityDescription
                        insertNewObjectForEntityForName:@"DDPGCourse"
                        inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"MastersDegreeName"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"MastersDegreeID"] intValue]];
    obj.sortedID = [NSNumber numberWithInt:i++];

    obj.headerName = @"Course";
    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
    
}

+(void)updateDataFromTextFile
{
    NSManagedObjectContext *temporaryContext = [NGStaticDDHelper privateMoc];
    [temporaryContext performBlockAndWait:^
     {
         NSError* error = nil;
         NSArray *arr = [NGStaticContentManager getNewDropDownData:DDC_PGCOURSE];
         for(NSDictionary *dict in arr)
         {
             DDPGCourse *course = (DDPGCourse *)[DDPGCourse localObjectWithDict:dict andContext:temporaryContext ];
             [course addSpecs: [DDPGSpec PGSpecs: [dict objectForKey:@"MastersCourseList"] andContext:temporaryContext]];
         }
         if (![temporaryContext save:&error]){
             NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
             sedm.serverExceptionErrorType =K_CORE_DATA_SAVE_EXCEPTION_ERROR;
             sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([DDPGCourse class])];
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
             [NGStaticDDCoreDataLayer saveDataContext];
     }];
}


@end
