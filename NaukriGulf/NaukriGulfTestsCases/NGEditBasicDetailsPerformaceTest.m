//
//  NGEditBasicDetailsPerformaceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGLoginHelperTest.h"
#import "NGEditBasicDetailsViewController.h"


@interface NGEditBasicDetailsPerformaceTest : XCTestCase<NGLoginHelperTestDelegate>{
    NGEditBasicDetailsViewController *editBasicDetailVC;
    XCTestExpectation *testExpectationVar;
    NGMNJProfileModalClass *testUserProfileModal;
}

@end

@implementation NGEditBasicDetailsPerformaceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testExpectationVar = [self expectationWithDescription:@"NGEditBasicDetailsPerformaceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editBasicDetailVC = [[NGEditBasicDetailsViewController alloc] init];
    //NOTE:Set all public property of above object here, if any.
    editBasicDetailVC.modalClassObj = testUserProfileModal;
    editBasicDetailVC.editDelegate = nil;//not required here becz of zero impact on current VC
}

- (void)tearDown {
    testExpectationVar = [self expectationWithDescription:@"NGEditBasicDetailsPerformaceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editBasicDetailVC = nil;

    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark Login Delegate
-(void)successfullyLoginTest{
    
    [testExpectationVar fulfill];
}
-(void)successfullyLoginTestWithProfileModal:(NGMNJProfileModalClass *)profileModal{
    testUserProfileModal = profileModal;
    [testExpectationVar fulfill];
}
- (void)successfullyLogoutTest{
    
    [testExpectationVar fulfill];
}
-(void)errorInLoginTest{
    XCTFail(@"Error In Login : NGEditBasicDetailsPerformaceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGEditBasicDetailsPerformaceTest");
    
    [testExpectationVar fulfill];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [editBasicDetailVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [editBasicDetailVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [editBasicDetailVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [editBasicDetailVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [editBasicDetailVC viewDidDisappear:YES];
        
    }];
}

@end
