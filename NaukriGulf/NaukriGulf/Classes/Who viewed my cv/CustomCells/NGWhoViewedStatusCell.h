//
//  NGWhoViewedStatusCell.h
//  NaukriGulf
//
//  Created by Minni Arora on 03/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Custom cell informs about the profile viewed
 */
@interface NGWhoViewedStatusCell : UITableViewCell

/**
 *   A label informs about the status 
 */
@property (weak, nonatomic) IBOutlet NGLabel *lblStatus;
-(void)configureCell:(NSUInteger)dataFeed;
@end
