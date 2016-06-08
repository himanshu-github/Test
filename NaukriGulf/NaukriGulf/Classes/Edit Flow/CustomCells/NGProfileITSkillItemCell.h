//
//  NGProfileITSkillItemCell.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGProfileITSkillItemCell : UICollectionViewCell

@property (weak,nonatomic) IBOutlet UILabel *lblSkills;
@property (weak,nonatomic) IBOutlet UILabel *lblDuration;
@property (weak,nonatomic) IBOutlet UILabel *lblLastUsingYear;
@property (weak,nonatomic) IBOutlet UIView *viewSeperatorView;

- (void)createITSkillfromData:(NGITSkillDetailModel*)obj atIndex:(NSInteger)index;
@end
