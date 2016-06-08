//
//  NGStaticDDCoreDataLayer.m
//  NaukriGulf
//
//  Created by Himanshu on 9/14/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGStaticDDCoreDataLayer.h"

@implementation NGStaticDDCoreDataLayer
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize mainMOC = _mainMOC;
@synthesize writerMOC = _writerMOC;



- (id)init {
    
    self = [super init];
    if (self) {
    }
    return self;
}

+(NGStaticDDCoreDataLayer*) sharedInstance
{
    static NGStaticDDCoreDataLayer *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGStaticDDCoreDataLayer alloc]init];
    });
    return sharedInstance;
    
}

#pragma mark - Core Data stack


- (NSManagedObjectContext *)managedObjectContext
{
    return [self mainMOC];
    
}

-(NSManagedObjectContext*)mainMOC{
    if (_mainMOC)
        return _mainMOC;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainMOC.parentContext = [self writerMOC];
    }
    return _mainMOC;
}


-(NSManagedObjectContext*)writerMOC{
    if (_writerMOC)
        return _writerMOC;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _writerMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_writerMOC setPersistentStoreCoordinator:coordinator];
    }
    return _writerMOC;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NaukriGulf_Static" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    NSLog(@"ddd>>>%@",[self documentDD]);
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NaukriGulf_Static.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* foofile = [documentsPath stringByAppendingPathComponent:@"NaukriGulf_Static.sqlite"];
        if([[NSFileManager defaultManager] fileExistsAtPath:foofile])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtURL:storeURL error:NULL];
            _persistentStoreCoordinator=nil;
            [self persistentStoreCoordinator];
        }
        
        
    }
    
    [self checkUpgradeOfAppForCopyingStaticDDFIles];
    
    if([NGSavedData getDDDatabaseCreated]== false){
        [NGSavedData DDDataBaseCreated:YES];
        [self copyDatabaseFileAtDocumentDirectory];
        _persistentStoreCoordinator=nil;
        [self persistentStoreCoordinator];
    }

    return _persistentStoreCoordinator;
}
-(void)checkUpgradeOfAppForCopyingStaticDDFIles{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL versionUpgraded;
    NSString *version = [NSString getAppVersion];
    NSString *preVersion = [prefs stringForKey:@"NGAppVersion"];
    
    if ([prefs stringForKey:@"NGAppVersion"] != nil) {
        versionUpgraded = !([preVersion isEqualToString: version]);
    } else {
        versionUpgraded = YES;
    }
    
    if (versionUpgraded) {
        [prefs setObject:version forKey:@"NGAppVersion"];
        [prefs setObject:preVersion forKey:@"NGprevAppVersion"];
        
        //remove setting api last hit date so that Dropdown gets updated with the latest from server
        
        [prefs removeObjectForKey:K_SETTINGS_API_LAST_HIT_DATE];
        [prefs synchronize];

        [NGSavedData DDDataBaseCreated:FALSE];
    }
    
}

-(NSString*)documentDD{

    NSArray *appsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [appsDirectory objectAtIndex:0];
    
}
- (void)copyDatabaseFileAtDocumentDirectory {
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DBPath = [pathArray objectAtIndex:0];
    NSString *writableDBPath = @"";
    
    NSError *error;
    
    {
        writableDBPath = [DBPath stringByAppendingPathComponent:@"NaukriGulf_Static.sqlite"];
        if([filemanager fileExistsAtPath:writableDBPath])
        {
        [filemanager removeItemAtPath:writableDBPath error:&error];
        NSString *defaultDBpath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"NaukriGulf_Static.sqlite"];
        [filemanager copyItemAtPath:defaultDBpath toPath:writableDBPath error:&error];
        [NGDirectoryUtility addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:defaultDBpath]];

        }
    }
    
    {
        writableDBPath = [DBPath stringByAppendingPathComponent:@"NaukriGulf_Static.sqlite-shm"];
        if([filemanager fileExistsAtPath:writableDBPath])
        {
        [filemanager removeItemAtPath:writableDBPath error:&error];
        NSString *defaultDBpath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"NaukriGulf_Static.sqlite-shm"];
        [filemanager copyItemAtPath:defaultDBpath toPath:writableDBPath error:&error];
            [NGDirectoryUtility addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:defaultDBpath]];

        }
    }
    
    
    {
        writableDBPath = [DBPath stringByAppendingPathComponent:@"NaukriGulf_Static.sqlite-wal"];
        if([filemanager fileExistsAtPath:writableDBPath])
        {
        [filemanager removeItemAtPath:writableDBPath error:&error];
        NSString *defaultDBpath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"NaukriGulf_Static.sqlite-wal"];
        [filemanager copyItemAtPath:defaultDBpath toPath:writableDBPath error:&error];
        [NGDirectoryUtility addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:defaultDBpath]];

        }
    }
    

}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+(void)saveDataContext
{
    NSManagedObjectContext *context =  [[NGStaticDDCoreDataLayer sharedInstance] managedObjectContext];
    [context performBlockAndWait:^{
        [context save:nil];
    }];
    [context.parentContext performBlock:^{
        [context.parentContext save:nil];
    }];
}

@end
