//
//  NGEditWorkExperienceViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/13/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
enum {
    
    ROW_TYPE_DESIGNATION = 0,
    ROW_TYPE_ORGANISATOIN,
    ROW_TYPE_CURRENT_COMPANY,
    ROW_TYPE_START_DATE,
    ROW_TYPE_TILL_DATE,
    ROW_TYPE_JOB_PROFILE,
    ROW_TYPE_REMOVE_EXPERIENCE
    
};


/**
 *   delegate of NGEditWorkExpViewController must adopt the EditWorkExpDelegate and informs about the actions performed during editing
 */
@protocol EditWorkExpDelegate <NSObject>
/**
 *   a delegate method initailzed when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */
-(void)editedWorkExpWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */

@end

@interface NGEditWorkExperienceViewController : NGEditBaseViewController

@property (weak, nonatomic) id<EditWorkExpDelegate> editDelegate;

/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */
@property (strong, nonatomic) NGWorkExpDetailModel *modalClassObj;

-(void)updateDataWithParams:(NGWorkExpDetailModel *)obj;

@end
