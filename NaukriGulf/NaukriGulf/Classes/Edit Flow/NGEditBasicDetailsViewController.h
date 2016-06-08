//
//  NGEditBasicDetailsViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 06/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGValueSelectionViewController.h"
#import "NGLayeredValueSelectionViewController.h"
#import "NGCalenderPickerView.h"

/**
 *   delegate of NGEditBasicDetailViewController must adopt the EditBasicDetailsDelegate and informs about the actions performed during editing
 */
@protocol EditBasicDetailsDelegate <NSObject>
/**
 *  editdelegate method  triggers on editing the basic details
 *
 *  @param successFlag If Yes, the details are edited successFully
 */
-(void)editedBasicDetailsWithSuccess:(BOOL)successFlag;
/**
 *    editdelegate method triggers on cancellation of edit options
 */

@end
/**
 *   NGEditBasicDetailsViewController shows basic details (name, currentDesignation, totalExperience) and provide edit option
 *
 *  Conforms the UITextFieldDelegate, ValueSelectorDelegate, CalenderDelegate .
 */



@interface NGEditBasicDetailsViewController : NGEditBaseViewController<UITextFieldDelegate,ValueSelectorDelegate,LayeredValueSelectionDelegate,NGCalenderDelegate>

@property (weak, nonatomic) id<EditBasicDetailsDelegate> editDelegate;
/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj;

@end
