//
//  NGProfileViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//


/**
 *  The class displays the user profile. It also gives user a facilty to edit the profile.
 
    Conforms the UITableViewDataSource, UITableViewDelegate, NGAnimatorDelegate .
 */
@interface NGProfileViewController : NGBaseViewController<UITableViewDataSource,UITableViewDelegate>

/**
 *  This is set to YES when user navigates from MNJ Home Page on tapping a particular tab to edit it.
 */
@property (nonatomic) BOOL isEditingProfile;

/**
 *  Maintains the row index for editing.
 */
@property (nonatomic) NSInteger editRow;

/**
 *  Records the time when profile view starts loaded in memory for display on screen. 
 */
@property(nonatomic,readwrite) UserProfile autoLandingSection;
@property(nonatomic,readwrite) NSInteger scrollToIndex;
@property (strong, nonatomic) NSDate *profileStartTime;
@property(nonatomic,assign) BOOL showBackButton;
@end
