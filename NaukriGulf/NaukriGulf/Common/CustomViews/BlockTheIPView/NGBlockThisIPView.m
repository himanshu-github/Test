//
//  NGBlockThisIPView.m
//  NaukriGulf
//
//  Created by Himanshu on 3/30/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGBlockThisIPView.h"

@implementation NGBlockThisIPView

static NGBlockThisIPView *singleton;

+ (NGBlockThisIPView *)sharedInstance {
    
    @synchronized(self) {
        if (singleton == nil) {
            
                singleton = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (IS_IPHONE5||IS_IPHONE4)?200:170)];
        }
    }
    return singleton;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:153.0/255 green:63.0/255 blue:60.0/255 alpha:1.0]];
        
        TTTAttributedLabel *titleLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-30*2, (IS_IPHONE5||IS_IPHONE4)?160:140)];
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.delegate = self;
        titleLbl.font = [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_BOLD size:15.0];
        [self addSubview:titleLbl];
        
         [self createAttributedLabel:titleLbl withString:[NSString stringWithFormat:@"%@%@%@",BLOCK_IP_MESSAGE_PART1,TECH_SUPPORT_MAIL_ID,BLOCK_IP_MESSAGE_PART2]];
        
 
        NGButton* crossBtn=  (NGButton*)[UIButton buttonWithType:UIButtonTypeCustom];
        [self setCustomButton:crossBtn withImage:[UIImage imageNamed:@"crossBtn"] withFrame:CGRectMake(SCREEN_WIDTH-40, (self.frame.size.height-40)/2, 40, 40)];
        [crossBtn addTarget:self action:@selector(hideBlockIPView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:crossBtn];

        
        
    }
    return self;
}

-(void)createAttributedLabel:(TTTAttributedLabel *)label withString: (NSString *) text {
    
    NSRange range = [text rangeOfString:TECH_SUPPORT_MAIL_ID];
    [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        UIFont *boldSystemFont = [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_BOLD size:13.0];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
            
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            
            CFRelease(font);
        }
        
        return mutableAttributedString;
    }];
    [label addLinkToURL:[NSURL URLWithString:@"action://mailIDClicked"] withRange:range];
    
    [label getAttributedHeightOfText:label.text havingLineSpace:3];
    
    [label resizeLabel];
}


-(void)setCustomButton:(NGButton*)button withImage:(UIImage*)image withFrame:(CGRect)frame
{
    [button setImage:image forState:UIControlStateNormal];
    [button setFrame:frame];
    
    if (button.tag!=42)
        [button setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    button.showsTouchWhenHighlighted = YES;
}
-(void)hideBlockIPView
{
    UIView *netView = self;
    CGPoint fadeOutToPoint;
    fadeOutToPoint = CGPointMake(netView.center.x, -CGRectGetHeight(netView.frame));
    [UIView animateWithDuration:0.5 animations:^
     {
         netView.center = fadeOutToPoint;
     } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
         _isViewShowing = NO;

     }];
    

}
-(void)showBlockIPView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBlockIPView) object:nil];
    NSArray *navArr =[(IENavigationController*)[(MFSideMenuContainerViewController*)APPDELEGATE.window.rootViewController centerViewController] viewControllers];
    UIViewController *topVC = nil;
    if(navArr.count>0)
        topVC = [navArr lastObject];
    UIView *netView = self;
    [APPDELEGATE.window addSubview:netView];
    CGPoint fadeInToPoint;
    fadeInToPoint = CGPointMake(netView.center.x, 64.0f+CGRectGetHeight(netView.frame)/2.f);
    [UIView animateWithDuration:0.5 animations:^
     {
         netView.center = fadeInToPoint;
     } completion:^(BOOL finished)
     {
         _isViewShowing = YES;
     }];
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"mailIDClicked"]) {
            
            [self hideBlockIPView];
            [self openMail];
            
        }
    }
    
}
-(void)openMail{
    
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients: [NSArray arrayWithObjects:TECH_SUPPORT_MAIL_ID,nil] ];
        [controller setSubject:BLOCK_IP_SUBJECT];
        [APPDELEGATE.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }
    else{
        [NGUIUtility showAlertWithTitle:@"Ok" message:MAIL_NOT_CONFIGURED_MESSAGE delegate:nil];
    }
    
}

#pragma mark - MFMailComposeController delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    switch (result){
        case MFMailComposeResultCancelled:
        {
        }
            break;
        case MFMailComposeResultSaved:
        {
        }
            break;
        case MFMailComposeResultSent:
        {
        }
            break;
        case MFMailComposeResultFailed:
        {
        }
            break;
        default:
            break;
    }
    [APPDELEGATE.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
