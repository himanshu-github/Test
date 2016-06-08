//
//  NIEditContactNumberCell.h
//  Naukri
//
//  Created by Arun Kumar on 3/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactNumberCellDelegate <NSObject>
@optional
- (void)textFieldDelegate:(UITextField *)textfield havingIndex:(NSInteger)index;
- (void)textFieldDelegateDidStartEditing:(UITextField *)textfield havingIndex:(NSInteger)index;
- (void)textFieldDelegateDidEndEditing:(UITextField *)textfield havingIndex:(NSInteger)index;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string;
@end

@interface NGEditContactNumberCell : NGCustomValidationCell<UITextFieldDelegate>


@property(nonatomic, weak) IBOutlet NGTextField* txtCountryCode;
@property(nonatomic, weak) IBOutlet NGTextField* txtAreaCode;
@property(nonatomic, weak) IBOutlet NGTextField* txtNumber;

/**
 *  This variable represents row index.
 */
@property(nonatomic, assign) NSInteger index;


/**
 *  This variable holds delegates of Contact Number Cell.
 */
@property (nonatomic, weak) id<ContactNumberCellDelegate> delegate;

/**
 *  This variable defines edit module number (like Basic details, Contact details).
 */
@property(nonatomic, assign) NSInteger editModuleNumber;

/**
 *  This method is used for configuring edit profile cell based on different different Edit Module.
 *
 *  @param dict will be having data, coming from ViewController.
 */
-(void)configureEditContactNumberCellWithData:(NSMutableDictionary*)dataDict andIndexPath:(NSIndexPath*)indexPath;

@end
