//
//  NGITSkillsCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGITSkillsCell.h"
#import "NGProfileITSkillItemCell.h"

@interface NGITSkillsCell ()
{


   __weak IBOutlet UICollectionView *collectionViewSkillItems;
   __weak IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
    
    
    
    __weak IBOutlet UIImageView *redDotITSkill;
    
}

@end

static NSString *profileITSkillItemIdentifier = @"profileITSkillItemCellIdentifier";

@implementation NGITSkillsCell

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
- (void)configureCell{

    redDotITSkill.hidden = YES;
    
    NSInteger itemCount = _skillsArr.count;
    if (itemCount > 0) {
        [collectionViewSkillItems reloadData];
    }else{
        [self removeCollectionViewFromView];
        redDotITSkill.hidden = NO;

    }
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotITSkill" value:@"redDotITSkill" forUIElement:redDotITSkill];

}

- (void)removeCollectionViewFromView{
    [collectionViewSkillItems setHidden:YES];
    [collectionViewHeightConstraint setConstant:0];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_skillsArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NGProfileITSkillItemCell *cell = (NGProfileITSkillItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:profileITSkillItemIdentifier forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    if (cell == nil) {
        cell = [[NGProfileITSkillItemCell alloc] initWithFrame:CGRectMake(0, 0, 160, 64)];
    }
    NGITSkillDetailModel *obj = [_skillsArr fetchObjectAtIndex:row];
    [cell createITSkillfromData:obj atIndex:row];
    
    NSInteger itemCount = [_skillsArr count] - 1;
    if (itemCount == row) {
        [cell.viewSeperatorView setHidden:YES];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}
- (void)dealloc{
    //NSLog(@"%s",__PRETTY_FUNCTION__);
}
@end
