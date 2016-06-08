//
//  NGApplyServiceHandler.h
//  NaukriGulf
//
//  Created by Rahul on 20/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGApplyServiceHandler : NSObject

+(NGApplyServiceHandler *)sharedManager;

- (void) setupServiceForAppliedJobs:(NGJobsHandlerObject *)jobsObj;
-(void)applyJobHavingParam:(NSMutableDictionary*)params  serviceType:(NSInteger)serviceType
              withCallback:(void (^)(NGAPIResponseModal* modal))callback;
@property(nonatomic)JD_OPEN_PAGES jdOpenPage;

@end
