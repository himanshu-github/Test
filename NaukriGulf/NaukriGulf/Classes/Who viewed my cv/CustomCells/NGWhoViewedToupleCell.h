//
//  NGWhoViewedToupleCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 30/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGProfileViewDetails.h"
/**
 * Custom Cell display Recruiter baisc Information *(name, recruiterLocation, recruiterType)
 */
@interface NGWhoViewedToupleCell : UITableViewCell
/**
 *   label informs about the recruiter name
 */
@property (weak, nonatomic) IBOutlet NGLabel *lblRecruiterName;
/**
 *   label informs about the recruiter type
 */
@property (weak, nonatomic) IBOutlet NGLabel *lblRecruiterType;
/**
 *   label informs about the recruiter  location
 */
@property (weak, nonatomic) IBOutlet NGLabel *lblRecruiterLocation;
/**
 *  label informs about the recruiter viewed time
 */
@property (weak, nonatomic) IBOutlet NGLabel *lblRecruiterViewedTime;
/**
 *  image about Recruiter Location
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLocation;

-(void)configureCell:(NGProfileViewDetails*)profileViewDetail;

@end
