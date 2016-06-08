//
//  NGContactsDetailCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGEditContactDetailViewController.h"

/**
 *  The class used for customizing the contact details cell.
 
 Conforms the EditContactDetailsDelegate .
 */
@interface NGContactsDetailCell : UITableViewCell<EditContactDetailsDelegate>

/**
 *  This method is used for customizing the UI of cell basis the profile data.
 */
-(void)customizeUIWithModel:(NGMNJProfileModalClass*)modalClassObj;

@end
