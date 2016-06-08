//
//  NGTextField.m
//  NaukriGulf
//
//  Created by Arun Kumar on 03/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGTextField.h"
#import "UIButton+Extensions.h"

@implementation NGTextField

- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super initWithBasicParameters:params];
    if (self)
    {        
        [super setTextFieldStyle];
        [self customize];
    }
    return self;
}
-(void)setStyle{
    
    self.secureTextEntry = YES;
}

-(void)customize{
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.font = [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0f];
}

-(void)createHideContentFunctionality{
    
      UIButton *hideBtn=  [UIButton buttonWithType:UIButtonTypeCustom];
    [hideBtn setTitle:@"show" forState:UIControlStateNormal];
    hideBtn.titleLabel.font = [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:14.0f];
    [hideBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    hideBtn.backgroundColor = [UIColor clearColor];
    [hideBtn addTarget:self action:@selector(hideText:) forControlEvents:UIControlEventTouchUpInside];
    
    [hideBtn setFrame:CGRectMake(250, 0, 50, 44)];
    hideBtn.tag=1;
    [self addSubview:hideBtn];
    [hideBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
}

-(void)hideText:(UIButton*)sender{

    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag==1) {
        [btn setTitle:@"hide" forState:UIControlStateNormal];
        btn.tag=2;
        self.secureTextEntry = NO;
    }else{
        [btn setTitle:@"show" forState:UIControlStateNormal];
        btn.tag=1;
        self.secureTextEntry = YES;
    }
}

-(void)changeBorderColor:(UIColor *)color{
    self.layer.borderColor = [color CGColor];
}

-(void)setRightViewAsButtonTitleAs:(NSString *)title bounds:(CGRect)bounds target:(id)target{
    NSMutableDictionary* dictionaryForBtn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_BUTTON],KEY_VIEW_TYPE,
                                           [NSValue valueWithCGRect:bounds],KEY_FRAME,
                                           [NSNumber numberWithInteger:self.tag+50],KEY_TAG,title,@"ButtonTitle",
                                           nil];
    
    NGButton* btn_=  (NGButton*)[NGViewBuilder createView:dictionaryForBtn];
    [btn_ addTarget:target action:@selector(txtFldRightViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@_btn",title] forUIElement:btn_];
    self.rightView = btn_;
    self.rightViewMode = UITextFieldViewModeAlways;
}

-(void)setRightViewAsButtonImageAs:(NSString *)paramImageName bounds:(CGRect)bounds target:(id)target{
    NSMutableDictionary* dictionaryForBtn=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_BUTTON],KEY_VIEW_TYPE,
                                           [NSValue valueWithCGRect:bounds],KEY_FRAME,
                                           [NSNumber numberWithInteger:self.tag+50],KEY_TAG,@"",@"ButtonTitle",
                                           nil];
    
    NGButton* btn_=  (NGButton*)[NGViewBuilder createView:dictionaryForBtn];
    [btn_ addTarget:target action:@selector(txtFldRightViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@_btn",@"addButtonWithPlusImage"] forUIElement:btn_];
    [btn_ setBackgroundColor:[UIColor clearColor]];
    [[btn_ imageView] setContentMode:UIViewContentModeCenter];
    [btn_ setImage:[UIImage imageNamed:paramImageName] forState:UIControlStateNormal];
    self.rightView = btn_;
    self.rightViewMode = UITextFieldViewModeAlways;
}

-(NSString *)getFilteredText{
    NSString *txt = self.text;
    
    if (txt) {
        txt = [NSString stripTags:txt];
        txt = [NSString formatSpecialCharacters:txt];
    }else{
        txt = @"";
    }    
    
    return txt;
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    if (!enabled) {
        self.backgroundColor = UIColorFromRGB(0xcccccc);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
