//
//  CompanyName+CoreDataProperties.h
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompanyName.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyName (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sortedIA_ID;
@property (nullable, nonatomic, retain) NSSet<IndustryAreaMapped *> *iamappings;

@end

@interface CompanyName (CoreDataGeneratedAccessors)

- (void)addIamappingsObject:(IndustryAreaMapped *)value;
- (void)removeIamappingsObject:(IndustryAreaMapped *)value;
- (void)addIamappings:(NSSet<IndustryAreaMapped *> *)values;
- (void)removeIamappings:(NSSet<IndustryAreaMapped *> *)values;

@end

NS_ASSUME_NONNULL_END
