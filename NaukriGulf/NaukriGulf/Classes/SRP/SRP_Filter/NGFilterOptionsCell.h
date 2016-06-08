//
//  NGFilterOptionsCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 20/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGFilterOptionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *filterNumbersBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblTextLeadingConstraint;

- (void)updateConstraintsWithSize:(CGSize)paramNewSize;
@end
