//
//  BaseSegmentedControl.h
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Base class for NGSegmentedControl.
    NGSegmentedControl is a custom segmentedcontrol being used in NaukriGulf app.
 */

@interface BaseSegmentedControl : UISegmentedControl
/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;

@end
