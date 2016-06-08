//
//  NGTestBasicDetails.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/2/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGTestBasicDetails : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;

}

@end

@implementation NGTestBasicDetails

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestBasicDetails"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestBasicDetails"];
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
- (void)testEditBasicDetails {
  
    expectation = [self expectationWithDescription:@"NGTestBasicDetails"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"10" forKey:@"country"];
    [params setObject:@"13" forKey:@"ctc"];
    [params setObject:@"Batman Hu" forKey:@"name"];
    [params setObject:@"6" forKey:@"ctc"];
    [params setObject:@"2032-01-01" forKey:@"visaExpiryDate"];
    [params setObject:@"5" forKey:@"visaStatus"];
    [params setObject:@"1" forKey:@"totalExperienceMonths"];
    [params setObject:@"6" forKey:@"totalExperienceYears"];


    NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
    [cityDict setObject:@"10.1000" forKey:@"id"];
    [cityDict setObject:@"Other" forKey:@"other"];
    [cityDict setObject:@"Other" forKey:@"otherEN"];
    
    [params setObject:cityDict forKey:@"city"];

    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Edit Basic Details Api response");
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}


@end
