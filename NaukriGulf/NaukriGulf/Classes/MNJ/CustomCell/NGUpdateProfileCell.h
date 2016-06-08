//
//  NIUpdateProfileCell.h
//  Naukri
//
//  Created by Arun Kumar on 6/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateProfileCellDelegate <NSObject>

-(void)onUpdateProfile;
@end

@interface NGUpdateProfileCell : UITableViewCell{
    
    id<UpdateProfileCellDelegate>delegate;
}

@property(nonatomic, strong) id<UpdateProfileCellDelegate>delegate;


@end
