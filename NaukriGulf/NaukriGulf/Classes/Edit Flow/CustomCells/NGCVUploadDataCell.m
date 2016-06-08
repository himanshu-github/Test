//
//  NGCVUploadDataCell.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 10/03/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGCVUploadDataCell.h"

@implementation NGCVUploadDataCell{
    IBOutlet UIImageView *uploadServiceImageView;
    
    
    __weak IBOutlet NSLayoutConstraint *leadingConstrntOfImgView;
    
}

- (void)awakeFromNib {
    // Initialization code
    
    float xOffset = 0;
    
    if(IS_IPHONE4||IS_IPHONE5)
        xOffset =42;
    else if (IS_IPHONE6)
        xOffset = 65;
    else if (IS_IPHONE6_PLUS)
        xOffset = 94;
    
    leadingConstrntOfImgView.constant = xOffset;
}
-(void)configureCellWithWay:(enum NGResmanCVUploadWay)paramWay{
    switch (paramWay) {
        case NGResmanCVUploadWayDropbox:{
            self.lblMaintext.text = @"Dropbox";
            [self setIconImageWithImageName:@"dropbox_img"];
        }break;
            
        case NGResmanCVUploadWayGoogleDrive:{
            self.lblMaintext.text = @"Google Drive";
            [self setIconImageWithImageName:@"googledrive_img"];
        }break;
            
        case NGResmanCVUploadWayiCloudDrive:{
            self.lblMaintext.text = @"iCloud Drive";
            [self setIconImageWithImageName:@"iCloud_drive_img"];
        }break;
            
                   
        default:
            break;
    }
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    
}
-(void)setIconImageWithImageName:(NSString*)paramImageName{
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    BOOL isValidString = (0 >= [vManager validateValue:paramImageName withType:ValidationTypeString].count);
    
    
    if (isValidString) {
        uploadServiceImageView.hidden = NO;
        uploadServiceImageView.image = [UIImage imageNamed:paramImageName];
    }else{
        uploadServiceImageView.hidden = YES;
    }
    vManager = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
