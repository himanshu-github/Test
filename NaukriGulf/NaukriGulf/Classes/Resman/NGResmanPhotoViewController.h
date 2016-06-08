//
//  NGResmanPhotoViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 2/4/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

@protocol EditResmanPhotoDelegate <NSObject>
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
@interface NGResmanPhotoViewController : NGEditBaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) id<EditResmanPhotoDelegate> editDelegate;


@end
