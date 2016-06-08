//
//  DDPGSpec.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DDBase.h"

@class DDPGCourse;

@interface DDPGSpec : DDBase

@property (nonatomic, retain) DDPGCourse *course;

+(NSSet *) PGSpecs:(NSArray *)cityArray andContext:(NSManagedObjectContext *)context;
@end
