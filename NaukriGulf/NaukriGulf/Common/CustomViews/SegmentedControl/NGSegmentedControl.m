//
//  NGSegmentedControl.m
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGSegmentedControl.h"

@implementation NGSegmentedControl


- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super initWithBasicParameters:params];
    if (self)
    {
        
    }
    return self;
}

-(void)setStyle{
    self.layer.cornerRadius = 14;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithRed:162/255.0f green:162/255.0f blue:162/255.0f alpha:1.0f]CGColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Helvetica" size:13], NSFontAttributeName,
                                [UIColor grayColor], NSForegroundColorAttributeName, nil];
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                  [UIFont fontWithName:@"Helvetica" size:13], NSFontAttributeName,
                  [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
}

@end
