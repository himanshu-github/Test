//
//  NGHelpTextCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGHelpTextCell.h"

@implementation NGHelpTextCell
{


    __weak IBOutlet UILabel *lblHelpText;

    
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)configureCell:(NSString*)data
{
    [lblHelpText setText:data];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
