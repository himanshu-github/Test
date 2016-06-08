//
//  NGHelperTests.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/6/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGHelperTests : XCTestCase

@end

@implementation NGHelperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}
- (void)testSharedInstance {
    
    NGHelper *instanceOne = [NGHelper sharedInstance];
    NGHelper *instanceTwo = [NGHelper sharedInstance];
    
    //single instance not nil
    XCTAssertNotNil(instanceOne,@"Instance is nil");
    
    //two instaces should be same
    XCTAssertEqual(instanceOne, instanceTwo,@"Instances are not equal");
    
    //Alloc
    instanceOne = [[NGHelper alloc] init];
    
    //alloc instance not nil
    XCTAssertNotEqual(instanceOne, instanceTwo,@"Instances should not be equal but they are equal");
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
