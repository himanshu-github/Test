//
//  NGProfilePerformanceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGProfileViewController.h"
#import "NGLoginHelperTest.h"


@interface NGProfilePerformanceTest : XCTestCase<NGLoginHelperTestDelegate>{
    NGProfileViewController *profileVC;
    XCTestExpectation *testExpectationVar;
}


@end

@implementation NGProfilePerformanceTest

- (void)setUp {
    [super setUp];
    
    testExpectationVar = [self expectationWithDescription:@"NGProfilePerformanceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    profileVC = [[NGHelper sharedInstance].profileStoryboard instantiateViewControllerWithIdentifier:@"ProfileView"];
    //NOTE:Set all public property of above object here, if any.
    profileVC.showBackButton = NO;
    profileVC.scrollToIndex = 0;
}

- (void)tearDown {
    testExpectationVar = [self expectationWithDescription:@"NGProfilePerformanceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    profileVC = nil;

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
    XCTFail(@"Error In Login : NGProfilePerformanceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGProfilePerformanceTest");
    
    [testExpectationVar fulfill];
}


#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [profileVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [profileVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [profileVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [profileVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [profileVC viewDidDisappear:YES];
        
    }];
}

@end
