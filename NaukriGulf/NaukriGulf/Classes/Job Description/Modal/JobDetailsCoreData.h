//
//  JobDetailsCoreData.h
//  NaukriGulf
//
//  Created by Nikhil bansal on 19/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
/**
 *
 *  The class used by coredata to save and retrieve Job details from local database.
 */


@interface JobDetailsCoreData : NSManagedObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * companyProfile;
@property (nonatomic, retain) NSString * contactDesignation;
@property (nonatomic, retain) NSString * contactEmail;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactWebsite;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * dcProfile;
@property (nonatomic, retain) NSString * designation;
@property (nonatomic, retain) NSString * education;
@property (nonatomic, retain) NSString * functionalArea;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * industryType;
@property (nonatomic, retain) NSString * isCtcHidden;
@property (nonatomic, retain) NSString * isEmailHiddden;
@property (nonatomic, retain) NSString * isWebjob;
@property (nonatomic, retain) NSString * isJobRedirection;
@property (nonatomic, retain) NSString * jobRedirectionUrl;


@property (nonatomic, retain) NSString * jobDescription;
@property (nonatomic, retain) NSString * jobID;
@property (nonatomic, retain) NSString * latestPostedDate;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * maxCtc;
@property (nonatomic, retain) NSString * maxExp;
@property (nonatomic, retain) NSString * minCtc;
@property (nonatomic, retain) NSString * minExp;
@property (nonatomic, retain) NSString * nationality;
@property (nonatomic, retain) NSNumber * vacancies;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString* isAlreadyApplied;
@property (nonatomic, retain) NSString* keywords;
@property (nonatomic, retain) NSString* logoURL;
@property (nonatomic, retain) NSString* showLogo;
@end
