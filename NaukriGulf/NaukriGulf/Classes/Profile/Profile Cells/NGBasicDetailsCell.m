//
//  NGBasicDetailsCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGBasicDetailsCell.h"
#import "DDCurrency.h"

@interface NGBasicDetailsCell ()
{

    __weak IBOutlet NGLabel *nameLbl;
    __weak IBOutlet NGLabel *designLbl;
    __weak  IBOutlet NGLabel *locationLbl;
    __weak IBOutlet NGLabel *visaLbl;
    __weak IBOutlet NGLabel *expLbl;
    __weak IBOutlet NGButton *editBtn;
    __weak IBOutlet UIImageView *locationImg;
    __weak IBOutlet UIImageView *expImg;
    __weak IBOutlet UIImageView *salaryImg;
    
    __weak IBOutlet UIImageView *redDotDesignation;
    
    __weak IBOutlet UIImageView *redDotLoc;

    __weak IBOutlet UIImageView *redDotVisa;
    
    __weak IBOutlet UIImageView *redDotExperience;
    
    __weak IBOutlet UIImageView *redDotSal;
}
/**
 *  The NGMNJProfileModalClass object contains the data of user's profile.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;



- (IBAction)editTapped:(id)sender;
- (IBAction)editPhotoTapped:(id)sender;

@end

@implementation NGBasicDetailsCell

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

-(void)customizeUIWithModel:(NGMNJProfileModalClass*)modalClassObj{
    
    redDotDesignation.hidden = YES;
    redDotLoc.hidden = YES;
    redDotVisa.hidden = YES;
    redDotExperience.hidden = YES;
    redDotSal.hidden = YES;
    
    
    
    _modalClassObj = modalClassObj;
    
    self.contentView.backgroundColor = [UIColor colorWithRed:26.0/255 green:131.0/255 blue:206.0/255 alpha:1.0];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    nameLbl.text = _modalClassObj.name;
    
    if (0<[vManager validateValue:nameLbl.text withType:ValidationTypeString].count) {
        nameLbl.text = K_NOT_MENTIONED;
        
    }
    
    if(![[[NGSavedData getUserDetails]objectForKey:@"name"] isEqualToString:_modalClassObj.name]){
    
        [NGSavedData saveUserDetails:@"name" withValue:_modalClassObj.name];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MNJ_NAV_TITLE_VIEW object:nil];
    }else{
        
        [NGSavedData saveUserDetails:@"name" withValue:_modalClassObj.name];
    }

    
    
    
    NSString *designation = _modalClassObj.currentDesignation;
    if (0<[vManager validateValue:designation withType:ValidationTypeString].count) {
        designLbl.text = K_NOT_MENTIONED;
        designation = @"";
        redDotDesignation.hidden = NO;
        
    }else{
        designLbl.text = designation;
    }
    
    [NGSavedData saveUserDetails:@"currentDesignation" withValue:designation];
    
    
    NSString *country = [_modalClassObj.country objectForKey:KEY_VALUE];
    NSString *city = [_modalClassObj.city objectForKey:KEY_VALUE];
    
    if ([city isEqualToString:@"Other"]) {
        city = [_modalClassObj.city objectForKey:KEY_SUBVALUE];
    }
    
    NSString *location = @"";
    location = [NSString stringWithFormat:@"%@, %@",city,country];
    if (0<[vManager validateValue:country withType:ValidationTypeString].count) {
        location = K_NOT_MENTIONED;
        redDotLoc.hidden = NO;

    }
    locationLbl.text = location;

    NSString *visaStatus = [_modalClassObj.visaStatus objectForKey:KEY_VALUE];
    if (0<[vManager validateValue:visaStatus withType:ValidationTypeString].count) {
        visaLbl.text = @"Visa Not Mentioned";
        redDotVisa.hidden = NO;

    }else{
        NSString *visaDate = _modalClassObj.visaExpiryDate ;
        if (0>=[vManager validateValue:visaDate withType:ValidationTypeDate].count) {
            visaStatus = [visaStatus stringByAppendingFormat:@"(%@)",[self getDateInDesiredFormat:visaDate]];
        }
        visaLbl.text = visaStatus;
    }
    
    NSString *years = [_modalClassObj.totalExpYears objectForKey:KEY_VALUE];
    
    NSMutableString *exp = [NSMutableString string];
    
    if (0>=[vManager validateValue:years withType:ValidationTypeString].count) {
        
        NSInteger yrs = [years integerValue];
        [exp appendFormat:@"%@ %@",years,1<yrs?@"Years":@"Year"];
    }else{
        [exp appendString:K_NOT_MENTIONED];
        redDotExperience.hidden = NO;

    }
    
    NSString *months = [_modalClassObj.totalExpMonths objectForKey:KEY_VALUE];
    if (0>=[vManager validateValue:months withType:ValidationTypeString].count) {
        NSInteger mnth = [months integerValue];
        [exp appendFormat:@" %@ %@",months,1<mnth?@"Months":@"Month"];
    }
    
    expLbl.text = exp;
    
    NSString *currency = [DDCurrency getShortCurrencyWithCurrencyValue:[_modalClassObj.currency objectForKey:KEY_VALUE]];
    if (currency)
    {
        NSString *salary = _modalClassObj.salary;
        if (0>=[vManager validateValue:salary withType:ValidationTypeString].count) {
            _salaryLbl.text = [NSString stringWithFormat:@"%@ %@ per month",salary, currency];
        }else{
            _salaryLbl.text = K_NOT_MENTIONED;
            redDotSal.hidden = NO;
            
        }
    }
    else
    {
        NSString *salary = [_modalClassObj.salary_range objectForKey:KEY_VALUE];
        if (0>=[vManager validateValue:salary withType:ValidationTypeString].count) {
            _salaryLbl.text = [NSString stringWithFormat:@"%@ USD per month",salary];
        }else{
            _salaryLbl.text = K_NOT_MENTIONED;
            redDotSal.hidden = NO;
        }
    }
    
    
    [self setAutomationLabels];
    
    
    
    [locationLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-(320-166)];
    
    
    {
    //as discussed , no need to show red dot for basic details fields.
        redDotDesignation.hidden = YES;
        redDotLoc.hidden = YES;
        redDotVisa.hidden = YES;
        redDotExperience.hidden = YES;
        redDotSal.hidden = YES;
    }
    
    
    
    vManager = nil;
}
-(void)setAutomationLabels{
    
    [UIAutomationHelper setAccessibiltyLabel:@"editBasicDetail_btn" forUIElement:editBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"name_lbl_profile" value:nameLbl.text forUIElement:nameLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"design_lbl" value:designLbl.text forUIElement:designLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"location_lbl" value:locationLbl.text forUIElement:locationLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"visa_lbl" value:visaLbl.text forUIElement:visaLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"salary_lbl" value:_salaryLbl.text forUIElement:_salaryLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"experience_lbl" value:expLbl.text forUIElement:expLbl];
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotDesignation" forUIElement:redDotDesignation];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotLoc" forUIElement:redDotLoc];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotVisa" forUIElement:redDotVisa];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotExperience" forUIElement:redDotExperience];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotSal" forUIElement:redDotSal];


    
    
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

- (IBAction)editTapped:(id)sender {
    NGEditBasicDetailsViewController *vc = [[NGEditBasicDetailsViewController alloc] init];
    vc.modalClassObj = _modalClassObj;
    vc.editDelegate = self;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
    
    [vc updateDataWithParams:vc.modalClassObj];
}

- (IBAction)editPhotoTapped:(id)sender {
    NGEditPhotoViewController *vc = [[NGEditPhotoViewController alloc]init];
    vc.editDelegate = self;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
}

#pragma mark Edit Basic Details Delegate

-(void)editedBasicDetailsWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}


#pragma mark Edit Photo Delegate

-(void)editedPhotoWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}
-(void)cancelPhotoEditing{
    
}

- (void)dealloc{
}

@end
