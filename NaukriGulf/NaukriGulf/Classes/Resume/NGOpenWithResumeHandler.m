//
//  NGOpenWithResumeHandler.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 29/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGOpenWithResumeHandler.h"

@implementation NGOpenWithResumeHandler

static NGOpenWithResumeHandler *singleton;
/**
 *  A Shared Instance Singleton class of NGLocalNotificationAppHandler
 *
 *  @return sharedInstance created once only
 */

+(instancetype)sharedInstance{
    static dispatch_once_t onceTokenOWRH;
    dispatch_once(&onceTokenOWRH, ^{
        singleton = [[NGOpenWithResumeHandler alloc]init];
    });
    
    return singleton;
}


#pragma mark - Public Method
/**
 *  @name Public Method
 */
-(void)performOpenWithTypeDocumentNotificationAction{
    [NGUIUtility loadOpenWithTypeDocument];
}
-(void)receivedOpenWithTypeDocumentNotification:(NSNotification*)paramNotification{
    
    if ([OPEN_WITH_DOCUMENT_TYPE_HANDLER isEqualToString:[paramNotification name]]) {
        [self performSelector:@selector(performOpenWithTypeDocumentNotificationAction) withObject:nil afterDelay:2.0];
        
        [self setIsRegisteredByLocalObserver:NO];
    }
}
-(void)setIsRegisteredByLocalObserver:(BOOL)isRegisteredByObserver{
    _isRegisteredByLocalObserver = isRegisteredByObserver;
    if (_isRegisteredByLocalObserver) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedOpenWithTypeDocumentNotification:) name:OPEN_WITH_DOCUMENT_TYPE_HANDLER object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:OPEN_WITH_DOCUMENT_TYPE_HANDLER object:nil];
    }
}
-(void)dealloc{
}
@end
