//
//  NGFilterPerformaceTest.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/9/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGFilterViewController.h"

@interface NGFilterPerformaceTest : XCTestCase{
    
    NGFilterViewController *filterVC;
}

@end

@implementation NGFilterPerformaceTest

- (void)setUp {
    
    [super setUp];
    
    
    filterVC = [[NGFilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    
    filterVC.filterDelegate = nil;
    filterVC.clusterDict = nil;
    
    [APPDELEGATE.container setRightMenuViewController:filterVC];
    
    filterVC.clusterDict = nil;
    
    [filterVC.resultDict setDictionary:nil];
    [filterVC.paramsDict setDictionary:nil];
    [filterVC updateFiltersList];
    [filterVC resetAll];
    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];

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
        [filterVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [filterVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [filterVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [filterVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [filterVC viewDidDisappear:YES];
        
    }];
}
@end
