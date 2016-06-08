//
//  NGApplyConfirmationViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 19/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

@interface NGApplyConfirmationViewController : NGBaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray* simJobs;
@property (nonatomic, strong) NGJobDetails *jobObj;
@property (nonatomic, strong) NSString *jobId;

@property (nonatomic, strong) NSString *jobDesignation;
@property (weak, nonatomic) IBOutlet UILabel *designLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign) BOOL bScrollTableToTop;


-(void)paginationForSimJobs;
-(void)deallocAllElements;

@end
