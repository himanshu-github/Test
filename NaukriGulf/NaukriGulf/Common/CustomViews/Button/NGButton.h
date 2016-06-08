//
//  NGButton.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseButton.h"

/**
 *  The class represnts a custom button.
    The class provides methods for configuring button's default style and some additinal functionalities.
 */
@interface NGButton : BaseButton

/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */

- (id)initWithBasicParameters:(NSMutableDictionary*)params;

/**
 * Sets style for NGButton.
 *
 *  @param params Dictionary with style configuration parameters
 */
-(void)setButtonStyle:(NSMutableDictionary*)params;

/**
 *  Sets background image for button.
 *
 *  @param image BackgroundImage
 */

-(void)setImageStyleForButton:(UIImage *)image;

/**
 *  Initilizing button's tag and frame.
 *  @param params Dictionary with buttons tag and frame information.
 *
 */
-(void)initWithButtonParameters:(NSMutableDictionary*)params;

/**
 *  Adds border color for button.
 */
-(void)addBorder;

@end
