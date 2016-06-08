//
//  NGEmployerDetailsCell.m
//  NaukriGulf
//
//  Created by Minni Arora on 07/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEmployerDetailsCell.h"

@implementation NGEmployerDetailsCell

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
 *  Displays data for employer cell.
 *
 *  @param cell Cell
 */
- (void)configureEDCell: (NGJDJobDetails *)jobObj{
    
    if (jobObj.companyProfile.length <= LABEL_CHAR_LIMIT) {
        _employerDetailsLbl.text = jobObj.shortCompanyProfile;
        [_employerDetailsLbl setDefaultValue];
        [_employerDetailsLbl getAttributedHeightOfText:_employerDetailsLbl.text
                                       havingLineSpace:K_TEXT_LINE_SPACING];
        
    }
    else{
        
        
        if (_isEDReadMoreTapped == 0) {
            [_employerDetailsLbl setDefaultValue];
             [self createAttributedLabel:_employerDetailsLbl withString:jobObj.shortCompanyProfile forSection:@"ED"];
            
        }
        else{
            _employerDetailsLbl.text = jobObj.companyProfile;
            [_employerDetailsLbl setDefaultValue];
            [_employerDetailsLbl getAttributedHeightOfText:_employerDetailsLbl.text
                                               havingLineSpace:K_TEXT_LINE_SPACING];
            
        }
        
    }
    
    [self setAutomationLabels];
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
            
            CFRelease(font);
        }
        
        return mutableAttributedString;
    }];
    [label addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"action://read-more-%@",section]] withRange:range];
    
    [label getAttributedHeightOfText:label.text havingLineSpace:K_TEXT_LINE_SPACING];
    
    [label resizeLabel];
}


-(void) setAutomationLabels{
    [UIAutomationHelper setAccessibiltyLabel:@"employerDetails_lbl" value:_employerDetailsLbl.text forUIElement:_employerDetailsLbl];

}

@end
