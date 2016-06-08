//
//  BaseView.h
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Base class for NGView.
    NGView is a custom view being used in NaukriGulf app.
 */

@interface BaseView : UIView
/**
 *  Designated Initializer

 *
 *  @param params Dictionary with parameters required for initlization.
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;
@end
