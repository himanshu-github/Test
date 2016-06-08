//
//  NGJobTupleCustomCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 16/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NGJobTupleCustomCell;

/**
 A delegate that informs about shortlisted button is taaped on JobToupleCell.
 */

@protocol JobTupleCellDelegate <NSObject>

/**
 *  Informs delegate that shortlisted button is tapped
 
 *
 *  @param jobTupleObj JobToupleCustomCell
 *  @param flag        BOOL value informs that if shortlisted is clicked.
 */

-(void)jobTupleCell:(NGJobTupleCustomCell*)jobTupleObj shortListTappedWithFlag:(BOOL)flag;

@end

@interface NGJobTupleCustomCell : UITableViewCell

@property(nonatomic,strong)NGJobDetails *jobObj;

@property (weak, nonatomic) IBOutlet NGLabel *appliedDate;
@property (weak, nonatomic) IBOutlet NGButton *shortListBtn;

@property(nonatomic)NSInteger jobIndex;
@property (weak, nonatomic) id<JobTupleCellDelegate> delegate;

/**
 *  Displays data in the custom cell
 *
 *  @param jdObj NGJobDetails object
 *  @param index index of job
 */
-(void)displayData:(NGJobDetails *)jdObj atIndex:(NSInteger)index;

@end
