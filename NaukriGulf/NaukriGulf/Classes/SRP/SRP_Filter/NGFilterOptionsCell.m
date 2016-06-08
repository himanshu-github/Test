//
//  NGFilterOptionsCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 20/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGFilterOptionsCell.h"


@implementation NGFilterOptionsCell

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
    
    self.labelText.textColor=UIColorFromRGB(0X515050);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
}
-(void)awakeFromNib{
    
    if(IS_IPHONE6_PLUS)
        _lblTextLeadingConstraint.constant = 100;
    [UIAutomationHelper setAccessibiltyLabel:@"FilterNumbers_btn" forUIElement:_filterNumbersBtn];
}

- (void)updateConstraintsWithSize:(CGSize)paramNewSize{
    
    
}
@end
