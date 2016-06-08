//
//  NGDesiredCandidateCell.h
//  NaukriGulf
//
//  Created by Minni Arora on 07/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

/**
 *  Custom cell for desired candidate's detail.
 */

@interface NGDesiredCandidateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;
@property (weak, nonatomic) IBOutlet UILabel *nationLbl;
@property (weak, nonatomic) IBOutlet UILabel *educationLbl;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *dcProfileLbl;
@property (weak, nonatomic) IBOutlet UIImageView *eduImg;
@property (weak, nonatomic) IBOutlet UIImageView *dcImg;
@property (weak, nonatomic) IBOutlet UIImageView *nationImg;
@property(nonatomic) BOOL isDCReadMoreTapped;
- (void)configureDesiredCandidateCell:(NGJDJobDetails *)jobObj ;


@end
