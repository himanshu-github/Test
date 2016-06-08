//
//  NGUserDetails.h
//  NaukriGulf
//
//  Created by Arun Kumar on 19/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The class used to save the details of user.
 */
@interface NGUserDetails : NSObject

/**
 *  ConMNJ of user. It works as a auth token.
 */
@property (nonatomic, strong) NSString *conmnj;

/**
 *  Name of user.
 */
@property (nonatomic, strong) NSString *name;

/**
 *  Designation of user.
 */
@property (nonatomic, strong) NSString *designation;

/**
 *  Base64 encoded string of profile photo image.
 */
@property (nonatomic, strong) NSString *profileImgStr;

/**
 *  Last modified date of resume.
 */
@property (nonatomic, strong) NSString *lastModifiedDate;

/**
 *  Last Modified date of profile photo.
 */
@property (nonatomic, strong) NSString *photoModifiedDate;

/**
 *  Local url (Document directory url) of profile photo.
 */
@property (nonatomic, strong) NSString *photoURL;

@end
