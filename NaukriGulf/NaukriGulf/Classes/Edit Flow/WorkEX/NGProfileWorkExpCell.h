//
//  NGProfileWorkExpCell.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGEditWorkExperienceViewController.h"

@interface NGProfileWorkExpCell : UITableViewCell<EditWorkExpDelegate>


-(IBAction)workExpEditButtonPressed:(id)sender;
- (void)setWorkExpData:(NGWorkExpDetailModel*)obj AndIndex:(NSInteger)index;
@end
