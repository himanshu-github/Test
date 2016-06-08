//
//  NGEditIndustryInformationTest.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/6/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGEditIndustryInformationTest : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;
}

@end

@implementation NGEditIndustryInformationTest

- (void)setUp {
    
    [super setUp];
    expectation = [self expectationWithDescription:@"NGEditIndustryInformationTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGEditIndustryInformationTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
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

- (void)testEditIndustryInformation {
 
    expectation = [self expectationWithDescription:@"NGEditIndustryInformationTest"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"3" forKey:@"noticePeriod"];
    
    NSMutableDictionary *otherParamDict = [NSMutableDictionary dictionary];
    [otherParamDict setObject:@"0" forKey:@"resId"];
    
    [params setObject:otherParamDict forKey:@"otherparamskey"];
    
    NSMutableDictionary *functionalAreaDict = [NSMutableDictionary dictionary];
    [functionalAreaDict setObject:@"1000" forKey:@"id"];
    [functionalAreaDict setObject:@"Banana test" forKey:@"other"];
    [functionalAreaDict setObject:@"Banana test" forKey:@"otherEN"];
    [params setObject:functionalAreaDict forKey:@"functionalArea"];
    
    NSMutableDictionary *industryTypeDict = [NSMutableDictionary dictionary];
    [industryTypeDict setObject:@"1000" forKey:@"id"];
    [industryTypeDict setObject:@"Banana test" forKey:@"other"];
    [industryTypeDict setObject:@"Banana test" forKey:@"otherEN"];
    [params setObject:functionalAreaDict forKey:@"industryType"];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Personal Details Api Response");
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}
@end
