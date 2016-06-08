//
//  NGView.m
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGView.h"

@implementation NGView

- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super initWithBasicParameters:params];
    if (self)
    {
        
    }
    
    return self;
}


-(void)setSeparatorStyle
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
}



-(void)setViewStyle:(NSMutableDictionary*)params

{
    [self setClipsToBounds:NO];
     self.backgroundColor=[params valueForKey:KEY_BACKGROUND_COLOR];
    [self.layer setShadowColor:[[params valueForKey:KEY_SHADOW_COLOR] CGColor]];
    [self.layer setShadowOpacity:[[params valueForKey:KEY_OPACITY] floatValue]];
    [self.layer setShadowOffset:[[params valueForKey:kEY_SHADOW_OFFSET] CGSizeValue]];
}

-(void)setShadowView

{
    self.backgroundColor = [UIColor whiteColor];
    [self setClipsToBounds:NO];
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOpacity:0.2];
    [self.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    
}

-(void)setShadowAcrossBorder{
    self.backgroundColor = [UIColor whiteColor];
    [self setClipsToBounds:NO];
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOpacity:0.3];
    [self.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
}

@end
