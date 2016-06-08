//
//  NGTestPersonalDetails.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/2/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGTestPersonalDetails : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;

}

@end


@implementation NGTestPersonalDetails

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestPersonalDetails"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestPersonalDetails"];
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

- (void)testPersonalDetails {

    expectation = [self expectationWithDescription:@"NGTestPersonalDetails"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"1998-02-28" forKey:@"dateOfBirth"];
    [params setObject:@"y" forKey:@"drivingLicense"];
    [params setObject:@"13" forKey:@"drivingLicenseCountry"];
    [params setObject:@"Female" forKey:@"gender"];
    [params setObject:@"22" forKey:@"languagesKnown"];
    [params setObject:@"1" forKey:@"maritalStatus"];
    [params setObject:@"2" forKey:@"nationality"];
    
    NSMutableDictionary *otherParamDict = [NSMutableDictionary dictionary];
    [otherParamDict setObject:@"0" forKey:@"resId"];
    
    [params setObject:otherParamDict forKey:@"otherparamskey"];
    
    NSMutableDictionary *religionDict = [NSMutableDictionary dictionary];
    [religionDict setObject:@"5" forKey:@"id"];
    [religionDict setObject:@"Other" forKey:@"other"];
    [religionDict setObject:@"Other" forKey:@"otherEN"];
    [params setObject:religionDict forKey:@"religion"];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
       
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Personal Details Api Response");
        [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

@end
