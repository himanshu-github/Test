//
//  NGProfileWorkExpCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGProfileWorkExpCell.h"




@implementation NGProfileWorkExpCell{
    NGWorkExpDetailModel *modalClassObj;
    
    __weak IBOutlet UILabel *lblDesignation;
    __weak IBOutlet UILabel *lblCompany;
    __weak IBOutlet UILabel *lblDate;
    __weak IBOutlet UIButton *btnWorkExpEdit;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWorkExpData:(NGWorkExpDetailModel*)obj AndIndex:(NSInteger)index{

    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    modalClassObj = obj;
    
     btnWorkExpEdit.tag = 10+index;
    
    lblDesignation.text = modalClassObj.designation;
    
    lblCompany.text = modalClassObj.organization;
    if (0<[vManager validateValue:lblDesignation.text withType:ValidationTypeString].count) {
        lblDesignation.text = K_NOT_MENTIONED;
    }
    
    if (0<[vManager validateValue:lblCompany.text withType:ValidationTypeString].count) {
        lblCompany.text = K_NOT_MENTIONED;
    }
    
    BOOL isStartDate = FALSE;
    BOOL isEndDate = FALSE;
    
    NSString *startDate = modalClassObj.startDate;
    NSString *endDate = modalClassObj.endDate;
    
    NSString *dateStr = @"";
    NSDate *date1,*date2;
    
    if (0<[vManager validateValue:startDate withType:ValidationTypeDate].count) {
        dateStr = [dateStr stringByAppendingFormat:@""];
        date1 = [NSDate date];
    }else{
        date1 = [self getDesiredDateFromString:startDate];
        
        NSString *startDateInDesiredFormat = [self getDateInDesiredFormat:startDate];
        if(startDateInDesiredFormat)
        dateStr = [dateStr stringByAppendingString:startDateInDesiredFormat];
        isStartDate = TRUE;
    }
    
    
    if (0<[vManager validateValue:endDate withType:ValidationTypeDate].count) {
        dateStr = [dateStr stringByAppendingFormat:@""];
        date2 = [NSDate date];
    }else{
        if ([endDate isEqualToString:@"Present"]) {
            dateStr = [dateStr stringByAppendingFormat:@" - Present"];
            date2 = [NSDate date];
        }else{
            dateStr = [dateStr stringByAppendingFormat:@" - %@",[self getDateInDesiredFormat:endDate]];
            date2 = [self getDesiredDateFromString:endDate];
        }
        isEndDate = TRUE;
    }
    
    
    
    NSDateComponents *components = [NGDateManager getDifferenceBTWDate:date1 withDate:date2];
    
    NSInteger years = [components year];
    NSInteger months = [components month];
    
    if (months==0) {
        dateStr = [dateStr stringByAppendingFormat:@" (%ld Years)",(long)years];
    }else if (years==0) {
        dateStr = [dateStr stringByAppendingFormat:@" (%ld Months)",(long)months];
    }else{
        dateStr = [dateStr stringByAppendingFormat:@" (%ld Years %ld Months)",(long)years,(long)months];
    }
    
    lblDate.text = dateStr;
    
    if (!isStartDate && !isEndDate) {
        lblDate.text = K_NOT_MENTIONED;
    }
    
    if (!isStartDate && isEndDate) {
        lblDate.text = @"Present";
    }
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"design_%ld_lbl",(long)index] value:lblDesignation.text forUIElement:lblDesignation];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"company_%ld_lbl",(long)index] value:lblCompany.text forUIElement:lblCompany];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"date_%ld_lbl",(long)index] value:lblDate.text forUIElement:lblDate];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"editWorkEx_%ld_btn",(long)index ]forUIElement:btnWorkExpEdit];
    
    vManager = nil;
}
/**
 *  Convert Date format like 2013-12-13 to date format like Dec, 2013.
 *
 *  @param dateStr Date to be converted. It must be in format yyyy-MM-dd.
 *
 *  @return Returns Date with format MMM, yyyy.
 */
-(NSString *)getDateInDesiredFormat:(NSString *)dateStr{
    // Convert string to date object
    NSDate *date = [NGDateManager dateFromString:dateStr WithDateFormat:@"yyyy-MM-dd"];
    
    // Convert date object to desired output format
    dateStr = [NGDateManager stringFromDate:date WithDateFormat:@"MMM, yyyy"];
    return dateStr;
}

/**
 *  Convert NSString object with format yyyy-MM-dd to NSDate object.
 *
 *  @param dateStr NSString object with format yyyy-MM-dd.
 *
 *  @return Returns NSDate object with format yyyy-MM-dd.
 */
-(NSDate *)getDesiredDateFromString:(NSString *)dateStr{
    return [NGDateManager dateFromString:dateStr WithDateFormat:@"yyyy-MM-dd"];
}
-(IBAction)workExpEditButtonPressed:(id)sender{
    NGEditWorkExperienceViewController *vc = [[NGEditWorkExperienceViewController alloc]
                                              initWithNibName:nil bundle:nil];
    vc.editDelegate = self;
    vc.modalClassObj = modalClassObj;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
}
#pragma mark Edit WorkExperience Delegate

-(void)editedWorkExpWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}
- (void)dealloc{
}
@end
