//
//  NGStaticDDCoreDataLayer.h
//  NaukriGulf
//
//  Created by Himanshu on 9/14/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NGStaticDDCoreDataLayer : NSObject
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(void)saveDataContext;
+ (NGStaticDDCoreDataLayer *)sharedInstance;


@property (nonatomic, strong, readonly) NSManagedObjectContext *writerMOC;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainMOC;


@end
