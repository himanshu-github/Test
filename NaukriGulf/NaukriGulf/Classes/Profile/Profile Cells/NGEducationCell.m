//
//  NGEducationCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEducationCell.h"

@interface NGEducationCell ()

- (IBAction)addEducationTapped:(id)sender;

@end

@implementation NGEducationCell

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
    [UIAutomationHelper setAccessibiltyLabel:@"addEducation_btn" forUIElement:[self.contentView viewWithTag:2]];

}

- (IBAction)addEducationTapped:(id)sender {
    
    NGEditEducationViewController *vc = [[NGEditEducationViewController alloc]
                                         initWithNibName:nil bundle:nil];
    

    vc.courseTypeValue = self.addCourseType;
    vc.editDelegate = self;

    [((IENavigationController*)APPDELEGATE.container.centerViewController) pushActionViewController:vc Animated:YES];
    
}

#pragma mark Education Tuple Delegate

-(void)editEducationTupleWithParams:(NGEducationDetailModel *)obj{
    
    NGEditEducationViewController *vc = [[NGEditEducationViewController alloc]
                                                   initWithNibName:nil bundle:nil];
    
    vc.modalClassObj = obj;
    vc.courseTypeValue = obj.type;
    vc.editDelegate = self;
    
    [((IENavigationController*)APPDELEGATE.container.centerViewController) pushActionViewController:vc Animated:YES];
    
}

#pragma mark Edit Education Delegate

-(void)editedEducationWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}


@end
