//
//  NGUploadResumeViaEmailView.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 29/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGUploadResumeViaEmailView.h"

@implementation NGUploadResumeViaEmailView

- (IBAction)okButtonClicked:(id)sender {
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^
     {
         self.leadingConstraint.constant = SCREEN_WIDTH;
         [self.superview layoutIfNeeded];
         
     }completion:^(BOOL finished) {
         
         [self removeFromSuperview];
         [[((UIViewController*)self.delegate).navigationController.view viewWithTag:1010] removeFromSuperview];
         
     }];
    
}


- (id)init
{
    if (self) {
        // Initialization code
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"ResumeEmailUploadView" owner:self options:nil] fetchObjectAtIndex:0];
        
    }
    return self;
}

@end
