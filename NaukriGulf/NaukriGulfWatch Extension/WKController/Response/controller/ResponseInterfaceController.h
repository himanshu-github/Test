//
//  ResponseInterfaceController.h
//  NaukriGulf
//
//  Created by Arun on 12/31/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@protocol ResponseDelegate<NSObject>
-(void)refreshTableRowAt:(NSInteger)iIndex;
-(void)popToSource;



@end

@interface ResponseInterfaceController : WKInterfaceController
@property(nonatomic, weak) id<ResponseDelegate>delegate;

@end
