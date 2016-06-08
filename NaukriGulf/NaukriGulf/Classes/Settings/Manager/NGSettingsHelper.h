//
//  NGSettingsHelper.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 10/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGSettingsHelper : NSObject

/**
 * Returns the singleton instance.
 *
 *  @return Singleton Instance
 */
+(NGSettingsHelper *)sharedInstance;
-(void)fetchSettingsFromServer;

@end
