//
//  NGResmanLoginDetailsViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/13/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//
enum
{
    ROW_TYPE_CELL_HEADING = 0,
    ROW_TYPE_USERNAME,
    ROW_TYPE_PASSWORD,
    ROW_TYPE_NEXT_BUTTON,
    ROW_TYPE_SOCIAL_LOGIN
};

@interface NGResmanLoginDetailsViewController : NGEditBaseViewController
@property(nonatomic) BOOL isComingFromUnregApply;
@property(nonatomic) BOOL isComingFromMailer;


@end
