//
//  NGJobDescriptionCell.m
//  NaukriGulf
//
//  Created by Minni Arora on 07/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJobDescriptionCell.h"

@implementation NGJobDescriptionCell

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


-(void) configureJobDescCell : (NGJDJobDetails*) jobObj{
    
 if (jobObj.jobDescription.length <= LABEL_CHAR_LIMIT) {
            
            _descriptionLbl.text = jobObj.jobDescription ;
            [_descriptionLbl setDefaultValue];
            [_descriptionLbl getAttributedHeightOfText:_descriptionLbl.text havingLineSpace:K_TEXT_LINE_SPACING];
     
     
        }
        else{
            
            if (_isJDReadMoreTapped == 0)
            {
                [self createAttributedLabel:_descriptionLbl withString:jobObj.shortJobDescription forSection:@"JD"];
            }
            else{
                
                _descriptionLbl.text = jobObj.jobDescription ;
                [_descriptionLbl setDefaultValue];
                [_descriptionLbl getAttributedHeightOfText:_descriptionLbl.text
                                               havingLineSpace:K_TEXT_LINE_SPACING];
                
                }
            
            
            _industryHeaderLbl.hidden = NO;
            _industryLbl.hidden = NO;
            _functionHeaderLbl.hidden = NO;
            _functionLbl.hidden = NO;
            _keySkillLbl.hidden = NO;
            _keySkillLblOne.hidden = NO;
        }
   
    [self setDataInJobDescriptionCell:jobObj];
    
    [_descriptionLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-(320-287)];
    [_industryLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-142];
    [_functionLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-142];

}


-(void)setDataInJobDescriptionCell:(NGJDJobDetails*) jobObj{
    
    _industryLbl.text = jobObj.industryType;
    [_industryLbl setDefaultValue];
    [_industryLbl getAttributedHeightOfText:_industryLbl.text havingLineSpace:K_TEXT_LINE_SPACING];
    
    _functionLbl.text = jobObj.functionalArea;
    [_functionLbl setDefaultValue];
    [_functionLbl getAttributedHeightOfText:_functionLbl.text
                                havingLineSpace:K_TEXT_LINE_SPACING];

    _keySkillLbl.text = @"Keywords";
    _keySkillLblOne.text = jobObj.keywords;
    [_keySkillLblOne setDefaultValue];
    [_keySkillLblOne getAttributedHeightOfText:_keySkillLblOne.text
                                havingLineSpace:K_TEXT_LINE_SPACING];
    [self setAutomationLables];
}


-(void) setAutomationLables {
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"industry_lbl" value:_industryLbl.text forUIElement:_industryLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"function_lbl" value:_functionLbl.text forUIElement:_functionLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"description_lbl" value:_descriptionLbl.text forUIElement:_descriptionLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"industryHeader_lbl" value:_industryHeaderLbl.text forUIElement:_industryHeaderLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"functionHeader_lbl" value:_functionHeaderLbl.text forUIElement:_functionHeaderLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"keySkill_lbl" value:_keySkillLbl.text forUIElement:_keySkillLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"keySkillOne_lbl" value:_keySkillLblOne.text forUIElement:_keySkillLblOne];

}


/**
 *  Generates Read more functionailty for label text.
 *
 *  @param label   Label
 *  @param text    Label Text
 *  @param section Section in which Read more is required
 */
-(void)createAttributedLabel:(TTTAttributedLabel *)label withString: (NSString *) text forSection:(NSString *) section {
    
    NSRange range = [text rangeOfString:@"Read More"];
    [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        
        UIFont *boldSystemFont = [UIFont systemFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
            
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            
            CFRelease(font);
        }
        
        return mutableAttributedString;
    }];
    [label addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"action://read-more-%@",section]] withRange:range];
    
    [label getAttributedHeightOfText:label.text havingLineSpace:K_TEXT_LINE_SPACING];
    
    [label resizeLabel];
}




@end
