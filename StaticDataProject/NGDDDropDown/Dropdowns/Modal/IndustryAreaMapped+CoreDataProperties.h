//
//  IndustryAreaMapped+CoreDataProperties.h
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IndustryAreaMapped.h"

NS_ASSUME_NONNULL_BEGIN

@interface IndustryAreaMapped (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<CompanyName *> *company;

@end

@interface IndustryAreaMapped (CoreDataGeneratedAccessors)

- (void)addCompanyObject:(CompanyName *)value;
- (void)removeCompanyObject:(CompanyName *)value;
- (void)addCompany:(NSSet<CompanyName *> *)values;
- (void)removeCompany:(NSSet<CompanyName *> *)values;

@end

NS_ASSUME_NONNULL_END
