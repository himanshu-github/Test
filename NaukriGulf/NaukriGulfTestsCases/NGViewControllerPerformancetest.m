//
//  NGViewControllerPerformancetest.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/9/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGViewController.h"
@interface NGViewControllerPerformancetest : XCTestCase{
    
    NGViewController *homeVc;
    XCTestExpectation *testExpectationVar;

}

@end

@implementation NGViewControllerPerformancetest

- (void)setUp {
    [super setUp];
    
    homeVc = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"navigationController"];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [homeVc viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [homeVc viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [homeVc viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [homeVc viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [homeVc viewDidDisappear:YES];
        
    }];
}
@end
