//
//  NGImageView.h
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseImageView.h"

/**
 *  The class represnts a custom imageview.
    The class provides methods for some additional functionalities for the imageview.
 */

@interface NGImageView : BaseImageView

/**
 *  Designated Initializer
 *
 *  @param params Dictionary with parameters required for initlization.
 
 *
 *  @return id
 */
- (id)initWithBasicParameters:(NSMutableDictionary*)params;
/**
 *  Crops image based on Borderwidth.
 *
 *  @param borderWidth BordeWidth
 */
-(void)cropImageCircularWithBorderWidth:(float)borderWidth;

/**
 *  Sets image url locally.
 *
 *  @param url ImageUrl
 */
-(void)setImageWithLocalURL:(NSString *)url;

@end
