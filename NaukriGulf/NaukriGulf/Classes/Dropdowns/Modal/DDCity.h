//
//  DDCity.h
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DDBase.h"

@class DDCountry;

@interface DDCity : DDBase

@property (nonatomic, retain) NSSet *country;
@end

@interface DDCity (CoreDataGeneratedAccessors)

- (void)addCountryObject:(DDCountry *)value;
- (void)removeCountryObject:(DDCountry *)value;
- (void)addCountry:(NSSet *)values;
- (void)removeCountry:(NSSet *)values;

+(NSSet *) cities:(NSArray *)cityArray andContext:(NSManagedObjectContext *)context;
@end
