//
//  NGAppStateTests.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/6/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGAppStateTests : XCTestCase

@end

@implementation NGAppStateTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSharedInstance {
    
    NGAppStateHandler *instanceOne = [NGAppStateHandler sharedInstance];
    NGAppStateHandler *instanceTwo = [NGAppStateHandler sharedInstance];
    
    
    if (!instanceOne) {
        
        XCTFail(@"Instance is nil");
        
    }
    
    // Two instances
    if (instanceOne != instanceTwo) {
        
        XCTFail(@"Instances are not equal");
        
    }
    
    //Alloc
    instanceOne = [[NGAppStateHandler alloc] init];
    
    if (instanceOne == instanceTwo) {
        
        XCTFail(@"Instances should not be equal but they are equal");
        
    }
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
