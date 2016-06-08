//
//  NGCVUploadDataCell.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 10/03/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ENUM(NSUInteger, NGResmanCVUploadWay){
    NGResmanCVUploadWayDropbox,
    NGResmanCVUploadWayGoogleDrive,
    NGResmanCVUploadWayiCloudDrive,
    NGResmanCVUploadWayRemindMeLater
};

@interface NGCVUploadDataCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *lblMaintext;

-(void)configureCellWithWay:(enum NGResmanCVUploadWay)paramWay;

@end
