//
//  NGCustomCell.h
//  NaukriGulf
//
//  Created by Iphone Developer on 30/05/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* labelText;
@property (weak, nonatomic) IBOutlet UIImageView* imgView;
@property (weak, nonatomic) IBOutlet UIImageView* selectionImageView;
@end
