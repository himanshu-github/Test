//
//  NGDropDownsTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DropDown.h"
@interface NGDropDownsTest : XCTestCase

@end

/*
 NGREC-1098
 country
 city
 employment_status
 farea
 industry_type
 job_type
 language
 marital_status
 nationality
 notice_period
 pgcourse
 pgspec
 ugcourse
 ugspec
 ppgcourse
 ppgspec
 religion
 salary_lacs
 work_level
 work_status
 currency
 pref_location
 exp_year
 exp_month
 search_location
 higher_education
 
*/

@implementation NGDropDownsTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDropDownCountry{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"country" forKey:@"dropdownType"];
            
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
           XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}


- (void)testDropDownCity{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"city" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}


- (void)testDropDownEmploymentStatus{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"employment_status" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownfArea{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"farea" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownIndustryType{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"industry_type" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownJobType{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"job_type" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownEmploymentLanguage{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"language" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownMaritalStatus{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"marital_status" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testDropDownNationality{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"nationality" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testDropDownNoticePeriod{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"notice_period" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownPgCourse{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"pgcourse" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownPGSpec{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"pgspec" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testDropDownUGCourse{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"ugcourse" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testDropDownUGSpec{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"ugspec" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownPPGCourse{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"ppgcourse" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownPPGSpec{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"ppgspec" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownReligion{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"religion" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testDropDownSalary{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"salary_lacs" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}


- (void)testDropDownWorkLevel{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"work_level" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testDropDownWorkStatus{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"work_status" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownCurrency{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"currency" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownPrefLocation{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"pref_location" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownExperinceYear{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"exp_year" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testDropDownExperinceMonth{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"exp_month" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownSearchLocation{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"search_location" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testDropDownWorHigherEducation{
    
    XCTestExpectation* expOBJ = [self expectationWithDescription:@"test_dropdown"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"higher_education" forKey:@"dropdownType"];
    
    NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
    [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
     {
         XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS, @"Error in SERVICE_TYPE_DROPDOWN");
         [expOBJ fulfill];
         
     }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
@end
