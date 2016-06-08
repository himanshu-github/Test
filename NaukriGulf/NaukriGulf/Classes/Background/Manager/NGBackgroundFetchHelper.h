//
//  NGBackgroundFetchHelper.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGBackgroundFetchHelper : NSObject
/**
 * Returns the singleton instance.
 *
 *  @return Singleton Instance
 */
+(NGBackgroundFetchHelper *)sharedInstance;
-(void) checkForNewRecommendedJobs:(void (^)(UIBackgroundFetchResult))completionHandler;
-(BOOL) shouldPerformBgFetchForRecommendedJobs;
@end
