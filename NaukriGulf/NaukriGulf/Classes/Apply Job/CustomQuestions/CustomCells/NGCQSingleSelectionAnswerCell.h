//
//  NGCQSingleSelectionAnswerCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 08/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol checkMarkOptionDelegate ;

@interface NGCQSingleSelectionAnswerCell : UITableViewCell<UIGestureRecognizerDelegate>
{
   
}
@property(assign) id <checkMarkOptionDelegate> delegateForAnsweredOption;


//autolyaout constraints

@property (weak, nonatomic) IBOutlet UIImageView *option1Icon;
@property (weak, nonatomic) IBOutlet UIImageView *option2Icon;
@property (weak, nonatomic) IBOutlet UIImageView *option3Icon;
@property (weak, nonatomic) IBOutlet UIImageView *option4Icon;

-(void)configureCQSingleSelectionAnswerCell:(NSDictionary*)dictData;


@end



@protocol checkMarkOptionDelegate <NSObject>

@optional
- (void) checkMarkOptionPressed:(UIImageView*)imgV andCell:(NGCQSingleSelectionAnswerCell*)cell;

@end;