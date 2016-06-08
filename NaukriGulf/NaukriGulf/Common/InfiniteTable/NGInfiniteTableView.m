//
//  NGInfiniteTableView.m
//  test
//
//  Created by Himanshu on 7/20/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "NGInfiniteTableView.h"
#import "NGTableViewInterceptor.h"


@interface NGInfiniteTableView()
{
    int visibleCell;
    NGTableViewInterceptor *_dataSourceInterceptor;
    NSInteger _totalRows;
    
}

@end
@implementation NGInfiniteTableView

#pragma mark Private methods

- (void)resetContentOffsetIfNeeded
{
    
    NSArray *indexpaths = [self indexPathsForVisibleRows];
    int totalVisibleCells =[indexpaths count];
    
    if( visibleCell > totalVisibleCells )
    {
        return;
    }
    CGPoint contentOffset  = self.contentOffset;
    if( contentOffset.y<=0.0)
    {
        contentOffset.y = self.contentSize.height/3.0f;
    }
    else if( contentOffset.y >= ( self.contentSize.height - self.bounds.size.height) )
    {
        contentOffset.y = self.contentSize.height/3.0f- self.bounds.size.height;
    }
    [self setContentOffset: contentOffset];
}

#pragma mark Layout

- (void)layoutSubviews
{
    visibleCell = self.frame.size.height / self.rowHeight;
    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];
}

#pragma mark Setter/Getter
- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    
    if( !_dataSourceInterceptor)
    {
        _dataSourceInterceptor = [[NGTableViewInterceptor alloc] init];
    }
    
    _dataSourceInterceptor.receiver = dataSource;
    _dataSourceInterceptor.middleMan = self;
    
    [super setDataSource:(id<UITableViewDataSource>)_dataSourceInterceptor];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    _totalRows = [_dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section];
    
    return _totalRows *CONTENT_SIZE_MULTIPLY_FACTOR;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row % _totalRows inSection:indexPath.section]];
}


@end
