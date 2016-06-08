//
//  NGSecondLayerCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 24/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGSecondLayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImg;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;

- (void)updateConstraintsWithSize:(CGSize)paramNewSize;
@end