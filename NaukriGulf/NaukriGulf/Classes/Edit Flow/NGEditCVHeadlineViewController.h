//
//  NGEditCVHeadlineViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 13/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEditProfileTextviewCell.h"

/**
 * delegate of NGEditCVHeadlineViewController must adopt the EditCVHeadlineDelegate and informs about the actions performed during editing
 */
@protocol EditCVHeadlineDelegate <NSObject>

/**
 *   a delegate method initailzed when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */
-(void)editedCVHeadlineWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */

@end

/**
 *   NGEditCVHeadlineViewController used for compsoing or creating Cv headlines
 *
 *  Conforms the UITextFieldDelegate.
 */

@interface NGEditCVHeadlineViewController : NGEditBaseViewController<EditProfileTextViewCellDelegate>
/**
 * Delegate Object for reference
 */

@property (weak, nonatomic) id<EditCVHeadlineDelegate> editDelegate;

/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */

@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

@property(nonatomic, assign) IBOutlet NGLabel* lblPlaceholder2;


-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj;

@end
