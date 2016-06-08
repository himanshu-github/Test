//
//  BaseTextField.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseTextField.h"



@interface BaseTextField ()

@end

@implementation BaseTextField

- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super init];
    if (self)
    {
        self.tag=[[params valueForKey:KEY_TAG] intValue];
        self.frame=[[params valueForKey:KEY_FRAME] CGRectValue];
    }
    return self;
}

-(void)setTextFieldStyle
{
   
    self.backgroundColor=[UIColor whiteColor];
    self.layer.borderColor=[UIColorFromRGB(0xaaaaaa)CGColor];
    self.layer.cornerRadius=CORNER_RADIUS_TEXTFIELD;
    self.layer.borderWidth=BORDE_WIDTH_TEXTFIELD;
    
    [self setLeftPaddingForTextField];
}


-(void)setLeftPaddingForTextField
{
    UIView* paddingViewLocation=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.leftView=paddingViewLocation;
    self.leftViewMode=UITextFieldViewModeAlways;
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setLeftPaddingAsText:(NSString *)text
{
    NSMutableDictionary* dictionaryForTitleLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                [NSNumber numberWithInt:0],KEY_TAG,
                                                [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 44)],KEY_FRAME,
                                                nil];
    
    NGLabel* titleLbl=(NGLabel*)   [NGViewBuilder createView:dictionaryForTitleLbl];
    
    NSMutableDictionary* dictionaryForTitleStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor clearColor],KEY_BACKGROUND_COLOR,
                                                  text,KEY_LABEL_TEXT,
                                                  [NSNumber numberWithInteger:NSTextAlignmentCenter],kEY_LABEL_ALIGNMNET,
                                                  [UIColor grayColor],KEY_TEXT_COLOR,
                                                  FONT_STYLE_HELVITCA_LIGHT,KEY_FONT_FAMILY,FONT_SIZE_13,KEY_FONT_SIZE,nil];
    
    [titleLbl setLabelStyle:dictionaryForTitleStyle];
    
    self.leftView=titleLbl;
    self.leftViewMode=UITextFieldViewModeAlways;
    self.backgroundColor = [UIColor whiteColor];
    
}

-(void)setRightViewAsDropDownForTextField
{
    UIImageView * rightView = [[ UIImageView  alloc ]  initWithImage :[UIImage  imageNamed : @"marker-light" ]];
    [self    setRightView:rightView];
    [ self   setRightViewMode: UITextFieldViewModeAlways];
}

-(void)setValidation:(NSMutableDictionary*)params
{
    self.validationType=[[params valueForKey:VALIDATION_TYPE] intValue];
    self.errorMessage=[params valueForKey:ERROR_MESSAGE];
    self.viewFrame=[[params valueForKey:KEY_FRAME] CGRectValue];
    
}

-(BOOL)checkValidation
{
    BOOL isValidated=TRUE;
    
    //In case of null (on UnReg ViewWillAppear)
    
    if (self.text.length==0)
    {
        self.text= @"";
    }
    
    switch(self.validationType)
    {
        case VALIDATION_TYPE_EMPTY:
            if ([NGDecisionUtility isTextFieldNotEmpty:self.text])
            {
                isValidated=TRUE;
            }
            else
            {
                 isValidated=FALSE;
            }
            
            break;
        case VALIDATION_TYPE_VALIDEMAIL:
            if ([NGDecisionUtility isValidEmail:self.text])
            {
                [self removeErrorLabelforView:self];
                isValidated=TRUE;
            }
            else
            {
                [self addErrorLabel:self.errorMessage forview:self withFrame:self.viewFrame];
                
                isValidated=FALSE;
            }
            break;
        case VALIDATION_TYPE_NUMERIC:
            if ([NGDecisionUtility isValidNumber:self.text])
            {
                [self removeErrorLabelforView:self];
                isValidated=TRUE;
            }
            else
            {
                [self addErrorLabel:self.errorMessage forview:self withFrame:self.viewFrame];
                
                isValidated=FALSE;
            }
             break;
        case VALIDATION_TYPE_SPECIALCHAR_OR_NUMERIC:
            if (![NGDecisionUtility doesStringContainSpecialCharOrNumeric:self.text])
            {
                [self removeErrorLabelforView:self];
                isValidated=TRUE;
            }
            else
            {
                [self addErrorLabel:self.errorMessage forview:self withFrame:self.viewFrame];
                
                isValidated=FALSE;
            }

            break;
            
            
    }
    
    return isValidated;
    
}

