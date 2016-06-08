//
//  NGEditDesiredJobsViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/20/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
enum{
    
    ROW_TYPE_PREFERRED_LOCATION=0,
    ROW_TYPE_EMPLOYMENT_STATUS,
    ROW_TYPE_EMPLOYMENT_TYPE
    
};


/**
 *  delegate of NGEditDesiredJobViewController must adopt the EditDesiredJobDelegate and informs about the actions
 *  performed during editing
 */
@protocol EditDesiredJobDelegate <NSObject>
/**
 *   a delegate method initailzed when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */

-(void)editedDesiredJobWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */

@end

@interface NGEditDesiredJobsViewController : NGEditBaseViewController<ProfileEditCellDelegate>

@property (weak, nonatomic) id<EditDesiredJobDelegate> editDelegate;

/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj;

@end