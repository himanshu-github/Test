//
//  NGNetworkStatusView.m
//  NaukriGulf
//
//  Created by Himanshu Gupta on 17/08/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGNetworkStatusView.h"

@implementation NGNetworkStatusView

static NGNetworkStatusView *singleton;

+ (NGNetworkStatusView *)sharedInstance {
    
    @synchronized(self) {
        if (singleton == nil) {
            
            
           singleton = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            
        }
    }
    return singleton;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:UIColorFromRGB(0xF2E1E1)];
        NSMutableDictionary* dictionaryForTitleLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                    [NSNumber numberWithInt:0],KEY_TAG,
                                                    [NSValue valueWithCGRect:CGRectMake(30, 10, 282, 20)],KEY_FRAME,
                                                    nil];
        
        NGLabel* titleLbl=(NGLabel*)   [NGViewBuilder createView:dictionaryForTitleLbl];
        
        NSMutableDictionary* dictionaryForTitleStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor clearColor],KEY_BACKGROUND_COLOR,
                                                      [NSString stringWithFormat:@"%@",@"Internet Connection not available"],KEY_LABEL_TEXT,
                                                      [NSNumber numberWithInteger:NSTextAlignmentLeft],kEY_LABEL_ALIGNMNET,
                                                      UIColorFromRGB(0xF21D40),KEY_TEXT_COLOR,
                                                      FONT_STYLE_HELVITCA_LIGHT,KEY_FONT_FAMILY,FONT_SIZE_15,KEY_FONT_SIZE,nil];
        
        [titleLbl setLabelStyle:dictionaryForTitleStyle];
        [self addSubview:titleLbl];
        NGButton* infoIcon=  (NGButton*)[UIButton buttonWithType:UIButtonTypeCustom];
        [self setCustomButton:infoIcon withImage:[UIImage imageNamed:@"Error"] withFrame:CGRectMake(5, 10, 20, 20)];
        [self addSubview:infoIcon];
        
        
        NGButton* crossBtn=  (NGButton*)[UIButton buttonWithType:UIButtonTypeCustom];
        [self setCustomButton:crossBtn withImage:[UIImage imageNamed:@"crossBtn"] withFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
        [crossBtn addTarget:self action:@selector(crossTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:crossBtn];
        
        
        
    }
    return self;
}
-(void)setCustomButton:(NGButton*)button withImage:(UIImage*)image withFrame:(CGRect)frame
{
    [button setImage:image forState:UIControlStateNormal];
    [button setFrame:frame];
    
    if (button.tag!=42)
        [button setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    button.showsTouchWhenHighlighted = YES;
}
-(void)crossTapped:(UIButton*)sender
{
    [APPDELEGATE removeSingletonNetworkErrorLayer];
}

@end
