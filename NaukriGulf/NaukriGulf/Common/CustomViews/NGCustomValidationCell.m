//
//  NGCustomValidationCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 19/08/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGCustomValidationCell.h"

@implementation NGCustomValidationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIsShowValidationError:(BOOL)isShowValidationError{
    _isShowValidationError = isShowValidationError;
}
@end
