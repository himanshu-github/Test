//
//  NGLoginServiceTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 02/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>



@interface NGLoginServiceTest : XCTestCase{
    
   XCTestExpectation *expectation;
    
}

@end

@implementation NGLoginServiceTest

- (void)setUp {

    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testLogin {
   
    expectation = [self expectationWithDescription:@"NGLoginServiceTest"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"gulflive1@gmail.com",@"username",@"123456",@"password", nil];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_LOGIN];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
       
        XCTAssertTrue(responseInfo.isSuccess,@"Login Api not working");
        [expectation fulfill];
    }];
     
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

@end
