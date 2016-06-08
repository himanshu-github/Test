//
//  NGAddNewItemCell.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGEditWorkExperienceViewController.h"
#import "NGEditEducationViewController.h"

@interface NGAddNewItemCell : UITableViewCell<EditWorkExpDelegate,EditEducationDelegate>


@property (nonatomic,strong) NSDictionary *infoData;//can hold any data

-(void)customizeUIWithData:(NSString *)data andTagValue:(int)tag;

-(IBAction)addNewItemButtonPressed:(id)sender;
@end
