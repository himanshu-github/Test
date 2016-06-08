//
//  BaseLabel.h
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Base class for NGLabel.
    NGLabel is a custom label being used in NaukriGulf app.
 */
@interface BaseLabel : UILabel

/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */

- (id)initWithBasicParameters:(NSMutableDictionary*)params;

/**
 *  Making label's text as mandatory by adding '*' in the label's text.
 */
-(void)makeItCompulsoryField;

/**
 *  Sets border color and style for label.
 *
 *  @param color  Border color
 *  @param radius Corner radius
 */
-(void)setBorderColor:(UIColor*)color withCornerRadius:(float)radius;

@end
