//
//  NGResmanFresherOrExpTableViewCell.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/14/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanFresherOrExpTableViewCell.h"


@interface NGResmanFresherOrExpTableViewCell(){
    __weak IBOutlet UIImageView *imgView;
    __weak IBOutlet UILabel *txtLabel;
}

@end

@implementation NGResmanFresherOrExpTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCell:(NSIndexPath*)index {
    
    switch (index.row) {
            
        case 1:{
            imgView.image = [UIImage imageNamed:@"professional"];
            txtLabel.text = @"I am an Experienced Professional";
            [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@_imgView",@"professional"] forUIElement:imgView withAccessibilityEnabled:YES];

            break;
        }
        case 2:{
            imgView.image = [UIImage imageNamed:@"fresher"];
            txtLabel.text = @"I am a Fresher & Starting my Career";
            [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@_imgView",@"fresher"] forUIElement:imgView withAccessibilityEnabled:YES];
            break;

        }
            
    }
    self.tag = index.row;
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@_lbl",txtLabel.text] forUIElement:txtLabel withAccessibilityEnabled:YES];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"NGResmanFresherOrExpTableViewCell_%ld",(long)self.tag] forUIElement:self withAccessibilityEnabled:NO];
}

@end
