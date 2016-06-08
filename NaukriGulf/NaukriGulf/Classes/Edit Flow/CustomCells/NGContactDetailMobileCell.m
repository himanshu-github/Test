//
//  NGContactDetailMobileCell.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGContactDetailMobileCell.h"

@implementation NGContactDetailMobileCell

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
    
    self.countryCode.delegate = self;
    self.mobileCode.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureMobileCellWithData:(NSMutableDictionary*)data andIndexPath:(NSIndexPath*)indexPath{

    NSString *controller = [data objectForKey:@"ControllerName"];
    
    int enumValue = 0;
    if(controller.intValue == K_EDIT_CONTACT_DETAIL_PAGE)
        enumValue = K_EDIT_CONTACT_DETAIL_PAGE;
    else if (controller.intValue == K_RESMAN_PAGE_PERSONAL_DETAILS)
        enumValue = K_RESMAN_PAGE_PERSONAL_DETAILS;
    else if (controller.intValue == K_EDIT_UNREG_APPLY)
        enumValue = K_EDIT_UNREG_APPLY;
    
    switch (enumValue) {
        case K_EDIT_CONTACT_DETAIL_PAGE:
        {
            self.index = indexPath.row;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            [lbl setText:@"+"];
            [paddingView addSubview:lbl];
            [self.countryCode setLeftViewMode:UITextFieldViewModeAlways];
            [self.countryCode setLeftView:paddingView];
            self.mobileCode.accessibilityLabel = @"mobileNumber_txtFld";
            self.countryCode.accessibilityLabel = @"countryCcode_txtFld";
            [self setAccessibilityLabel:@"mobileNumber_cell"];

            _lblPlaceHolder.text = @"Mobile Number";
            _countryCode.placeholder = @"Country";
            _mobileCode.placeholder= @"Phone Number";
            _countryCode.text = [data objectForKey:@"mobileCountryCode"];
            _mobileCode.text = [data objectForKey:@"mobileNumber"];
            
            [self customTextFieldDidBeginEditing: _mobileCode];
            [_mobileCode setKeyboardType:UIKeyboardTypeNumberPad];
            
            [self customTextFieldDidBeginEditing: _countryCode];
            [_countryCode setKeyboardType:UIKeyboardTypeNumberPad];

            
        }
        break;
        case K_RESMAN_PAGE_PERSONAL_DETAILS:
        {
            self.index = indexPath.row;
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            [lbl setText:@"+"];
            [paddingView addSubview:lbl];
            [self.countryCode setLeftViewMode:UITextFieldViewModeAlways];
            [self.countryCode setLeftView:paddingView];
            [UIAutomationHelper setAccessibiltyLabel:@"mobile_cell" forUIElement:self withAccessibilityEnabled:NO];
            self.mobileCode.accessibilityLabel = @"mobileNumber_txtFld";
            self.countryCode.accessibilityLabel = @"countryCcode_txtFld";
            
            
            _lblPlaceHolder.text = @"Mobile Number";
            _countryCode.placeholder = @"ISD code";
            _mobileCode.placeholder = @"Your Mobile Number";
            _countryCode.text = [data objectForKey:@"mobileCountryCode"];
            _mobileCode.text = [data objectForKey:@"mobileNumber"];

            [self customTextFieldDidBeginEditing: _mobileCode];
            [_mobileCode setKeyboardType:UIKeyboardTypeNumberPad];
            
            [self customTextFieldDidBeginEditing: _countryCode];
            [_countryCode setKeyboardType:UIKeyboardTypeNumberPad];

            
        }
        break;
        case K_EDIT_UNREG_APPLY:
        {
            _lblPlaceHolder.text = @"Mobile Number";
            _countryCode.placeholder = @"Country";
            _mobileCode.placeholder = @"Mobile Number";
            _countryCode.text = [data objectForKey:@"mobileCountryCode"];//mobileCountryCode;
            _mobileCode.text = [data objectForKey:@"mobileNumber"];//mobileNumber;
            self.index = indexPath.row;
            self.countryCode.tag = UnRegApplyContactCellTextTagCountryCode;
            self.mobileCode.tag = UnRegApplyContactCellTextTagMobileNumber;
            self.countryCode.accessibilityLabel = @"mobileCountryCode_txtFld";
            self.mobileCode.accessibilityLabel = @"mobileCode_txtFld";
            [self setAccessibilityLabel:@"mobileNumber_cell"];
            [self customTextFieldDidBeginEditing: _mobileCode];
            [_mobileCode setKeyboardType:UIKeyboardTypeNumberPad];
        
            [self customTextFieldDidBeginEditing: _countryCode];
            [_countryCode setKeyboardType:UIKeyboardTypeNumberPad];
        }
        break;
            
        default:
            break;
    }
        
    

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    if([_delegate respondsToSelector:@selector(textFieldShouldStartEditing:)])
        return [_delegate textFieldShouldStartEditing:_index];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([_delegate respondsToSelector:@selector(textFieldDidReturn:)])
        [_delegate textFieldDidReturn:_index];
    
    if ([_delegate respondsToSelector:@selector(textFieldDidReturn:forIndex:)]) {
        [_delegate textFieldDidReturn:textField forIndex:_index];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textField: havingIndex:)])
        [self.delegate textField:textField havingIndex:_index];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    selectedTF =textField;
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidStartEditing:)])
        [_delegate textFieldDidStartEditing:_index];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.text = [NSString stripWhiteSpaceFromBeginning:textField.text];
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldValue: havingIndex:)])
        [self.delegate textFieldValue:textField.text havingIndex:_index];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing: havingIndex:)])
        [_delegate textFieldDidEndEditing:textField havingIndex:_index];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing: WithValue:havingIndex:)]){
        [_delegate textFieldDidEndEditing:textField WithValue:textField.text havingIndex:_index];
    }
}
-(void)customTextFieldDidBeginEditing:(UITextField*)textField
{
    [textField setInputAccessoryView:[self customToolBarForKeyBoard:textField]];
}

-(UIToolbar*)customToolBarForKeyBoard:(UITextField*)textField
{
    
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolBar.frame = CGRectMake(0, 0, 320, 50);
    [toolBar setTintColor:UIColorFromRGB(0x403E3F)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [toolBar sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)];
    
    
    [doneButton setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:15],
                                         NSForegroundColorAttributeName: UIColorFromRGB(0X75cafb)
                                         } forState:UIControlStateNormal];
    NSArray *items  =   [[NSArray alloc] initWithObjects:doneButton,nil];
    
    [toolBar setItems:items];
    
    
    return toolBar;
}



-(void)dismissKeyboard:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyboardToolBarButtonPressed:)]) {
        [_delegate keyboardToolBarButtonPressed:sender];
    }
    
    [selectedTF resignFirstResponder];
    
}


@end
