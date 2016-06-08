//
//  NGEmployerDetailsCell.h
//  NaukriGulf
//
//  Created by Minni Arora on 07/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
/**
 *   Custom cell for Employer's detail.
 */
@interface NGEmployerDetailsCell : UITableViewCell 
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *employerDetailsLbl;
@property(nonatomic) BOOL isEDReadMoreTapped;

- (void)configureEDCell:(NGJDJobDetails *)cell ;
@end
