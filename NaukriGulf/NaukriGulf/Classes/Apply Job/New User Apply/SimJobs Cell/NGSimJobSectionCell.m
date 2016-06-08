//
//  NGSimJobSectionCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 04/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSimJobSectionCell.h"

@interface NGSimJobSectionCell(){

 IBOutlet UILabel* lbl;
 IBOutlet UIImageView* imgView;
    
}
@end

@implementation NGSimJobSectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
