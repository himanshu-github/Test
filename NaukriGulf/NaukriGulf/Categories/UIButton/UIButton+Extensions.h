//
//  UIButton+Extensions.h
//  NaukriGulf
//
//  Created by Arun Kumar on 26/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  A category of UIButton for making the clickable area a bit larger.
 */
@interface UIButton (Extensions)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
