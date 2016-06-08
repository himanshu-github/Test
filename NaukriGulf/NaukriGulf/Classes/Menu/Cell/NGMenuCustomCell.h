//
//  NGMenuCustomCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The class used for Menu Items custom cell.
 */
@interface NGMenuCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuTitle;
@property (weak, nonatomic) IBOutlet UIImageView *menuImg;
@property (weak, nonatomic) IBOutlet UILabel *menuCountLbl;

@end
