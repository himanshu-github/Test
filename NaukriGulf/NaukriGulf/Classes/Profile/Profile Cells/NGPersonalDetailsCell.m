//
//  NGPersonalDetailsCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGPersonalDetailsCell.h"

@interface NGPersonalDetailsCell ()
{


    __weak IBOutlet UIImageView *redDotDOB;
    __weak IBOutlet UIImageView *redDotGender;
    __weak IBOutlet UIImageView *redDotNationality;
    __weak IBOutlet UIImageView *redDotReliogion;
    __weak IBOutlet UIImageView *redDotDrivingL;
    __weak IBOutlet UIImageView *redDotMaritalStatus;
    __weak IBOutlet UIImageView *redDotLanguage;
    
    
    
    
}
@property (weak, nonatomic) IBOutlet NGLabel *dobLbl;
@property (weak, nonatomic) IBOutlet NGLabel *genderLbl;
@property (weak, nonatomic) IBOutlet NGLabel *nationalityLbl;
@property (weak, nonatomic) IBOutlet NGLabel *religionLbl;
@property (weak, nonatomic) IBOutlet NGLabel *maritalLbl;
@property (weak, nonatomic) IBOutlet NGLabel *dlLbl;
@property (weak, nonatomic) IBOutlet NGLabel *nationalityStaticLbl;
@property (weak, nonatomic) IBOutlet NGLabel *religionStaticLbl;
@property (weak, nonatomic) IBOutlet NGLabel *maritalStaticLbl;
@property (weak, nonatomic) IBOutlet NGLabel *dlStaticLbl;
@property (weak, nonatomic) IBOutlet NGLabel *languagesStaticLbl;



- (IBAction)editTapped:(id)sender;

@end

@implementation NGPersonalDetailsCell

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
    
    redDotDOB.hidden = YES;
    redDotGender.hidden = YES;
    redDotNationality.hidden = YES;
    redDotReliogion.hidden = YES;
    redDotDrivingL.hidden = YES;
    redDotMaritalStatus.hidden = YES;
    redDotLanguage.hidden = YES;
    
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    NSString *dobStr = _modalClassObj.dateOfBirth;
    
    if (0>=[vManager validateValue:dobStr withType:ValidationTypeDate].count) {
        _dobLbl.text = [NGDateManager getDateInLongStyle:dobStr];
    }else{
        _dobLbl.text = K_NOT_MENTIONED;
        redDotDOB.hidden = NO;
        
    }
    
    NSString *gender = _modalClassObj.gender;
    
    if (0>=[vManager validateValue:gender withType:ValidationTypeString].count){
        _genderLbl.text = gender;
    }else{
        _genderLbl.text = K_NOT_MENTIONED;
        redDotGender.hidden = NO;
        
    }
    
    NSString *nationality = [_modalClassObj.nationality objectForKey:KEY_VALUE];
    if (0>=[vManager validateValue:nationality withType:ValidationTypeString].count) {
        _nationalityLbl.text = nationality;
    }else{
        _nationalityLbl.text = K_NOT_MENTIONED;
        redDotNationality.hidden = NO;
    }
    
    NSString *religion = [_modalClassObj.religion objectForKey:KEY_VALUE];
    if (0>=[vManager validateValue:religion withType:ValidationTypeString].count) {
        _religionLbl.text = religion;
    }else{
        _religionLbl.text = K_NOT_MENTIONED;
        redDotReliogion.hidden = NO;
    }
    
    NSString *marital = [_modalClassObj.maritalStatus objectForKey:KEY_VALUE];
    if (0>=[vManager validateValue:marital withType:ValidationTypeString].count) {
        _maritalLbl.text = marital;
    }else{
        _maritalLbl.text = K_NOT_MENTIONED;
        redDotMaritalStatus.hidden = NO;
    }
    
    
    NSString *dl = _modalClassObj.dlStr;
    
    if (0>=[vManager validateValue:dl withType:ValidationTypeString].count) {
        if ([dl isEqualToString:@"n"]) {
            _dlLbl.text = @"No";
        }else{
            _dlLbl.text = @"Yes";
            
            NSString *dlCountry = [_modalClassObj.dlCountry objectForKey:KEY_VALUE];
            
            if (dlCountry && ![dlCountry isEqualToString:@""]) {
                _dlLbl.text = dlCountry;
            }
        }
    }else{
        _dlLbl.text = K_NOT_MENTIONED;
        redDotDrivingL.hidden = NO;
        
    }
    
    NSString *languagesStr = [_modalClassObj.languagesKnown objectForKey:KEY_VALUE];

    if(0>=[[ValidatorManager sharedInstance] validateValue:languagesStr withType:ValidationTypeString].count){
        _languagesLbl.text = languagesStr;
        
    }
    else{
        _languagesLbl.hidden = NO;
        _languagesLbl.text = K_NOT_MENTIONED;
        redDotLanguage.hidden = NO;
    }

    
    [_dobLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-150];
    [_genderLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-150];
    [_nationalityLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-150];
    [_religionLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-150];
    [_maritalLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-150];
    [_dlLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-150];
    [_languagesLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-150];

    
    
    
    [self setAutomationLabels];
    
    vManager= nil;
}
-(void)setAutomationLabels{
    [UIAutomationHelper setAccessibiltyLabel:@"dob_lbl" value:_dobLbl.text forUIElement:_dobLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"gender_lbl" value:_genderLbl.text forUIElement:_genderLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"nationality_lbl" value:_nationalityLbl.text forUIElement:_nationalityLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"religion_lbl" value:_religionLbl.text forUIElement:_religionLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"marital_lbl" value:_maritalLbl.text forUIElement:_maritalLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"dl_lbl" value:_dlLbl.text forUIElement:_dlLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"languages_lbl" value:_languagesLbl.text forUIElement:_languagesLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"editPersonalInfo_btn" forUIElement:[self.contentView viewWithTag:99]];
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotDOB" value:@"redDotDOB" forUIElement:redDotDOB];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotDrivingL" value:@"redDotDrivingL" forUIElement:redDotDrivingL];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotGender" value:@"redDotGender" forUIElement:redDotGender];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotLanguage" value:@"redDotLanguage" forUIElement:redDotLanguage];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotMaritalStatus" value:@"redDotMaritalStatus" forUIElement:redDotMaritalStatus];

    [UIAutomationHelper setAccessibiltyLabel:@"redDotNationality" value:@"redDotNationality" forUIElement:redDotNationality];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotReliogion" value:@"redDotReliogion" forUIElement:redDotReliogion];

    

    
}
- (IBAction)editTapped:(id)sender {
    NGEditPersonalDetailsViewController *vc = [[NGEditPersonalDetailsViewController alloc]init];
    vc.editDelegate = self;
    vc.modalClassObj = _modalClassObj;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
    
    [vc updateDataWithParams:vc.modalClassObj];
}

#pragma mark EditCVHeadline Delegate

-(void)editedPersonalDetailsWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}

- (void)dealloc{
}
@end
