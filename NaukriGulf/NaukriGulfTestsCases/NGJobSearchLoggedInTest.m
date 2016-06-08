//
//  NGJobSearchLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 04/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGJobSearchLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;
}

@end

@implementation NGJobSearchLoggedInTest

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGJobSearchLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGJobSearchLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}

- (void)testJobSearchLoggedIn
{
    expectation = [self expectationWithDescription:@"NGJobSearchLoggedInTest"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:0] forKey:@"Offset"];
    [params setObject:[NSNumber numberWithInteger:[[NGSearchJobHelperTest sharedInstance] jobDownloadLimitForTest]] forKey:@"Limit"];
    [params setObject:@"software testing" forKey:@"Keywords"];
    [params setObject:@"" forKey:@"Location"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"Experience"];
    [params setObject:@"ios" forKey:@"requestsource"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_ALL_JOBS];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, "Not received response for Job Search API");
            NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
            NGJobDetailModel *objModel = [responseDataDict objectForKey:KEY_JOBS_INFO];
            [self checkFormat:objModel];
            
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
-(void)checkFormat:(NGJobDetailModel*)modelObj{
    
    XCTAssertNotNil(modelObj.jobList, @"Not getting the list/data array for Job Search API");
    
}

@end
