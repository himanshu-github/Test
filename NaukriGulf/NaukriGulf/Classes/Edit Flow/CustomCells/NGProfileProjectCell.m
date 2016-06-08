//
//  NGProfileProjectCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGProfileProjectCell.h"


@implementation NGProfileProjectCell{
    
       NGProjectDetailModel *modalClassObj;
     __weak IBOutlet UILabel *lblResumeHeadline;
     __weak IBOutlet UILabel *lblClient;
     __weak IBOutlet UILabel *lblDate;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setProjectData:(NGProjectDetailModel*)obj AndIndex:(NSInteger)index{
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    modalClassObj = obj;
    
    self.contentView.tag = 10+index;
    
    NSString *title = modalClassObj.title;
    
    if (0>=[vManager validateValue:title withType:ValidationTypeString].count) {
        lblResumeHeadline.text = title;
    }else{
        lblResumeHeadline.text = K_NOT_MENTIONED;
    }
    
    
    NSString *clientStr = modalClassObj.client;
    NSString *location = modalClassObj.location;
    
    NSString *onsiteStr = @"";
    if ([modalClassObj.site isEqualToString:@"0"]) {
        onsiteStr = @"Onsite";
    }else{
        onsiteStr = @"Offsite";
    }
    
    if (0>=[vManager validateValue:clientStr withType:ValidationTypeString].count) {
        lblClient.text = title;
        
        if (0>=[vManager validateValue:location withType:ValidationTypeString].count) {
            clientStr  = [clientStr stringByAppendingFormat:@"(%@:%@)",modalClassObj.location,onsiteStr];
        }else{
            clientStr  = [clientStr stringByAppendingFormat:@"(%@)",onsiteStr];
        }
        
        lblClient.text = clientStr;
        
    }else{
        lblClient.text = K_NOT_MENTIONED;
    }
    
    
    NSString *startDate = modalClassObj.startDate;
    NSString *endDate = modalClassObj.endDate;
    
    NSString *dateStr = @"";
    if (0>=[vManager validateValue:startDate withType:ValidationTypeDate].count) {
        NSString *startDateInDesiredFormat = [self getDateInDesiredFormat:startDate];
        if(startDateInDesiredFormat)
        dateStr = [dateStr stringByAppendingString:startDateInDesiredFormat];
        
        if (0>=[vManager validateValue:endDate withType:ValidationTypeDate].count) {
            if ([endDate isEqualToString:@"Present"]) {
                dateStr = [dateStr stringByAppendingFormat:@" - Present"];
            }else{
                dateStr = [dateStr stringByAppendingFormat:@" - %@",[self getDateInDesiredFormat:endDate]];
            }
        }
    }else{
        dateStr = K_NOT_MENTIONED;
    }
    
    lblDate.text = dateStr;
    
   
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"title_%ld_lbl",(long)index] value:lblResumeHeadline.text forUIElement:lblResumeHeadline];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"client_%ld_lbl",(long)index] value:lblClient.text forUIElement:lblClient];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"date_%ld_lbl",(long)index] value:lblDate.text forUIElement:lblDate];
    
    vManager = nil;
}
/**
 *  Convert Date format like 2013-12-13 to date format like Dec 12, 2013.
 *
 *  @param dateStr Date to be converted. It must be in format yyyy-MM-dd.
 *
 *  @return Returns Date with format MM DD, yyyy.
 */
-(NSString *)getDateInDesiredFormat:(NSString *)dateStr{
    // Convert string to date object
    NSDate *date = [NGDateManager dateFromString:dateStr WithDateFormat:@"yyyy-MM-dd"];
    
    // Convert date object to desired output format
    dateStr = [NGDateManager stringFromDate:date WithStyle:NSDateFormatterMediumStyle];
    
    return dateStr;
}
- (void)dealloc{
}
@end
