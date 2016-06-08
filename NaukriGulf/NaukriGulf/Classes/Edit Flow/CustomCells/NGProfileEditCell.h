//
//  NIProfileEditCell.h
//  Naukri
//
//  Created by Arun Kumar on 2/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGTextField.h"

@protocol ProfileEditCellDelegate <NSObject>
@optional
- (void)textField:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index;
- (void)textFieldValue:(NSString *)textFieldValue havingIndex:(NSInteger)index;
- (void)textFieldDidStartEditing:(NSInteger)index;
- (void)textFieldDidStartEditing:(UITextField*)textField havingIndex:(NSInteger)index;
- (BOOL)textFieldShouldStartEditing:(NSInteger)index;
- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index;
- (void)textFieldDidReturn:(NSInteger)index;
- (void)textFieldDidEndEditing:(NSString *)textFieldValue havingIndex:(NSInteger)index;
- (void)textFieldDidEndEditing:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index;
- (void)deleteTapped:(NSInteger)index;
@end

@interface NGProfileEditCell : NGCustomValidationCell<UITextFieldDelegate>

/**
 *  This variable represents row index.
 */
@property(nonatomic, assign) NSInteger index;

/**
 *  This variable denotes profile edit cell textfield.
 */
@property(nonatomic, weak) IBOutlet NGTextField* txtTitle;


/**
 *  This variable denotes profile edit cell textfield.
 */
@property(nonatomic, weak) IBOutlet UILabel* lblOtherTitle;


/**
 *  This variable holds delegates of Profile Edit Cell.
 */
@property (nonatomic, assign) id<ProfileEditCellDelegate> delegate;


/**
 *  This variable defines edit module number (like Basic details, Contact details).
 */
@property(nonatomic, assign) NSInteger editModuleNumber;


/**
 *  This method is used for configuring edit profile cell based on different different Edit Module.
 *
 *  @param dict will be having data, coming from NIEditBasicDetailsViewController.
 */
- (void)showOtherTextField;
- (void)hideOtherTextField;
-(void)configureEditProfileCellWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index;


@property(nonatomic, assign) NSString* otherDataStr;
@property(nonatomic, assign) BOOL isEditable;


@property(nonatomic, weak) IBOutlet UILabel* lblPlaceHolder;

@end
