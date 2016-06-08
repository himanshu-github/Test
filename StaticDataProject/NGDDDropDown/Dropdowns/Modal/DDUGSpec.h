//
//  DDUGSpec.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DDBase.h"

@class DDUGCourse;

@interface DDUGSpec : DDBase

@property (nonatomic, retain) DDUGCourse *course;

+(NSSet *) UGSpecs:(NSArray *)array andContext:(NSManagedObjectContext *)context;

@end
