//
//  NGModifySearchSaveAlertButtonTupple.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 22/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGModifySearchSaveAlertButtonTuppleDelegate <NSObject>
- (void)saveAlertButtonClicked:(UIButton *)sender;
@end


@interface NGModifySearchSaveAlertButtonTupple : UITableViewCell
@property (weak,nonatomic) IBOutlet UIButton *createAlertButton;
@property (weak,nonatomic) id<NGModifySearchSaveAlertButtonTuppleDelegate> delegate;
@end