-(BOOL)checkValidEmail:(NSMutableDictionary*)params
{
     [self setValidation:params];
    return [self checkValidation];
    
}

-(void)stripWhiteSpace{
    self.text = [self.text trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(void)addErrorLabel:(NSString*)message forview:(UIView*)view withFrame:(CGRect)frame

{
    view.layer.borderColor=[[UIColor colorWithRed:200.0/255.0f green:129.0/255.0f blue:132.0/255.0f alpha:1.0f]CGColor];
    
    NGLabel* labelError=(NGLabel*)[view.superview viewWithTag:view.tag+50];
    
    
        
    if (labelError==nil)
    {
        
        CGRect rectLabel=CGRectMake(frame.origin.x, frame.origin.y+frame.size.height-2, 290, 30);
        
        
        
        //TextView (Feedback Form)
        if ([view class]== [UITextView class])
            rectLabel=CGRectMake(frame.origin.x, frame.origin.y+frame.size.height-5, 290, 30);
        
        NSInteger tagValue=view.tag+50;
        
        NSMutableDictionary* dictionaryForErrorLabel=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                     [NSString stringWithFormat:@"%ld",(long)tagValue],KEY_TAG,
                                                      [NSValue valueWithCGRect:rectLabel],KEY_FRAME,
                                                     nil];
        
        labelError=(NGLabel*)   [NGViewBuilder createView:dictionaryForErrorLabel];
             
        NSMutableDictionary* dictionaryForTextLablStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor clearColor],KEY_BACKGROUND_COLOR,
                                                         [NSString stringWithFormat:@"%@",message],KEY_LABEL_TEXT,
                                                         [UIColor colorWithRed:170.0/255.0f green:97.0/255.0f blue:97.0/255.0f alpha:1.0f],KEY_TEXT_COLOR,
                                                         [NSNumber numberWithInteger:NSTextAlignmentLeft],kEY_LABEL_ALIGNMNET,
                                                          @"Helvetica",KEY_FONT_FAMILY,@"10.0",KEY_FONT_SIZE,
                                                         nil];
        
        [labelError setLabelStyle:dictionaryForTextLablStyle];
        [view.superview addSubview:labelError];
        
    }
}

-(void)removeErrorLabelforView:(UIView*)view
{
    view.layer.borderColor=[UIColorFromRGB(0xaaaaaa)CGColor];
    UILabel* labelError=(UILabel*)[view.superview viewWithTag:view.tag+50];
    [labelError removeFromSuperview];
}
-(void)setLeftViewWithImage:(NSString*)imageName
{
    UIView *leftViewWithPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    
    UIImageView *paddingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    paddingView.contentMode = UIViewContentModeLeft;
    paddingView.backgroundColor = [UIColor clearColor];
    paddingView.image = [UIImage imageNamed:imageName];
    [leftViewWithPadding addSubview:paddingView];
    
    self.leftView = leftViewWithPadding;
    self.leftViewMode = UITextFieldViewModeAlways;
}
-(void)displayHideBtn:(BOOL)secureTextEntry
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 16);
    button.selected = secureTextEntry;
    self.secureTextEntry = secureTextEntry;
    button.showsTouchWhenHighlighted = NO;
    button.titleLabel.font =[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:14.0f];
    [button setTitleColor:Clr_DarkBlue forState:UIControlStateSelected];
    [button setTitleColor:Clr_DarkBlue forState:UIControlStateNormal];
    [button setTitle:@"Show" forState:UIControlStateSelected];
    [button setTitle:@"Hide" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showHideText:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = button;
    self.rightViewMode = UITextFieldViewModeAlways;
}

-(void)showHideText:(UIButton*)sender
{
    
    
    [self resignFirstResponder];
    sender.selected = !sender.isSelected;
    self.secureTextEntry = sender.isSelected;
    self.text = self.text;
    [self becomeFirstResponder];
}
@end
