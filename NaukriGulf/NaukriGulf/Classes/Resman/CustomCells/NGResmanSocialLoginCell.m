//
//  NGResmanSocialLoginCell.m
//  NaukriGulf
//
//  Created by Nveen Bandlamoodi on 09/03/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGResmanSocialLoginCell.h"
#import <GoogleSignIn/GoogleSignIn.h>

@implementation NGResmanSocialLoginCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)facebookButtonTapped:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(facebookButtonPressed)])
    {
        [_delegate facebookButtonPressed];
    }
}

- (IBAction)googleButtonTapped:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(gPlusButtonPressed)])
    {
        [_delegate gPlusButtonPressed];
    }
}

@end
