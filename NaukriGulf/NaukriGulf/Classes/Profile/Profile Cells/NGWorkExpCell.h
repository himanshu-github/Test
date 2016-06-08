//
//  NGWorkExpCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGEditWorkExperienceViewController.h"

/**
 *  The class used for customizing the work experience cell.
 
 Conforms the EditWorkExpDelegate, WorkExpTupleDelegate .
 */
@interface NGWorkExpCell : UITableViewCell<EditWorkExpDelegate>

/**
 *  The NGMNJProfileModalClass object contains the data of user's profile.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

@property (weak, nonatomic) IBOutlet UIView *workExpItemView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workExpItemViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workExpItemViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workExpAddMoreItemViewHeightConstraint;
@end
