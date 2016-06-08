//
//  NGProfileInfoCell.h
//  Naukri
//
//  Created by Swati Kaushik on 18/04/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGProfileInfoCell : UITableViewCell
{
    IBOutlet UILabel* profileNameLbl;
    IBOutlet UILabel* designationLbl;
    IBOutlet UILabel* lastUpdatedLbl;

}
@property (weak, nonatomic) IBOutlet UILabel *showHideDataLabel;

-(void)configureCell;
@end
