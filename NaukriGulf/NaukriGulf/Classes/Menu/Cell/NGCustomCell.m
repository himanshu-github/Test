//
//  NGCustomCell.m
//  NaukriGulf
//
//  Created by Iphone Developer on 30/05/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCustomCell.h"

@implementation NGCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect frameRectForKws = self.textLabel.frame;
        frameRectForKws.origin.x = 100.0;
        self.textLabel.frame = frameRectForKws;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
