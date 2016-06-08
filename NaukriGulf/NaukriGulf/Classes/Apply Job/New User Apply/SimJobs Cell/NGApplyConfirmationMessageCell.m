//
//  NGApplyConfirmationMessageCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 04/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGApplyConfirmationMessageCell.h"

@interface NGApplyConfirmationMessageCell(){
    
 IBOutlet UILabel* bottomLbl;
 IBOutlet UILabel* designLbl;
    
}
@end

@implementation NGApplyConfirmationMessageCell

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

-(void)configureACMessageCell:(NSString*)message{
    
    self.userInteractionEnabled = NO;
    designLbl.text = message;
    
    [UIAutomationHelper setAccessibiltyLabel:@"ApplyConfirmationMessageCellDesignation"
                                       value:designLbl.text forUIElement:designLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"ApplyConfirmationMessageCell"
                                        forUIElement:self withAccessibilityEnabled:NO];

}
@end
