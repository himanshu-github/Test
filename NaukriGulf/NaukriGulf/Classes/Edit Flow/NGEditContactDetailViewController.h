//
//  NGEditContactDetailViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
#import "NGEditContactNumberCell.h"
#import "NGEditContactEmailCell.h"
#import "NGContactDetailMobileCell.h"

@protocol EditContactDetailsDelegate <NSObject>
/**
 *   a delegate method initailzed when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */
-(void)editedContactDetailsWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */

@end
@interface NGEditContactDetailViewController : NGEditBaseViewController <ContactEmailCellDelegate,
ContactNumberCellDelegate,
ContactDetailMobileCell,NGErrorViewDelegate>
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

@property (weak, nonatomic) id<EditContactDetailsDelegate> editDelegate;
/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */
-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj;

@end
