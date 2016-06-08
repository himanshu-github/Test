//
//  UINavigationItem+Custome.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 05/05/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "UINavigationItem+Custome.h"
#import <QuickLook/QuickLook.h>
#import <objc/runtime.h>
#import "NGQLDocumentPreviewViewController.h"

@implementation UINavigationItem (Custome)

void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL);

- (void) override_setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{
    if (item && [item.target isKindOfClass:[QLPreviewController class]] && item.action == @selector(actionButtonTapped:)){
        NGQLDocumentPreviewViewController* qlpc = (NGQLDocumentPreviewViewController*)item.target;
        [self override_setRightBarButtonItem:qlpc.btnRight animated: animated];
    }else{
        [self override_setRightBarButtonItem:item animated: animated];
    }
}

+ (void)load {
    MethodSwizzle(self, @selector(setRightBarButtonItem:animated:), @selector(override_setRightBarButtonItem:animated:));
}

void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL) {
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
    
    if (class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

@end