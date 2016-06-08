//
//  NIProfileCompletionView.m
//  PercentCompletionView
//
//  Created by Swati Kaushik on 17/04/14.
//  Copyright (c) 2014 Swati Kaushik. All rights reserved.
//

#import "NGProfileCompletionView.h"
#define kCircleCentre CGPointMake(32,32)
#define kCircleRadius 22.0f

#define Clr_Grey_SearchJob  [UIColor colorWithRed:232.0/255 green:230.0/255 blue:231.0/255 alpha:1.0]

#define Clr_Profile_Blue  [UIColor colorWithRed:26.0/255 green:131.0/255 blue:206.0/255 alpha:1.0]

@implementation NGProfileCompletionView
-(id)initWithOriginPoint:(CGPoint)origin{
    
    CGRect selfFrame = CGRectMake(origin.x,origin.y, 60, 80);
    
    self = [super initWithFrame:selfFrame];
    if (self) {
        // Initialization code
        _currentValue = 0.0;
        newValue = 0.0;
        IsAnimationInProgress = NO;
        
        self.alpha = 0.95;
        self.backgroundColor = [UIColor clearColor];
    
        profileImg = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,2*kCircleRadius,2*kCircleRadius)];
        profileImg.layer.cornerRadius = kCircleRadius;
        profileImg.layer.masksToBounds = YES;
        [self refreshPhoto];
        [self addSubview:profileImg];
        
        percentCompLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,55, self.frame.size.width-10, 40.0)];
        percentCompLbl.font = [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:17.f];
        percentCompLbl.text = @"0%";
        percentCompLbl.backgroundColor = [UIColor clearColor];
        percentCompLbl.textColor = [UIColor darkGrayColor];
        percentCompLbl.textAlignment = NSTextAlignmentCenter;
        percentCompLbl.alpha = self.alpha;
        [self addSubview:percentCompLbl];
        [self createPrefilledCircle];
        [percentCompLbl setHidden:TRUE];
        
        [UIAutomationHelper setAccessibiltyLabel:@"profileImg" forUIElement:profileImg withAccessibilityEnabled:YES];
        [UIAutomationHelper setAccessibiltyLabel:@"percentCompLbl" value:percentCompLbl.text forUIElement:percentCompLbl];
        
        [UIAutomationHelper setAccessibiltyLabel:@"NGProfileCompletionView" forUIElement:self withAccessibilityEnabled:NO];
    }
    return self;
}

-(void)refreshPhoto
{
    
    NSString *imageURL = [NSString getProfilePhotoPath];
    NSString* defaultPic = @"usrPic";
    if ([[NSFileManager defaultManager]fileExistsAtPath:imageURL])
       [profileImg setImage:[UIImage imageWithContentsOfFile:imageURL]];
    else
        [profileImg setImage:[UIImage imageNamed:defaultPic]];
}
-(void)UpdateLabelsWithValue:(NSString*)value
{
    percentCompLbl.text = value;
}


-(void)setProgressValue:(float)toValue withAnimationTime:(float)animationTime
{
    float timer = 0;
    
    float step = 0.1;
    
    float value_step = (toValue-self.currentValue)*step/animationTime;
    int final_value = self.currentValue*100;
    
    while (timer<animationTime-step) {
        final_value += floor(value_step*100);
        [self performSelector:@selector(UpdateLabelsWithValue:) withObject:[NSString stringWithFormat:@"%i%%", final_value] afterDelay:timer];
        timer += step;
    }
    
    [self performSelector:@selector(UpdateLabelsWithValue:) withObject:[NSString stringWithFormat:@"%.0f%%", toValue*100] afterDelay:animationTime];
}

-(void)SetAnimationDone
{
    IsAnimationInProgress = NO;
    if (newValue>self.currentValue)
        [self setProgress:[NSNumber numberWithFloat:newValue]];
}
-(void)createPrefilledCircle{
    float start_angle = 0;
    float end_angle = 2*M_PI;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:kCircleCentre radius:kCircleRadius startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
     circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = Clr_Grey_SearchJob.CGColor;
    circle.lineWidth = 3;
    [self.layer addSublayer:circle];
}
- (void)setProgress:(NSNumber*)value{
    
    float toValue = [value floatValue];
    
    if (toValue<=self.currentValue)
        return;
    else if (toValue>1.0)
        toValue = 1.0;
    
    if (IsAnimationInProgress)
    {
        newValue = toValue;
        return;
    }
    
    IsAnimationInProgress = YES;
    
    float animationTime = toValue-self.currentValue;
    
    [self performSelector:@selector(SetAnimationDone) withObject:Nil afterDelay:animationTime];
    
    if (toValue == 1.0 && _delegate && [_delegate respondsToSelector:@selector(didFinishAnimation:)])
        [_delegate performSelector:@selector(didFinishAnimation:) withObject:self afterDelay:animationTime];
    
    [self setProgressValue:toValue withAnimationTime:animationTime];
    
    float start_angle = 2*M_PI*self.currentValue-M_PI_2;
    float end_angle = 2*M_PI*toValue-M_PI_2;
    
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    // Make a circular shape
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:kCircleCentre radius:kCircleRadius startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    
    circle.strokeColor = Clr_Profile_Blue.CGColor;
    circle.lineWidth = 3;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration            = animationTime;
    drawAnimation.repeatCount         = 0.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    self.currentValue = toValue;
}


@end
