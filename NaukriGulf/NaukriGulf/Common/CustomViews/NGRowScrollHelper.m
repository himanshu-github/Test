//
//  NGRowScrollHelper.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 06/05/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGRowScrollHelper.h"

@interface NGRowScrollHelper(){
    NSDictionary *keyboardUserInfo;
}

@end

@implementation NGRowScrollHelper

-(void)listenToKeyboardEvent:(BOOL)paramSwitch{
    if (paramSwitch) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rowScrollHelperKeyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rowScrollHelperKeyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)rowScrollHelperKeyboardWillShowNotification:(NSNotification *)notification{
    keyboardUserInfo = notification.userInfo;
    [self scrollUpWithKeyboardUserInfo:keyboardUserInfo];
}

- (void)rowScrollHelperKeyboardWillHideNotification:(NSNotification *)notification
{
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    if (nil != rate && [NSNull class] != rate) {
        [UIView animateWithDuration:rate.floatValue animations:^{
            self.tableViewToScroll.contentOffset = CGPointZero;
            self.tableViewToScroll.contentInset = UIEdgeInsetsZero;
            self.tableViewToScroll.scrollIndicatorInsets = UIEdgeInsetsZero;
            keyboardUserInfo = nil;
        }];
    }else{
        self.tableViewToScroll.contentOffset = CGPointZero;
        self.tableViewToScroll.contentInset = UIEdgeInsetsZero;
        self.tableViewToScroll.scrollIndicatorInsets = UIEdgeInsetsZero;
        keyboardUserInfo = nil;
    }
    
    self.tableViewFooter.hidden = NO;
    self.tableViewToScroll.scrollEnabled = YES;
}
-(void)setIndexPathOfScrollingRow:(NSIndexPath*)paramIndexPath{
    _indexPathOfScrollingRow = paramIndexPath;
    if (nil != _indexPathOfScrollingRow && nil != keyboardUserInfo) {
        [self scrollUpWithKeyboardUserInfo:keyboardUserInfo];
    }
}
-(void)scrollUpWithKeyboardUserInfo:(NSDictionary*)paramKeyboardUserInfo{
    
    if (nil == self.indexPathOfScrollingRow) {
        return;
    }
    
    CGSize keyboardSize = [[paramKeyboardUserInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    CGPoint contentOffSetPoint = CGPointZero;
    
    if (NGScrollRowTypeNormal == self.rowType || NGScrollRowTypeNormalReloadInset == self.rowType) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        
    }else if(NGScrollRowTypeSuggestor == self.rowType){
        CGFloat bottomShift = self.headerHeight + ((self.indexPathOfScrollingRow.item-1) * self.rowHeight);
        contentInsets = UIEdgeInsetsMake(-bottomShift, 0.0, bottomShift, 0.0);
        
    }else if (NGScrollRowTypeSuggestorOffSet == self.rowType){
        CGFloat yOffSet = self.headerHeight + ((self.indexPathOfScrollingRow.item-1) * self.rowHeight);
        contentOffSetPoint = CGPointMake(0.0f, yOffSet);
        
    }else if(NGScrollRowTypeSuggestorInsetOffset == self.rowType){
        contentInsets = UIEdgeInsetsMake(-self.shiftVal, 0, self.shiftVal, 0);
        contentOffSetPoint = CGPointMake(0, self.shiftVal);
        NSNumber *rate = paramKeyboardUserInfo[UIKeyboardAnimationDurationUserInfoKey];
        if (nil != rate && [NSNull class] != rate) {
            [UIView animateWithDuration:rate.floatValue animations:^{
                self.tableViewToScroll.contentInset = contentInsets;
                self.tableViewToScroll.scrollIndicatorInsets = contentInsets;
                self.tableViewToScroll.contentOffset = contentOffSetPoint;
            }];
        }else{
            self.tableViewToScroll.contentInset = contentInsets;
            self.tableViewToScroll.scrollIndicatorInsets = contentInsets;
            self.tableViewToScroll.contentOffset = contentOffSetPoint;
        }
        
        //reset shift value
        self.shiftVal = 0.0f;
        
        self.tableViewFooter.hidden = YES;
        
        self.indexPathOfScrollingRow = nil;
        
        return;

    }else{
        //dummy
    }
    
    if (NO == UIEdgeInsetsEqualToEdgeInsets(contentInsets, UIEdgeInsetsZero)) {
        
        if (YES == UIEdgeInsetsEqualToEdgeInsets(self.tableViewToScroll.contentInset, contentInsets) && self.rowType!=NGScrollRowTypeNormalReloadInset) {
            return;
        }
        
        NSNumber *rate = paramKeyboardUserInfo[UIKeyboardAnimationDurationUserInfoKey];
        if (nil != rate && [NSNull class] != rate) {
            [UIView animateWithDuration:rate.floatValue animations:^{
                self.tableViewToScroll.contentInset = contentInsets;
                self.tableViewToScroll.scrollIndicatorInsets = contentInsets;
            }];
        }else{
            self.tableViewToScroll.contentInset = contentInsets;
            self.tableViewToScroll.scrollIndicatorInsets = contentInsets;
        }
        
        [self.tableViewToScroll scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.indexPathOfScrollingRow.item inSection:self.indexPathOfScrollingRow.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];

        
    }else if (NO == CGPointEqualToPoint(contentOffSetPoint, CGPointZero)){
        [self.tableViewToScroll setContentOffset:contentOffSetPoint animated:YES];
    }
    self.tableViewFooter.hidden = YES;
    
    self.indexPathOfScrollingRow = nil;
}
@end
