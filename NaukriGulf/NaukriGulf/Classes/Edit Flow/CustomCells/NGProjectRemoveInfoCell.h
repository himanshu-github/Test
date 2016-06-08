//
//  NGProjectRemoveInfoCell.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/13/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//



@protocol DeleteInfoCellDelegate <NSObject>

@optional
-(void)deleteInfoCellButtonClicked;
@end
@interface NGProjectRemoveInfoCell : NGCustomValidationCell

@property(nonatomic,weak) IBOutlet UIImageView  *trashImageView;
@property(nonatomic,weak) IBOutlet UILabel      *titleLabel;
@property(nonatomic,weak) IBOutlet UILabel      *InfoLabel;
@property(nonatomic,weak) IBOutlet UIButton     *deleteButton;
@property(nonatomic,weak) id <DeleteInfoCellDelegate> delegate;
@property (nonatomic,strong) NSString* titleLblStr;
@property (nonatomic,strong) NSString* infoLblStr;
-(void)showInformationOnBottom;
@end
