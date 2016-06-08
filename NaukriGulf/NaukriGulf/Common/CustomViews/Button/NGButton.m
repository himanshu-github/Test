//
//  NGButton.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGButton.h"


@implementation NGButton

//static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";


- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super initWithBasicParameters:params];
    if (self)
    {
        [self setButtonStyle:params];
        
    }
    
    return self;
}

-(void)initWithButtonParameters:(NSMutableDictionary*)params
{
    [super initWithButtonParameters:params];
    [self setButtonStyle:params];

}

 
-(void)setButtonStyle:(NSMutableDictionary*)params
{
    
    self.backgroundColor= [UIColor colorWithRed:12.0/255.0f green:78.0/255.0f blue:144.0/255.0f alpha:1.0f];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.layer.cornerRadius=CORNER_RADIUS_BUTTON;
    self.layer.masksToBounds=YES;
    
    [self.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:BUTTON_TITLE_FONTSIZE]];
    [self setTitle:[params valueForKey:@"ButtonTitle"] forState:UIControlStateNormal];
}

-(void)setImageStyleForButton:(UIImage *)image
{
  
    [self setImage:image forState:UIControlStateNormal];
   
    self.backgroundColor=[UIColor clearColor];
    self.layer.cornerRadius=0.0;
    self.titleLabel.text=@"";
}

-(void)addBorder{
    [super addBorderColored:[UIColor blackColor] Width:0.3f];
}

@end
