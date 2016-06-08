//
//  NGContactDetailCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGContactDetailCell.h"

@interface NGContactDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblEmailId;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNo;

@property (weak, nonatomic) IBOutlet UIImageView *emailIdIcon;
@property (weak, nonatomic) IBOutlet UIImageView *contactNoIcon;

@end

@implementation NGContactDetailCell

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

-(void)configure:(NGApplyFieldsModel*)model{
    self.lblEmailId.text = model.emailId;
    self.lblMobileNo.text = model.mobileNumber;
    
    [self setAccessibilityLabels];
}
-(void)setAccessibilityLabels{
    
    [UIAutomationHelper setAccessibiltyLabel:@"email_lbl" value:_lblEmailId.text forUIElement:_lblEmailId];
    [UIAutomationHelper setAccessibiltyLabel:@"mobile_lbl" value:_lblMobileNo.text forUIElement:_lblMobileNo];
    
    [UIAutomationHelper setAccessibiltyLabel:@"ContactDetailCell" forUIElement:self withAccessibilityEnabled:NO];
}
@end
