//
//  NGTestContactDetails.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/2/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGTestContactDetails : XCTestCase<NGLoginHelperTestDelegate>{
    
     XCTestExpectation *expectation;
}

@end

@implementation NGTestContactDetails

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestContactDetails"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestContactDetails"];
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

- (void)testContactDetails {
    
    expectation = [self expectationWithDescription:@"NGTestContactDetails"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"9995559969+0011111" forKey:@"mphone"];
    [params setObject:@"123158+555+6538511" forKey:@"rphone"];
    
    NSMutableDictionary *otherParamDict = [NSMutableDictionary dictionary];
    [otherParamDict setObject:@"0" forKey:@"resId"];
    [params setObject:otherParamDict forKey:@"otherparamskey"];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Contact Details Api Response");
        [expectation fulfill];
        
      }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}



@end
