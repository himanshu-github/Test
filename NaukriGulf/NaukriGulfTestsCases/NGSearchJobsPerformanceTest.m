//
//  NGSearchJobsPerformanceTest.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/9/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGSearchJobsViewController.h"

@interface NGSearchJobsPerformanceTest : XCTestCase{
    
    NGSearchJobsViewController *searchJobsVc;
}

@end

@implementation NGSearchJobsPerformanceTest

- (void)setUp {
    [super setUp];
    
   searchJobsVc = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JobSearch"];
    
    [searchJobsVc setComingVia:K_GA_MNJ_SCREEN];
    
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

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [searchJobsVc viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [searchJobsVc viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [searchJobsVc viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [searchJobsVc viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [searchJobsVc viewDidDisappear:YES];
        
    }];
}

@end
