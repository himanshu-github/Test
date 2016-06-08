//
//  NGVacancyCustomCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 16/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGVacancyCustomCell : UITableViewCell

@property (nonatomic, weak)IBOutlet NGLabel *vacancyLbl;
@property (weak, nonatomic) IBOutlet UIButton *modifySearchBtn;

/**
 *  Display total no of jobs & vacancies view
 *
 *  @param totalJobs    total number of jobs
 *  @param totalVacancy total number of vacancies
 */
-(void)displayDataWithTotalJobs:(NSInteger)totalJobs Vacancies:(NSInteger)totalVacancy;

@end
