//
//  NGTestCVHeadline.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/2/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSMutableDictionary+SetObject.h"
@interface NGTestCVHeadline : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;
}

@end

@implementation NGTestCVHeadline

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestCVHeadline"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestCVHeadline"];
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
- (void)testCVHeadline {
    
    expectation = [self expectationWithDescription:@"NGTestCVHeadline"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    NSString *cvHeadline = @"This is my resume headline";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:cvHeadline forKey:@"default"];
    [dict setCustomObject:cvHeadline forKey:@"EN"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:dict,@"headline", nil];
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with CV Headline Api Response");
        [expectation fulfill];
        
    }];
   
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}



@end
