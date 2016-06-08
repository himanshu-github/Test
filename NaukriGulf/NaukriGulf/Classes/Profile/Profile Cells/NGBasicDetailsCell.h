//
//  NGBasicDetailsCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGEditBasicDetailsViewController.h"
#import "NGEditPhotoViewController.h"

/**
 *  The class used for customizing the basic details cell.
 
    Conforms the EditBasicDetailsDelegate, EditPhotoDelegate .
 */

@interface NGBasicDetailsCell : UITableViewCell<EditBasicDetailsDelegate,EditPhotoDelegate>

@property (weak, nonatomic) IBOutlet NGButton *editPhotoBtn;
@property (weak, nonatomic) IBOutlet NGImageView *profileImg;
@property (weak, nonatomic) IBOutlet NGLabel *salaryLbl;


/**
 *  This method is used for customizing the UI of cell basis the profile data.
 */
-(void)customizeUIWithModel:(NGMNJProfileModalClass*)modalClassObj;

@end
