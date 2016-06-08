//
//  NGProjectDetailCoreData+CoreDataProperties.h
//  NaukriGulf
//
//  Created by Nveen Bandlamoodi on 13/04/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NGProjectDetailCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface NGProjectDetailCoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *client;
@property (nullable, nonatomic, retain) NSString *designation;
@property (nullable, nonatomic, retain) NSString *endDate;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *site;
@property (nullable, nonatomic, retain) NSString *startDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NGMNJProfileCoreData *belongsToProfile;

@end

NS_ASSUME_NONNULL_END
