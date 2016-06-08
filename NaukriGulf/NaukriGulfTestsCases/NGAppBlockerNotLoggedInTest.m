//
//  NGAppBlockerNotLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 15/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGAppBlockerModel.h"

@interface NGAppBlockerNotLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
   
    XCTestExpectation *expectation;
}
@end

@implementation NGAppBlockerNotLoggedInTest

- (void)setUp {
   
    [super setUp];
    
    expectation = [self expectationWithDescription:@"NGAppBlockerNotLoggedInTest"];
    
    [NGLoginHelperTest sharedInstance].delegate = self;
    
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAppBlockerNotLoggedIn{
   
    expectation = [self expectationWithDescription:@"NGAppBlockerNotLoggedInTest"];
    
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
    //written just to suppress xcode warning
}
- (void)successfullyLogoutTest{
    
    [expectation fulfill];
}
-(void)errorInLoginTest{
    
    //written just to suppress xcode warning
}
-(void)errorInLogoutTest{
   
    XCTFail(@"Error In Logout");
    [expectation fulfill];
}

@end
