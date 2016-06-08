//
//  DDPPGCourse.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DDBase.h"

@class DDPPGSpec;

@interface DDPPGCourse : DDBase

@property (nonatomic, retain) NSSet *specs;
@end

@interface DDPPGCourse (CoreDataGeneratedAccessors)

- (void)addSpecsObject:(DDPPGSpec *)value;
- (void)removeSpecsObject:(DDPPGSpec *)value;
- (void)addSpecs:(NSSet *)values;
- (void)removeSpecs:(NSSet *)values;


@end
