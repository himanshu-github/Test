//
//  NGResmanSocialLoginCell.h
//  NaukriGulf
//
//  Created by Nveen Bandlamoodi on 09/03/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SocialLoginProtocol <NSObject>

@required
-(void) facebookButtonPressed;
-(void) gPlusButtonPressed;

@end

@interface NGResmanSocialLoginCell : NGCustomValidationCell

@property (nonatomic, assign) id<SocialLoginProtocol> delegate;

@end
