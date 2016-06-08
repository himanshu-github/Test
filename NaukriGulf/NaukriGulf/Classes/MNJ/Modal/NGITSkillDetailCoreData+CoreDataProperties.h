//
//  NGITSkillDetailCoreData+CoreDataProperties.h
//  NaukriGulf
//
//  Created by Nveen Bandlamoodi on 13/04/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NGITSkillDetailCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface NGITSkillDetailCoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *experience;
@property (nullable, nonatomic, retain) NSString *lastUsed;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NGMNJProfileCoreData *belongsToProfile;

@end

NS_ASSUME_NONNULL_END
