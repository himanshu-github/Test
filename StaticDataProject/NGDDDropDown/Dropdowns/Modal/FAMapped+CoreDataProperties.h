//
//  FAMapped+CoreDataProperties.h
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FAMapped.h"

NS_ASSUME_NONNULL_BEGIN

@interface FAMapped (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *designation;

@end

@interface FAMapped (CoreDataGeneratedAccessors)

- (void)addDesignationObject:(NSManagedObject *)value;
- (void)removeDesignationObject:(NSManagedObject *)value;
- (void)addDesignation:(NSSet<NSManagedObject *> *)values;
- (void)removeDesignation:(NSSet<NSManagedObject *> *)values;
+(NSSet *) famappings:(NSArray *)faArray andContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END
