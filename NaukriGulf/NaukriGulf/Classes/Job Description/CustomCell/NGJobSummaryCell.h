//
//  NGJobSummaryCell.h
//  NaukriGulf
//
//  Created by Minni Arora on 12/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Custom cell for job summery.
 */

@interface NGJobSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *jobDesignationLbl;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *expLbl;
@property (weak, nonatomic) IBOutlet UILabel *vacanciesLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *salaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *postedDateLbl;
@property (weak, nonatomic) IBOutlet UIView *labelConatinerView;
@property (weak, nonatomic) IBOutlet UIImageView *expImg;
@property (weak, nonatomic) IBOutlet UIImageView *posImg;
@property (weak, nonatomic) IBOutlet UIImageView *salImg;
@property (weak, nonatomic) IBOutlet UIImageView *locImg;
@property (weak, nonatomic) IBOutlet UIImageView *postImg;


-(void) configureCell : (NGJDJobDetails*) jobInfo;

@end
