//
//  NGResmanSocialEmailRegistrationViewController.h
//  NaukriGulf
//
//  Created by Himanshu on 3/29/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
enum
{
    ROW_TYPE_HEADING = 0,
    ROW_TYPE_EMAIL
};

@interface NGResmanSocialEmailRegistrationViewController : NGEditBaseViewController
@property(nonatomic) BOOL isComingFromUnregApply;
@property(nonatomic) BOOL isComingFromMailer;


@end
