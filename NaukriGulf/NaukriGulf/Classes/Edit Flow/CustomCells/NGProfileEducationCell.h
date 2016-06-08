//
//  NGProfileEducationCell.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGEditEducationViewController.h"

@interface NGProfileEducationCell : UITableViewCell<EditEducationDelegate>

-(IBAction)educationEditButtonPressed:(id)sender;

-(void)setEducationDataWithModel:(NGMNJProfileModalClass*)obj andIndex:(NSInteger)index;
@end
