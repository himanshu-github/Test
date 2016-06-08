//
//  NGAppBlockerLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 15/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGAppBlockerModel.h"

@interface NGAppBlockerLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;
}
@end

@implementation NGAppBlockerLoggedInTest

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGAppBlockerLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGAppBlockerLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
   [[NGLoginHelperTest sharedInstance] makeUserLogOut];
   [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}

- (void)testAppBlockerLoggedIn {
   
    
    expectation = [self expectationWithDescription:@"NGAppBlockerLoggedInTest"];
    
    NGWebDataManager* dataManager = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_APP_BLOCKER];
    
    [dataManager getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionary],K_RESOURCE_PARAMS,[NSDictionary dictionaryWithObjectsAndKeys:@"",@"time", nil],K_ATTRIBUTE_PARAMS, nil] handler:^(NGAPIResponseModal *responseData){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NGAppBlockerModel *obj = [responseData.parsedResponseData objectForKey:@"apiModel"];
            XCTAssertNotNil(obj,@"NGAppBlockerModel is nil, AppBlocker API not working!");
            XCTAssertTrue([self isFlagValid:obj.flag],@"AppBlocker API sent invalid flag!");
            [expectation fulfill];
        });
    }];
  
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}
-(BOOL)isFlagValid:(NSInteger)paramFlag{
    if (K_NA == paramFlag || K_BLOCKER== paramFlag || K_NON_BLOCKING_MSG == paramFlag || K_FORCE_UPGRADE == paramFlag || K_BLOCK_NOTIFICATIONS== paramFlag) {
        return YES;
    }
    return NO;
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
