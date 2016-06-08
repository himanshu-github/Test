//
//  NGDesiredCandidateCell.m
//  NaukriGulf
//
//  Created by Minni Arora on 07/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGDesiredCandidateCell.h"
#import "NGImageLabelTuple.h"
@implementation NGDesiredCandidateCell

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


/**
 *  Displays data for desire candidate cell.
 *
 *  @param cell Cell
 */

- (void)configureDesiredCandidateCell:(NGJDJobDetails *)jobObj {
    
    
    if (jobObj.dcProfile.length <= LABEL_CHAR_LIMIT) {
        _dcProfileLbl.text = jobObj.dcProfile;
 
        [_dcProfileLbl setDefaultValue];
        [_dcProfileLbl getAttributedHeightOfText:_dcProfileLbl.text
                                       havingLineSpace:K_TEXT_LINE_SPACING];
        
        
    }
    else{
        if (_isDCReadMoreTapped == 0) {
            
              [self createAttributedLabel:_dcProfileLbl withString:jobObj.shortDcProfile forSection:@"DC"];
            
        }
        else{
            _dcProfileLbl.text = jobObj.dcProfile;
            [_dcProfileLbl setDefaultValue];
            [_dcProfileLbl getAttributedHeightOfText:_dcProfileLbl.text
                                         havingLineSpace:K_TEXT_LINE_SPACING];
            
            
        }
    }
    
    
    
    _genderLbl.text = jobObj.gender;
    [_genderLbl setDefaultValue];
    
    if ([_genderLbl.text isEqualToString:@"Any"]) {
        _genderLbl.text = @"Any Gender";
    }
    
    
    _nationLbl.text = jobObj.nationality;
    [_nationLbl setDefaultValue];
    
    [_nationLbl getAttributedHeightOfText:_nationLbl.text havingLineSpace:K_TEXT_LINE_SPACING];
    
    if ([_nationLbl.text isEqualToString:@"Any"]) {
        _nationLbl.text = @"Any Nationality";
    }
    
  
    _educationLbl.text = jobObj.education;
    [_educationLbl setDefaultValue];
    
    [_educationLbl getAttributedHeightOfText:_educationLbl.text
                                 havingLineSpace:K_TEXT_LINE_SPACING];
    
  
    if ([_nationLbl.text isEqualToString:@""] ) {
        _nationLbl.hidden = YES;
        _nationImg.hidden = YES;
    }
    
    if ([_dcProfileLbl.text isEqualToString:@""] ) {
        _dcProfileLbl.hidden = YES;
        _dcImg.hidden = YES;
    }else{
        
        _dcProfileLbl.hidden = NO;
        _dcImg.hidden = NO;
        
    }
    if ([_educationLbl.text isEqualToString:@""] ) {
        _educationLbl.hidden = YES;
        _eduImg.hidden = YES;
    }
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if (![jobObj.education isEqualToString:@""]) {
        NGImageLabelTuple *obj = [[NGImageLabelTuple alloc] init];
        obj.img = _eduImg.image;
        obj.txt = jobObj.education;
        [tempArray addObject:obj];
        
    }
    
    if (![jobObj.education isEqualToString:@""]) {
        NGImageLabelTuple *obj = [[NGImageLabelTuple alloc] init];
        obj.img = _dcImg.image;
        obj.txt = _dcProfileLbl.text;
        [tempArray addObject:obj];
    }
    [_educationLbl sizeToFit];
    
    

    [self setAccessibilityLabels];
}

-(void) setAccessibilityLabels {
    
    [UIAutomationHelper setAccessibiltyLabel:@"gender_lbl" value:_genderLbl.text forUIElement:_genderLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"nation_lbl" value:_nationLbl.text forUIElement:_nationLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"education_lbl" value:_educationLbl.text forUIElement:_educationLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"dcProfile_lbl" value:_dcProfileLbl.text forUIElement:_dcProfileLbl];

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
        
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:13];
        
        
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
            
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[UIColor greenColor].CGColor range:range];
            
            CFRelease(font);
        }
                
        return mutableAttributedString;
    }];
    [label addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"action://read-more-%@",section]] withRange:range];
    
    [label getAttributedHeightOfText:label.text havingLineSpace:K_TEXT_LINE_SPACING];
    
    [label resizeLabel];
}




@end
