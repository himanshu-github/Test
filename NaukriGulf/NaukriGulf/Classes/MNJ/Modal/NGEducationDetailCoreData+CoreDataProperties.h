//
//  NGEducationDetailCoreData+CoreDataProperties.h
//  NaukriGulf
//
//  Created by Nveen Bandlamoodi on 13/04/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NGEducationDetailCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface NGEducationDetailCoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) id country;
@property (nullable, nonatomic, retain) id course;
@property (nullable, nonatomic, retain) id specialization;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *year;
@property (nullable, nonatomic, retain) NGMNJProfileCoreData *belongsToProfile;

@end

NS_ASSUME_NONNULL_END
