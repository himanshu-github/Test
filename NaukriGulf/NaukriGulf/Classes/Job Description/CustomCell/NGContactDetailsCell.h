//
//  NGContactDetailsCell.h
//  NaukriGulf
//
//  Created by Minni Arora on 07/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Custom cell for recruiter's contact detail.
 */

@interface NGContactDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *websiteLbl;
@property (weak, nonatomic) IBOutlet UILabel *sectionLbl;
@property (weak, nonatomic) IBOutlet UIImageView *nameImg;
@property (weak, nonatomic) IBOutlet UIImageView *emailImg;
@property (weak, nonatomic) IBOutlet UIImageView *websiteImg;
-(void)configureContactDetailsCell:(NGJDJobDetails *)jobObj;
@end
