//
//  WatchAndiOSCommunicationLayer.h
//  NaukriGulf
//
//  Created by Arun on 10/11/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchOSAndiOSCommunicationLayer: NSObject


-(void)activateSession;
+(WatchOSAndiOSCommunicationLayer *)sharedInstance;
-(void)sendLoginStatusToWatch:(BOOL)userLoggedIn;

@end
