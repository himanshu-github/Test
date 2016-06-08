//
//  WebDataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseLocalDataFetcher.h"
#import "NGMNJProfileModalClass.h"
/**
 *  The class used to fetch data from the local database.
 */

@interface NGProfileDataFetcher : BaseLocalDataFetcher

/**
 *  This method is used to save profile viewers in local database.
 *
 *  @param profileViewArray list of profile viewers (NGProfileViewDetails object) to be saved.
 */
-(void) saveProfileViewTuple:(NSArray *)profileViewArray;

/**
 *  This method is used to get profile viewers from local database.
 *
 *  @return Returns the list of profile viewers (NGProfileViewDetails object).
 */
- (NSArray *) getAllProfileViews;

/**
 *  This method is used to delete profile viewers from local database.
 */
-(void)deleteAllProfileViews;

/**
 *  This method is used to save user profile to local database.
 *
 *  @param modelObj The NGMNJProfileModalClass object represents the information about user's profile.
 */
-(void)saveMNJUserProfile:(NGMNJProfileModalClass *)modelObj;

/**
 *  This method is used to get user profile from local database.
 *
 *  @return Returns the NGMNJProfileModalClass object.
 */
-(NGMNJProfileModalClass *)getMNJUserProfile;

/**
 *  This method is used to delete user profile from local database.
 */
-(void)deleteMNJUserProfile;


@end
