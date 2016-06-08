//
//  NGMNJViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 18/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    DashBoardRowSearch = 0,
    DashBoardRowRecommendedJobs,
    DashBoardRowSavedJobs,
    DashBoardRowAppliedJobs,
    DashBoardRowPV
}
DashBoardRow;


/**
 *  The class behaves as a home page for a loggedin user. It displays the information related to user like name, designation, profile photo, recommended jobs, applied jobs, shortlisted jobs, profile viewers.
 
    Conforms the UIGestureRecognizerDelegate
 */

@interface NGMNJViewController : NGBaseViewController<UIGestureRecognizerDelegate,AppStateHandlerDelegate>

@end
