//
//  NGCriticalSectionCell.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 8/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGProfileSectionModalClass.h"

@interface NGCriticalSectionCell : UITableViewCell

{
    IBOutlet UILabel* nameLbl;
    IBOutlet UILabel* descriptionLbl;
    IBOutlet UIImageView* iconImgView;
}
-(void)configureCell:(NGProfileSectionModalClass*)sectionObj ;

@end
