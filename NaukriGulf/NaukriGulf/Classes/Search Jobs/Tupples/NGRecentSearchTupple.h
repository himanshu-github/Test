//
//  NGRecentSearcheTupple.h
//  NGSearchPage
//
//  Created by Arun Kumar on 1/14/14.
//  Copyright (c) 2014 naukri. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NGJobAlertDetail.h"
@class NGRecentSearchData;

typedef enum{
    RecentSearchTuppleType,
    SavedAlertSearchTuppleType
}SearchTuppleType;

@protocol SaveSearchDelegate <NSObject>

@optional
-(void) showJobsForSaveSearch:(NSInteger) index;

@end

@interface NGRecentSearchTupple : UITableViewCell
@property(weak,nonatomic) IBOutlet UILabel* lblKeyword; //skill, role or designation
@property(weak,nonatomic) IBOutlet UILabel* lblLocation; // experience or salary
@property(weak,nonatomic) IBOutlet UILabel* lblExperience; // experience or salary
@property(weak,nonatomic) IBOutlet UILabel* lblSalary; // experience or salary
@property (weak, nonatomic) IBOutlet UILabel *lblAlertName;
@property (weak,nonatomic) IBOutlet UILabel *lblJobCount;
@property(weak,nonatomic) id delegate;
@property(assign,nonatomic) int index;
@property (nonatomic,readwrite) SearchTuppleType tuppleType;
/**
 *  This method is used for configuring Recent Searches Cell.
 *
 *  @param data contains the Searched Job parameters.
 */
- (void)configureCellWithData:(NGRescentSearchTuple*)paramData AndIndex:(NSInteger)paramIndex;
@end
