//
//  NGEditPersonalDetailsViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 07/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//
#import "NGValueSelectionViewController.h"
#import "NGCalenderPickerView.h"
#import "NGEditProfileTextviewCell.h"
/**
 * delegate of NGEditPersonalDetailsViewController must adopt the EditPersonalDetailsDelegate and informs about the actions performed during editing
 */
@protocol EditPersonalDetailsDelegate <NSObject>
/**
 *   a delegate method initailzed when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */
-(void)editedPersonalDetailsWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */

@end

/**
 *  This Controller is used for displaying Personnel Information of user like date of birth , gender, driving license 
 *  Conforms the UITextFieldDelegate, ValueSelectorDelegate, CalenderDelegate .
 */
@interface NGEditPersonalDetailsViewController : NGEditBaseViewController<UITextFieldDelegate,ValueSelectorDelegate,NGCalenderDelegate,EditProfileTextViewCellDelegate>

@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

@property (weak, nonatomic) id<EditPersonalDetailsDelegate> editDelegate;

-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj;

@end
