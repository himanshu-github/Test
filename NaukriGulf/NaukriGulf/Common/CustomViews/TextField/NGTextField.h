//
//  NGTextField.h
//  NaukriGulf
//
//  Created by Arun Kumar on 03/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"

/**
 *  The class represnts a custom textfield.
    The class provides methods for configuring textfield's default style and other functionalities.
 */

@interface NGTextField : BaseTextField

/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;

/**
 *  Sets the text type for textfield's text.
 */
-(void)setStyle;

/**
 *  Adds a new button in textfield for making typed text as hidden.
 */

-(void)createHideContentFunctionality;

/**
 *  Sets the boredr color for textview.
 *
 *  @param color BorderColor
 */
-(void)changeBorderColor:(UIColor *)color;

-(void)setRightViewAsButtonImageAs:(NSString *)paramImageName bounds:(CGRect)bounds target:(id)target;

-(void)setRightViewAsButtonTitleAs:(NSString *)title bounds:(CGRect)bounds target:(id)target;

/**
 *  Formats and filters HTML characters and special characters typed in textfield.
 *
 *  @return filtered text
 */
-(NSString *)getFilteredText;

@end
