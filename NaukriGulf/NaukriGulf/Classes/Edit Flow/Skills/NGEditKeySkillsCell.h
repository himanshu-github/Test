//
//  NGEditKeySkillsCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 23/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditKeySkillsCellDelegate <NSObject>
-(void)deleteKeySkillAtIndex:(NSInteger)index;
-(void)editKeySkillAtIndex:(NSInteger)index;
@end

@interface NGEditKeySkillsCell : UITableViewCell

-(void)configureCell:(NSString*)keySkill;
@property (weak, nonatomic) id<EditKeySkillsCellDelegate> delegate;
@property (nonatomic) NSInteger index;

@end
