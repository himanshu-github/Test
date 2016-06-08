//
//  NGCQHandler.h
//  NaukriGulf
//
//  Created by Rahul on 19/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGCQHandler : NSObject

+ (NGCQHandler *)sharedManager;

- (void)fetchCustomQuestions:(NGJobsHandlerObject *)cqObj;
- (void) cqHandlerCallUpdateAppliedService:(NGJobsHandlerObject *)obj;
-(void)fetchCQFor:(NSMutableDictionary*)dict withCallBack:(void (^)(NGAPIResponseModal* modal))callback;
@end
