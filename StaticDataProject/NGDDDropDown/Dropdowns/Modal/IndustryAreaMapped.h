//
//  IndustryAreaMapped.h
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBase.h"

@class CompanyName;

NS_ASSUME_NONNULL_BEGIN

@interface IndustryAreaMapped : DDBase

// Insert code here to declare functionality of your managed object subclass
+(NSSet *) IAmappings:(NSArray *)faArray andContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

#import "IndustryAreaMapped+CoreDataProperties.h"
