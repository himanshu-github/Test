//
//  NIDashboardCell.h
//  Naukri
//
//  Created by Swati Kaushik on 15/04/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSInteger{
    CellTypeRecommendedJobs = 1,
    CellTypeSavedJobs,
    CellTypeAppliedJobs,
    CellTypePV,
}CellType;
@protocol NIDashboardCellDelegate <NSObject>

-(void)changeCellState:(CellType)type isExpanded:(BOOL)isExpanded;

@end
@interface NIDashboardCell : UITableViewCell
{
    IBOutlet UILabel* titleLbl;
    IBOutlet UILabel* counterLbl;
    IBOutlet UIImageView* tilesImageView;
    IBOutlet UILabel* tilesCountLbl;
    
}
@property (nonatomic,assign) id<NIDashboardCellDelegate> delegate;
@property (nonatomic,assign) NSInteger displayCount;
@property (nonatomic,assign) BOOL isExpanded;
@property (nonatomic,assign) NSInteger tileCount;
-(void)configureCellWithType:(CellType)cellType;
@end
