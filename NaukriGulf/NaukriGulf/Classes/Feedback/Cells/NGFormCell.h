//
//  NGFormCell.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 8/27/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NGFormCell : NGCustomValidationCell
@property (weak, nonatomic) IBOutlet NGTextField *inputTextField;

-(void)configureDataForInputType:(FormType)formType index:(NSInteger)index;


@end
