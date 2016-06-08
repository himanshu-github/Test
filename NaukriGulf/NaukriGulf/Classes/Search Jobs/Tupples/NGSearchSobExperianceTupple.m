//
//  NGSearchSobExperianceTupple.m
//  NGSearchPage
//
//  Created by Arun Kumar on 1/14/14.
//  Copyright (c) 2014 naukri. All rights reserved.
//

#import "NGSearchSobExperianceTupple.h"

NSInteger const K_EXP_TAG = 100;
//NSInteger const K_SCROLLVIEW_OFFSET_DEFAULT =  135;
NSInteger const K_SCROLLVIEW_OFFSET_DEFAULT = 185;
NSInteger const K_SCROLLVIEW_HEIGHT = 30;
NSInteger const K_BUTTON_WIDTH = 50;
NSInteger const K_BUTTON_HEIGHT = 66;
//NSInteger const K_SCROLLVIEW_ORIGIN_X = 150;
NSInteger const K_SCROLLVIEW_ORIGIN_X = 170;

NSInteger const K_EXPERIENCE_TEXT_SIZE = 14;


@interface NGSearchSobExperianceTupple (){
    
    NSInteger iPreviousSelectedExperience;
    BOOL bIsExpButtonClicked;
    BOOL bIsScrollViewDragged;
    float shiftScrollviewOriginX;
}


@property(nonatomic, weak) IBOutlet UILabel* lblExpSelected;
@end


@implementation NGSearchSobExperianceTupple

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureExperienceScrollview{
   
    for (UIView* view in _scrollExperiance.subviews){
        
        if ([view isKindOfClass:[UIButton class]]) {
            return;
        }
    }
    
    float fOriginX =  SCREEN_WIDTH - K_SCROLLVIEW_OFFSET_DEFAULT;
    shiftScrollviewOriginX = SCREEN_WIDTH-K_SCROLLVIEW_OFFSET_DEFAULT;
    if (IS_IPHONE5)
        fOriginX = fOriginX +25;
    else if (IS_IPHONE6){
        fOriginX = fOriginX - 25;
        shiftScrollviewOriginX = shiftScrollviewOriginX - 25;
        
    }
    else if (IS_IPHONE6_PLUS){
        fOriginX = fOriginX - 50;
        shiftScrollviewOriginX = shiftScrollviewOriginX - 50;

    }
   
    for (int i = -1; i<=15; i++) {
        
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(fOriginX, 0, K_BUTTON_WIDTH, K_BUTTON_HEIGHT)];
        [btn setTag:i+K_EXP_TAG];
        
        NSString* title = @"";
        UIColor* clrTitle = Clr_DarkBrown_SearchJob;
        if (i == -1){
            
            title = @"-";
            clrTitle = [UIColor whiteColor];
        }
        else if (i==15)
            title = [NSString stringWithFormat:@"%d+",i];
        else
            title = [NSString stringWithFormat:@"%d",i];
        
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:K_EXPERIENCE_TEXT_SIZE]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:clrTitle forState:UIControlStateNormal];
        [btn setTitleColor:clrTitle forState:UIControlStateHighlighted];
        [btn setTitleColor:clrTitle forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(onExpereianceSelect:) forControlEvents:UIControlEventTouchUpInside];
        fOriginX = fOriginX + btn.frame.size.width;
        
        [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"exp_btn_%@",title] forUIElement:btn];
        [_scrollExperiance addSubview:btn];
        
    }
 
    CGFloat xOffxet = (SCREEN_WIDTH-K_BUTTON_WIDTH)*0.5;
    [_scrollExperiance setContentSize:CGSizeMake(fOriginX+xOffxet, K_SCROLLVIEW_HEIGHT)];
    
    _iCurrentSelectedExperience = Const_Any_Exp_Tag;
    iPreviousSelectedExperience = _iCurrentSelectedExperience;
}

