//
//  ProfileViews.h
//  NaukriGulf
//
//  Created by Arun Kumar on 30/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  Core Data Class for saving recruiter information
 */
@interface ProfileViewCoreData : NSManagedObject
/**
 *  Attribute used for saving company location
 */
@property (nonatomic, retain) NSString * compLocation;
/**
 * Attribute used for saving comapny name
 */
@property (nonatomic, retain) NSString * compName;
/**
 *  Attribute used for saving current View  Date
 */
@property (nonatomic, retain) NSString * currentViewDate;
/**
 *  Attribute used for saving industry type
 */
@property (nonatomic, retain) NSString * indType;
/**
 *  Attribute used for saving profile Viewed Date
 */
@property (nonatomic, retain) NSString * profileViewedDate;

@end
