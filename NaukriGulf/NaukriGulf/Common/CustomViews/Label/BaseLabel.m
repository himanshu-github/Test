//
//  BaseLabel.m
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel

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

-(void)makeItCompulsoryField{
    [self sizeToFit];
    
    NSMutableDictionary* dictionaryForTitleLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                [NSNumber numberWithInt:0],KEY_TAG,
                                                [NSValue valueWithCGRect:CGRectMake(self.frame.size.width, 0, 15, 15)],KEY_FRAME,
                                                nil];
    
    NGLabel* titleLbl=(NGLabel*)   [NGViewBuilder createView:dictionaryForTitleLbl];
    
    NSMutableDictionary* dictionaryForTitleStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor clearColor],KEY_BACKGROUND_COLOR,
                                                  @"*",KEY_LABEL_TEXT,
                                                  [NSNumber numberWithInteger:NSTextAlignmentLeft],kEY_LABEL_ALIGNMNET,
                                                  [UIColor redColor],KEY_TEXT_COLOR,
                                                  FONT_STYLE_HELVITCA_LIGHT,KEY_FONT_FAMILY,FONT_SIZE_13,KEY_FONT_SIZE,nil];
    
    [titleLbl setLabelStyle:dictionaryForTitleStyle];
    [self addSubview:titleLbl];
    
    self.clipsToBounds = NO;
}

-(void)setBorderColor:(UIColor*)color withCornerRadius:(float)radius{
    self.layer.borderColor = [color CGColor];
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = 0.1f;
}

@end