- (void)onExpereianceSelect:(id)sender{
    
    bIsExpButtonClicked = YES;
    _bPresetExperience = NO; // for prefilling
    
    UIButton* btn = (UIButton*)sender;
    NSInteger iTag = btn.tag;
    if (btn.tag >=K_EXP_TAG)
        iTag = btn.tag - K_EXP_TAG;
    else
        iTag = Const_Any_Exp_Tag;
    
    if (!_bIsFirstTimeSelected) {
        
        NSInteger iButtonTag = 0;
        if (iPreviousSelectedExperience == Const_Any_Exp_Tag)
            iButtonTag = Const_Any_Exp_Tag;
        else
            iButtonTag = iPreviousSelectedExperience + K_EXP_TAG;

        UIButton* btnExperience =  (UIButton*)[_scrollExperiance viewWithTag:iButtonTag];
        [btnExperience setUserInteractionEnabled:YES];
        [btnExperience setTitleColor:Clr_DarkBrown_SearchJob forState:UIControlStateNormal];
        
    }else{
        
        _bIsFirstTimeSelected = NO;
        iPreviousSelectedExperience = K_EXP_TAG;
    }
    
    _iCurrentSelectedExperience = iTag;
    [_scrollExperiance setContentOffset:CGPointMake(btn.frame.origin.x- shiftScrollviewOriginX, 0) animated:YES];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (_bPresetExperience){
        
        _bPresetExperience = NO;
        return;
    }
    
    if (bIsExpButtonClicked) {
        
        bIsExpButtonClicked = NO;
        
        NSInteger iButtonTag = 0;
        if (_iCurrentSelectedExperience == Const_Any_Exp_Tag)
            iButtonTag = Const_Any_Exp_Tag;
        else
            iButtonTag = _iCurrentSelectedExperience + K_EXP_TAG;
    
        UIButton* btnExperience =  (UIButton*)[_scrollExperiance viewWithTag:iButtonTag];
        [btnExperience setUserInteractionEnabled:NO];
        [btnExperience setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(userSelectedExperience:)]){

        if (_iCurrentSelectedExperience == Const_Any_Exp_Tag)
            _iCurrentSelectedExperience = Const_Any_Exp_Tag;

        [self.delegate userSelectedExperience:_iCurrentSelectedExperience];
    }
        iPreviousSelectedExperience = _iCurrentSelectedExperience;
    }
    
    for (UIView* viewsChild in scrollView.subviews){
        
        if ([viewsChild isKindOfClass:[UIButton class]]) {
            
            UIButton* btnExperience =  (UIButton*)viewsChild;
            if (btnExperience.tag != _iCurrentSelectedExperience + K_EXP_TAG){
                [btnExperience setUserInteractionEnabled:YES];
                [btnExperience setTitleColor:Clr_DarkBrown_SearchJob forState:UIControlStateNormal];
            }
            

            
        }
    }
    
    if (_iCurrentSelectedExperience == Const_Any_Exp_Tag){
        
        UIButton* btn = (UIButton*)[_scrollExperiance viewWithTag:_iCurrentSelectedExperience];
        [btn setUserInteractionEnabled:NO];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    UIButton* btnExperience =  (UIButton*)[_scrollExperiance viewWithTag:_iCurrentSelectedExperience+K_EXP_TAG];
    [btnExperience setUserInteractionEnabled:YES];
    [btnExperience setTitleColor:Clr_DarkBrown_SearchJob forState:UIControlStateNormal];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (decelerate)
        return;
    [self setExperienceAnimation:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     [self setExperienceAnimation:scrollView];
}

- (void)setExperienceAnimation:(UIScrollView*)scrollView{
    
    float fScrollviewOffsetX = scrollView.contentOffset.x;
    iPreviousSelectedExperience = _iCurrentSelectedExperience;
    NSInteger iQuotient = fScrollviewOffsetX/K_BUTTON_WIDTH;
    NSInteger iRemainder = ((int)fScrollviewOffsetX % K_BUTTON_WIDTH);
    NSInteger iTag = 0;

    if (iQuotient == 0){
        iTag = Const_Any_Exp_Tag;
        _iCurrentSelectedExperience = iTag;

    }
    else{
        
        if (iRemainder > K_BUTTON_WIDTH * 0.5){
            iTag = iQuotient + K_EXP_TAG;
            _iCurrentSelectedExperience = iQuotient;

        }
        else{
            iTag = iQuotient + K_EXP_TAG - 1;
            _iCurrentSelectedExperience = iQuotient - 1;
        }

    }

    UIButton* btnExperience = (UIButton*)[_scrollExperiance viewWithTag:iTag];
    [scrollView setContentOffset:CGPointMake(btnExperience.frame.origin.x - shiftScrollviewOriginX,0) animated:YES];
    [btnExperience setUserInteractionEnabled:NO];
    [btnExperience setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if(self.delegate && [self.delegate respondsToSelector:@selector(userSelectedExperience:)]){
        
        if (_iCurrentSelectedExperience == Const_Any_Exp_Tag)
            _iCurrentSelectedExperience = Const_Any_Exp_Tag;
        
        [self.delegate userSelectedExperience:_iCurrentSelectedExperience];
    }
    
}


#pragma mark
#pragma mark Public Method

- (void)setExperience:(NSString*)currentExperience andPreviousExperince:(NSString*)previousExperience{

    NSInteger iButtonTag = 0;
    NSInteger iPreviousButtonTag = 0;
    _bPresetExperience = YES;

    //current experience
    if ([currentExperience isEqualToString:[NSString stringWithFormat:@"%d",Const_Any_Exp_Tag]]){
        
        iButtonTag = Const_Any_Exp_Tag;
        _iCurrentSelectedExperience = Const_Any_Exp_Tag;
    }
    else{
        _iCurrentSelectedExperience = [currentExperience integerValue];
        iButtonTag = _iCurrentSelectedExperience + K_EXP_TAG;
    }
    
    UIButton* btnExperience =  (UIButton*)[_scrollExperiance viewWithTag:iButtonTag];
    [_scrollExperiance setContentOffset:CGPointMake(btnExperience.frame.origin.x -
                                                    shiftScrollviewOriginX, 0) animated:YES];
    [btnExperience setUserInteractionEnabled:NO];
    [btnExperience setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //previous experince
    if ([previousExperience isEqualToString:currentExperience])
        return;
    
    if ([previousExperience isEqualToString:[NSString stringWithFormat:@"%d",Const_Any_Exp_Tag]])
        iPreviousButtonTag = Const_Any_Exp_Tag;
    
    else
        iPreviousButtonTag = [previousExperience integerValue] + K_EXP_TAG;
    
    UIButton* btnPreviouslySelected =  (UIButton*)[_scrollExperiance viewWithTag:iPreviousButtonTag];
    [btnPreviouslySelected setUserInteractionEnabled:YES];
    [btnPreviouslySelected setTitleColor:Clr_DarkBrown_SearchJob
                                forState:UIControlStateNormal];

}

@end
