//
//  NGVacancyCustomCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGVacancyCustomCell.h"

@implementation NGVacancyCustomCell

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


-(void)displayDataWithTotalJobs:(NSInteger)totalJobs Vacancies:(NSInteger)totalVacancy{
    
    self.vacancyLbl.text = [NSString stringWithFormat:@"%ld Jobs",(long)totalJobs];
    self.vacancyLbl.preferredMaxLayoutWidth = (SCREEN_WIDTH - self.modifySearchBtn.frame.size.width - 20.0); // 20.0  = (Left Padding + Right Padding)
    [UIAutomationHelper setAccessibiltyLabel:@"Vacancy_lbl" value:self.vacancyLbl.text forUIElement:self.vacancyLbl];
}

@end
