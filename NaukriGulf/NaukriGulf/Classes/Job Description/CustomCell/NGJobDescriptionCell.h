//
//  NGJobDescriptionCell.h
//  NaukriGulf
//
//  Created by Minni Arora on 07/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

/**
 *  Custom cell for job descrption.
 */
@interface NGJobDescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *industryLbl;
@property (weak, nonatomic) IBOutlet UILabel *functionLbl;
@property (weak, nonatomic) IBOutlet UILabel *industryHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *functionHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *keySkillLbl;
@property (weak, nonatomic) IBOutlet UILabel *keySkillLblOne;
@property(nonatomic) BOOL isJDReadMoreTapped;
-(void) configureJobDescCell : (NGJDJobDetails*) jobObj;

@end
