//
//  NGProfileSectionHeaderCell.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGProfileSectionHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *redDot;

-(void)customizeUIWithData:(NSString*)data;

- (IBAction)headerEditButtonPressed:(id)sender;

@end
