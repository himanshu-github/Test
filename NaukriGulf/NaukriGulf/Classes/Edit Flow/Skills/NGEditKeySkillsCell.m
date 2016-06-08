//
//  NGEditKeySkillsCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 23/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEditKeySkillsCell.h"
@interface NGEditKeySkillsCell()
@property (weak, nonatomic) IBOutlet UILabel *keySkillsLbl;
@property (weak,nonatomic)   IBOutlet UIButton* editBtn;
@property  (weak,nonatomic)  IBOutlet UIButton* deleteBtn;



@end
@implementation NGEditKeySkillsCell

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
-(void)configureCell:(NSString*)keySkill{

    NSString *trimmedString = [keySkill trimCharctersInSet :
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.keySkillsLbl.text = trimmedString;
    
    
    NSString *labelString =  [@"skill_lbl" stringByAppendingString:[NSString stringWithFormat:@"_%ld",self.index?(long)self.index:0]];
    NSString *editButtonAccessibilityLabel =  [@"edit_btn" stringByAppendingString:[NSString stringWithFormat:@"_%ld",self.index?(long)self.index:0]];
    NSString *deleteButtonAccesibilityLabel =  [@"delete_btn" stringByAppendingString:[NSString stringWithFormat:@"_%ld",self.index?(long)self.index:0]];
    
    [UIAutomationHelper setAccessibiltyLabel:labelString value:self.keySkillsLbl.text forUIElement:self.keySkillsLbl];
    [UIAutomationHelper setAccessibiltyLabel:editButtonAccessibilityLabel forUIElement:self.editBtn];
    [UIAutomationHelper setAccessibiltyLabel:deleteButtonAccesibilityLabel forUIElement:self.deleteBtn];
}
- (IBAction)deleteTapped:(id)sender {
    [self.delegate deleteKeySkillAtIndex:self.index];
}

- (IBAction)editTapped:(id)sender {
    [self.delegate editKeySkillAtIndex:self.index];
}


@end
