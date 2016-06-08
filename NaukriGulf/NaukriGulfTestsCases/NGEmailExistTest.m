//
//  NGEmailExistTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGEmailExistTest : XCTestCase<NGLoginHelperTestDelegate>{
   
    XCTestExpectation *expectation;
}

@end

@implementation NGEmailExistTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    expectation = [self expectationWithDescription:@"NGEmailExistTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmailExist {
    
    expectation = [self expectationWithDescription:@"NGEmailExistTest"];
    
    NSString* testEmailToCheck = @"abcd@gmail.com";
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_CHECK_REGISTERED_USER];
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:testEmailToCheck,@"email", nil] handler:^(NGAPIResponseModal *responseData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, "Not received response for Email Exist API");
            
            NSString* emailExistStr = [[responseData.responseData JSONValue] objectForKey:KEY_REGISTERED_EMAIL_DATA];
            
            XCTAssertNotNil(emailExistStr,@"Received empty decision variable from server for Email Exist API ");
            [expectation fulfill];
        });
    }];
 
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
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
    [expectation fulfill];}
@end
