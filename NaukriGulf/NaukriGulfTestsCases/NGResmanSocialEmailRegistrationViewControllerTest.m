//
//  NGResmanSocialEmailRegistrationViewControllerTest.m
//  NaukriGulf
//
//  Created by Himanshu on 6/7/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NGResmanSocialEmailRegistrationViewController.h"

@interface NGResmanSocialEmailRegistrationViewControllerTest : XCTestCase{
    NGResmanSocialEmailRegistrationViewController *resmanSocialEmailResVC;
    XCTestExpectation *testExpectationVar;
    
}
@end

@implementation NGResmanSocialEmailRegistrationViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
    resmanSocialEmailResVC = [[NGResmanSocialEmailRegistrationViewController alloc] init];

    //NOTE:Set all public property of above object here, if any.
}

- (void)tearDown {
    
    resmanSocialEmailResVC = nil;
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [resmanSocialEmailResVC viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [resmanSocialEmailResVC viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [resmanSocialEmailResVC viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [resmanSocialEmailResVC viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [resmanSocialEmailResVC viewDidDisappear:YES];
        
    }];
}

@end
