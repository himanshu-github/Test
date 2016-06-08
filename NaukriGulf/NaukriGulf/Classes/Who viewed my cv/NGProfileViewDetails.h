//
//  NGProfileViewDetails.h
//  NaukriGulf
//
//  Created by Arun Kumar on 02/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *   Cluster Object used with ProfileViewCoreData
 */
@interface NGProfileViewDetails : NSObject
/**
 *  NSString informs about the companyLocation
 */
@property (nonatomic, retain) NSString * compLocation;
/**
 *  NSString informs about company Name
 */
@property (nonatomic, retain) NSString * compName;
/**
 *  NSString informs about the currentViewDate
 */
@property (nonatomic, retain) NSString * currentViewDate;
/**
 *  NSString informs about the industry type
 */
@property (nonatomic, retain) NSString * indType;

/**
 *   NSString informs about profileViewedDate
 */
@property (nonatomic, retain) NSString * profileViewedDate;

/**
 *   NSString informs about clientID.
 */
@property (nonatomic, retain) NSString *clientID;

@end
