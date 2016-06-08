//
//  NGLabel.m
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLabel.h"

@implementation NGLabel

- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super initWithBasicParameters:params];
    if (self)
    {
        
    }
    
    return self;
}

-(void)setLabelStyle:(NSMutableDictionary*)params
{
    
    self.backgroundColor = [params valueForKey:KEY_BACKGROUND_COLOR];
    self.textColor = [params valueForKey:KEY_TEXT_COLOR];
    self.shadowColor=[params valueForKey:KEY_SHADOW_COLOR];
    self.shadowOffset=[[params valueForKey:kEY_SHADOW_OFFSET] CGSizeValue];
    self.numberOfLines = [[params valueForKey:KEY_LABEL_NO_OF_LINES] intValue];
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.textAlignment = [[params valueForKey:kEY_LABEL_ALIGNMNET] integerValue];
    self.text = [params valueForKey:KEY_LABEL_TEXT];
    self.font = [UIFont fontWithName:[params valueForKey:KEY_FONT_FAMILY] size:[[params valueForKey:KEY_FONT_SIZE] floatValue]];
}

-(void)makeItCompulsoryFieldForCQ:(CGFloat)left{
 
     
    NSMutableDictionary* dictionaryForTitleLbl=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_LABEL],KEY_VIEW_TYPE,
                                                [NSNumber numberWithInt:0],KEY_TAG,
                                                [NSValue valueWithCGRect:CGRectMake(self.frame.origin.x-16, self.frame.origin.y+5, 15, 15)],KEY_FRAME,
                                                nil];
    
    NGLabel* titleLbl=(NGLabel*)   [NGViewBuilder createView:dictionaryForTitleLbl];
    
    NSMutableDictionary* dictionaryForTitleStyle=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor clearColor],KEY_BACKGROUND_COLOR,
                                                  @"*",KEY_LABEL_TEXT,
                                                  [NSNumber numberWithInteger:NSTextAlignmentRight],kEY_LABEL_ALIGNMNET,
                                                  [UIColor redColor],KEY_TEXT_COLOR,
                                                  FONT_STYLE_HELVITCA_LIGHT,KEY_FONT_FAMILY,FONT_SIZE_13,KEY_FONT_SIZE,nil];
    
    [titleLbl setLabelStyle:dictionaryForTitleStyle];
}

-(void)makeItHighlightedField{
    
    NSMutableDictionary* dictDotImg=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",VIEW_TYPE_IMAGEVIEW],KEY_VIEW_TYPE,
                                         [NSValue valueWithCGRect:CGRectMake(15,15,14,14) ],KEY_FRAME,
                                         [NSNumber numberWithInt:0],KEY_TAG,
                                         nil];
    
    NGImageView *dotImg=  (NGImageView*)[NGViewBuilder createView:dictDotImg];
    dotImg.image = [UIImage imageNamed:@"orangeDot"];
    dotImg.center = CGPointMake(self.frame.size.width + 10, self.frame.size.height/2);
    
    self.clipsToBounds = NO;
}

@end
