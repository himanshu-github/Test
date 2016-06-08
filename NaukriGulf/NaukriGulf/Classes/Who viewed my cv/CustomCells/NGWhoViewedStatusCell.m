//
//  NGWhoViewedStatusCell.m
//  NaukriGulf
//
//  Created by Minni Arora on 03/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGWhoViewedStatusCell.h"

@implementation NGWhoViewedStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCell:(NSUInteger)dataFeed{
    self.userInteractionEnabled=NO;
    self.selectionStyle=UITableViewCellEditingStyleNone;
    NSString *statusValue = [NSString stringWithFormat:@"%lu CV views/downloads in last 3 months",(unsigned long)dataFeed];
    self.lblStatus.text = statusValue;
}
@end
