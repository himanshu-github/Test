//
//  NGContactDetailsCell.m
//  NaukriGulf
//
//  Created by Minni Arora on 07/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGContactDetailsCell.h"

@implementation NGContactDetailsCell

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



/**
 *  Displays data for recruiter's contact detail cell.
 *
 *  @param cell Cell
 */

-(void)configureContactDetailsCell:(NGJDJobDetails *)jobObj{
    
    [_nameLbl setText:jobObj.contactName];
    [_nameLbl setDefaultValue];
    
    _websiteLbl.text = jobObj.contactWebsite;
    [_websiteLbl setDefaultValue];
    
    [self setAutomationLabels];
}
-(void) setAutomationLabels {
    
    [UIAutomationHelper setAccessibiltyLabel:@"name_lbl" value:_nameLbl.text forUIElement:_nameLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"website_lbl" value:_websiteLbl.text forUIElement:_websiteLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"section_lbl" value:_sectionLbl.text forUIElement:_sectionLbl];

}
@end
