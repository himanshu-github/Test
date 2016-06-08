//
//  NGIndustryInfoCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGEditIndustryInformationViewController.h"
/**
 *  The class used for customizing the industry info cell.
 
 Conforms the EditIndustryInfoDelegate .
 */
@interface NGIndustryInfoCell : UITableViewCell<EditIndustryInfoDelegate>


/**
 *  The NGMNJProfileModalClass object contains the data of user's profile.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

/**
 *  This method is used for customizing the UI of cell basis the profile data.
 */
-(void)customizeUI;

@end
