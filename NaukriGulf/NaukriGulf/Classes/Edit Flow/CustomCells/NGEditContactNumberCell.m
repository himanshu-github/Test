//
//  NIEditContactNumberCell.m
//  Naukri
//
//  Created by Arun Kumar on 3/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditContactNumberCell.h"


NSInteger const K_COUNTRY_CODE_CHARCTER_LIMIT = 10;
NSInteger const K_AREA_CODE_CHARCTER_LIMIT = 10;
NSInteger const K_NUMBER_CHARCTER_LIMIT = 15;

@interface NGEditContactNumberCell(){
    UITextField* selectedTF;
    
}

@property (nonatomic, weak) IBOutlet NGLabel* lblPlaceholder;


@end


@implementation NGEditContactNumberCell

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


-(void)configureEditContactNumberCellWithData:(NSMutableDictionary*)dataDict andIndexPath:(NSIndexPath*)indexPath{
    
    self.index = indexPath.row;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [lbl setText:@"+"];
    [paddingView addSubview:lbl];
    [self.txtCountryCode setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtCountryCode setLeftView:paddingView];
    
    
    self.txtCountryCode.accessibilityLabel = @"countryCode_txtFld";
    self.txtAreaCode.accessibilityLabel = @"areaCode_txtFld";
    self.txtNumber.accessibilityLabel = @"number_txtFld";
    [self setAccessibilityLabel:@"telephoneNumber_cell"];
    _lblPlaceholder.text = @"Telephone Number";
    _txtCountryCode.text = [dataDict objectForKey:K_KEY_EDIT_COUNTRY_CODE];
    _txtAreaCode.text = [dataDict objectForKey:K_KEY_EDIT_AREA_CODE];
    _txtNumber.text = [dataDict objectForKey:K_KEY_EDIT_PHONE_NUMBER];
    dataDict = nil;

}

#pragma mark -
#pragma mark UITextfield Delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    switch (_editModuleNumber) {
            
        case K_EDIT_CONTACT_DETAIL_PAGE:{
            
            if (textField.tag == K_RESIDENCE_PHONE_COUNTRY_CODE) {
                
                if (textField.text.length >= K_COUNTRY_CODE_CHARCTER_LIMIT){
                    if (![string isEqualToString:@""])
                        return NO;
                }
            }else if (textField.tag == K_RESIDENCE_PHONE_AREA_CODE ) {
                
                if (textField.text.length >= K_AREA_CODE_CHARCTER_LIMIT){
                    if (![string isEqualToString:@""])
                        return NO;
                }
            }else if (textField.tag == K_RESIDENCE_PHONE_NUMBER) {
                
                if (textField.text.length >= K_NUMBER_CHARCTER_LIMIT){
                    if (![string isEqualToString:@""])
                        return NO;
                }
            }
            return YES;
            break;
        }
            
        default:
            break;
    }
    

    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegate: havingIndex:)])
        [self.delegate textFieldDelegate:textField havingIndex:_index];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self customTextFieldDidBeginEditing:textField];

    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegateDidStartEditing: havingIndex:)])
        [self.delegate textFieldDelegateDidStartEditing:textField havingIndex:_index];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegate: havingIndex:)])
        [self.delegate textFieldDelegate:textField havingIndex:_index];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegateDidEndEditing: havingIndex:)])
        [_delegate textFieldDelegateDidEndEditing:textField havingIndex:_index];
}
-(void)customTextFieldDidBeginEditing:(UITextField*)textField
{
    [textField setInputAccessoryView:[self customToolBarForKeyBoard:textField]];
}

-(UIToolbar*)customToolBarForKeyBoard:(UITextField*)textField
{
    selectedTF =textField;
    
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
    [selectedTF resignFirstResponder];
}

@end
