//
//  NGCustomCell2.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 21/08/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGCustomCell2.h"

@interface NGCustomCell2(){
    
    __weak IBOutlet NSLayoutConstraint *lblTitleLeadingConstrnt;
    __weak IBOutlet NSLayoutConstraint *lblDescriptionLeadingConstrnt;

    
    __weak IBOutlet NSLayoutConstraint *lblTitleHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *lblDescriptionHeightConstraint;
}

@end

@implementation NGCustomCell2

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
    
    lblTitleLeadingConstrnt.constant = 90;
    lblDescriptionLeadingConstrnt.constant = 90;

    if(IS_IPHONE6)
    {
        
        lblTitleLeadingConstrnt.constant += 5;
        lblDescriptionLeadingConstrnt.constant += 5;
        
    }
   else if(IS_IPHONE6_PLUS)
    {
        lblTitleLeadingConstrnt.constant += 10;
        lblDescriptionLeadingConstrnt.constant += 10;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellWithTitle:(NSString*)paramTitle{
    float labelSizeHeight = [paramTitle getDynamicHeightWithFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0f] width:186.0f];
    [lblTitleHeightConstraint setConstant:labelSizeHeight];
}
- (void)setCellWithDescription:(NSString*)paramDescription{
    float labelSizeHeight = [paramDescription getDynamicHeightWithFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0f] width:186.0f];
    [lblDescriptionHeightConstraint setConstant:labelSizeHeight];
}
@end
