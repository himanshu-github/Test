//
//  NGEducationDetailsCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEducationDetailsCell.h"

@interface NGEducationDetailsCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblBasicDegree;
@property (weak, nonatomic) IBOutlet UILabel *lblMaterDegree;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctorateDegree;
@property (weak, nonatomic) IBOutlet UILabel *lblBasicSpec;
@property (weak, nonatomic) IBOutlet UILabel *lblMaterSpec;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctorateSpec;
@property (weak, nonatomic) IBOutlet UIImageView *doctorateDegreeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *mastersDegreeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *basicDegreeIcon;

@end

@implementation NGEducationDetailsCell

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

-(void)configure:(NGApplyFieldsModel*)model{
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    NSMutableArray *vArray = [vManager validateValue:[model.gradCourse objectForKey:KEY_VALUE] withType:ValidationTypeString];
    
    self.lblBasicDegree.text = (0>=vArray.count)?[model.gradCourse objectForKey:KEY_VALUE]:[NSString stringWithFormat:@"Grad Course %@",K_NOT_MENTIONED];
    
    vArray = [vManager validateValue:[model.gradspecialisation objectForKey:KEY_VALUE] withType:ValidationTypeString];
    self.lblBasicSpec.text = (0>=vArray.count)?[model.gradspecialisation objectForKey:KEY_VALUE]:[NSString stringWithFormat:@"Grad Spec %@",K_NOT_MENTIONED];
    
    vArray = [vManager validateValue:[model.pgCourse objectForKey:KEY_VALUE] withType:ValidationTypeString];
    self.lblMaterDegree.text = (0>=vArray.count)?[model.pgCourse objectForKey:KEY_VALUE]:[NSString stringWithFormat:@"PG Course %@",K_NOT_MENTIONED];
    
    vArray = [vManager validateValue:[model.pgSpecialisation objectForKey:KEY_VALUE] withType:ValidationTypeString];
    self.lblMaterSpec.text = (0>=vArray.count)?[model.pgSpecialisation objectForKey:KEY_VALUE]:[NSString stringWithFormat:@"PG Spec %@",K_NOT_MENTIONED];
    
    vArray = [vManager validateValue:[model.doctCourse objectForKey:KEY_VALUE] withType:ValidationTypeString];
    self.lblDoctorateDegree.text = (0>= vArray.count)?[model.doctCourse objectForKey:KEY_VALUE]:[NSString stringWithFormat:@"PPG Course %@",K_NOT_MENTIONED];
    
    vArray = [vManager validateValue:[model.doctspecialisation objectForKey:KEY_VALUE] withType:ValidationTypeString];
    self.lblDoctorateSpec.text = (0>=vArray.count)?[model.doctspecialisation objectForKey:KEY_VALUE]:[NSString stringWithFormat:@"PPG Spec %@",K_NOT_MENTIONED];
    
    [self setAccessibilityLabels];
    
    vArray = nil;
    vManager = nil;
}

-(void)setAccessibilityLabels{
    
    [UIAutomationHelper setAccessibiltyLabel:@"basic_degree_lbl" value:_lblBasicDegree.text forUIElement:_lblBasicDegree];
    
    [UIAutomationHelper setAccessibiltyLabel:@"basic_spec_lbl" value:_lblBasicSpec.text forUIElement:_lblBasicSpec];
    
    [UIAutomationHelper setAccessibiltyLabel:@"master_degree_lbl" value:_lblMaterDegree.text forUIElement:_lblMaterDegree];
    
    [UIAutomationHelper setAccessibiltyLabel:@"master_spec_lbl" value:_lblMaterSpec.text forUIElement:_lblMaterSpec];
    
    [UIAutomationHelper setAccessibiltyLabel:@"doctorate_degree_lbl" value:_lblDoctorateDegree.text forUIElement:_lblDoctorateDegree];
    
    [UIAutomationHelper setAccessibiltyLabel:@"doctorate_spec_lbl" value:_lblDoctorateSpec.text forUIElement:_lblDoctorateSpec];
    
    [UIAutomationHelper setAccessibiltyLabel:@"EducationDetailsCell" forUIElement:self withAccessibilityEnabled:NO];
}
@end
