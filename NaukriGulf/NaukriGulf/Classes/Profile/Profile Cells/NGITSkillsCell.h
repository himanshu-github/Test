//
//  NGITSkillsCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The class used for customizing the IT Skill cell. 
 */
@interface NGITSkillsCell : UITableViewCell

/**
 *  This method is used to add all IT Skills Tuples.
 *
 *  @param skillsArr Maintains list of all the IT Skills.
 */
@property (nonatomic,strong) NSArray *skillsArr;
- (void)removeCollectionViewFromView;
- (void)configureCell;

@end
