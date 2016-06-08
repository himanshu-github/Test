//
//  NGSettingsNotLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NGSettingsModel.h"

@interface NGSettingsNotLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *expectation;
    
}

@end

@implementation NGSettingsNotLoggedInTest

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGSettingsLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSettingsNotLoggedIn {
    expectation = [self expectationWithDescription:@"NGSettingsLoggedInTest"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SETTINGS];
    
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"json",@"format", nil]] handler:^(NGAPIResponseModal *responseData) {
        
        NGSettingsModel *settingsModel = [responseData.parsedResponseData objectForKey:@"apiModel"];
        XCTAssertNotNil(settingsModel,@"Settings API not working!");
        
        
        NSDictionary *responseObj = [responseData.responseData JSONValue];
        
        XCTAssertNotNil([responseObj objectForKey:@"default"],@"SERVICE_TYPE_SETTINGS : default param is NIL");
        XCTAssertNotNil([[responseObj objectForKey:@"default"] objectForKey:@"intervalSettings"],@"SERVICE_TYPE_SETTINGS : default->intervalSettings param is NIL");
        XCTAssertNotNil([[[responseObj objectForKey:@"default"] objectForKey:@"intervalSettings"] objectForKey:@"localRecoInterval"],@"SERVICE_TYPE_SETTINGS : default->intervalSettings->localRecoInterval param is NIL");
        
        
        XCTAssertNotNil([responseObj objectForKey:@"app"],@"SERVICE_TYPE_SETTINGS : app param is NIL");
        XCTAssertNotNil([[responseObj objectForKey:@"app"] objectForKey:@"intervalSettings"],@"SERVICE_TYPE_SETTINGS : app->intervalSettings param is NIL");
        XCTAssertNotNil([[[responseObj objectForKey:@"app"] objectForKey:@"intervalSettings"] objectForKey:@"localRecoInterval"],@"SERVICE_TYPE_SETTINGS : app->intervalSettings->localRecoInterval param is NIL");
        
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
