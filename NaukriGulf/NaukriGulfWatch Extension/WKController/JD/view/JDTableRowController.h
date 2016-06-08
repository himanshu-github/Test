//
//  JDTableRowController.h
//  NaukriGulf
//
//  Created by Arun on 1/17/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@protocol JDTableRowControllerDelegate<NSObject>

-(void)applyClicked;
@end


@interface JDTableRowController : NSObject


@property(nonatomic, weak) id<JDTableRowControllerDelegate>delegate;

-(void)configureJDRow:(NSDictionary*)dict;
-(void)configureTableForApply;
-(void)configureTableForApplying;
-(void)configureTableForApplied;
@end
