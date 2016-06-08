//
//  NGViewMoreSimJobPerformanceTest.m
//  NaukriGulf
//
//  Created by Himanshu on 12/1/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NGViewMoreSimJobsViewController.h"

@interface NGViewMoreSimJobPerformanceTest : XCTestCase<NGLoginHelperTestDelegate>
{
    NGViewMoreSimJobsViewController *vmsVC;
    XCTestExpectation *testExpectationVar;

}

@end

@implementation NGViewMoreSimJobPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testExpectationVar = [self expectationWithDescription:@"NGViewMoreSimJobPerformanceTest_login"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    vmsVC = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"VMJView"];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    testExpectationVar = [self expectationWithDescription:@"NGViewMoreSimJobPerformanceTest_logout"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    vmsVC = nil;

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
    XCTFail(@"Error In Login : NGViewMoreSimJobPerformanceTest");
    
    [testExpectationVar fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout : NGViewMoreSimJobPerformanceTest");
    
    [testExpectationVar fulfill];
}



#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [vmsVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [vmsVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [vmsVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [vmsVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [vmsVC viewDidDisappear:YES];
        
    }];
}
@end