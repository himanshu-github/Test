//
//  NGEditProfileTextviewCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 9/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditProfileTextviewCell.h"

@interface NGEditProfileTextviewCell(){
    
    NSInteger iLimit;
    NSInteger charCountLeft;
}

@property(nonatomic, assign) IBOutlet NGLabel* lblPlaceholder1;

@end


@implementation NGEditProfileTextviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect frame = _lblPlaceholder1.frame;
        frame.origin.x = frame.origin.x+3;
        [_lblPlaceholder1 setFrame:frame];
        
        [_lblPlaceholder1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
        
        frame = _txtview.frame;
        frame.origin.x = frame.origin.x+3;
        frame.origin.y= frame.origin.y - 5;
        [_txtview setFrame:frame];
        _txtview.returnKeyType = UIReturnKeyDone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)awakeFromNib{
    [self.txtview setTextColor:[UIColor blackColor]];
}
- (void)configureEditProfileTextviewCell:(NSMutableDictionary*)dict{
    
    iLimit =  [[dict objectForKey:K_KEY_TEXT_CHARACTER_LIMIT] integerValue];
    _lblPlaceholder1.text = [dict objectForKey:K_KEY_EDIT_PLACEHOLDER];
    _lblPlaceholder2.text = [dict objectForKey:K_KEY_EDIT_PLACEHOLDER2];
    _txtview.text = [dict objectForKey:K_KEY_EDIT_TITLE];
    _txtview.returnKeyType = UIReturnKeyDone;
    
    switch (self.editModuleNumber) {
            
        case PERSONAL_DETAILS:{
            
            if([[dict objectForKey:K_KEY_HIDDEN_PLACEHOLDER] isEqualToString:@"TRUE"])
                [_lblPlaceholder2 setHidden:TRUE];
            break;
        }
        case WORK_EXPERIENCE:
            [self showPlaceHolderForTextView];
            break;
            
        
        case  CV_HEADLINE:
        {
            CGRect tempRect  = self.txtview.frame;
            tempRect.size.height = [[dict objectForKey:K_KEY_TEXTVIEW_HEIGHT] intValue];
            self.txtview.frame = tempRect;
        }
            break;
            
        
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITEXTVIEW Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   
    switch (self.editModuleNumber) {
        case WORK_EXPERIENCE: {
            if ([textView.text isEqualToString:K_EMPLOYMENT_DESC_MESSAGE]) {
               
                textView.text = @"";
                textView.textColor = [UIColor blackColor];
            }
        }
            break;
            
        default:
            break;
    }
       return YES;
    
}

-(void) textViewDidChange:(UITextView *)textView
{
    NSInteger charactersLeft = iLimit - textView.text.length;
    if (charactersLeft <0)
        charactersLeft = 0;
    _lblPlaceholder2.text = [NSString stringWithFormat:@"%ld Characters Left", (long)charactersLeft];
    
    charCountLeft= charactersLeft;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    BOOL bToReturn = YES;
    
    if ( [text isEqualToString: @"\n" ] ) {
		[textView resignFirstResponder ];
    }
    
   
    
    if ((textView.text.length+text.length) > iLimit){
        if (![text isEqualToString:@""]){
            bToReturn = NO;
        }
    }
    
    else{
        
        NSInteger charactersLeft = iLimit - textView.text.length;
        if (charactersLeft <0)
            charactersLeft = 0;
        _lblPlaceholder2.text = [NSString stringWithFormat:@"%ld Characters Left", (long)charactersLeft];
    }
    
    return bToReturn;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
     _lblPlaceholder2.hidden = FALSE;
    if (_delegate && [_delegate respondsToSelector:@selector(textViewDidStartEditing:)])
        [_delegate textViewDidStartEditing:_index];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [self showPlaceHolderForTextView];
    
    textView.text = [NSString stripWhiteSpaceFromBeginning:textView.text];
    
    if(_delegate && [_delegate respondsToSelector:@selector(setCharCount:)]){
        
        [_delegate setCharCount:charCountLeft];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(textViewDidEndEditing: havingIndex:)]){
        
        [_delegate textViewDidEndEditing:textView.text havingIndex:_index];
    }
    
}

-(void) showPlaceHolderForTextView {
    
    switch (self.editModuleNumber) {
       
        case WORK_EXPERIENCE:{
            
            _lblPlaceholder2.hidden = TRUE;
            
            if (!_txtview.text || _txtview.text.length == 0) {
                
                _txtview.text = K_EMPLOYMENT_DESC_MESSAGE;
                [_txtview setTextColor:[UIColor lightGrayColor]];
            }else{
                [_txtview setTextColor:[UIColor blackColor]];
            }

        }
                  break;
            
        default:
            break;
    }
    
}
@end

