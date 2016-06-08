//
//  NGOpenWithResumeHandler.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 29/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGOpenWithResumeHandler : NSObject

@property (nonatomic,readwrite) BOOL isRegisteredByLocalObserver;

/**
 *  Singleton Instance handle
 *
 *  @return sharedInstance
 */
+(instancetype)sharedInstance;

@end
