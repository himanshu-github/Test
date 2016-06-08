//
//  BaseTextView.h
//  NaukriGulf
//
//  Created by Arun Kumar on 13/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  Base class for NGTextView.
    NGTextView is a custom textview being used in NaukriGulf app.
 */

@interface BaseTextView : UITextView
/**
 *  Represents error message associated with the textview.
 */
@property(nonatomic,strong) NSString* errorMessage;

/**
 *  Represnt the validation type for the textview.
 
 */
@property(nonatomic,assign) NSInteger validationType;
/**
 *  Sets the frame for the view.
 */
@property(nonatomic,assign) CGRect viewFrame;

/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;

/**
 *  Sets textview style.
 */

-(void)setTextViewStyle;
/**
 *  Sets the validation applied for the textview.
 *
 *  @param params Validation parameters
 */
-(void)setValidation:(NSMutableDictionary*)params;

/**
 *  Adds error label below the textview in case of validation failed.
 *
 *  @param message error message for label's text
 *  @param view    view for which validation is failed
 *  @param frame   view's frame for which validation is failed
 */
-(void)addErrorLabel:(NSString*)message forview:(UIView*)view withFrame:(CGRect)frame;

/**
 *  Removes error label whenever validation is passed for the textview.
 *
 *  @param view view for which validation is passed.
 */
-(void)removeErrorLabelforView:(UIView*)view;

/**
 *  Verifies that if validation is passed or failed.
 *
 *  @return Returns YES if validation is failed.
 */
-(BOOL)checkValidation;

@end
