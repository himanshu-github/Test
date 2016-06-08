//
//  NGWebJobViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 11/19/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmailWebJobDelegate <NSObject>

@required
-(void) closeTapped;
-(void) emailJobTappedWithEmail : (NSString *) emailId;
-(void) applyWebJobTapped;

@end
@interface NGWebJobViewController : UIViewController
{



}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mailJobViewBottomConstrnt;
@property(nonatomic,weak) id<EmailWebJobDelegate> delegate;
@end
