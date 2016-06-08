//
//  NGDesiredJobCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGDesiredJobCell.h"

@interface NGDesiredJobCell ()
{



    __weak IBOutlet UIImageView *redDotEmployementType;
    __weak IBOutlet UIImageView *redDotEmloyeStatus;
    __weak IBOutlet UIImageView *redDotPreferedLocation;
}

@property (weak, nonatomic) IBOutlet NGLabel *employmentStaticLbl;
@property (weak, nonatomic) IBOutlet NGLabel *preferredLocLbl;
@property (weak, nonatomic) IBOutlet NGLabel *employmentTypeStaticLbl;
@property (weak, nonatomic) IBOutlet NGLabel *employmentTypeLbl;

- (IBAction)editTapped:(id)sender;

@end

@implementation NGDesiredJobCell

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
    
    redDotEmployementType.hidden = YES;
    redDotEmloyeStatus.hidden = YES;
    redDotPreferedLocation.hidden = YES;
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    NSString* locationStr = [_modalClassObj.preferredWorkLocation objectForKey:KEY_VALUE];
    _preferredLocLbl.text = nil;
    
    if(0>=[vManager validateValue:locationStr withType:ValidationTypeString].count){
        _preferredLocLbl.text = locationStr;
    }else{
        _preferredLocLbl.text = K_NOT_MENTIONED;
        [_preferredLocLbl makeItHighlightedField];
        redDotPreferedLocation.hidden = NO;
        
    }
    
    NSString *employmentStatus = [_modalClassObj.employmentStatus objectForKey:KEY_VALUE];
    NSString *employmentType = [_modalClassObj.employmentType objectForKey:KEY_VALUE];

    _employeeStatusLbl.text = employmentStatus;
    _employmentTypeLbl.text = employmentType;
    
    if (0<[vManager validateValue:_employeeStatusLbl.text withType:ValidationTypeString].count) {
        _employeeStatusLbl.text = K_NOT_MENTIONED;
        [_employeeStatusLbl makeItHighlightedField];
        redDotEmloyeStatus.hidden = NO;
        
        
    }
    
    if (0<[vManager validateValue:_employmentTypeLbl.text withType:ValidationTypeString].count) {
        _employmentTypeLbl.text = K_NOT_MENTIONED;
        [_employmentTypeLbl makeItHighlightedField];
        redDotEmployementType.hidden = NO;
    }
    
    [_preferredLocLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-170];
    [_employeeStatusLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-170];
    [_employmentTypeLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-170];

   
    [self setAutomationLabels];
    
    vManager = nil;
}

-(void)setAutomationLabels{
    [UIAutomationHelper setAccessibiltyLabel:@"employmentType_lbl" value:_employmentTypeLbl.text forUIElement:_employmentTypeLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"preferredLoc_lbl" value:_preferredLocLbl.text forUIElement:_preferredLocLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"employeeStatus_lbl" value:_employeeStatusLbl.text forUIElement:_employeeStatusLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"editDesiredJob_btn" forUIElement:[self.contentView viewWithTag:99]];
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotEmployementType" value:@"redDotEmployementType" forUIElement:redDotEmployementType];

    [UIAutomationHelper setAccessibiltyLabel:@"redDotEmloyeStatus" value:@"redDotEmloyeStatus" forUIElement:redDotEmloyeStatus];

    [UIAutomationHelper setAccessibiltyLabel:@"redDotPreferedLocation" value:@"redDotPreferedLocation" forUIElement:redDotPreferedLocation];

}

- (IBAction)editTapped:(id)sender {
    NGEditDesiredJobsViewController *vc = [[NGEditDesiredJobsViewController alloc] initWithNibName:nil bundle:nil];
    
    vc.modalClassObj = _modalClassObj;
    vc.editDelegate = self;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
}

#pragma mark EditCVHeadline Delegate

-(void)editedDesiredJobWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}

- (void)dealloc{
}
@end
