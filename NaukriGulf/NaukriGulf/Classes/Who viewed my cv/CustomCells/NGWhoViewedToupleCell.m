//
//  NGWhoViewedToupleCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 30/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGWhoViewedToupleCell.h"

@implementation NGWhoViewedToupleCell

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
-(void)configureCell:(NGProfileViewDetails*)profileViewDetail{

    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled=NO;
    self.lblRecruiterName.textColor = UIColorFromRGB(0x003f7d);
    self.lblRecruiterName.text=profileViewDetail.compName;
    self.lblRecruiterType.text=profileViewDetail.indType;
    self.lblRecruiterLocation.text=profileViewDetail.compLocation;
    if([self.lblRecruiterLocation.text length] == 0)
    {
        self.lblRecruiterLocation.text = K_NOT_MENTIONED;
    }

    self.lblRecruiterViewedTime.text=[self profileViewedDate:profileViewDetail.profileViewedDate];

}
/**
 *    Informs about the time since profile viewed
 *
 *  @param date show date on which it is created
 *
 *  @return time span
 */
-(NSString*)profileViewedDate:(NSString*)date
{
    NSDate* todayDate=[NSDate date];
    NSString *dateStr = date;
    NSString* todayDateStr;
    
    // Convert string to date object
    NSDate *date_ = [NGDateManager dateFromString:dateStr WithDateFormat:@"dd MMM yyyy"];
    // Convert date object to desired output format
    dateStr = [NGDateManager stringFromDate:date_ WithDateFormat:@"dd MMM yyyy"];
    todayDateStr= [NGDateManager stringFromDate:todayDate WithDateFormat:@"dd MMM yyyy"];
    if ([dateStr isEqualToString:todayDateStr])
    {
        return @"Today";
    }
    else
    {
        NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
        NSString *yesterdayStr = [NGDateManager stringFromDate:yesterday WithDateFormat:@"dd MMM yyyy"];
        if ([dateStr isEqualToString:yesterdayStr])
        {
            return @"Yesterday";
        }
        else
        {
            return dateStr;
        }
    }
}

@end
