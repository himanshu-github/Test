//
//  NGEditProfileTextviewCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 9/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@protocol EditProfileTextViewCellDelegate <NSObject>
@optional
- (void)textViewValue:(NSString *)textViewValue havingIndex:(NSInteger)index;
- (void)textViewDidStartEditing:(NSInteger)index;
- (void)textViewDidEndEditing:(NSString *)textViewValue havingIndex:(NSInteger)index;
-(void)setCharCount:(NSInteger) count;
@end

@interface NGEditProfileTextviewCell : NGCustomValidationCell<UITextFieldDelegate,UITextViewDelegate>


/**
 *  This variable holds delegates of Profile Edit Cell.
 */
@property (nonatomic, weak) id<EditProfileTextViewCellDelegate> delegate;

/**
 *  This variable denotes profile edit cell textfield.
 */
@property(nonatomic, weak) IBOutlet UIPlaceHolderTextView* txtview;


/**
 *  This variable defines edit module number (like Basic details, Contact details).
 */
@property(nonatomic, assign) NSInteger editModuleNumber;

/**
 *  This variable represents row index.
 */
@property(nonatomic, assign) NSInteger index;

@property(nonatomic, assign) IBOutlet NGLabel* lblPlaceholder2;

/**
 *  This method is used for configuring edit profile cell based on different different Edit Module.
 *
 *  @param dict will be having data, setting from controllers.
 */
- (void)configureEditProfileTextviewCell:(NSMutableDictionary*)dict;

@end
