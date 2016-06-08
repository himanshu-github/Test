//
//  NGTableViewInterceptor.h
//  test
//
//  Created by Himanshu on 7/20/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGTableViewInterceptor : NSObject


@property (nonatomic, readwrite, weak) id receiver;
@property (nonatomic, readwrite, weak) id middleMan;

@end
