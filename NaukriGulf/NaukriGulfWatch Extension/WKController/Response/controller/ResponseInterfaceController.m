//
//  ResponseInterfaceController.m
//  NaukriGulf
//
//  Created by Arun on 12/31/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "ResponseInterfaceController.h"
#import "WatchConstants.h"
#import "RecoJobsInterfaceController.h"
#import "WatchHelper.h"


@interface ResponseInterfaceController (){
    
    NSInteger rowIndex;
    id myContext;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblStatus;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnStatus;

@end

@implementation ResponseInterfaceController

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    //NSLog(@"context = %@", context);
    [self setTitle:@""];
    
    if (context[KEY_INDEX])
        rowIndex = [context[KEY_INDEX] integerValue];
    if (context[KEY_DELEGATE])
        _delegate = context[KEY_DELEGATE];
    
    myContext = context;
    [WatchHelper sendScreenReportOnGA:GA_WATCH_RECO_RESPONSE_SCREEN];

}


-(void)configureResponse{
    
    [_lblStatus setText:[NSString stringWithFormat:@"%@", myContext[KEY_MESSAGE]]];
    [_btnStatus setTitle:@"OK"];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self configureResponse];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (IBAction)onStatus {
    
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableRowAt:)])
        [_delegate refreshTableRowAt:rowIndex];
    
    if (_delegate && [_delegate respondsToSelector:@selector(popToSource)])
        [_delegate popToSource];
    
    [self dismissController];
}

@end



