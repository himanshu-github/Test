//
//  DDPPGSpec.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DDBase.h"

@class DDPPGCourse;

@interface DDPPGSpec : DDBase

@property (nonatomic, retain) DDPPGCourse *course;


+(NSSet *) PPGSpecs:(NSArray *)cityArray andContext:(NSManagedObjectContext *)context;

@end
