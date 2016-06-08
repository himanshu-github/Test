//
//  UILabel+DefaultValue.m
//  NaukriGulf
//
//  Created by Ajeesh T S on 04/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "UILabel+DefaultValue.h"

@implementation UILabel (DefaultValue)

-(void)setDefaultValue{

    if([self.text isKindOfClass:[NSNull class]] || !self.text || ([self.text length]==0)){
    
        self.text = @"Not Mentioned";
    }
}

@end
