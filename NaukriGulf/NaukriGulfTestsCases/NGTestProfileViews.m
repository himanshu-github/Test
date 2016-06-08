//
//  NGTestProfileViews.m
//  NaukriGulf
//
//  Created by Arun Kumar on 1/7/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NGTestProfileViews : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *expectation;
}

@end

@implementation NGTestProfileViews

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestProfileViews"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestProfileViews"];
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

- (void)testProfileViewsAPI{
    
    expectation = [self expectationWithDescription:@"NGTestProfileViews"];
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_WHO_VIEWED_MY_CV];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertTrue(responseData.isSuccess,@"Profile Views API is not working");
            
            [expectation fulfill];
        });
        
    }];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}



@end
