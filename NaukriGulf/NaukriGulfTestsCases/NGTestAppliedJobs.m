//
//  NGTestAppliedJobs.m
//  NaukriGulf
//
//  Created by Arun Kumar on 1/7/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NGTestAppliedJobs : XCTestCase<NGLoginHelperTestDelegate>{
   
    XCTestExpectation *expectation;
}

@end

@implementation NGTestAppliedJobs

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestAppliedJobs"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestAppliedJobs"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}

- (void)testAppliedJobsAPI{
    expectation = [self expectationWithDescription:@"NGTestAppliedJobs"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_APPLIED_JOBS];
    
    [obj getDataWithParams:(NSMutableDictionary*)[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format",[NSNumber numberWithInt:0],@"offset",[NSNumber numberWithInt:APPLIED_PAGINATION_LIMIT],@"limit", nil] handler:^(NGAPIResponseModal *responseData){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertTrue(responseData.isSuccess,@"Applied Jobs API is not working");
            
            [expectation fulfill];
        });
        
    }];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

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

@end
