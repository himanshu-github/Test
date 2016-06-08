//
//  NGTextView.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGTextView.h"

@implementation NGTextView

- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super initWithBasicParameters:params];
    if (self)
    {
        
    }
    return self;
}

-(NSString *)getFilteredText{
    NSString *txt = self.text;
    
    if (txt) {
        txt = [NSString stripTags:txt];
        txt = [NSString formatSpecialCharacters:txt];
    }else{
        txt = @"";
    }
    
    return txt;
}

@end
