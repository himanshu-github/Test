//
//  BaseButton.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseButton.h"
#import <objc/runtime.h>

@implementation BaseButton

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";


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

-(void)initWithButtonParameters:(NSMutableDictionary*)params
{
    self.tag=[[params valueForKey:KEY_TAG] intValue];
    self.frame=[[params valueForKey:KEY_FRAME] CGRectValue];
}



-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)addGradient{
    
    // Add Border
    CALayer *layer = self.layer;
    layer.cornerRadius = self.layer.cornerRadius;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)UIColorFromRGB(0x0a5a92).CGColor,
                         (id)UIColorFromRGB(0x016db5).CGColor,                         
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer insertSublayer:shineLayer atIndex:0];
    
}

-(void)addBorderColored:(UIColor *)borderColor Width:(float)borderWidth{
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
}
 
@end
