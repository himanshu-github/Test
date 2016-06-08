//
//  NGMNJDashboardPerformanceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGLoginHelperTest.h"
#import "NGMNJViewController.h"
@interface NGMNJDashboardPerformanceTest : XCTestCase<NGLoginHelperTestDelegate>{
    NGMNJViewController *mnjVC;
    XCTestExpectation *testExpectationVar;
}
@end

@implementation NGMNJDashboardPerformanceTest

- (void)setUp {
    [super setUp];
    
    testExpectationVar = [self expectationWithDescription:@"NGMNJDashboardPerformanceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    mnjVC = [[NGHelper sharedInstance].mNJStoryboard instantiateViewControllerWithIdentifier:@"MNJView"];
    //NOTE:Set all public property of mnjvc object here, if any.
}

- (void)tearDown {
    testExpectationVar = [self expectationWithDescription:@"NGMNJDashboardPerformanceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    mnjVC = nil;
    
    [super tearDown];
}

#pragma mark Login Delegate
-(void)successfullyLoginTest{
    
    [testExpectationVar fulfill];
}
- (void)successfullyLogoutTest{
    
    [testExpectationVar fulfill];
}
-(void)errorInLoginTest{
    XCTFail(@"Error In Login : NGMNJDashboardPerformanceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGMNJDashboardPerformanceTest");
    
    [testExpectationVar fulfill];
}



#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {

    [self measureBlock:^{
        [mnjVC viewDidLoad];

    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [mnjVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [mnjVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [mnjVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [mnjVC viewDidDisappear:YES];
        
    }];
}
@end
