//
//  NGSearchBar.m
//  NaukriGulf
//
//  Created by Arun Kumar on 7/3/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGSearchBar.h"

@implementation NGSearchBar

-(void)addSearchBarOnView:(UIView*)viewToAdd{
    
    NSInteger yHeight = 66;
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, yHeight,
                                                                     SCREEN_WIDTH-110, 40)];
    _searchTextField.borderStyle = UITextBorderStyleNone;
    [_searchTextField setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0]];
    _searchTextField.placeholder = @"Type to Search";
    _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchTextField.keyboardType = UIKeyboardTypeDefault;
    _searchTextField.returnKeyType = UIReturnKeyDone;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTextField.delegate = self;
    [_searchTextField setBackgroundColor:[UIColor clearColor]];
    _searchTextField.textColor = UIColorFromRGB(0X515050);
    _searchTextField.rightViewMode = UITextFieldViewModeUnlessEditing;

    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:
                                   [UIImage imageNamed:@"search"]];
    _searchTextField.rightView = rightImageView;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
     [UIAutomationHelper setAccessibiltyLabel:@"DDSearch" value:@"Search" forUIElement:_searchTextField];
    CGRect tempRect = _searchTextField.frame;
    UIView* viewLine = [[UIView alloc] initWithFrame:CGRectMake(0
                                                                , tempRect.size.height -5, tempRect.size.width,1)];
    [viewLine setBackgroundColor:[UIColor colorWithRed:170.0/255 green:169.0/255 blue:170.0/255 alpha:1.0]
];
    [_searchTextField addSubview:viewLine];
    [viewToAdd addSubview:_searchTextField];
    viewLine = nil;
    viewToAdd = nil;
    
}
-(void)addSearchBarOnClusteredView:(UIView*)viewToAdd{
    
    NSInteger yHeight = 79;
    CGFloat xLeading = 95;
    
    if(IS_IPHONE6)
        xLeading = 95;
    else if (IS_IPHONE6_PLUS)
        xLeading = 100;
    
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(xLeading, yHeight,
                                                                     SCREEN_WIDTH-xLeading, 40)];
    _searchTextField.borderStyle = UITextBorderStyleNone;
    [_searchTextField setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0]];
    _searchTextField.placeholder = @"Type to Search";
    _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchTextField.keyboardType = UIKeyboardTypeDefault;
    _searchTextField.returnKeyType = UIReturnKeyDone;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTextField.delegate = self;
    [_searchTextField setBackgroundColor:[UIColor clearColor]];
    _searchTextField.textColor = UIColorFromRGB(0X515050);
    _searchTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:
                                   [UIImage imageNamed:@"search"]];
    _searchTextField.rightView = rightImageView;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [UIAutomationHelper setAccessibiltyLabel:@"DDSearch" value:@"Search" forUIElement:_searchTextField];
    CGRect tempRect = _searchTextField.frame;
    UIView* viewLine = [[UIView alloc] initWithFrame:CGRectMake(0
                                                                , tempRect.size.height -5, tempRect.size.width,1)];
    [viewLine setBackgroundColor:[UIColor colorWithRed:170.0/255 green:169.0/255 blue:170.0/255 alpha:1.0]
     ];
    [_searchTextField addSubview:viewLine];
    [viewToAdd addSubview:_searchTextField];
    viewLine = nil;
    viewToAdd = nil;
    
}

-(void)setBIsSearchModeOn:(BOOL)bIsSearchModeOn
{
    _bIsSearchModeOn = bIsSearchModeOn;
    if(!bIsSearchModeOn)
        self.searchTextField.text = @"";
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        return NO;
    }
    NSRange textFieldRange = NSMakeRange(0, [textField.text length]);
    if (NSEqualRanges(range, textFieldRange) && [string length] == 0) {
        // Game on: when you return YES from this, your field will be empty
        _bIsSearchModeOn = NO;
        [_delegate didEndSearch];
        return YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didBeginSearch:)])
    {
        _bIsSearchModeOn = YES;
        NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        [_delegate didBeginSearch:searchStr];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
//    _bIsSearchModeOn = NO;
    
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    _bIsSearchModeOn = NO;
    [_delegate didEndSearch];
    
    return YES;
}

@end

