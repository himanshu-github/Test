//
//  NGKeySkillsCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGKeySkillsCell.h"

@interface NGKeySkillsCell ()
{
    IBOutlet UIButton* addKeySkillsBtn;
    __weak IBOutlet UILabel *keySkillLbl;
    __weak IBOutlet UIImageView *redDotKeySkill;
    
    
}
- (IBAction)editTapped:(id)sender;
- (IBAction)addKeySkillsTapped:(id)sender;

@end

@implementation NGKeySkillsCell

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
    redDotKeySkill.hidden = YES;
    NSArray *keySkillsArr = _modalClassObj.keySkillsList;
    
    if (keySkillsArr.count>0) {
        
        [keySkillLbl setText:[keySkillsArr componentsJoinedByString:@", "]];
    }else{
        keySkillLbl.text = K_NOT_MENTIONED;
        redDotKeySkill.hidden = NO;

    }
    
    [UIAutomationHelper setAccessibiltyLabel:@"keySkill_lbl" value:keySkillLbl.text forUIElement:keySkillLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"addKeySkillsBtn" forUIElement:addKeySkillsBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"editKeySkillsBtn" forUIElement:[self.contentView viewWithTag:99]];
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotKeySkill" value:@"redDotKeySkill" forUIElement:redDotKeySkill];

}

- (IBAction)editTapped:(id)sender {
    [self loadKeySkillViewController];
}

- (IBAction)addKeySkillsTapped:(id)sender {
    [self loadKeySkillViewController];
}

-(void)loadKeySkillViewController{
    NGEditKeySkillsViewController *vc = [[NGEditKeySkillsViewController alloc] init];
    vc.modalClassObj = _modalClassObj;
    vc.editDelegate = self;

    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
    
    [vc updateDataWithParams:vc.modalClassObj];
}
#pragma mark EditCVHeadline Delegate

-(void)editedKeySkillsWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}

- (void)dealloc{
}
@end
