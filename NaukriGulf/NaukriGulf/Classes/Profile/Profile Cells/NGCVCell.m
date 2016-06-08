//
//  NGCVCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCVCell.h"

@interface NGCVCell ()
{


    __weak IBOutlet UILabel *resumeNameLbl;
    __weak IBOutlet NGButton *uploadBtn;
    __weak IBOutlet UILabel *lblLastUpdateDateOfResume;
    __weak IBOutlet UILabel *lblHeadingText;
    
    __weak IBOutlet UIImageView *redDotCV;

    
    
}
@end

@implementation NGCVCell

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
-(void)configureCellWithoutData{
    
    redDotCV.hidden = NO;
    lblHeadingText.text = @"No CV Attached";
    UIView *view = [self.contentView viewWithTag:10];
    view.hidden = YES;
    
    view = [self.contentView viewWithTag:11];
    view.hidden = NO;

}
-(void)configureCellWithData:(NGMNJProfileModalClass*)usrDetailsObj{

    redDotCV.hidden = YES;
    
    NSString *name = usrDetailsObj.name;
    
    if (name.length > 42 && name!=nil) {
        name = [name substringToIndex:42];
        name = [name stringByAppendingString:@"..."];
    }
    
    
    NSString *wholeResumeName = [NSString stringWithFormat:@"%@.%@",name,usrDetailsObj.attachedCvFormat.lowercaseString];
    
    resumeNameLbl.text = wholeResumeName;
    
    NSString *date1 = [[usrDetailsObj.attachedCvModDate componentsSeparatedByString:@" "] firstObject];
    
    NSString *dateTmp = [NGDateManager getDateInLongStyle:date1];
    
    lblLastUpdateDateOfResume.text = [NSString stringWithFormat:@"Last Updated - %@",dateTmp];
    
    
    [UIAutomationHelper setAccessibiltyLabel:@"resumeName_lbl" value:resumeNameLbl.text forUIElement:resumeNameLbl];
    [UIAutomationHelper setAccessibiltyLabel:@"resumeLastUpdateDate_lbl" value:lblLastUpdateDateOfResume.text forUIElement:lblLastUpdateDateOfResume];
    
    [UIAutomationHelper setAccessibiltyLabel:@"redDotCV" value:@"redDotCV" forUIElement:redDotCV];

    
    
    UIView *view = [self.contentView viewWithTag:11];
    view.hidden = YES;
    
    view = [self.contentView viewWithTag:10];
    view.hidden = NO;
    lblHeadingText.text = @"Attached CV";


}
- (IBAction)uploadTapped:(id)sender{
    
}
- (void)dealloc{
}
@end
