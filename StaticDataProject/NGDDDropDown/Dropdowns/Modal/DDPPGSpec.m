//
//  DDPPGSpec.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDPPGSpec.h"
#import "DDPPGCourse.h"


@implementation DDPPGSpec

@dynamic course;


+(DDPPGSpec*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    DDPPGSpec *obj = [NSEntityDescription
                   insertNewObjectForEntityForName:@"DDPPGSpec"
                   inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"DoctorateCourseName"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"DoctorateCourseID"] intValue]];
    obj.headerName = @"Specialization";
    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
    
}

+(NSSet *) PPGSpecs:(NSArray *)specArray andContext:(NSManagedObjectContext *)context
{
    
    NSMutableSet *childSet = [NSMutableSet new];
    for(NSDictionary *dict in specArray)
    {
        DDPPGSpec *obj = (DDPPGSpec *)[DDPPGSpec localObjectWithDict:dict andContext:context];
        [childSet addObject:obj];
    }
    return childSet;
}

@end
