//
//  NGCustomCell2.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 21/08/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGCustomCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* labelText;
@property (weak, nonatomic) IBOutlet UIImageView* selectionImageView;
//used in setting page
@property (weak, nonatomic) IBOutlet UILabel* lblDescription;

- (void)setCellWithTitle:(NSString*)paramTitle;
- (void)setCellWithDescription:(NSString*)paramDescription;
@end
