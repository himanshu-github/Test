//
//  NGSSAView.h
//  NaukriGulf
//
//  Created by Arun Kumar on 06/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATE_NONE 1
#define STATE_JOB_ALERT 2
#define STATE_MODIFY_ALERT 3
#define STATE_ENTER_EMAIL 4

/**
 *  The class has SSA view,using which user can save the Job alert creteria for him.
    The user can also modify this Job alert.
    
    Conforms the WebDataManagerDelegate,UITextFieldDelegate and UIGestureRecognizerDelegate
 
 */
@interface NGSSAView : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,NGErrorViewDelegate>

/**
 *  Maintains the app state
 */
@property (nonatomic)NSInteger state;

/**
 *  Dictionary contains job alert parameters/fields (keywords,location,emailid)
 */
@property (strong, nonatomic) NSMutableDictionary *paramsDict;

/**
 *  Blurr view when SSA is taaped on SRP
 */
@property (strong, nonatomic) NGView *blurrView;

/**
 *  To open the SSA view without tapping it
 */
@property (nonatomic) BOOL isAutomaticOpen;

@property (weak, nonatomic) IBOutlet UIButton *ssaBtn;

@property (readwrite,nonatomic) BOOL needToListenKeyboardEvent;

-(IBAction)ssaTapped:(id)sender;
- (void)hideSSAViewFromSuperView;
@end
