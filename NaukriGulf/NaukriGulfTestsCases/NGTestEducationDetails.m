//
//  NGTestEducationDetails.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/2/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGTestEducationDetails : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;

}

@end

@implementation NGTestEducationDetails

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGTestEducationDetails"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestEducationDetails"];
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


- (void)testAddUgEducation{
    
    expectation = [self expectationWithDescription:@"NGTestEducationDetails"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"14" forKey:@"ugCountry"];
    [params setObject:@"2011" forKey:@"ugYear"];
 
    NSMutableDictionary *otherParamDict = [NSMutableDictionary dictionary];
    [otherParamDict setObject:@"0" forKey:@"resId"];
    [params setObject:otherParamDict forKey:@"otherparamskey"];
    
    
    NSMutableDictionary *ugCouseDict = [[NSMutableDictionary alloc] init];
    [ugCouseDict setObject:@"1" forKey:@"id"];
    [ugCouseDict setObject:@"Other" forKey:@"other"];
    [ugCouseDict setObject:@"Other" forKey:@"otherEN"];
    
    [params setObject:ugCouseDict forKey:@"ugCourse"];
    
    NSMutableDictionary *ugSpecDict = [[NSMutableDictionary alloc] init];
    [ugSpecDict setObject:@"1.1" forKey:@"id"];
    [ugSpecDict setObject:@"Other" forKey:@"other"];
    [ugSpecDict setObject:@"Other" forKey:@"otherEN"];
    [params setObject:ugSpecDict forKey:@"ugCourse"];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Save UG Education Api Response");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
}

-(void) testAddPgEducation{
    
    expectation = [self expectationWithDescription:@"NGTestEducationDetails"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"17" forKey:@"pgCountry"];
    [params setObject:@"2014" forKey:@"pgYear"];
    
    NSMutableDictionary *otherParamDict = [NSMutableDictionary dictionary];
    [otherParamDict setObject:@"0" forKey:@"resId"];
    [params setObject:otherParamDict forKey:@"otherparamskey"];

    NSMutableDictionary *pgCouseDict = [[NSMutableDictionary alloc] init];
    [pgCouseDict setObject:@"1" forKey:@"id"];
    [pgCouseDict setObject:@"Other" forKey:@"other"];
    [pgCouseDict setObject:@"Other" forKey:@"otherEN"];
    
    [params setObject:pgCouseDict forKey:@"pgCourse"];
    
    NSMutableDictionary *pgSpecDict = [[NSMutableDictionary alloc] init];
    [pgSpecDict setObject:@"1.1" forKey:@"id"];
    [pgSpecDict setObject:@"Other" forKey:@"other"];
    [pgSpecDict setObject:@"Other" forKey:@"otherEN"];
    [params setObject:pgSpecDict forKey:@"pgSpec"];

    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
      
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Save Master Education Api Response");
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
}

-(void) testAddDoctEducation {
    
    expectation = [self expectationWithDescription:@"NGTestEducationDetails"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"10" forKey:@"ppgCountry"];
    [params setObject:@"2008" forKey:@"ppgYear"];
    
    NSMutableDictionary *otherParamDict = [NSMutableDictionary dictionary];
    [otherParamDict setObject:@"0" forKey:@"resId"];
    [params setObject:otherParamDict forKey:@"otherparamskey"];
    
    NSMutableDictionary *ppgCouseDict = [[NSMutableDictionary alloc] init];
    [ppgCouseDict setObject:@"1" forKey:@"id"];
    [ppgCouseDict setObject:@"Other" forKey:@"other"];
    [ppgCouseDict setObject:@"Other" forKey:@"otherEN"];
    
    [params setObject:ppgCouseDict forKey:@"ppgCourse"];
    
    NSMutableDictionary *ppgSpecDict = [[NSMutableDictionary alloc] init];
    [ppgSpecDict setObject:@"1.2" forKey:@"id"];
    [ppgSpecDict setObject:@"Other" forKey:@"other"];
    [ppgSpecDict setObject:@"Other" forKey:@"otherEN"];
    [params setObject:ppgSpecDict forKey:@"ppgSpec"];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Save Doct Education Api Response");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
}



@end
