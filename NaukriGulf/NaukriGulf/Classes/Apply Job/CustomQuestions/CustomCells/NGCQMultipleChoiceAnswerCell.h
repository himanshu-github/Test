//
//  NGCQMultipleChoiceAnswerCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 08/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol multipleCheckMarkOptionDelegate ;

@interface NGCQMultipleChoiceAnswerCell : UITableViewCell
@property(assign) id <multipleCheckMarkOptionDelegate> delegateForAnsweredOptions;
-(void)configureCQMultipleChoiceAnswerCell:(NSDictionary*)dictData;
@property (weak, nonatomic) IBOutlet UIImageView *option1Icon;
@property (weak, nonatomic) IBOutlet UIImageView *option2Icon;
@property (weak, nonatomic) IBOutlet UIImageView *option3Icon;
@property (weak, nonatomic) IBOutlet UIImageView *option4Icon;
@end


@protocol multipleCheckMarkOptionDelegate <NSObject>
@optional
- (void) multipleCheckMarkOptionPressed:(UIImageView*)imgV andCell:(NGCQMultipleChoiceAnswerCell*)cell;

@end;