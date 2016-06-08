//
//  UIAutomationHelper.m
//  Naukri
//
//  Created by Arun Kumar on 3/14/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "UIAutomationHelper.h"

@implementation UIAutomationHelper

+(void)setAccessibiltyLabel:(NSString *)label value:(NSString *)value forUIElement:(id)element{
    
    [element setIsAccessibilityElement:YES];
    [element setAccessibilityLabel:label];
    [element setAccessibilityValue:value];
}

+(void)setAccessibiltyLabel:(NSString *)label forUIElement:(id)element{
    [element setIsAccessibilityElement:YES];
    [element setAccessibilityLabel:label];
}


+(void)setAccessibiltyLabel:(NSString *)label forUIElement:(id)element withAccessibilityEnabled:(BOOL)isAccessibilityEnabled{
    
    [element setIsAccessibilityElement:isAccessibilityEnabled];
    [element setAccessibilityLabel:label];
}
@end
