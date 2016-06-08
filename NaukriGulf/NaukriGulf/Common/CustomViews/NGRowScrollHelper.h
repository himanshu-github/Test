//
//  NGRowScrollHelper.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 06/05/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NGScrollRowType){
    NGScrollRowTypeNormal = 1,
    NGScrollRowTypeSuggestor,
    NGScrollRowTypeSuggestorOffSet,
    NGScrollRowTypeNormalReloadInset,
    NGScrollRowTypeSuggestorInsetOffset
};


@interface NGRowScrollHelper : NSObject

@property(nonatomic,readwrite) NSUInteger headerHeight;
@property(nonatomic,strong) NSIndexPath *indexPathOfScrollingRow;
@property(nonatomic,readwrite) CGFloat rowHeight;
@property(nonatomic,readwrite) enum NGScrollRowType rowType;

@property(nonatomic,weak) UITableView *tableViewToScroll;
@property(nonatomic,weak) UIView *tableViewFooter;

@property(nonatomic,readwrite) CGFloat shiftVal;

-(void)listenToKeyboardEvent:(BOOL)paramSwitch;
@end
