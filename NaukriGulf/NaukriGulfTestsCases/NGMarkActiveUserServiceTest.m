//
//  NGMarkActiveUserServiceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NGMarkActiveUserServiceTest : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *expectation;
    
}

@end

@implementation NGMarkActiveUserServiceTest

- (void)setUp {
    [super setUp];
    
    expectation = [self expectationWithDescription:@"NGMarkActiveUserServiceTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    expectation = [self expectationWithDescription:@"NGMarkActiveUserServiceTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    [super tearDown];
}

- (void)testMarkActiveLoggedInUser{
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_USER_ACTIVE_STATE];
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"markactive"
                                                                           }] handler:^(NGAPIResponseModal *responseData) {
        
        XCTAssertTrue(responseData.isSuccess,@"SERVICE_TYPE_USER_ACTIVE_STATE : Failed to get response from API");
        
        XCTAssertEqual(K_RESPONSE_SUCESS_WITHOUT_BODY, responseData.responseCode,@"SERVICE_TYPE_USER_ACTIVE_STATE : Invalid response received from server.");
    }];
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
