//
//  NGResmanHalfWayToFullViewController.h
//  NaukriGulf
//
//  Created by Maverick on 28/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGResmanHalfWayToFullViewController : NGBaseViewController
@property(nonatomic) BOOL isSuccess;
@property(nonatomic) NSInteger serviceType;
@property (nonatomic, strong) NGJobsHandlerObject *aObject;
@property(nonatomic,strong) NSDictionary *parsedResponseForSim;
@end
