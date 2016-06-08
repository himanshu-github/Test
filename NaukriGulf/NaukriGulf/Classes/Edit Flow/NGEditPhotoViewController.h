//
//  NGEditPhotoViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

//#import "GKImagePicker.h"

/**
 *   delegate of NGEditPhotoViewController must adopt the EditPhotoDelegate and informs about the actions performed during editing
 */
@protocol EditPhotoDelegate <NSObject>
/**
 *   a delegate method initailzed when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */
-(void)editedPhotoWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */

-(void)cancelPhotoEditing;

@end
/**
 *  This Controller is used for displaying Profile Photo
 *  Conforms the UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate .
 */
@interface NGEditPhotoViewController : NGEditBaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) id<EditPhotoDelegate> editDelegate;
@end
