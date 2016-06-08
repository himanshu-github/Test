//
//  NGOperationQueueManager.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 17/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGOperationQueueManager : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;


+(NGOperationQueueManager *)sharedManager;

- (void)addOperationToQueue:(NSOperation *)oper;
- (void)cancelAllOperationInQueue;
- (void)fetchCurrentCount;
- (void)cancelOperation:(NSArray*)serviceArr;


@end
