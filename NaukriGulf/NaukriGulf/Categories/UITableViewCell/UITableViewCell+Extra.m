//
//  UITableViewCell+Extra.m
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "UITableViewCell+Extra.h"

@implementation UITableViewCell (Extra)

+ (CGFloat) getCellHeight:(UITableViewCell*) cell
{
    
    [cell setNeedsLayout];
    
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
   
    return size.height+1;
}

@end
