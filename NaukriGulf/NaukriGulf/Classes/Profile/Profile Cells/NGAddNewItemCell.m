//
//  NGAddNewItemCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGAddNewItemCell.h"



@implementation NGAddNewItemCell
{


   __weak IBOutlet UILabel *lblAddNewItemText;
   __weak IBOutlet UIButton *btnAddNewItem;
    

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)customizeUIWithData:(NSString *)data andTagValue:(int)tag{

    [btnAddNewItem setTag:tag];
    [lblAddNewItemText setText:data];

}
-(IBAction)addNewItemButtonPressed:(id)sender{
    switch ([sender tag]) {
        case EDUCATION:{
            NGEditEducationViewController *vc = [[NGEditEducationViewController alloc]
                                                 initWithNibName:nil bundle:nil];
            
            vc.courseTypeValue = [_infoData objectForKey:@"addCourseType"];
            vc.editDelegate = self;
            
            [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
            
        }break;
        
        case WORK_EXPERIENCE:{
            
            NGEditWorkExperienceViewController *vc = [[NGEditWorkExperienceViewController alloc]
                                                      initWithNibName:nil bundle:nil];
            vc.editDelegate = self;
            
            [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
        }break;
            
        default:
            break;
    }
}
#pragma mark Edit WorkExperience Delegate

-(void)editedWorkExpWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}
#pragma mark Edit Education Delegate

-(void)editedEducationWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}
- (void)dealloc{
}
@end
