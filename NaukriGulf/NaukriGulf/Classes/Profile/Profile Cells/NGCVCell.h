//
//  NGCVCell.h
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  The class used for customizing the cv cell. 
 */
@interface NGCVCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *resumeNameLbl;
//@property (weak, nonatomic) IBOutlet NGButton *uploadBtn;
//@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdateDateOfResume;
//@property (weak, nonatomic) IBOutlet UILabel *lblHeadingText;
//
-(void)configureCellWithData:(NGMNJProfileModalClass*)usrDetailsObj;
-(void)configureCellWithoutData;

- (IBAction)uploadTapped:(id)sender;

@end
