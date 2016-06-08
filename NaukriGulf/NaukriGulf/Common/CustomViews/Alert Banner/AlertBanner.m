//
//  AlertBanner.m
//  Naukri
//
//  Created by Swati Kaushik on 10/09/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "AlertBanner.h"
@interface AlertBanner()
{
    IBOutlet UILabel* headingLbl;
    IBOutlet UILabel* displayLbl;
}
@end
@implementation AlertBanner

-(id)initWithType:(BannerType)type position:(BannerPosition)position onView:(id)view duration:(float)duration title:(NSString *)title subtitle:(NSString *)subtitle priority:(BannerPriority)priority
{
    if(self)
    self = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil] fetchObjectAtIndex:0];;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, self.frame.size.height);
    
    self.bannerPosition = position;
    self.bannerType = type;
    self.baseView = view;
    self.displayTime = duration;
    self.bannerPriority = priority;
    self.alpha  = 0.9;
    NSString *alertType = @"";//for ui automation
    switch (type) {
        case BannerTypeError:
            alertType = @"Error";
            self.backgroundColor = UIColorFromRGB(0xdf4e4e);
            break;
        case BannerTypeInfo:
            alertType = @"Info";
            self.backgroundColor = UIColorFromRGB(0xc8c6c6);
            break;

        case BannerTypeSuccess:
            alertType = @"Success";
            self.backgroundColor = UIColorFromRGB(0x37995a);
            break;
        default:
            break;
    }
   
    headingLbl.text = title;
    displayLbl.text = subtitle;
    
    [self layoutIfNeeded];
    CGRect lblFrame = self.frame;
    lblFrame.size.height =  displayLbl.frame.origin.y+displayLbl.frame.size.height;
    self.frame = lblFrame;
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"headingLbl" value:headingLbl.text forUIElement:headingLbl];
    [UIAutomationHelper setAccessibiltyLabel:alertType value:displayLbl.text forUIElement:displayLbl];
    
    [UIAutomationHelper setAccessibiltyLabel:@"AlertBanner" forUIElement:self withAccessibilityEnabled:NO];
    
    return self;
}

@end
