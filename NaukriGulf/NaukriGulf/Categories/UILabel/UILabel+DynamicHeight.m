//
//  UILabel+DynamicHeight.m
//  NaukriGulf
//
//  Created by Ajeesh T S on 05/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "UILabel+DynamicHeight.h"

@implementation UILabel (DynamicHeight)

-(float)getDynamicHeight{
    
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];

    return  self.frame.size.height;
}

- (CGSize)getDynamicSize{
    CGSize size = [self expectedSize];
    CGRect newFrame = [self frame];
     newFrame.size = size;
    [self setFrame:newFrame];
    return  self.frame.size;
}


- (CGSize)expectedSize {

    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize maximumLabelSize = CGSizeMake(160.0,MAXFLOAT);
    
    CGRect labelRect = [self.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    labelRect.size.height = ceil(labelRect.size.height);
    labelRect.size.width = ceil(labelRect.size.width);
    return labelRect.size;
}

/**
 *  Calculate the expected height of UILabel basis text.
 *
 *  @return Returns the expected height.
 */
-(float)expectedHeight{
    
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,MAXFLOAT);
    CGRect labelRect = [self.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    return ceil(labelRect.size.height);
}

- (float)getAttributedHeightOfText:(NSString*)text havingLineSpace:(NSInteger)lineSpace {
    
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineSpacing:lineSpace];
    
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,MAXFLOAT);
    
    if (![NGDecisionUtility isValidNonEmptyNotNullString:text])
        text = @"";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text
                                                                                  attributes:@{NSFontAttributeName :self.font, NSParagraphStyleAttributeName : style, }];
    [attString addAttribute:NSForegroundColorAttributeName value:self.textColor
                      range:NSMakeRange(0, attString.length)];
    
    NSRange range = [text rangeOfString:@"Read More"];

    
    UIFont *boldSystemFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
    if (boldSystemFont) {
        [attString addAttribute:NSFontAttributeName value:boldSystemFont range:range];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range];
        boldSystemFont = nil;
    }
    
    self.attributedText =  attString;
    CGRect labelRect = [self.attributedText boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    float height =  ceil(labelRect.size.height);
    
    CGRect newFrame = [self frame];
    newFrame.size.height = height + 30;
    return  self.frame.size.height;
}
@end
