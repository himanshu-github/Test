//
//  NGEditPersonalDetailsPerformanceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGEditPersonalDetailsViewController.h"
#import "NGLoginHelperTest.h"
@interface NGEditPersonalDetailsPerformanceTest : XCTestCase<NGLoginHelperTestDelegate>{
    NGEditPersonalDetailsViewController *editPersonalDetailsVC;
    XCTestExpectation *testExpectationVar;
    NGMNJProfileModalClass *testUserProfileModal;
}

@end

@implementation NGEditPersonalDetailsPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testExpectationVar = [self expectationWithDescription:@"NGEditPersonalDetailsPerformanceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editPersonalDetailsVC = [[NGEditPersonalDetailsViewController alloc] init];
    //NOTE:Set all public property of above object here, if any.
    editPersonalDetailsVC.modalClassObj = testUserProfileModal;
    editPersonalDetailsVC.editDelegate = nil;//not required here becz of zero impact on current VC
}

- (void)tearDown {
    testExpectationVar = [self expectationWithDescription:@"NGEditPersonalDetailsPerformanceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editPersonalDetailsVC = nil;
    
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
    XCTFail(@"Error In Login : NGEditPersonalDetailsPerformanceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGEditPersonalDetailsPerformanceTest");
    
    [testExpectationVar fulfill];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [editPersonalDetailsVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [editPersonalDetailsVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [editPersonalDetailsVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [editPersonalDetailsVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [editPersonalDetailsVC viewDidDisappear:YES];
        
    }];
}

@end
