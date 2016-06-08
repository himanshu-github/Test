//
//  NGJDLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGJDLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;
}

@end

@implementation NGJDLoggedInTest

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGJDLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGJDLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}

- (void)testJDLoggedIn{
    
    expectation = [self expectationWithDescription:@"NGJDLoggedInTest"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:0] forKey:@"Offset"];
    [params setObject:[NSNumber numberWithInteger:[NGConfigUtility getJobDownloadLimit]] forKey:@"Limit"];
    [params setObject:@"sales" forKey:@"Keywords"];
    [params setObject:@"" forKey:@"Location"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"Experience"];
    [params setObject:@"ios" forKey:@"requestsource"];
    
    [[NGSearchJobHelperTest sharedInstance] fetchJDWithParams:params AndHandler:^(NGJobDetailModel* jobDetailModel){
        if(jobDetailModel)
        {
            NGJobDetails *jobFetched = [jobDetailModel.jobList firstObject];
            NSDictionary *resourceParams = [NSDictionary dictionaryWithObjectsAndKeys:jobFetched.jobID,@"jobId", nil];
            NSMutableDictionary *attributeParams = [NSMutableDictionary  dictionaryWithDictionary:resourceParams];
            [attributeParams removeObjectForKey:@"jobId"];
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_JD];
            [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:resourceParams,K_RESOURCE_PARAMS,attributeParams,K_ATTRIBUTE_PARAMS, nil] handler:^(NGAPIResponseModal *responseData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS,@"Error in fetching JD");
                    [expectation fulfill];
                    
                });
            }];
            
            
        }
        else
        {
            XCTFail(@"No search result");
            [expectation fulfill];
        }
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
