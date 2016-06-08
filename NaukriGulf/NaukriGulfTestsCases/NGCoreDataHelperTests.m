//
//  NGCoreDataHelperTests.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/6/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGCoreDataHelperTests : XCTestCase
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainMOC;

@end

@implementation NGCoreDataHelperTests
@synthesize persistentStoreCoordinator;
@synthesize managedObjectModel;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    XCTAssertNotNil(coordinator,@"Instance is nil");
    
    _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSharedInstance {
    
    NGCoreDataHelper *instanceOne = [NGCoreDataHelper sharedInstance];
    NGCoreDataHelper *instanceTwo = [NGCoreDataHelper sharedInstance];
    
    
    //single instance not nil
    XCTAssertNotNil(instanceOne,@"Instance is nil");
    
    //two instaces should be same
    XCTAssertEqual(instanceOne, instanceTwo,@"Instances are not equal");
    
    //Alloc
    instanceOne = [[NGCoreDataHelper alloc] init];
    
    //alloc instance not nil
    XCTAssertNotEqual(instanceOne, instanceTwo,@"Instances should not be equal but they are equal");
    
    
}
-(void)testDocumentDD{
    
    NSArray *appsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* ddDirectory =  [appsDirectory objectAtIndex:0];
    XCTAssertNotNil(ddDirectory,@"Instance is nil");
    
}
-(void)testMainMocIsNotNil{
    
    XCTAssertNotNil(_mainMOC,@"Instance is nil");
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    
    if ( persistentStoreCoordinator!= nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NaukriGulf_Static.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"%@",error.localizedDescription);
        XCTFail(@"Error In Database creation");
        
    }
    
    return persistentStoreCoordinator;
}
- (NSManagedObjectModel *)managedObjectModel{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NaukriGulf_Static" withExtension:@"momd"];
    XCTAssertNotNil(modelURL,@"modelUrl is nil");
    
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    XCTAssertNotNil(managedObjectModel,@"managedObjectModel is nil");
    
    return managedObjectModel;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    XCTAssertNotNil(url,@"applicationDocumentsDirectory is nil");
    return url;
}
-(void)testsaveDataContext
{
    NSManagedObjectContext *context =  [[NGCoreDataHelper sharedInstance] managedObjectContext];
    __block NSError *error = nil;
    [context performBlockAndWait:^{
        [context save:&error];
        XCTAssertNil(error,@"error is nil");
    }];
    [context.parentContext performBlock:^{
        [context.parentContext save:&error];
        XCTAssertNil(error,@"error is nil");
        
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
