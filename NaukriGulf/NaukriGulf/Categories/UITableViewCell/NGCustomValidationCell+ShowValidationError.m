//
//  NGCustomValidationCell+ShowValidationError.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 19/08/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGCustomValidationCell+ShowValidationError.h"

@implementation NGCustomValidationCell (ShowValidationError)
NSInteger const K_ERRORVIEW_TAG = 123321;

-(void)showValidationInProcess{
    
    [self setIsShowValidationError:YES];
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = tempFrame.origin.x + (tempFrame.size.width -8);
    tempFrame.size.width    =   8;
    tempFrame.origin.y      =   0;
    UIView *validationErrorView = [[UIView alloc] initWithFrame:tempFrame];
    validationErrorView.backgroundColor = [UIColor grayColor];
    validationErrorView.tag = K_ERRORVIEW_TAG;
    [self.contentView addSubview:validationErrorView];
    
    
}
-(void)showValidationError{
    
    UIView *erroView = [self.contentView viewWithTag:K_ERRORVIEW_TAG];
    if(erroView){
        erroView.backgroundColor = [UIColor redColor];
    }
    else{
        CGRect tempFrame = self.frame;
        tempFrame.origin.x = tempFrame.origin.x + (tempFrame.size.width -8);
        tempFrame.size.width = 8;
        tempFrame.origin.y   = 0;
        UIView *validationErrorView = [[UIView alloc] initWithFrame:tempFrame];
        validationErrorView.backgroundColor = [UIColor redColor];
        validationErrorView.tag = K_ERRORVIEW_TAG;
        [self.contentView addSubview:validationErrorView];
    }
    
}
-(void)hideValidationError{
    [self hideAnimationView];
}
-(void)hideAnimationView{
    
    UIView *erroView = [self viewWithTag:K_ERRORVIEW_TAG];
    if(erroView){
        [erroView removeFromSuperview];
        erroView =  nil;
    }
    
}


@end
