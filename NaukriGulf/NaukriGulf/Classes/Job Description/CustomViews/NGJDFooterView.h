//
//  NGApplyView.h
//  NaukriGulf
//
//  Created by Minni Arora on 10/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGWebJobViewController.h"
@protocol footerViewDelegate;

/**
 *  The class handles bottom/footer section of JobDescrption page.
    This footer section take care of Apply, Share app & Email this job functionality.
    Conforms the UITextFieldDelegate,WebDataManagerDelegate & UIGestureRecognizerDelegate
 */

@interface NGJDFooterView : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,EmailWebJobDelegate>

@property(assign) id <footerViewDelegate> delegate;
@property(nonatomic,strong) NGJobDetails *jobObj;



/**
 *  Sets the Job type (if job is alreday applied or webjob).
 *
 *  @param isWebJob     isWebJob
 *  @param isAppliedJob isAlreadyAppliedJob
 *  @param jobObj       The JobDetail object
 *  @param isJobRedirection Job is posted job, need to be applied from Webview (isWebJob may be false)
 */

-(void) setParams: (BOOL) isWebJob isAppliedJob:(BOOL) isAppliedJob andJobObj: (NGJobDetails *) jobObj andJD:(NGJDJobDetails*) JDObj;

/**
 *  Displays view for archived/deleted job.
 */
//-(void)showArchivedJobView;

/**
 *  MIS service parameter
 */
@property (nonatomic, strong)NSString *xzMIS;

@end

/**
 A delegate that informs about the apply job or sharing the app using footer section.
 */

@protocol footerViewDelegate  <NSObject>

@optional

/**
 *  Informs delegate that Job has been applied.
 *
 *  @param jobDetailObj The JobDetail object
 */
- (void) applyClicked:(NGJobDetails*)jobDetailObj;
/**
 *  Informs delegate that Job has been shared
 *
 *  @param jobDetailObj The JobDetail object
 */
- (void) shareClicked:(NGJobDetails*)jobDetailObj;


@end
