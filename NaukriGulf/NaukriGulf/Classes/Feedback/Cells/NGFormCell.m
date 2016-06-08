//
//  NGFormCell.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 8/27/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGFormCell.h"

@implementation NGFormCell

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


-(void)configureDataForInputType:(FormType)formType index:(NSInteger)index
{
    InputFieldType inputFieldType = inputFieldTypeMail;
    _inputTextField.tag = 200+index; //This has been set as 200 from the xib
       NSString* placeHolder = @"";
    
    //decide field type first
    switch (index)
    {
        case 0:
        {
            switch (formType)
            {
                case contactUs:
                    inputFieldType= inputFieldTypeFeedback;
                    placeHolder = @"Feedback";
                    break;
                
                case loginForm:
                    inputFieldType= inputFieldTypeMail;
                    placeHolder = @"Email Address";
                    self.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
                    
                    break;
                    
                case forgotPwd:
                    inputFieldType= inputFieldTypeMail;
                    placeHolder = @"Enter your Registered Email";
                    self.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
                    break;
                    
                default:
                    self.inputTextField.keyboardType = UIKeyboardTypeDefault;
                    
                    break;
            }
            
        }
            break;
            
        case 1:
        {
            switch (formType) {
                case loginForm:
                    inputFieldType= inputFieldTypePwd;
                    self.inputTextField.keyboardType = UIKeyboardTypeDefault;
                    self.inputTextField.returnKeyType = UIReturnKeyGo;
                    placeHolder = @"Password";
                    break;
                    
                    case contactUs:
                    placeHolder = @"Your Name";
                    inputFieldType= inputFieldTypeName;
                    self.inputTextField.keyboardType = UIKeyboardTypeDefault;
                    break;
                    
                default:
                    self.inputTextField.keyboardType = UIKeyboardTypeDefault;
                    break;
            }
        }
            break;
            

        case 2:
        {
            
            switch (formType)
            {
                case contactUs:
                    inputFieldType= inputFieldTypeMail;
                    self.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
                    placeHolder = @"Email ID";
                    break;
                    
                default:
                    self.inputTextField.keyboardType = UIKeyboardTypeDefault;
                    
                    break;
            }
            
        }
            break;
            
              break;
        case 3:
            default:
            self.inputTextField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
    
    //set image based on field type
    NSString* autLabel = @"";
    switch (inputFieldType)
    {
        case inputFieldTypeMail:
            [self.inputTextField setLeftViewWithImage:@"emailLogin"];
            autLabel = @"mail";
             break;
        case inputFieldTypePwd:
            [self.inputTextField setLeftViewWithImage:@"password"];
            autLabel = @"password";
            break;
        case inputFieldTypeName:
            [self.inputTextField setLeftViewWithImage:@"name"];
            autLabel = @"name";
            break;
            
        case inputFieldTypeMobileNum:
            self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            [self.inputTextField setLeftViewWithImage:@"mobile"];
            autLabel = @"mobile";
            break;
        default:
            break;
    }
    
    _inputTextField.returnKeyType = UIReturnKeyDone;
    _inputTextField.placeholder = placeHolder;
 
    NSString*  className = formType==loginForm?@"loginForm":(formType==contactUs?@"contactUs":@"forgotPassword");
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%@_%@_txtFld",className,autLabel] forUIElement:_inputTextField];
    
}


@end
