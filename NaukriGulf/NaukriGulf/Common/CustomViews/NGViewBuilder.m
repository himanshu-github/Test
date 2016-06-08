//
//  NGViewBuilder.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGViewBuilder.h"



@implementation NGViewBuilder

+(UIView*)createView:(NSMutableDictionary*)params
{
    UIView* view=nil;
    
    if ([[params valueForKey:KEY_VIEW_TYPE] isEqualToString:VIEW_TYPE_BUTTON])
    {
        view = (NGButton*)[NGButton buttonWithType:UIButtonTypeCustom];
        [(NGButton*)view initWithButtonParameters:params];
    }
    else if ([[params valueForKey:KEY_VIEW_TYPE] isEqualToString:VIEW_TYPE_TEXTFIELD])
    {
        view= [[NGTextField alloc] initWithBasicParameters:params];
    }
    else if ([[params valueForKey:KEY_VIEW_TYPE] isEqualToString:VIEW_TYPE_VIEW])
    {
        view= [[NGView alloc] initWithBasicParameters:params];
    }
    else if ([[params valueForKey:KEY_VIEW_TYPE] isEqualToString:VIEW_TYPE_LABEL])
    {
        view= [[NGLabel alloc] initWithBasicParameters:params];
    }else if ([[params valueForKey:KEY_VIEW_TYPE] isEqualToString:VIEW_TYPE_TEXTVIEW])
    {
        view= [[NGTextView alloc] initWithBasicParameters:params];
    }else if ([[params valueForKey:KEY_VIEW_TYPE] isEqualToString:VIEW_TYPE_IMAGEVIEW])
    {
        view= [[NGImageView alloc] initWithBasicParameters:params];
    }else if ([[params valueForKey:KEY_VIEW_TYPE] isEqualToString:VIEW_TYPE_SEGMENTEDCONTROL])
    {
        view= [[NGSegmentedControl alloc] initWithBasicParameters:params];
    }

    return view;
}

@end
