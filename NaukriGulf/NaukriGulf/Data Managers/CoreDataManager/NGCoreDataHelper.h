//
//  NGCoreDataHelper.h
//  NaukriGulf
//
//  Created by Arun Kumar on 23/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGCoreDataHelper : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, strong, readonly) NSManagedObjectContext *writerMOC;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainMOC;

/**
 *  Get Singleton Object of NGCoreDataHelper.
 *
 *  @return Return Singleton Object.
 */
+(NGCoreDataHelper *)sharedInstance;

+(void)saveDataContext;

@end
