//
//  NGCustomScrollView.m
//  NaukriGulf
//
//  Created by Minni Arora on 01/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCustomScrollView.h"

@implementation NGCustomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if ([view isKindOfClass:[UITableView class]]) {
        return NO;
    }
   
    return YES;
}

-(BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    
    if ([view isKindOfClass:[UIButton class]]) {//or whatever class you want to be able to scroll in
        return YES;
    }
    
    if ([view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesMoved: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}




@end
