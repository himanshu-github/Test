//
//  NGUploadResumeViaEmailView.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 29/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editResumeUploadViaEmailProtocol <NSObject>


@end

@interface NGUploadResumeViaEmailView : UIView

@property(nonatomic,weak) id<editResumeUploadViaEmailProtocol> delegate;
@property(nonatomic, weak) NSLayoutConstraint* leadingConstraint;

@end
