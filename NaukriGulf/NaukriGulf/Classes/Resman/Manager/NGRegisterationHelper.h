//
//  NGRegisterationHelper.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/27/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGRegisterationHelper : NSObject
-(void) registerUserWithCompletionHandler:(void(^)(NGAPIResponseModal* responseInfo))completionHandler;

@end
