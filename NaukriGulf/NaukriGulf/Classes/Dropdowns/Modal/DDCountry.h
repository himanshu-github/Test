//
//  DDCountry.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DDBase.h"

@class DDCity;

@interface DDCountry : DDBase

@property (nonatomic, retain) NSSet *cities;
@end

@interface DDCountry (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(DDCity *)value;
- (void)removeCitiesObject:(DDCity *)value;
- (void)addCities:(NSSet *)values;
- (void)removeCities:(NSSet *)values;

@end
