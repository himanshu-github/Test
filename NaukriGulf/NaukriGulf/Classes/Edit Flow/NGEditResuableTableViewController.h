//
//  NGEditResuableTableViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewSaveButtonProtocol <UITableViewDataSource, UITableViewDelegate>

@required
-(void) saveButtonPressed;
@optional
-(void) alreadyRegisteredPressed:(id)sender;

@end

@interface NGEditResuableTableViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableSaveRelativeConstraint;


@property(nonatomic,weak)id <EditViewSaveButtonProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

/**
 *  This variable denotes Reusable tableview for Edit MNJ.
 */
@property(nonatomic,weak) IBOutlet UITableView* tblEditMNJ;

-(void) makeTableFullScreen;
-(void) makeTableShortInHeight : (NSInteger) height;
-(void) reduceTableSizeWithSaveBtnHiddenBy:(NSInteger) height;

@end
