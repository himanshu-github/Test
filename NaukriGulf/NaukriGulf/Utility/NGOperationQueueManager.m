//
//  NGOperationQueueManager.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 17/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGOperationQueueManager.h"

@interface NGOperationQueueManager ()

@property (nonatomic, strong) NSMutableDictionary *operationDict;

@end

@implementation NGOperationQueueManager

static NGOperationQueueManager *sharedManager = nil;



+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NGOperationQueueManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
    
        _operationQueue = [[NSOperationQueue alloc]init];
        _operationQueue.name = @"com.naukriGulf.OperationQueue";
        _operationQueue.maxConcurrentOperationCount =  2;
        
        
        _operationDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)addOperationToQueue:(NSOperation *)oper {
    [self.operationQueue addOperation:oper];
}

- (void)cancelAllOperationInQueue {
    
    [self.operationQueue cancelAllOperations];
}

-(void)fetchCurrentCount{
}

- (void)cancelOperation:(NSArray*)serviceArr{
    
    for (NSNumber* apiID in serviceArr){
        for (BaseAPICaller* caller in _operationQueue.operations) {
            if (caller.apiRequestObj.apiId == [apiID integerValue]){
                [caller cancel];
                
            }
        }
    }
}

@end
