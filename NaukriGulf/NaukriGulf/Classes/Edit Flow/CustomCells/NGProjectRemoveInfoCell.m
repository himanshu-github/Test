//
//  NGProjectRemoveInfoCell.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/13/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGProjectRemoveInfoCell.h"


@implementation NGProjectRemoveInfoCell

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
-(void)showInformationOnBottom{
    
    float  cellHeight           =   self.frame.size.height;
    CGRect tempRect             =   self.trashImageView.frame;
    tempRect.origin.y           =   cellHeight-55;
    self.trashImageView.frame   =   tempRect;
    tempRect                    =   self.titleLabel.frame;
    tempRect.origin.y           =   cellHeight-53;
    self.titleLabel.frame       =   tempRect;
    tempRect                    =   self.InfoLabel.frame;
    tempRect.origin.y           =   cellHeight-33;
    self.InfoLabel.frame        =   tempRect;
    self.deleteButton.hidden    =   NO;
    tempRect                    =   self.deleteButton.frame;
    tempRect.origin.y           =   cellHeight-66;
    self.deleteButton.frame     =   tempRect;
    if(_infoLblStr)
        _InfoLabel.text = _infoLblStr;
    else
        _InfoLabel.text = @"This will permanently remove these details from your profile";
    
    if(_titleLblStr)
        _titleLabel.text = _titleLblStr;
    [UIAutomationHelper setAccessibiltyLabel:_infoLblStr forUIElement:_deleteButton];
}

-(IBAction)deleteButtonClicked{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteInfoCellButtonClicked)]){
        [self.delegate deleteInfoCellButtonClicked];
    }
    
}
@end