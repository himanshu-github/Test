//
//  DDUGCourse.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDUGCourse.h"
#import "DDUGSpec.h"


@implementation DDUGCourse

@dynamic specs;

+(DDUGCourse*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    static int i = 0;

    DDUGCourse *obj = [NSEntityDescription
                       insertNewObjectForEntityForName:@"DDUGCourse"
                       inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"BasicDegreeName"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"BasicDegreeID"] intValue]];
    obj.headerName = @"Course";
    obj.sortedID = [NSNumber numberWithInt:i++];

    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
    
}

+(void)updateDataFromTextFile
{
    NSManagedObjectContext *temporaryContext = [NGDatabaseHelper privateMoc];
    [temporaryContext performBlockAndWait:^
     {
         NSError* error = nil;
         NSArray *arr = [NGStaticContentManager getNewDropDownData:DDC_UGCOURSE];
         for(NSDictionary *dict in arr)
         {
             DDUGCourse *course = (DDUGCourse *)[DDUGCourse localObjectWithDict:dict andContext:temporaryContext ];
             [course addSpecs: [DDUGSpec UGSpecs: [dict objectForKey:@"BasicCourseList"] andContext:temporaryContext]];
         }
         if ([temporaryContext save:&error])
             [NGDropDownModel saveDataContext];
     }];    
}


@end
