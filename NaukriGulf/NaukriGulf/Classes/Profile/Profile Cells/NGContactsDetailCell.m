//
//  NGContactsDetailCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGContactsDetailCell.h"

@interface NGContactsDetailCell ()
{

    __weak IBOutlet NGLabel *emailLbl;
    __weak IBOutlet NGLabel *mobileLbl;
    
    __weak IBOutlet UIImageView *redDotEmail;
    
    __weak IBOutlet UIImageView *redDotMobileNumber;
    
    
    
}
/**
 *  The NGMNJProfileModalClass object contains the data of user's profile.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;


- (IBAction)editTapped:(id)sender;

@end

@implementation NGContactsDetailCell

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

-(void)customizeUIWithModel:(NGMNJProfileModalClass*)modalClassObj{
    redDotEmail.hidden = YES;
    redDotMobileNumber.hidden = YES;

    _modalClassObj = modalClassObj;
    self.contentView.backgroundColor = [UIColor colorWithRed:26.0/255 green:131.0/255 blue:206.0/255 alpha:1.0];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if(0>=[vManager validateValue:_modalClassObj.username withType:ValidationTypeString].count)
    {
        emailLbl.text = _modalClassObj.username;
        
    }
    else{
        emailLbl.text = K_NOT_MENTIONED;
        redDotEmail.hidden = NO;
    }
    
    NSString *mphone = _modalClassObj.mphone;
    NSString *rphone = _modalClassObj.rphone;
    
    
    NSMutableString *contactStr = [NSMutableString stringWithString:@""];
    if (mphone && !([mphone isEqualToString:@"++"] || [mphone isEqualToString:@""])) {
        [contactStr appendString:[NSString getFormattedMobile:mphone]];
        if (rphone && !([rphone isEqualToString:@"++"]|| [rphone isEqualToString:@""])) {
            [contactStr appendFormat:@", +%@",[NSString getFormattedTelephone:rphone]];
            
            
        }
    }else{
        if (rphone && !([rphone isEqualToString:@"++"]|| [rphone isEqualToString:@""])) {
            [contactStr appendFormat:@"%@",[NSString getFormattedTelephone:rphone]];
            if (mphone && !([mphone isEqualToString:@"++"]|| [mphone isEqualToString:@""])) {
                [contactStr appendFormat:@", +%@",[NSString getFormattedMobile:mphone]];

            }
        }
    }
    if (0>=[vManager validateValue:contactStr withType:ValidationTypeString].count) {
        mobileLbl.text = contactStr;
    }else{
        mobileLbl.text = K_NOT_MENTIONED;
        redDotMobileNumber.hidden = NO;
    }
    
    [self setAutomationLabels];
    
    vManager = nil;
}
-(void)setAutomationLabels{
    
    [UIAutomationHelper setAccessibiltyLabel:@"mobile_lbl" value:mobileLbl.text forUIElement:mobileLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"email_lbl" value:emailLbl.text forUIElement:emailLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"editContactDetail_btn" forUIElement:[self.contentView viewWithTag:99]];
    
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotEmail" value:@"redDotEmail" forUIElement:redDotEmail];
    [UIAutomationHelper setAccessibiltyLabel:@"redDotMobileNumber" value:@"redDotMobileNumber" forUIElement:redDotMobileNumber];

    
}
- (IBAction)editTapped:(id)sender {
    NGEditContactDetailViewController *vc = [[NGEditContactDetailViewController alloc]
                                             initWithNibName:nil bundle:nil];
    
    vc.modalClassObj = _modalClassObj;
    vc.editDelegate = self;
    
    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:vc Animated:YES];
    
    [vc updateDataWithParams:vc.modalClassObj];
}

#pragma mark EditCVHeadline Delegate

-(void)editedContactDetailsWithSuccess:(BOOL)successFlag{
    if (successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
        });
    }
}

- (void)dealloc{
}
@end
