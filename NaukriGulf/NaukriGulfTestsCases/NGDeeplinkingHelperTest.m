//
//  NGDeeplinkingHelperTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 06/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGDeeplinkingHelperTest : XCTestCase

@end

@implementation NGDeeplinkingHelperTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedInstance {
    NGDeepLinkingHelper *instanceOne = [NGDeepLinkingHelper sharedInstance];
    NGDeepLinkingHelper *instanceTwo = [NGDeepLinkingHelper sharedInstance];
    
    //nil check
    XCTAssertNotNil(instanceOne,@"NGDeepLinkingHelper instance is nil");
    
    
    //instances should be of equal reference
    XCTAssertTrue(instanceOne == instanceTwo,@"NGDeepLinkingHelper sharedInstance giving different instances.");
    
    
    //Allocation method should not give nil object
    NGDeepLinkingHelper *allocatedInstance = [[NGDeepLinkingHelper alloc] init];
    XCTAssertNotNil(allocatedInstance,@"NGDeepLinkingHelper alloc-init instance is nil");
    
    
    //Allocated instance and shared instances should not be equal
    XCTAssertTrue(allocatedInstance != instanceOne,@"NGDeepLinkingHelper sharedInstance and alloc giving same.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end