//
//  NGSettingsLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 15/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGSettingsModel.h"

@interface NGSettingsLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *expectation;

}
@end

@implementation NGSettingsLoggedInTest

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGSettingsLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    expectation = [self expectationWithDescription:@"NGSettingsLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    [super tearDown];
}


- (void)testSettingsLoggedIn{
   
    expectation = [self expectationWithDescription:@"NGSettingsLoggedInTest"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SETTINGS];
    
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format", nil]] handler:^(NGAPIResponseModal *responseData) {
        
        NGSettingsModel *settingsModel = [responseData.parsedResponseData objectForKey:@"apiModel"];
        XCTAssertNotNil(settingsModel,@"Settings API not working!");
        
        NSDictionary *dropDowns = [[[[responseData.responseData JSONValue] objectForKey:@"default"] objectForKey:@"modifiedList"] objectForKey:@"dropdowns"];
        XCTAssertNotNil(dropDowns,@"Settings API not working! - modifiedList-->Dropdown is NIL");
        
        [expectation fulfill];
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
