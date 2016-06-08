//
//  NGEditEducationDetailsPerformanceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGEditEducationViewController.h"
#import "NGLoginHelperTest.h"

@interface NGEditEducationDetailsPerformanceTest : XCTestCase<NGLoginHelperTestDelegate>{
    NGEditEducationViewController *editEducationVC;
    XCTestExpectation *testExpectationVar;
    NGMNJProfileModalClass *testUserProfileModal;
}

@end

@implementation NGEditEducationDetailsPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    //NOTE:Set all public property of above object here, if any.
    
    editEducationVC = [[NGEditEducationViewController alloc] init];
    testExpectationVar = [self expectationWithDescription:@"NGEditEducationDetailsPerformanceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];


}

- (void)tearDown {
    testExpectationVar = [self expectationWithDescription:@"NGEditEducationDetailsPerformanceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    editEducationVC = nil;
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark Login Delegate
-(void)successfullyLoginTest{
    
    [testExpectationVar fulfill];
}
-(void)successfullyLoginTestWithProfileModal:(NGMNJProfileModalClass *)profileModal{
    testUserProfileModal = profileModal;
    XCTAssertNotNil(testUserProfileModal,@"UserProfileModel is nil : NGEditEducationDetailsPerformanceTest");
    
    if(testUserProfileModal!=nil)
    {
        [testUserProfileModal createEducationList];
    }
    NGEducationDetailModel *eduDetailModel = [testUserProfileModal.educationList fetchObjectAtIndex:0];
    XCTAssertNotNil(eduDetailModel,@"EducationDetailModel is nil : NGEditEducationDetailsPerformanceTest");
    
    [testExpectationVar fulfill];

}
- (void)successfullyLogoutTest{
    
    [testExpectationVar fulfill];
}
-(void)errorInLoginTest{
    XCTFail(@"Error In Login : NGEditEducationDetailsPerformanceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGEditEducationDetailsPerformanceTest");
    
    [testExpectationVar fulfill];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [editEducationVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [editEducationVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [editEducationVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [editEducationVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [editEducationVC viewDidDisappear:YES];
        
    }];
}
@end
