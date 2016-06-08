//
//  NGViewBuilder.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGButton.h"
#import "NGTextField.h"
#import "NGView.h"
#import "NGTextView.h"
#import "NGImageView.h"
#import "NGSegmentedControl.h"

/**
 *  This class creates a View based on inputs provided(e.g.- KEY_VIEW_TYPE).
 
 */

@interface NGViewBuilder : NSObject
  +(UIView*)createView:(NSMutableDictionary*)params;
@end
