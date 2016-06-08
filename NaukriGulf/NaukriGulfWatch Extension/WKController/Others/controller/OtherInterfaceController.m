//
//  OtherInterfaceController.m
//  NaukriGulf
//
//  Created by Arun on 12/31/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "OtherInterfaceController.h"
#import "WatchHelper.h"
#import "WatchConstants.h"
@interface OtherInterfaceController ()

@end

@implementation OtherInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self setTitle:@"Back"];
    [WatchHelper sendScreenReportOnGA:GA_WATCH_OTHER_RESPONSE_SCREEN];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



