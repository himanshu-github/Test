//
//  NGCriticalSectionCell.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 8/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGCriticalSectionCell.h"

@implementation NGCriticalSectionCell
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

-(void)configureCell:(NGProfileSectionModalClass*)sectionObj{
 
    nameLbl.text = sectionObj.title;
    descriptionLbl.numberOfLines = 2;
    descriptionLbl.text = sectionObj.descriptionStr;
    iconImgView.image = [UIImage imageNamed:sectionObj.icon];

    [UIAutomationHelper setAccessibiltyLabel:@"criticalSectionName_lbl" value:nameLbl.text forUIElement:nameLbl];
  
    [UIAutomationHelper setAccessibiltyLabel:@"descriptionLbl_lbl" value:descriptionLbl.text forUIElement:descriptionLbl];
    
    [UIAutomationHelper setAccessibiltyLabel:sectionObj.icon forUIElement:iconImgView withAccessibilityEnabled:YES];
    
}
@end
