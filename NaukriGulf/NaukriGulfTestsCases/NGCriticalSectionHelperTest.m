//
//  NGCriticalSectionHelperTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 06/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGCriticalSectionHelper.h"

@interface NGCriticalSectionHelperTest : XCTestCase

@end

@implementation NGCriticalSectionHelperTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedInstance {
    NGCriticalSectionHelper *instanceOne = [NGCriticalSectionHelper sharedInstance];
    NGCriticalSectionHelper *instanceTwo = [NGCriticalSectionHelper sharedInstance];
    
    //nil check
    XCTAssertNotNil(instanceOne,@"NGCriticalSectionHelper instance is nil");
    
    
    //instances should be of equal reference
    XCTAssertTrue(instanceOne == instanceTwo,@"NGCriticalSectionHelper sharedInstance giving different instances.");
    
    
    //Allocation method should not give nil object
    NGCriticalSectionHelper *allocatedInstance = [[NGCriticalSectionHelper alloc] init];
    XCTAssertNotNil(allocatedInstance,@"NGCriticalSectionHelper alloc-init instance is nil");
    
    
    //Allocated instance and shared instances should not be equal
    XCTAssertTrue(allocatedInstance != instanceOne,@"NGCriticalSectionHelper sharedInstance and alloc giving same.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
