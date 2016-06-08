//
//  NGErrorViewController.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 19/08/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGErrorViewDelegate <NSObject>

-(void)customAlertbuttonClicked:(NSInteger)index;

@end


@interface NGErrorViewController : UIViewController

@property(nonatomic, weak)  id<NGErrorViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

-(void)showErrorScreenWithTitle:(NSString*)title withMessage:(NSArray*)messageArray withButtonsTitle:(NSString *)btnTitles withDelegate:(id)delegate;

- (void)showDeleteScreenWithTitle:(NSString*)title withMessage:(NSArray*)messageArray withButtonsTitle:(NSString *)btnTitles withDelegate:(id)delegate;
@end