//
//  NGIndustryInfoCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGIndustryInfoCell.h"

@interface NGIndustryInfoCell ()
{


    __weak IBOutlet NGLabel *joinDateLbl;
    __weak IBOutlet NGLabel *industryLbl;
    __weak IBOutlet NGLabel *fareaLbl;
    __weak IBOutlet NGButton *editBtn;
    __weak IBOutlet NGLabel *fareaStaticLbl;
    __weak IBOutlet NGLabel *joinStaticLbl;
    __weak IBOutlet NGLabel *workLvlLbl;
    __weak IBOutlet NGLabel *workLvlStaticLbl;
    
    __weak IBOutlet UIImageView *redDotIndustry;
    __weak IBOutlet UIImageView *redDotFA;
    __weak IBOutlet UIImageView *redDotLevel;
    __weak IBOutlet UIImageView *redDotJoin;
    
}

- (IBAction)editTapped:(id)sender;

@end

@implementation NGIndustryInfoCell

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

-(void)customizeUI{
    redDotIndustry.hidden = YES;
    redDotFA.hidden = YES;
    redDotLevel.hidden = YES;
    redDotJoin.hidden = YES;
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    NSString *industry = [_modalClassObj.industryType objectForKey:KEY_VALUE];
    if ([industry isEqualToString:@"Other"]) {
        industry = [_modalClassObj.industryType objectForKey:KEY_SUBVALUE];
    }
    
    if (0<[vManager validateValue:industry withType:ValidationTypeString].count) {
        industry = K_NOT_MENTIONED;
        redDotIndustry.hidden = NO;
    }
    
    industryLbl.text = industry;
    [industryLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-170];
    
    NSString *farea = [_modalClassObj.fArea objectForKey:KEY_VALUE];
    if ([farea isEqualToString:@"Other"]) {
        farea = [_modalClassObj.fArea objectForKey:KEY_SUBVALUE];
    }
    
    if (0<[vManager validateValue:farea withType:ValidationTypeString].count) {
        farea = K_NOT_MENTIONED;
        redDotFA.hidden = NO;
    }
    
    fareaLbl.text = farea;
    [fareaLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-170];

    joinDateLbl.text = [_modalClassObj.noticePeriod objectForKey:KEY_VALUE];
    if (0<[vManager validateValue:joinDateLbl.text withType:ValidationTypeString].count) {
        joinDateLbl.text = K_NOT_MENTIONED;
        redDotJoin.hidden = NO;
    }
    
    workLvlLbl.text = [_modalClassObj.workLevel objectForKey:KEY_VALUE];
    if (0<[vManager validateValue:workLvlLbl.text withType:ValidationTypeString].count) {
        workLvlLbl.text = K_NOT_MENTIONED;
        redDotLevel.hidden = NO;
        
    }
    
    
    
    
    [self setAutomationLabels];
    
    vManager = nil;
}

-(void)setAutomationLabels{
    [UIAutomationHelper setAccessibiltyLabel:@"industryLbl_lbl" value:industryLbl.text forUIElement:industryLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"fareaLbl_lbl" value:fareaLbl.text forUIElement:fareaLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"joinDate_lbl" value:joinDateLbl.text forUIElement:joinDateLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"editBtn" forUIElement:editBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"editIndustryInfo_btn" forUIElement:[self.contentView viewWithTag:91]];
    [UIAutomationHelper setAccessibiltyLabel:@"workLvl_lbl" value:workLvlLbl.text forUIElement:workLvlLbl];
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotFA" value:@"redDotFA" forUIElement:redDotFA];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotIndustry" value:@"redDotIndustry" forUIElement:redDotIndustry];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotJoin" value:@"redDotJoin" forUIElement:redDotJoin];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotLevel" value:@"redDotLevel" forUIElement:redDotLevel];

}

- (IBAction)editTapped:(id)sender {
    NGEditIndustryInformationViewController *vc = [[NGEditIndustryInformationViewController alloc] initWithNibName:nil bundle:nil];
    
    vc.modalClassObj = _modalClassObj;
    vc.editDelegate = self;
    [vc updateDataWithParams:vc.modalClassObj];
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
}

#pragma mark EditCVHeadline Delegate

-(void)editedIndustryInfoWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}

- (void)dealloc{
}
@end
