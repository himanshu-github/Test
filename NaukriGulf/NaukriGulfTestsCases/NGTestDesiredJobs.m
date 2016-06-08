//
//  NGTestDesiredJobs.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/2/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGTestDesiredJobs : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;

}

@end

@implementation NGTestDesiredJobs

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestDesiredJobs"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestDesiredJobs"];
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


- (void)testDesiredJobs {
    
    expectation = [self expectationWithDescription:@"NGTestDesiredJobs"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"employmentStatus"];
    [params setObject:@"1" forKey:@"employmentType"];
    [params setObject:@"171,170,177" forKey:@"preferredWorkLocation"];
    NSMutableDictionary *otherDict = [NSMutableDictionary dictionary];
    [otherDict setObject:@"0" forKey:@"resId"];
    [params setObject:otherDict forKey:@"otherparamskey"];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Desired Jobs Api Response");
        [expectation fulfill];
    }];
  
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}


@end
