//
//  NGEducationCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGEditEducationViewController.h"

/**
 *  The class used for customizing the education cell.
 
 Conforms the EducationTupleDelegate, EditEducationDelegate .
 */
@interface NGEducationCell : UITableViewCell<EditEducationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addCourseLbl;
@property (weak, nonatomic) IBOutlet UIButton *addCourseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addImg;

/**
 *  The NGMNJProfileModalClass object contains the data of user's profile.
 */
@property (strong, nonatomic) NGEducationDetailModel *modalClassObj;
@property (nonatomic, strong) NSString *addCourseType;
@property (weak, nonatomic) IBOutlet UIView *educationItemView;
@property (weak, nonatomic) IBOutlet UIView *addMoreEducationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *educationItemViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *educationItemViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *educationAddMoreItemViewHeightConstraint;
@end
