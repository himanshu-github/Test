//
//  UIAutomationHelper.h
//  Naukri
//
//  Created by Arun Kumar on 3/14/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAutomationHelper : NSObject

+(void)setAccessibiltyLabel:(NSString *)label value:(NSString *)value forUIElement:(id)element;
+(void)setAccessibiltyLabel:(NSString *)label forUIElement:(id)element;
+(void)setAccessibiltyLabel:(NSString *)label forUIElement:(id)element withAccessibilityEnabled:(BOOL)isAccessibilityEnabled;
@end
