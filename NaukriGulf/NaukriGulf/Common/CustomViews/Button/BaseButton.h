//
//  BaseButton.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Base class for NGButton.
    NGButton is a custom button being used in NaukriGulf app.
 */
@interface BaseButton : UIButton

/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;

/**
 *  Sets edge inset for button to increse its size.
 *
 *  @param hitTestEdgeInsets EdgeInset
 */

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets;

/**
 *  Initilizing button's tag and frame.
 *  @param params Dictionary with buttons tag and frame information.
 *
 */

-(void)initWithButtonParameters:(NSMutableDictionary*)params;

/**
 *  Adds gradient for the button.
 */
-(void)addGradient;

/**
 *  Adds border color and border width for the button.
 *
 *  @param borderColor BorderColor
 *  @param borderWidth BorderWidth
 */
-(void)addBorderColored:(UIColor *)borderColor Width:(float)borderWidth;

@end
