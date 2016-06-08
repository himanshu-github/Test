//
//  NGCQDescrptiveAnswerCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCQDescrptiveAnswerCell.h"
#import "UIPlaceHolderTextView.h"

@interface NGCQDescrptiveAnswerCell(){

 IBOutlet UIPlaceHolderTextView *txtViewDescrptiveAnswer;
 IBOutlet NGLabel *lblQuestion;
 IBOutlet NGLabel *lblQuestionText;
}

@end

@implementation NGCQDescrptiveAnswerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //txtViewDescrptiveAnswer = txtViewDescrptiveAnswer;
//    self.txtViewDescrptiveAnswer= self.txtViewDescrptiveAnswer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)configureCQDescriptiveAnswerCell:(NSDictionary*)dictData{
    
    if([[dictData objectForKey:@"manadatory"] integerValue] == 1)
        lblQuestion.text = [@"Question " stringByAppendingString:[[dictData objectForKey:@"row_number"] stringByAppendingString:@" "]];
    else
        lblQuestion.text = [@"Question " stringByAppendingString:[[dictData objectForKey:@"row_number"]  stringByAppendingString:@" (Optional)"]];
    
    
    lblQuestionText.text = [dictData objectForKey:@"text"];
    
    txtViewDescrptiveAnswer.placeholder = @"Write your answer here";
    txtViewDescrptiveAnswer.placeholderTextColor = [UIColor grayColor];
    txtViewDescrptiveAnswer.textColor = [UIColor blackColor];
    
    if([dictData objectForKey:@"AnsText"])
        txtViewDescrptiveAnswer.text  = [dictData objectForKey:@"AnsText"];
    else
        txtViewDescrptiveAnswer.text  = @"";

    [UIAutomationHelper setAccessibiltyLabel:@"txtViewDescrptiveAnswer" forUIElement:txtViewDescrptiveAnswer withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"lblQuestion" forUIElement:lblQuestion withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"option4Icon" forUIElement:lblQuestionText withAccessibilityEnabled:YES];
}

@end
