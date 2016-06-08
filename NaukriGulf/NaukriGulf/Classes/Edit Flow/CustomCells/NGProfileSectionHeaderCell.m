//
//  NGProfileSectionHeaderCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGProfileSectionHeaderCell.h"

@implementation NGProfileSectionHeaderCell
{

   __weak IBOutlet UILabel *lblHeaderText;
   __weak IBOutlet UIButton *btnHeaderEdit;

}
- (void)awakeFromNib {
    // Initialization code
}
-(void)customizeUIWithData:(NSString*)data{
    
    [lblHeaderText setText:data];
    [btnHeaderEdit setHidden:YES];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)headerEditButtonPressed:(id)sender{
    
}
- (void)dealloc{
}
@end
