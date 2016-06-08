//
//  NGLabel.h
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseLabel.h"

/**
 *  The class represnts a custom label.
  The class provides methods for configuring label's default style and some additinal functionalities.
 */

@interface NGLabel : BaseLabel

/**
 * Sets style for NGLabel.
 *
 *  @param params Dictionary with style configuration parameters
 */
-(void)setLabelStyle:(NSMutableDictionary*)params;

/**
 *  Making label's text as mandatory by adding '*' in the custom questions label's text.
 */

-(void)makeItCompulsoryFieldForCQ:(CGFloat)left;

/**
 *  Highlights the label's text.
 */
-(void)makeItHighlightedField;

@end
