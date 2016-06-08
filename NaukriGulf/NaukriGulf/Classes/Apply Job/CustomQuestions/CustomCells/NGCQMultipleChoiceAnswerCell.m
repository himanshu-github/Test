//
//  NGCQMultipleChoiceAnswer_m
//  NaukriGulf
//
//  Created by Arun Kumar on 08/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCQMultipleChoiceAnswerCell.h"

@interface NGCQMultipleChoiceAnswerCell(){
    
    IBOutlet NGLabel *lblQuestion;
    IBOutlet NGLabel *lblQuestionText;
    IBOutlet UILabel *lblOption1;
    IBOutlet UILabel *lblOption2;
    IBOutlet UILabel *lblOption3;
    IBOutlet UILabel *lblOption4;
    IBOutlet NSLayoutConstraint *option3layoutConstraint;
    IBOutlet NSLayoutConstraint *option2LayoutConstraint;
}



@end

@implementation NGCQMultipleChoiceAnswerCell

-(void)awakeFromNib
{
    [super awakeFromNib];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
    
    UITouch *touch = [touches anyObject];
    
    
    if ([[touch view] class] == [UIImageView class])
    {
        if(([touch view] == self.option1Icon)||([touch view] == self.option2Icon)||([touch view] == self.option3Icon)||([touch view] == self.option4Icon))
        {
            
            if([self.delegateForAnsweredOptions respondsToSelector:@selector(multipleCheckMarkOptionPressed:andCell:)])
                [self.delegateForAnsweredOptions multipleCheckMarkOptionPressed:(UIImageView*)[touch view] andCell:self];
            
            
        }
        
    }
    
}

-(void)configureCQMultipleChoiceAnswerCell:(NSDictionary *)dictData{
    
    if([[dictData objectForKey:@"manadatory"] integerValue] == 1)
        lblQuestion.text =[@"Question " stringByAppendingString:[[dictData objectForKey:@"row_number"] stringByAppendingString:@" "]];
    else
        lblQuestion.text = [@"Question " stringByAppendingString:[[dictData objectForKey:@"row_number"] stringByAppendingString:@" (Optional)"]];
    
    
    lblQuestionText.text = [dictData objectForKey:@"text"];
    
    NSArray*  optionsArray=[dictData valueForKey:@"options"];
    if(optionsArray.count == 1)
    {
        
        _option1Icon.hidden = NO;
        lblOption1.hidden = NO;
        _option2Icon.hidden = YES;
        lblOption2.hidden = YES;
        _option3Icon.hidden = YES;
        lblOption3.hidden = YES;
        _option4Icon.hidden = YES;
        lblOption4.hidden = YES;
        
        lblOption1.text=[[optionsArray fetchObjectAtIndex:0] valueForKey:@"text"];
        _option1Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:0] valueForKey:@"isSelected"] integerValue]==1)
            [_option1Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
    }
    else if(optionsArray.count == 2)
    {
        _option1Icon.hidden = NO;
        lblOption1.hidden = NO;
        _option2Icon.hidden = NO;
        lblOption2.hidden = NO;
        _option3Icon.hidden = YES;
        lblOption3.hidden = YES;
        _option4Icon.hidden = YES;
        lblOption4.hidden = YES;
        
        lblOption1.text=[[optionsArray fetchObjectAtIndex:0] valueForKey:@"text"];
        _option1Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:0] valueForKey:@"isSelected"] integerValue]==1)
            [_option1Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
        
        
        
        lblOption2.text=[[optionsArray fetchObjectAtIndex:1] valueForKey:@"text"];
        _option2Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:1] valueForKey:@"isSelected"] integerValue]==1)
            [_option2Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
    }
    else if(optionsArray.count == 3)
    {
        _option1Icon.hidden = NO;
        lblOption1.hidden = NO;
        _option2Icon.hidden = NO;
        lblOption2.hidden = NO;
        _option3Icon.hidden = NO;
        lblOption3.hidden = NO;
        _option4Icon.hidden = YES;
        lblOption4.hidden = YES;
        
        
        lblOption1.text=[[optionsArray fetchObjectAtIndex:0] valueForKey:@"text"];
        _option1Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:0] valueForKey:@"isSelected"] integerValue]==1)
            [_option1Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
        
        lblOption2.text=[[optionsArray fetchObjectAtIndex:1] valueForKey:@"text"];
        _option2Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:1] valueForKey:@"isSelected"] integerValue]==1)
            [_option2Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
        
        lblOption3.text=[[optionsArray fetchObjectAtIndex:2] valueForKey:@"text"];
        _option3Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:2] valueForKey:@"isSelected"] integerValue]==1)
            [_option3Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
    }
    else if(optionsArray.count == 4)
    {
        _option1Icon.hidden = NO;
        lblOption1.hidden = NO;
        _option2Icon.hidden = NO;
        lblOption2.hidden = NO;
        _option3Icon.hidden = NO;
        lblOption3.hidden = NO;
        _option4Icon.hidden = NO;
        lblOption4.hidden = NO;
        
        lblOption1.text=[[optionsArray fetchObjectAtIndex:0] valueForKey:@"text"];
        _option1Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:0] valueForKey:@"isSelected"] integerValue]==1)
            [_option1Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
        
        lblOption2.text=[[optionsArray fetchObjectAtIndex:1] valueForKey:@"text"];
        _option2Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:1] valueForKey:@"isSelected"] integerValue]==1)
            [_option2Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
        
        lblOption3.text=[[optionsArray fetchObjectAtIndex:2] valueForKey:@"text"];
        _option3Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:2] valueForKey:@"isSelected"] integerValue]==1)
            [_option3Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
        
        lblOption4.text=[[optionsArray fetchObjectAtIndex:3] valueForKey:@"text"];
        _option4Icon.userInteractionEnabled=YES;
        if([[[optionsArray fetchObjectAtIndex:3] valueForKey:@"isSelected"] integerValue]==1)
            [_option4Icon setImage:[UIImage imageNamed:@"checked"]];
        else
            [_option4Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
        
        
    }
    
    //autolayout
    switch (optionsArray.count) {
        case 2:
            
            option2LayoutConstraint.constant = 14;
            break;
        case 3:
            
            option3layoutConstraint.constant = 14;
            [self.contentView removeConstraint:option2LayoutConstraint];
            
        default:
            break;
    }
    
    [self.contentView updateConstraints];
    
    [UIAutomationHelper setAccessibiltyLabel:@"lblQuestion" forUIElement:lblQuestion withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"lblQuestionText" forUIElement:lblQuestionText withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"option1Icon" forUIElement:_option1Icon withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"lblOption1" forUIElement:lblOption1 withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"option2Icon" forUIElement:_option2Icon withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"lblOption2" forUIElement:lblOption2 withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"option3Icon" forUIElement:_option3Icon withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"lblOption3" forUIElement:lblOption3 withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"option4Icon" forUIElement:_option4Icon withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:@"lblOption4" forUIElement:lblOption4 withAccessibilityEnabled:YES];
}


@end
