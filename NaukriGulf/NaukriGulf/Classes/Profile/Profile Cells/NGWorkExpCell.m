//
//  NGWorkExpCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGWorkExpCell.h"

@interface NGWorkExpCell ()

- (IBAction)addWorkExpTapped:(id)sender;

@end

@implementation NGWorkExpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)awakeFromNib{
    [UIAutomationHelper setAccessibiltyLabel:@"addWorkEx_btn" forUIElement:[self.contentView viewWithTag:2]];
    
}

- (IBAction)addWorkExpTapped:(id)sender {
    
    
    NGEditWorkExperienceViewController *vc = [[NGEditWorkExperienceViewController alloc]
                                                   initWithNibName:nil bundle:nil];
    vc.editDelegate = self;
    
    [((IENavigationController*)APPDELEGATE.container.centerViewController) pushActionViewController:vc Animated:YES];
}


#pragma mark WorkExpTuple Delegate

-(void)editWorkExpTupleWithParams:(NGWorkExpDetailModel *)obj{
    NGEditWorkExperienceViewController *vc = [[NGEditWorkExperienceViewController alloc]
                                              initWithNibName:nil bundle:nil];
    vc.editDelegate = self;
    vc.modalClassObj = obj;
    [((IENavigationController*)APPDELEGATE.container.centerViewController) pushActionViewController:vc Animated:YES];
    
}

#pragma mark Edit WorkExperience Delegate

-(void)editedWorkExpWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}

@end
