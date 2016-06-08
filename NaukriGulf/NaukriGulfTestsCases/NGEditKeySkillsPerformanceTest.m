//
//  NGEditKeySkillsPerformanceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGEditKeySkillsViewController.h"
#import "NGLoginHelperTest.h"


@interface NGEditKeySkillsPerformanceTest : XCTestCase<NGLoginHelperTestDelegate>{
    NGEditKeySkillsViewController *editKeySkillsVC;
    XCTestExpectation *testExpectationVar;
    NGMNJProfileModalClass *testUserProfileModal;
}

@end

@implementation NGEditKeySkillsPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testExpectationVar = [self expectationWithDescription:@"NGEditKeySkillsPerformanceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editKeySkillsVC = [[NGEditKeySkillsViewController alloc] init];
    //NOTE:Set all public property of above object here, if any.
    editKeySkillsVC.modalClassObj = testUserProfileModal;
    editKeySkillsVC.editDelegate = nil;//not required here becz of zero impact on current VC
}

- (void)tearDown {
    testExpectationVar = [self expectationWithDescription:@"NGEditKeySkillsPerformanceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    editKeySkillsVC = nil;
    
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
    XCTFail(@"Error In Login : NGEditKeySkillsPerformanceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGEditKeySkillsPerformanceTest");
    
    [testExpectationVar fulfill];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [editKeySkillsVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [editKeySkillsVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [editKeySkillsVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [editKeySkillsVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [editKeySkillsVC viewDidDisappear:YES];
        
    }];
}
@end
