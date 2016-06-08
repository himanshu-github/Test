//
//  NGEditKeySkillInputCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 22/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGEditKeySkillInputCell.h"

@implementation NGEditKeySkillInputCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(self.frame.origin.x
                            , self.frame.origin.y, SCREEN_WIDTH, self.frame.size.height);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCell:(NSString*)keySkill{
    self.txtField.placeholder = @"Add Key Skills";
    self.txtField.returnKeyType = UIReturnKeyDone;
    [UIAutomationHelper setAccessibiltyLabel:@"addKeySkill_txtFld" forUIElement:self.txtField];
    self.txtField.text = keySkill;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
