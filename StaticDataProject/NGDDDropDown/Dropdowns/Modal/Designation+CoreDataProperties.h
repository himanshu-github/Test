//
//  Designation+CoreDataProperties.h
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Designation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Designation (CoreDataProperties)
@property (nullable, nonatomic, retain) NSString *sortedFA_ID;

@property (nullable, nonatomic, retain) NSSet<FAMapped *> *famappings;

@end

@interface Designation (CoreDataGeneratedAccessors)

- (void)addFamappingsObject:(FAMapped *)value;
- (void)removeFamappingsObject:(FAMapped *)value;
- (void)addFamappings:(NSSet<FAMapped *> *)values;
- (void)removeFamappings:(NSSet<FAMapped *> *)values;

@end

NS_ASSUME_NONNULL_END
