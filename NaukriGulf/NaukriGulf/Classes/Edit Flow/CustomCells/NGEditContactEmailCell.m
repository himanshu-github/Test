//
//  NIEditContactEmailCell.m
//  Naukri
//
//  Created by Arun Kumar on 3/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditContactEmailCell.h"


@interface NGEditContactEmailCell(){
    
}

@property (nonatomic, weak) IBOutlet NGLabel* lblPlaceholder1;
@property (nonatomic, weak) IBOutlet NGLabel* lblPlaceholder2;

@end


@implementation NGEditContactEmailCell

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

- (void)configureEditContactEmailCell:(NSMutableDictionary*)dict{
    
    NSString* placeholder1 = [dict objectForKey:K_KEY_EDIT_PLACEHOLDER];
    NSString* placeholder2 = [NSString stringWithFormat:@"(%@)", [dict objectForKey:K_KEY_EDIT_PLACEHOLDER2]];
    NSString* title = [dict objectForKey:K_KEY_EDIT_TITLE];
    
    _lblPlaceholder1.text = placeholder1;
    _lblPlaceholder2.text = placeholder2;
    _txtTitle.text = title;

 
   }

#pragma mark -
#pragma mark UITextfield Delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    BOOL bToReturn = NO;
    
    switch (_editModuleNumber) {
            
        case K_EDIT_CONTACT_DETAIL_PAGE:{
            return YES;
            break;
        }
            
        default:
            break;
    }
    
    
    return bToReturn;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegateShouldReturn:)]){
        [_delegate textFieldDelegateShouldReturn:textField];
    }
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegate: havingIndex:)])
        [self.delegate textFieldDelegate:textField havingIndex:_index];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegateDidStartEditing: havingIndex:)])
        [self.delegate textFieldDelegateDidStartEditing:textField havingIndex:_index];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegate: havingIndex:)])
        [self.delegate textFieldDelegate:textField havingIndex:_index];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDelegateDidEndEditing: havingIndex:)])
        [_delegate textFieldDelegateDidEndEditing:textField havingIndex:_index];
}


@end
