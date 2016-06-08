//
//  DDPPGCourse.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDPPGCourse.h"
#import "DDPPGSpec.h"


@implementation DDPPGCourse

@dynamic specs;


+(DDPPGCourse*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    static int i = 0;
    DDPPGCourse *obj = [NSEntityDescription
                      insertNewObjectForEntityForName:@"DDPPGCourse"
                      inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"DoctorateDegreeName"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"DoctorateDegreeID"] intValue]];
    obj.headerName = @"Course";
    obj.sortedID = [NSNumber numberWithInt:i++];

    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
    
}

+(void)updateDataFromTextFile
{
    NSManagedObjectContext *temporaryContext = [NGStaticDDHelper privateMoc];
    [temporaryContext performBlockAndWait:^
     {
         NSError* error = nil;
         NSArray *arr = [NGStaticContentManager getNewDropDownData:DDC_PPGCOURSE];
         for(NSDictionary *dict in arr)
         {
             DDPPGCourse *course = (DDPPGCourse *)[DDPPGCourse localObjectWithDict:dict andContext:temporaryContext ];
             [course addSpecs: [DDPPGSpec PPGSpecs: [dict objectForKey:@"DoctorateCourseList"] andContext:temporaryContext]];
         }
         if (![temporaryContext save:&error]){
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
             [NGStaticDDCoreDataLayer saveDataContext];
     }];
}

@end
