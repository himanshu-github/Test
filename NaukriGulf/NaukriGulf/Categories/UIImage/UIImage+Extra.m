//
//  UIImage+Extra.m
//  NaukriGulf
//
//  Created by Ayush Goel on 02/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "UIImage+Extra.h"

@implementation UIImage (Extra)

+ (UIImage*)cropImageCircularWithBorderWidth:(float)borderWidth borderColor:(UIColor *)borderColor ofImage:(UIImage*)imageToCrop{
    
    UIImage *image = imageToCrop;
    CGSize imageSize = image.size;
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Create the clipping path and add it
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:imageRect];
    [path addClip];
    [image drawInRect:imageRect];
    
    CGContextSetStrokeColorWithColor(ctx, [borderColor CGColor]);
    [path setLineWidth:borderWidth];
    [path stroke];
    
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
