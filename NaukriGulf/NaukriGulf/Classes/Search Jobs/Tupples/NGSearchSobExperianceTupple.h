//
//  NGSearchSobExperianceTupple.h
//  NGSearchPage
//
//  Created by Arun Kumar on 1/14/14.
//  Copyright (c) 2014 naukri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExperinceTupleDelegate <NSObject>

-(void)userSelectedExperience:(NSInteger)selectedExperience;

@end

@interface NGSearchSobExperianceTupple : UITableViewCell<UIScrollViewDelegate>
/**
 *  This delegate is used for passing Experience Slider value to NISearchJobsViewController.
 */
@property(nonatomic,assign)id <ExperinceTupleDelegate> delegate;

/**
 *  This variable is used for checking whether experiance button pressed first time.
 */
@property(nonatomic, assign) BOOL bIsFirstTimeSelected;

/**
 *  This variable holds current selected experience value.
 */
@property(nonatomic)     NSInteger iCurrentSelectedExperience;


/**
 *  This variable checks for prefilling the experince slider value.
 */
@property (nonatomic, assign) BOOL bPresetExperience;

/**
 *  This method is used for setting Experience slider for prefilling.
 *
 *  @param experience It denotes at which experience slider to set.
 */
- (void)setExperience:(NSString*)currentExperience andPreviousExperince:(NSString*)previousExperience;

@property(nonatomic, weak) IBOutlet UIScrollView* scrollExperiance;
/**
 *  This method is used for configuring scrollview slider.
 */

- (void)configureExperienceScrollview;
@end
