//
//  SRPTuplesCoreData.h
//  NaukriGulf
//
//  Created by Minni Arora on 21/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



/**
 *  The class used by coredata to save and retrieve Job touple from local database.
 */

@interface SRPTuplesCoreData : NSManagedObject

@property (nonatomic, retain) NSString * designation;
@property (nonatomic, retain) NSString * srpDescription;
@property (nonatomic, retain) NSString * cmpnyName;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * jobID;
@property (nonatomic, retain) NSString * jdURL;
@property (nonatomic, retain) NSString * jobType;
@property (nonatomic, retain) NSString * latestPostDate;
@property (nonatomic, retain) NSString * minExp;
@property (nonatomic, retain) NSString * maxExp;
@property (nonatomic, retain) NSNumber * vacancy;
@property (nonatomic, retain) NSString * cmpnyID;
@property (nonatomic, retain) NSNumber * isTopEmployer;
@property (nonatomic, retain) NSNumber * isTopEmployerLite;
@property (nonatomic, retain) NSNumber * isFeaturedEmployer;
@property (nonatomic, retain) NSNumber * isWebJob;
@property (nonatomic, retain) NSNumber * isQuickWebJob;
@property (nonatomic, retain) NSNumber * isPremiumJob;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString *logoURL;
@property (nonatomic, retain) NSString *tELogoURL;


@end
