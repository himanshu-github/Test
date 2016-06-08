//
//  NGView.h
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseView.h"

/**
 *  The class represnts a custom view.
    The class has methods for configuring its default style.
 */
@interface NGView : BaseView

/**
 *  Sets background color for the view.
 *
 */

-(void)setSeparatorStyle;

/**
 *  Sets view style.
 *
 *  @param params Dictionary with style configuration parameters
 */
-(void)setViewStyle:(NSMutableDictionary*)params;

/**
 *  Sets the shadow for the view.
 *
 *
 */
-(void)setShadowView;

/**
 *  Sets the shadow with border for the view.
 *
 *
 */
-(void)setShadowAcrossBorder;

@end
