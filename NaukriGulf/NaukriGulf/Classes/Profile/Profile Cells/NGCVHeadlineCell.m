//
//  NGCVHeadlineCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCVHeadlineCell.h"


@interface NGCVHeadlineCell ()
{
    __weak IBOutlet UILabel *cvHeadlineLbl;
    
    __weak IBOutlet UIImageView *redDotCV;

}
- (IBAction)editBtnTapped:(id)sender;

@end

@implementation NGCVHeadlineCell

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

-(void)customizeUI{
    
    redDotCV.hidden = YES;

    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if(0>=[vManager validateValue:_modalClassObj.headline withType:ValidationTypeString].count)
    {
        cvHeadlineLbl.text = _modalClassObj.headline;
    }
    else{
        cvHeadlineLbl.text = K_NOT_MENTIONED;
        redDotCV.hidden = NO;
    }
    [UIAutomationHelper setAccessibiltyLabel:@"cvHeadline_lbl" value:cvHeadlineLbl.text forUIElement:cvHeadlineLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"editCVHeadLine_btn" forUIElement:[self.contentView viewWithTag:99]];
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotCV" value:@"redDotCV" forUIElement:redDotCV];

    
    
    vManager = nil;
}

- (IBAction)editBtnTapped:(id)sender {
    NGEditCVHeadlineViewController *vc = [[NGEditCVHeadlineViewController alloc]init];
    vc.modalClassObj = _modalClassObj;
    vc.editDelegate = self;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
    
    [vc updateDataWithParams:vc.modalClassObj];
}

#pragma mark EditCVHeadline Delegate

-(void)editedCVHeadlineWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}

- (void)dealloc{
}

@end
