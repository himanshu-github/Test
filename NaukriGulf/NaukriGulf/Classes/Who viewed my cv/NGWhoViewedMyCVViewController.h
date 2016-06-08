//
//  NGWhoViewedMyCVViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 30/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *   This class displays  the information of recruiter and profileViewed by recruiters
 */
@interface NGWhoViewedMyCVViewController : NGBaseViewController
-(void)getCVViews:(void (^)(NGAPIResponseModal* modal))callback;
@property BOOL isAPIHitFromiWatch;

@end
