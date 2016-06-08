//
//  NGAppBlockHandler.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGAppBlockHandler : NSObject

+(NGAppBlockHandler *)sharedInstance;
-(void)fetchAppBlockerSettings;
-(void)performActionOverStoredAppBlockerResponse;

@end
