//
//  UIImage+Extra.h
//  NaukriGulf
//
//  Created by Ayush Goel on 02/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extra)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize ;
+ (UIImage*)cropImageCircularWithBorderWidth:(float)borderWidth borderColor:(UIColor *)borderColor ofImage:(UIImage*)imageToCrop;

@end
