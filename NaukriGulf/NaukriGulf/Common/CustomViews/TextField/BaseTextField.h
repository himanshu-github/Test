//
//  BaseTextField.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Base class for NGTextField.
    NGTextField is a custom textfield being used in NaukriGulf app.
 */
@interface BaseTextField : UITextField

{
    
}

/**
 *  Represents error message associated with the textfield.
 */
@property(nonatomic,strong) NSString* errorMessage;

/**
 *  Represnt the validation type for the textfield.
 
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
 *  Sets the left padding for textfield frame.
 */

-(void)setLeftPaddingForTextField;

/**
 *  Sets left padding for textfield's text.
 *
 *  @param text TextField's text
 */

-(void)setLeftPaddingAsText:(NSString *)text;

/**
 *  Adding right side accessoryview for textfield.
 */

-(void)setRightViewAsDropDownForTextField;

//-(void)setTextFieldStyle:(NSMutableDictionary*)params;
/**
 *  Sets textfield style.
 */

-(void)setTextFieldStyle;

/**
 *  Sets the validation applied for the textfield.
 *
 *  @param params Validation parameters
 */
-(void)setValidation:(NSMutableDictionary*)params;

/**
 *  Adds error label below the textfields in case of validation failed.
 *
 *  @param message error message for label's text
 *  @param view    view for which validation is failed
 *  @param frame   view's frame for which validation is failed
 */
-(void)addErrorLabel:(NSString*)message forview:(UIView*)view withFrame:(CGRect)frame;

/**
 *  Removes error label whenever validation is passed for the textfield.
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

/**
 *  Verifies the valid email-id entered for the textfield.
 *
 *  @param params validation parameters.
 *
 *  @return Returns YES if validation is failed.
 */
-(BOOL)checkValidEmail:(NSMutableDictionary*)params;
-(void)stripWhiteSpace;
-(void)setLeftViewWithImage:(NSString*)imageName;
-(void)displayHideBtn:(BOOL)secureTextEntry;
@end
