//
//  NGTestMNJDashboard.m
//  NaukriGulf
//
//  Created by Arun Kumar on 1/6/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NGTestMNJDashboard : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *expectation;
    
}

@end

@implementation NGTestMNJDashboard

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestMNJDashboard"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestMNJDashboard"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}



#pragma mark Login Delegate
-(void)successfullyLoginTest{
    
    [expectation fulfill];
}
- (void)successfullyLogoutTest{
    
    [expectation fulfill];
}
-(void)errorInLoginTest{
    XCTFail(@"Error In Login");
    
    [expectation fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout");
    
    [expectation fulfill];
}

- (void)testMNJDashboardAPI{
    
   expectation = [self expectationWithDescription:@"NGTestMNJDashboard"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_MNJ_INCOMPLETE_SECTION];
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseData){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertTrue(responseData.isSuccess,@"MNJ Dashboard API is not working");
            
            [expectation fulfill];
        });
        
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}


@end
