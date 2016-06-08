//
//  NGProjectsCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The class used for customizing the project cell. 
 */
@interface NGProjectsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *projectsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectsDetailViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectsDetailItemViewTopConstraint;

@end
