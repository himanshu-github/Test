//
//  DataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseLocalDataFetcher.h"


@implementation BaseLocalDataFetcher
@synthesize context = _context;

-(NSManagedObjectContext*)context{
    if(!_context)
        _context = [[NGCoreDataHelper sharedInstance] managedObjectContext];
    return _context;
}

-(NSManagedObjectContext*)privateMoc{
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.context;
    return temporaryContext;
    
}

- (NSEntityDescription *) initialiseCoreDataOperation : (NSString *) entityName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    
    return entity;
}

-(void)saveMainContext
{
    [self.context performBlockAndWait:^{
        [self.context save:nil];
    }];
    [self.context.parentContext performBlock:^{
        [self.context.parentContext save:nil];
    }];
}


@end
