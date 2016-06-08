//
//  NGEditProfileSegmentedCell.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/13/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileEditCellSegmentDelegate <NSObject>
@optional
-(void)cellSegmentClicked:(NSInteger)selectedSegmentIndex ofRow:(NSInteger)rowNumber;

@end

@interface NGEditProfileSegmentedCell : NGCustomValidationCell
@property (nonatomic) NSInteger iPreviouslySelectedButton;


@property(nonatomic) NSInteger iSelectedButton;

/**
 *  This variable holds delegates of Profile Edit Segment Cell.
 */
@property (nonatomic, weak) id<ProfileEditCellSegmentDelegate> delegate;

@property (nonatomic, assign) NSInteger rowIndex;
- (void)configureEditProfileSegmentedCell:(NSMutableDictionary*)dict;


@end
