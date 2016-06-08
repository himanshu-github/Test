//
//  NGEditContactDetailsPerformanceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGEditContactDetailViewController.h"
#import "NGLoginHelperTest.h"
#import "NGEditContactDetailViewController.h"

@interface NGEditContactDetailsPerformanceTest : XCTestCase<NGLoginHelperTestDelegate>{
    NGEditContactDetailViewController *editContactDetailVC;
    XCTestExpectation *testExpectationVar;
    NGMNJProfileModalClass *testUserProfileModal;
}

@end

@implementation NGEditContactDetailsPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testExpectationVar = [self expectationWithDescription:@"NGEditContactDetailsPerformanceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editContactDetailVC = [[NGEditContactDetailViewController alloc] init];
    //NOTE:Set all public property of above object here, if any.
    editContactDetailVC.modalClassObj = testUserProfileModal;
    editContactDetailVC.editDelegate = nil;//not required here becz of zero impact on current VC
}

- (void)tearDown {
    testExpectationVar = [self expectationWithDescription:@"NGEditContactDetailsPerformanceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editContactDetailVC = nil;

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
    XCTFail(@"Error In Login : NGEditContactDetailsPerformanceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGEditContactDetailsPerformanceTest");
    
    [testExpectationVar fulfill];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [editContactDetailVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [editContactDetailVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [editContactDetailVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [editContactDetailVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [editContactDetailVC viewDidDisappear:YES];
        
    }];
}
@end
