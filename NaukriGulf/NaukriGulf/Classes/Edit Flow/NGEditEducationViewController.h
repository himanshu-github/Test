//
//  NGEditEducationViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
#import "NGValueSelectionViewController.h"
#import "NGCalenderPickerView.h"

enum {
    
    ROW_TYPE_COURSE_TYPE = 0,
    ROW_TYPE_OTHER_COURSE_TYPE,
    ROW_TYPE_SPECIALISATION,
    ROW_TYPE_OTHER_SPECIALISATION,
    ROW_TYPE_YEAR_OF_GRAD,
    ROW_TYPE_COUNTRY,

    
};


/**
 *   delegate of NGEditBasicEducationViewController must adopt the EditEducationDelegate and informs about the actions performed during editing
 */
@protocol EditEducationDelegate <NSObject>
/**
 *   a delegate method initialized when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */

-(void)editedEducationWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */


@end

@interface NGEditEducationViewController : NGEditBaseViewController<ProfileEditCellDelegate,ValueSelectorDelegate,NGCalenderDelegate>

@property (weak, nonatomic) id<EditEducationDelegate> editDelegate;

/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */
@property (strong, nonatomic) NGEducationDetailModel *modalClassObj;

/**
 *  NSString contains course type value
 */
@property (nonatomic, strong) NSString *courseTypeValue;

-(void)updateDataWithParams:(NGEducationDetailModel *)obj;

@end
