//
//  NGDropDownModel.h
//  NaukriGulf
//
//  Created by Himanshu on 8/31/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NGDropDownModel : NSObject
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(void)saveDataContext;
+ (NGDropDownModel *)sharedInstance;

@end
