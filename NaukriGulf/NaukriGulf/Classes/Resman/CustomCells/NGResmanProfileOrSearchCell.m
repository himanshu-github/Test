//
//  NGResmanProfileOrSearchCell.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/13/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanProfileOrSearchCell.h"


@interface NGResmanProfileOrSearchCell(){
    
    __weak IBOutlet UIImageView *imgView;
    __weak IBOutlet UILabel *titleLbl;
    __weak IBOutlet UILabel *descLbl;
    
}

@end

@implementation NGResmanProfileOrSearchCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) configureCell{
    
    switch (self.index) {
        case kResmanProfileOrSearchRowTypeProfileOption:
            
            imgView.image = [UIImage imageNamed:@"resman_profile"];
            titleLbl.text = @"Complete Your Profile Now!";
            descLbl.text = @"Employers strongly prefer profiles with complete information";
            break;
        
        case kResmanProfileOrSearchRowTypeSearchOption:
            imgView.image = [UIImage imageNamed:@"resman_search"];
            titleLbl.text = @"Start with Job Search";
            descLbl.text = @"Proceed to Job Search";
            CGRect frame = descLbl.frame;
            frame.origin.y -= 20;
            [descLbl setFrame:frame];
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
