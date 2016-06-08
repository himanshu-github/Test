//
//  NGSearchJobParametersTupple.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 18/08/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGSearchJobParametersTupple.h"


NSInteger const K_KEYSKILL_TEXTFIELD_HEIGHT     = 20;
@interface NGSearchJobParametersTupple()
{
}
/**
 *  Used for left image in cell.
 */
@property(weak, nonatomic) IBOutlet UIImageView* imgBegin;
/**
 *  This variable denotes Search Job Button.
 */
@property(weak, nonatomic) IBOutlet UIButton* btnSearchJob;

@property (readwrite,nonatomic,assign) BOOL isValueSelectorTypeCell;


@end
@implementation NGSearchJobParametersTupple
@synthesize isValueSelectorTypeCell = _isValueSelectorTypeCell;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCellForModifySearchWithData:(NSMutableDictionary*)dataDict andIndexPath:(NSIndexPath*)index{

    switch (index.row) {
        case 0:
        {
        
            self.selectionStyle=UITableViewCellSelectionStyleNone;
            self.index = index.row;
            self.imgBegin.image=[UIImage imageNamed:@"keywords"];
            self.txtParameter.userInteractionEnabled    = YES;
            self.txtParameter.placeholder               = @"Enter Skill, Designation, Role";
            [self setTextFieldHeight:K_KEYSKILL_TEXTFIELD_HEIGHT];
            self.txtParameter.text = [dataDict objectForKey:@"cellText"];
            [UIAutomationHelper setAccessibiltyLabel:@"keySkill_txtFld" forUIElement:self.txtParameter];
            [self setKeyboardReturnKeyTypeForTextField:UIReturnKeyDone];
            self.isValueSelectorTypeCell = NO;

        }
            break;
        case 1:
        {
            
            self.selectionStyle=UITableViewCellSelectionStyleNone;

            self.index = index.row;
            self.txtParameter.userInteractionEnabled=NO;
            self.txtParameter.placeholder=@"Location";
            self.imgBegin.image=[UIImage imageNamed:@"location"];
            self.txtParameter.text = [dataDict objectForKey:@"cellText"];
            [UIAutomationHelper setAccessibiltyLabel:@"location_txtFld" forUIElement:self.txtParameter];
            self.isValueSelectorTypeCell = YES;

            
        }
            break;
        case 2:
        {
            
            self.selectionStyle=UITableViewCellSelectionStyleNone;

            self.index = index.row;
            self.txtParameter.userInteractionEnabled=NO;
            self.txtParameter.placeholder=@"Select Work Experience";
            self.imgBegin.image=[UIImage imageNamed:@"experience"];
            self.txtParameter.text = [dataDict objectForKey:@"cellText"];
            [UIAutomationHelper setAccessibiltyLabel:@"experience_txtFld" forUIElement:self.txtParameter];
            
            self.isValueSelectorTypeCell = YES;
            
            
        }
            break;
        case 3:
        {
            
            self.selectionStyle=UITableViewCellSelectionStyleNone;

            self.index = index.row;
            self.txtParameter.userInteractionEnabled=NO;
            self.txtParameter.placeholder=@"Select Function / Department";
            self.imgBegin.image=[UIImage imageNamed:@"functional_edit"];
            self.txtParameter.text = [dataDict objectForKey:@"cellText"];
            [UIAutomationHelper setAccessibiltyLabel:@"department_txtFld" forUIElement:self.txtParameter];
            
            self.isValueSelectorTypeCell = YES;
            
            
        }
            break;
        case 4:
        {
            
            self.selectionStyle=UITableViewCellSelectionStyleNone;

            self.index = index.row;
            self.txtParameter.userInteractionEnabled=NO;
            self.txtParameter.placeholder=@"Select Industry you want to work in";
            self.imgBegin.image=[UIImage imageNamed:@"industry_edit"];
            self.txtParameter.text = [dataDict objectForKey:@"cellText"];
            [UIAutomationHelper setAccessibiltyLabel:@"industry_txtFld" forUIElement:self.txtParameter];
            
            self.isValueSelectorTypeCell = YES;
            
            
        }
            break;


            
        default:
            break;
    }
    

}
-(void)configureCellForSearchWithData:(NSMutableDictionary*)dataDict andIndex:(int)index{

    switch (index) {
        case RowType_Skills:
        {
        
            self.selectionStyle=UITableViewCellSelectionStyleNone;

            self.isValueSelectorTypeCell = NO;
            self.txtParameter.userInteractionEnabled = YES;
            self.index = index;
            self.imgBegin.image=[UIImage imageNamed:@"keywords"];
            self.txtParameter.placeholder               = K_KEY_PLACEHOLDER_KEY_SKILL;
            [self setTextFieldHeight:K_KEYSKILL_TEXTFIELD_HEIGHT];
            self.txtParameter.text = [dataDict objectForKey:@"cellText"];
            [UIAutomationHelper setAccessibiltyLabel:@"keySkill_txtFld" forUIElement:self.txtParameter];
            [self setKeyboardReturnKeyTypeForTextField:UIReturnKeyDone];
            
            

        }
            break;
        case RowType_Location:
        {
            
            self.selectionStyle=UITableViewCellSelectionStyleNone;

            self.isValueSelectorTypeCell = YES;
            self.txtParameter.userInteractionEnabled=NO;
            self.index = index;
            self.txtParameter.placeholder=@"Location";
            self.imgBegin.image=[UIImage imageNamed:@"location"];
            self.txtParameter.text = [dataDict objectForKey:@"cellText"];
            [UIAutomationHelper setAccessibiltyLabel:@"location_txtFld" forUIElement:self.txtParameter];
            
        }
            break;
        case RowType_Location_Other:
        {
            
            self.selectionStyle=UITableViewCellSelectionStyleNone;

            self.index = index;
            self.txtParameter.userInteractionEnabled=NO;
            self.imgBegin.image=[UIImage imageNamed:@"keywords"];
            self.txtParameter.userInteractionEnabled    = YES;
            self.txtParameter.placeholder               = K_KEY_PLACEHOLDER_LOCATION_OTHER;
            self.isValueSelectorTypeCell = NO;
            
            [self setTextFieldHeight:K_KEYSKILL_TEXTFIELD_HEIGHT];
            self.txtParameter.text = [dataDict objectForKey:@"cellText"];
            [UIAutomationHelper setAccessibiltyLabel:@"location_other_txtFld" forUIElement:self.txtParameter];
            [self setKeyboardReturnKeyTypeForTextField:UIReturnKeyDone];
            
            
            
        }
            break;
        case RowType_SearchJobs:
        {
            self.index = index;
            [UIAutomationHelper setAccessibiltyLabel:@"searchJob_btn" forUIElement:self.btnSearchJob];
            
        }
            break;

        default:
            break;
    }


}
- (BOOL)isValueSelectorTypeCell{
    return _isValueSelectorTypeCell;
}
- (void)setIsValueSelectorTypeCell:(BOOL)paramIsValueSelectorTypeCell{
    @synchronized(@"valueSelectorCellLocker"){
    _isValueSelectorTypeCell = paramIsValueSelectorTypeCell;
    if (_isValueSelectorTypeCell) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 12.0f, 20.0f)];
        [imgView setImage:[UIImage imageNamed:@"arrow"]];
        [imgView setContentMode:UIViewContentModeCenter];
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
        [tmpView addSubview:imgView];
        [_txtParameter setRightView:tmpView];
        [_txtParameter setRightViewMode:UITextFieldViewModeAlways];
        imgView = nil;
    }else{
        
        [_txtParameter setRightView:nil];
        [_txtParameter setClearButtonMode:UITextFieldViewModeWhileEditing];
     }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (&index == 0)
        return YES;
    else
        
        return NO;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldValue:)])
        [self.delegate textFieldValue:textField.text];
    
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

#pragma mark
#pragma mark Cell Configuration

- (void)hideTxtParameterField:(BOOL)status{
    
    [self.txtParameter setHidden:status];
}
-(void)setTextFieldHeight:(int)height{
    
    CGRect textFieldNewFrame       =   self.txtParameter.frame;
    textFieldNewFrame.size.height  =   height;
    textFieldNewFrame.origin.y     =   (self.frame.size.height - height)/2;
    self.txtParameter.frame        =   textFieldNewFrame;
}
- (void)setKeyboardReturnKeyTypeForTextField:(UIReturnKeyType)paramReturnKeyType{
    [_txtParameter setReturnKeyType:paramReturnKeyType];
}
- (IBAction)searchJobButtonClicked:(UIButton *)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(searchJobButtonClicked:)]){
        [_delegate searchJobButtonClicked:sender];
    }
}
@end
