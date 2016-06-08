//
//  NGTextView.h
//  NaukriGulf
//
//  Created by Arun Kumar on 13/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseTextView.h"

/**
 *  The class represnts a custom textview.
   The class provides methods for configuring button's default style and some additinal functionalities.
 */

@interface NGTextView : BaseTextView

/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;

/**
 *  Formats and filters HTML characters and special characters typed in textfield.
 *
 *  @return filtered text
 */
-(NSString *)getFilteredText;

@end
