//
//  DDUGSpec.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDUGSpec.h"
#import "DDUGCourse.h"


@implementation DDUGSpec

@dynamic course;



+(DDUGSpec*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    DDUGSpec *obj = [NSEntityDescription
                     insertNewObjectForEntityForName:@"DDUGSpec"
                     inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"BasicCourseName"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"BasicCourseID"] intValue]];
    obj.headerName = @"Specialization";
    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
    
}

+(NSSet *) UGSpecs:(NSArray *)specArray andContext:(NSManagedObjectContext *)context
{
    NSMutableSet *childSet = [NSMutableSet new];
    for(NSDictionary *dict in specArray)
    {
        DDUGSpec *obj =(DDUGSpec *) [DDUGSpec localObjectWithDict:dict andContext:context];
        [childSet addObject:obj];
    }
    return childSet;
}



@end
