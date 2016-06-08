//
//  UILabel+DynamicHeight.h
//  NaukriGulf
//
//  Created by Ajeesh T S on 05/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  A category of UILabel for calculating the height basis multiline text.
 */
@interface UILabel (DynamicHeight)

/**
 *  Get the height basis multiline text.
 *
 *  @return Returns the height.
 */
- (float)getDynamicHeight;
- (CGSize)getDynamicSize;

- (float)expectedHeight;
- (float)getAttributedHeightOfText:(NSString*)text havingLineSpace:(NSInteger)lineSpace;
@end
