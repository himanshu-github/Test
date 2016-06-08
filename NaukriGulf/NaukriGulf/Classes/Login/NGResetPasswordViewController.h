//
//  NGResetPasswordViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 02/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This Class allows the user to login. User can login from two ways either by applying from Register view or from Apply view
 */

@interface NGResetPasswordViewController : NGBaseViewController<UITableViewDelegate,UITableViewDataSource>
/**
 *  a Boolean Value, checks Reset password condition
 */
@property (assign,nonatomic) BOOL isResetPasswordClicked;

@property (weak,nonatomic) IBOutlet UITableView *formTableView;

@end
