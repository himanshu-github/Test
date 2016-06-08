//
//  NIProfileInfoCell.m
//  Naukri
//
//  Created by Swati Kaushik on 18/04/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGProfileInfoCell.h"
@implementation NGProfileInfoCell

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
-(void)configureCell{
    
    _showHideDataLabel.text = [[NGSavedData getUserDetails] objectForKey:@"modifiedDate"]?[NSString stringWithFormat:@"%@",[NGDateManager getDateInMonthDayStyle:[[NGSavedData getUserDetails] objectForKey:@"modifiedDate"]]]:@"";
    
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    NSMutableArray *vArray = [vManager validateValue:[[NGSavedData  getUserDetails]objectForKey:@"name"] withType:ValidationTypeString];
    profileNameLbl.text = (0>=vArray.count)?[[NGSavedData getUserDetails]objectForKey:@"name"]:@"My Naukri";
    designationLbl.text = [[NGSavedData  getUserDetails]objectForKey:@"currentDesignation"]?[[NGSavedData getUserDetails]objectForKey:@"currentDesignation"]:[NSString stringWithFormat:@"Designation %@",K_NOT_MENTIONED];
    
    lastUpdatedLbl.text = [[NGSavedData getUserDetails] objectForKey:@"modifiedDate"]?[NSString stringWithFormat:@"Last updated on %@",[NGDateManager getDateInMonthDayStyle:[[NGSavedData  getUserDetails] objectForKey:@"modifiedDate"]]]:@"";
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"name_lbl" value:profileNameLbl.text forUIElement:profileNameLbl];
      
    [UIAutomationHelper setAccessibiltyLabel:@"designation_lbl" value:designationLbl.text forUIElement:designationLbl];
  
    [UIAutomationHelper setAccessibiltyLabel:@"lastUpdated_lbl" value:lastUpdatedLbl.text forUIElement:lastUpdatedLbl];
    
    [UIAutomationHelper setAccessibiltyLabel:@"smalldate_lbl" value:self.showHideDataLabel.text forUIElement:self.showHideDataLabel];
    
    [UIAutomationHelper setAccessibiltyLabel:@"NGProfileInfoCell" forUIElement:self withAccessibilityEnabled:NO];
    
    vArray = nil;
    vManager = nil;
    
  }
@end
