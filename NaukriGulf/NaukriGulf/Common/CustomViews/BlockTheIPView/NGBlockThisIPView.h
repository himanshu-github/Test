//
//  NGBlockThisIPView.h
//  NaukriGulf
//
//  Created by Himanshu on 3/30/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface NGBlockThisIPView : UIView<TTTAttributedLabelDelegate,MFMailComposeViewControllerDelegate>
+ (NGBlockThisIPView *)sharedInstance;
-(void)hideBlockIPView;
-(void)showBlockIPView;
@property (nonatomic,assign)BOOL isViewShowing;
@end
