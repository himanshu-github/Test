//
//  DDCity+CoreDataProperties.h
//  NaukriGulf
//
//  Created by Nveen Bandlamoodi on 23/02/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DDCity.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCity (CoreDataProperties)

@property (nullable, nonatomic, retain) DDCountry *country;

@end

NS_ASSUME_NONNULL_END
