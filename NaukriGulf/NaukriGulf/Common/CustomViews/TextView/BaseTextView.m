//
//  BaseTextView.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseTextView.h"


@implementation BaseTextView

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

-(void)setTextViewStyle{    
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColorFromRGB(0xaaaaaa)CGColor];
    self.backgroundColor = [UIColor whiteColor];
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
        self.text=@"";
    }
    
    switch(self.validationType)
    {
        case VALIDATION_TYPE_EMPTY:
            if ([NGDecisionUtility isTextViewNotEmpty:self.text])
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
        
            
            break;
            
            
    }
    
    return isValidated;
    
}


-(void)addErrorLabel:(NSString*)message forview:(UIView*)view withFrame:(CGRect)frame

{
    view.layer.borderColor=[[UIColor colorWithRed:200.0/255.0f green:129.0/255.0f blue:132.0/255.0f alpha:1.0f]CGColor];
    
    NGLabel* labelError=(NGLabel*)[view.superview viewWithTag:view.tag+50];
    
    
    
    if (labelError==nil)
    {
        
        CGRect rectLabel=CGRectMake(frame.origin.x, frame.origin.y+frame.size.height-5, 290, 30);        
        
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

@end
