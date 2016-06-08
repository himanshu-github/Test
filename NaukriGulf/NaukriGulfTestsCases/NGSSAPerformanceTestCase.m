//
//  NGSSAPerformanceTestCase.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/9/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGSSAView.h"


@interface NGSSAPerformanceTestCase : XCTestCase{
    
    
    NGSSAView *ssaView;
}

@end

@implementation NGSSAPerformanceTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    ssaView = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"SSAView"];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
