//
//  NGResmanHalfWayStatusTableViewCell.m
//  NaukriGulf
//
//  Created by Maverick on 29/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanHalfWayStatusTableViewCell.h"

@interface NGResmanHalfWayStatusTableViewCell(){
    
    IBOutlet UILabel* lblApplyStatus;
}

@end

@implementation NGResmanHalfWayStatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(BOOL)status{
    
    lblApplyStatus.text = (status == true)?@"You have successfully applied to the job":ERROR_MESSAGE_DUPLICATE_APPLY;
    lblApplyStatus.backgroundColor = (status == true)?UIColorFromRGB(0x37995a):UIColorFromRGB(0xdf4e4e);
}
@end
