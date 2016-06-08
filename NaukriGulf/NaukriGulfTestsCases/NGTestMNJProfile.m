//
//  NGTestMNJProfile.m
//  NaukriGulf
//
//  Created by Arun Kumar on 1/6/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NGTestMNJProfile : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *expectation;
    
}


@end

@implementation NGTestMNJProfile


- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestMNJProfile"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestMNJProfile"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}

- (void)testMNJProfileAPI{
    expectation = [self expectationWithDescription:@"NGTestMNJProfile"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"fullCv",@"lastModTimeStamp",@"photoMetadata",@"attachedCvFormat",@"currentWorkExperience", nil],@"fields", nil];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_USER_DETAILS];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertTrue(responseInfo.isSuccess,@"MNJ Profile API is not working");
            
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
