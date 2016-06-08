//
//  NGEditIndustryInfoPerformanceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGEditIndustryInformationViewController.h"
#import "NGLoginHelperTest.h"

@interface NGEditIndustryInfoPerformanceTest : XCTestCase<NGLoginHelperTestDelegate>{
    NGEditIndustryInformationViewController *editIndustryInfoVC;
    XCTestExpectation *testExpectationVar;
    NGMNJProfileModalClass *testUserProfileModal;
}
@end

@implementation NGEditIndustryInfoPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testExpectationVar = [self expectationWithDescription:@"NGEditIndustryInfoPerformanceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editIndustryInfoVC = [[NGEditIndustryInformationViewController alloc] init];
    //NOTE:Set all public property of above object here, if any.
    editIndustryInfoVC.modalClassObj = testUserProfileModal;
    editIndustryInfoVC.editDelegate = nil;//not required here becz of zero impact on current VC
}

- (void)tearDown {
    testExpectationVar = [self expectationWithDescription:@"NGEditIndustryInfoPerformanceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editIndustryInfoVC = nil;
    
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
    XCTFail(@"Error In Login : NGEditIndustryInfoPerformanceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGEditIndustryInfoPerformanceTest");
    
    [testExpectationVar fulfill];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [editIndustryInfoVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [editIndustryInfoVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [editIndustryInfoVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [editIndustryInfoVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [editIndustryInfoVC viewDidDisappear:YES];
        
    }];
}
@end
