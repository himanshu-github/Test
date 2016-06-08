//
//  JDInterfaceController.h
//  NaukriGulf
//
//  Created by Arun on 1/14/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>



@protocol JDInterfaceControllerDelegate<NSObject>

-(void)updateValuesForSave:(NSDictionary*)dictData;
-(void)updateApplyValueFromReco:(NSDictionary*)dictData;
-(void)updateApplyValueFromSaved:(NSDictionary*)dictData;


@end


@interface JDInterfaceController : WKInterfaceController

@property(nonatomic, weak) id<JDInterfaceControllerDelegate>delegate;

@end
