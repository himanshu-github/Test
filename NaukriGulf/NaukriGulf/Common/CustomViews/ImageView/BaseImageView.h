//
//  BaseImageView.h
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Base class for NGImageView.
    NGImageView is a custom imageview being used in NaukriGulf app.
 */

@interface BaseImageView : UIImageView

/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;
/**
 *  Crops the image.
 *
 *  @param borderWidth BorderWidth
 *  @param borderColor BorderColor
 */
-(void)cropImageCircularWithBorderWidth:(float)borderWidth borderColor:(UIColor *)borderColor;


@end
