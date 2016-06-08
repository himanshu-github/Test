//
//  NGEditKeySkillInputCell.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 22/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGEditKeySkillInputCell : NGCustomValidationCell

@property (weak,nonatomic) IBOutlet NGTextField *txtField;
-(void)configureCell:(NSString*)keySkill;

@end
