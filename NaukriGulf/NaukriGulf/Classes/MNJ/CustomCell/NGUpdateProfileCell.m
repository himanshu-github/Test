//
//  NIUpdateProfileCell.m
//  Naukri
//
//  Created by Arun Kumar on 6/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGUpdateProfileCell.h"

@implementation NGUpdateProfileCell
@synthesize delegate;

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

- (IBAction)onUpadteProfile:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onUpdateProfile)])
        [self.delegate onUpdateProfile];
    
}

@end
