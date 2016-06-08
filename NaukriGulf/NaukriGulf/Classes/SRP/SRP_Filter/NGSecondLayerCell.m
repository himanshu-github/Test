//
//  NGSecondLayerCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 24/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSecondLayerCell.h"


@interface NGSecondLayerCell(){
    
    __weak IBOutlet NSLayoutConstraint *lblTitleHeightConstraint ;
    
    __weak IBOutlet NSLayoutConstraint *lblTitleWidthConstraint;
    
    __weak IBOutlet NSLayoutConstraint *lblLeadingConstaraint;
}

@end

@implementation NGSecondLayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)updateConstraintsWithSize:(CGSize)paramNewSize{
    [lblTitleHeightConstraint setConstant:paramNewSize.height];
    [lblTitleWidthConstraint setConstant:paramNewSize.width];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.textLbl.textColor=UIColorFromRGB(0X515050);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}
-(void)awakeFromNib{
    
    if(IS_IPHONE6_PLUS)
        lblLeadingConstaraint.constant = 100;
    else if (IS_IPHONE6)
        lblLeadingConstaraint.constant = 90;

    
    [UIAutomationHelper setAccessibiltyLabel:@"secondLayerCount_btn" forUIElement:_countBtn];
}
@end
