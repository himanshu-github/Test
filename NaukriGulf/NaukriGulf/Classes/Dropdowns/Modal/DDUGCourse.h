//
//  DDUGCourse.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DDBase.h"

@class DDUGSpec;

@interface DDUGCourse : DDBase

@property (nonatomic, retain) NSSet *specs;
@end

@interface DDUGCourse (CoreDataGeneratedAccessors)

- (void)addSpecsObject:(DDUGSpec *)value;
- (void)removeSpecsObject:(DDUGSpec *)value;
- (void)addSpecs:(NSSet *)values;
- (void)removeSpecs:(NSSet *)values;

@end
