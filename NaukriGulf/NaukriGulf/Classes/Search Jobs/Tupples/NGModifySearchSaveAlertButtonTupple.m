//
//  NGModifySearchSaveAlertButtonTupple.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 22/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGModifySearchSaveAlertButtonTupple.h"

@implementation NGModifySearchSaveAlertButtonTupple

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)saveAlertButtonClicked:(UIButton*)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(saveAlertButtonClicked:)]){
        [_delegate saveAlertButtonClicked:sender];
    }

}
@end
