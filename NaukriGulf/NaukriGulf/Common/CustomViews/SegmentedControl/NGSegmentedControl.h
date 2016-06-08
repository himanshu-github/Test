//
//  NGSegmentedControl.h
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseSegmentedControl.h"

/**
 *  The class represnts a custom segmentedcontrol.
    The class provides method(s) for configuring segmented controls's default style.
 */

@interface NGSegmentedControl : BaseSegmentedControl
/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;

/**
 *  Sets style for Segmented control.
 */

-(void)setStyle;

@end
