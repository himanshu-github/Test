//
//  NGBasicInfoCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 27/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGBasicInfoCell.h"

@interface NGBasicInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UILabel *lblDesignation;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblNationality;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblExp;

@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imgNationality;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgExp;

@end

@implementation NGBasicInfoCell

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

-(void)configure:(NGApplyFieldsModel*)model
{    
    self.lblName.text = model.name;
    self.lblDesignation.text = model.currentDesignation;
    
    NSString* exp = [model getFinalExperience];
    self.lblExp.text = exp;
    
    NSString* location = @"";
    if([model.country objectForKey:KEY_VALUE ])
        location = [[[model.city objectForKey:KEY_VALUE] stringByAppendingString:@" - "] stringByAppendingString:[model.country objectForKey:KEY_VALUE ] ];
    else
        location = [model.city objectForKey:KEY_VALUE];
    
    self.lblLocation.text = location;
    
    self.lblNationality.text = [model.nationality objectForKey:KEY_VALUE];
    
    self.lblGender.text = model.gender;
    
    [self setAccessibilityLabels];
}

-(void)setAccessibilityLabels{
    
    [UIAutomationHelper setAccessibiltyLabel:@"name_lbl" value:_lblName.text forUIElement:_lblName];
    
    [UIAutomationHelper setAccessibiltyLabel:@"designation_lbl" value:_lblDesignation.text forUIElement:_lblDesignation];
    
    [UIAutomationHelper setAccessibiltyLabel:@"exp_lbl" value:_lblExp.text forUIElement:_lblExp];
    
    [UIAutomationHelper setAccessibiltyLabel:@"location_lbl" value:_lblLocation.text forUIElement:_lblLocation];
    
    [UIAutomationHelper setAccessibiltyLabel:@"nationality_lbl" value:_lblNationality.text forUIElement:_lblNationality];
    
    [UIAutomationHelper setAccessibiltyLabel:@"gender_lbl" value:_lblGender.text forUIElement:_lblGender];
    
    [UIAutomationHelper setAccessibiltyLabel:@"BasicInfoCell" forUIElement:self withAccessibilityEnabled:NO];
}

@end
