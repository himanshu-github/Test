//
//  DDPFCourse.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DDBase.h"

@class DDPGSpec;

@interface DDPGCourse : DDBase

@property (nonatomic, retain) NSSet *specs;
@end

@interface DDPGCourse (CoreDataGeneratedAccessors)

- (void)addSpecsObject:(DDPGSpec *)value;
- (void)removeSpecsObject:(DDPGSpec *)value;
- (void)addSpecs:(NSSet *)values;
- (void)removeSpecs:(NSSet *)values;


@end
