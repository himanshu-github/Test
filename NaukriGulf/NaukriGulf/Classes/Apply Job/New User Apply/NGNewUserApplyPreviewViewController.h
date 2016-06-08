//
//  NGNewUserApplyPreviewViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 27/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NGNewUserApplyViewController;

@interface NGNewUserApplyPreviewViewController : NGBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) NSArray* cqArray;

@property (strong,nonatomic) NGJobDetails *jobObj;
@property (strong,nonatomic) NGApplyFieldsModel *applyModel;
@property (nonatomic) int openJDLocation;
- (IBAction)applyJobFromPreview:(id)sender;

@end
