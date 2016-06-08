//
//  NGSecondLayer.h
//  NaukriGulf
//
//  Created by Arun Kumar on 24/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGSearchBar.h"

/**
 A delegate that informs about the clusters and subclusters selected on second layer.
 */

@protocol SecondLayerDelegate <NSObject>

/**
 *  Notifies the list of selected clusters & subclusters.
 *
 *  @param arr          array
 *  @param name         category name
 *  @param selectedRows selected rows
 */
-(void) didSelectOptions:(NSMutableArray *)arr ofCategory:(NSString *)name withSelectedRows:(NSMutableArray *)selectedRows;

@end

/**
 *  The class handles second layer of clusters.
    Conforms the UITableViewDataSource & UITableViewDelegate

 */
@interface NGSecondLayer : UIView <UITableViewDelegate, UITableViewDataSource,NGSearchBarDelegate>
{
    UIView *view;
}

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray* selectedRows;
@property (nonatomic,strong)NSMutableArray* selectedValues;
@property (nonatomic, weak) id <SecondLayerDelegate> delegate;

/**
 *  Initilize the frame of the cell.
 *
 *  @param frame      frame
 *  @param headerText headerText
 *  @param arr        array
 *  @param category   category name
 *  @param arrToCome  array of selected rows
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame withHeaderText:(NSString *)headerText withData:(NSMutableArray *) arr withCatergory:(NSString *)category andSelectedRows:(NSMutableArray *)arrToCome;


@property(nonatomic,strong) NGSearchBar* searchBar;
-(void)showSearchBar;


@end
