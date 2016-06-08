//
//  NGJobSummaryCell.m
//  NaukriGulf
//
//  Created by Minni Arora on 12/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJobSummaryCell.h"


@implementation NGJobSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _jobDesignationLbl.textColor = UIColorFromRGB(0x003f7d);
        [self.contentView setBackgroundColor: [UIColor yellowColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) configureCell : (NGJDJobDetails*) jobInfo {
    
    
    _jobDesignationLbl.text = jobInfo.designation;
    [_jobDesignationLbl getDynamicHeight];
    _companyNameLbl.text = jobInfo.companyName;
    _expLbl.text = jobInfo.formattedExperience ;
    _locationLbl.text = jobInfo.location;
    [_locationLbl getAttributedHeightOfText:_locationLbl.text havingLineSpace:K_TEXT_LINE_SPACING];
    
    _vacanciesLbl.text = jobInfo.formattedVacancies;
    _postedDateLbl.text = [NSString stringWithFormat:@"Posted on %@",jobInfo.formattedLatestPostedDate];
    
    if (![jobInfo.formattedSalary isEqualToString:K_NOT_MENTIONED])
    {
        _salaryLbl.text = [NSString stringWithFormat:@"%@ per month",jobInfo.formattedSalary];
    }
    else
        _salaryLbl.text= jobInfo.formattedSalary;
    
    if (![jobInfo.isCtcHidden isEqualToString:@"false"]) {
        _salaryLbl.text = K_NOT_MENTIONED;
    }
    
    [self setAutomationLabels];
}

-(void) setAutomationLabels {
    
    [UIAutomationHelper setAccessibiltyLabel:@"jobDesignation_lbl" value:_jobDesignationLbl.text forUIElement:_jobDesignationLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"companyName_lbl" value:_companyNameLbl.text forUIElement:_companyNameLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"exp_lbl" value:_expLbl.text forUIElement:_expLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"vacancies_lbl" value:_vacanciesLbl.text forUIElement:_vacanciesLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"location_lbl" value:_locationLbl.text forUIElement:_locationLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"salary_lbl" value:_salaryLbl.text forUIElement:_salaryLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"postedDate_lbl" value:_postedDateLbl.text forUIElement:_postedDateLbl];

}

@end
