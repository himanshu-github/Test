//
//  NGProfileEducationCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGProfileEducationCell.h"


@implementation NGProfileEducationCell{
    NGEducationDetailModel *modalClassObj;
    __weak IBOutlet UILabel *lblCourseName;
    __weak IBOutlet UILabel *lblSpecialization;
    __weak IBOutlet UILabel *lblCountry;
    __weak IBOutlet UILabel *lblYear;
    __weak IBOutlet UIButton *btnEducationEdit;
    __weak IBOutlet UIView *educationSeperatorView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setEducationDataWithModel:(NGMNJProfileModalClass*)usrDetailsObj andIndex:(NSInteger)index{
    
    NGEducationDetailModel *educationItemDataObject = [usrDetailsObj.educationList fetchObjectAtIndex:index];
    
    NSString *addCourseTypeTmp = usrDetailsObj.addCourseType;
    if ([addCourseTypeTmp isEqualToString:@""]) {
        if (index+1 == [usrDetailsObj.educationList count]) {
            [educationSeperatorView setHidden:NO];
        }else{
            [educationSeperatorView setHidden:YES];
        }
    }else{
        
        [educationSeperatorView setHidden:YES];
        
    }
    
    modalClassObj = educationItemDataObject;
    
    btnEducationEdit.tag = 10+index;
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    NSString *courseName = [modalClassObj.course objectForKey:KEY_VALUE];
    
    if ([courseName isEqualToString:@"Other"]) {
        courseName = [modalClassObj.course objectForKey:KEY_SUBVALUE];
    }
    
    NSString *spec = [modalClassObj.specialization objectForKey:KEY_VALUE];
    if ([spec isEqualToString:@"Other"]) {
        spec = [modalClassObj.specialization objectForKey:KEY_SUBVALUE];
    }
    
    if (0>=[vManager validateValue:courseName withType:ValidationTypeString].count) {
        lblCourseName.text = courseName;
    }else{
        lblCourseName.text = K_NOT_MENTIONED;
    }
    
    if (0>=[vManager validateValue:spec withType:ValidationTypeString].count) {
        lblSpecialization.text = spec;
    }else{
        lblSpecialization.text = K_NOT_MENTIONED;
    }
    
    NSString *country = [modalClassObj.country objectForKey:KEY_VALUE];
    NSString *countryNameForAccessibilityLabel = @"";
    if (0>=[vManager validateValue:country withType:ValidationTypeString].count) {
        lblCountry.text = [NSString stringWithFormat:@"%@ - ",country];
        countryNameForAccessibilityLabel = country;
    }else{
        lblCountry.text = @"Not Mentioned - ";
        countryNameForAccessibilityLabel = K_NOT_MENTIONED;
    }
    
    if (0>=[vManager validateValue:modalClassObj.year withType:ValidationTypeString].count) {
        lblYear.text = modalClassObj.year;
    }else{
        lblYear.text = K_NOT_MENTIONED;
    }
    
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"courseName_%@_lbl",modalClassObj.type] value:lblCourseName.text forUIElement:lblCourseName];
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"spec_%@_lbl",modalClassObj.type] value:lblSpecialization.text forUIElement:lblSpecialization];
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"country_%@_lbl",modalClassObj.type] value:countryNameForAccessibilityLabel forUIElement:lblCountry];
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"year_%@_lbl",modalClassObj.type] value:lblYear.text forUIElement:lblYear];
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"editEducation_%@_btn",modalClassObj.type ]forUIElement:btnEducationEdit];
    
    vManager = nil;

    
}
-(IBAction)educationEditButtonPressed:(id)sender{
    NGEditEducationViewController *vc = [[NGEditEducationViewController alloc]
                                         initWithNibName:nil bundle:nil];
    
    vc.modalClassObj = modalClassObj;
    vc.courseTypeValue = modalClassObj.type;
    vc.editDelegate = self;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
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
