//
//  NGProfileITSkillItemCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGProfileITSkillItemCell.h"

@implementation NGProfileITSkillItemCell{
    NGITSkillDetailModel *modalObject;
}

- (void)createITSkillfromData:(NGITSkillDetailModel*)obj atIndex:(NSInteger)index{

    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    self.tag = 10+index;
    
    modalObject = obj;
    
    NSString *skillName = modalObject.name;
    if (0>=[vManager validateValue:skillName withType:ValidationTypeString].count) {
        _lblSkills.text = skillName;
    }else{
        _lblSkills.text = K_NOT_MENTIONED;
    }
    
    
    NSString *exp = modalObject.experience;
    
    if (0>=[vManager validateValue:exp withType:ValidationTypeString].count) {
        _lblDuration.text = [NSString parseExperience:exp];
    }else{
        _lblDuration.text = K_NOT_MENTIONED;
    }
    
    NSString *year = modalObject.lastUsed;
    
    if (0>=[vManager validateValue:year withType:ValidationTypeString].count) {
        _lblLastUsingYear.text = [NSString stringWithFormat:@"Last Used in %@",year];
    }else{
        _lblLastUsingYear.text = K_NOT_MENTIONED;
    }
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"itSkillLastUsed_%ld_lbl",(long)index] value:_lblLastUsingYear.text forUIElement:_lblLastUsingYear];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"itSkillDuration_%ld_lbl",(long)index] value:_lblDuration.text forUIElement:_lblDuration];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"itSkill_%ld_lbl",(long)index] value:_lblSkills.text forUIElement:_lblSkills];
    
    vManager = nil;
}
- (void)dealloc{
}
@end
