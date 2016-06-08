//
//  NGEditProfileSegmentedCell.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/13/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditProfileSegmentedCell.h"

@interface NGEditProfileSegmentedCell()
    
@property(nonatomic, weak) IBOutlet UILabel* lblPlaceHolder;


@end
@implementation NGEditProfileSegmentedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureEditProfileSegmentedCell:(NSMutableDictionary*)dict{
    
    for (NGView* view in self.contentView.subviews){
        
        if ([view isKindOfClass:[NGButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    float fOriginX = K_SEGMENT_BUTTON_ORIGIN_X;
    if (IS_IPHONE6)
        fOriginX += 30;
    else if(IS_IPHONE6_PLUS)
        fOriginX += 50;
    
    _lblPlaceHolder.text = [dict objectForKey:K_KEY_EDIT_PLACEHOLDER];
    float fOriginY = K_SEGMENT_BUTTON_ORIGIN_Y;
    
    
    if ([_lblPlaceHolder.text isEqualToString:@""])
        fOriginY = K_SEGMENT_BUTTON_ORIGIN_Y -18;
    
    
    NSMutableArray* arrTitles = [dict objectForKey:K_KEY_EDIT_TITLE];
    float fWidth = K_SEGMENT_TOTAL_VIEW_WIDTH/[arrTitles count];
    
    for (int i = 0; i< [arrTitles count]; i++){
        
        NGButton* btn = [NGButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+1;
        [btn setFrame:CGRectMake(fOriginX, fOriginY,
                                 fWidth, K_SEGMENT_BUTTON_HEIGHT)];
        [btn setTitle:[arrTitles fetchObjectAtIndex:i] forState:UIControlStateNormal];
        [btn setAccessibilityLabel:[NSString stringWithFormat:@"%ld_segment%d_btn",(long)_rowIndex,i]];
        [btn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE
                                                size:arrTitles.count>2?12.0:14.0]];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabSelected.png"] forState:UIControlStateSelected];
        [btn setTitleColor:Clr_Segment_Button_Title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [[btn layer] setBorderWidth:.6f];
        [[btn layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        
        if (_iSelectedButton == btn.tag) {
            btn.selected = YES;
            _iPreviouslySelectedButton = _iSelectedButton;
        }
        [self.contentView addSubview:btn];
        fOriginX = fOriginX + fWidth;
    }
    
}

- (void)onButtonClicked:(id)sender{
    
   
    NGButton* btnPreviously = (NGButton*)[self.contentView viewWithTag:_iPreviouslySelectedButton];
    if ([btnPreviously isKindOfClass:[NGButton class]]) {
        btnPreviously.selected = NO;
    }
    NGButton* btnCurrently  = (NGButton*)sender;
    btnCurrently.selected = YES;
    _iPreviouslySelectedButton = btnCurrently.tag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(cellSegmentClicked: ofRow:)])
        [_delegate cellSegmentClicked:btnCurrently.tag ofRow:_rowIndex];
    
    
}

@end
