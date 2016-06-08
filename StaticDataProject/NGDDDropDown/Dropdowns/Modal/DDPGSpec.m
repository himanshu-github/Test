//
//  DDPGSpec.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDPGSpec.h"
#import "DDPGCourse.h"


@implementation DDPGSpec

@dynamic course;

+(DDPGSpec*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
     DDPGSpec *obj = [NSEntityDescription
                      insertNewObjectForEntityForName:@"DDPGSpec"
                      inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"MastersCourseName"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"MastersCourseID"] intValue]];
    obj.headerName = @"Specialization";
    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
    
}

+(NSSet *) PGSpecs:(NSArray *)specArray andContext:(NSManagedObjectContext *)context
{
    NSMutableSet *childSet = [NSMutableSet new];
    for(NSDictionary *dict in specArray)
    {
        DDPGSpec *obj =(DDPGSpec *) [DDPGSpec localObjectWithDict:dict andContext:context];
        [childSet addObject:obj];
    }
    return childSet;
}


@end
