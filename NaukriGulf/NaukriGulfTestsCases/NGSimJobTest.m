//
//  NGSimJobTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 08/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGSimJobTest : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *loginExpectation;
    XCTestExpectation *logoutExpectation;
    XCTestExpectation *simjobExpectation;

}

@end

@implementation NGSimJobTest

- (void)setUp {
    [super setUp];
    loginExpectation = [self expectationWithDescription:@"NGLoginTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    logoutExpectation = [self expectationWithDescription:@"NGLogoutTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:15 handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}

-(void)testSimJobs{
    
    simjobExpectation = [self expectationWithDescription:@"NGSimJobTest"];
    NGSearchJobHelperTest *searchJobHelper = [NGSearchJobHelperTest sharedInstance];
    [searchJobHelper fetchJDWithHandler:^(NGJobDetailModel *jobDetailModel) {
        
        if (jobDetailModel) {
            NGJobDetails *jobFetched = [jobDetailModel.jobList firstObject];
            
            NSNumber *offset = [NSNumber numberWithInt:0];
            NSNumber *limit = [NSNumber numberWithInteger:[searchJobHelper jobDownloadLimitForTest]];
            NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
            [params setValue:offset forKey:@"offset"];
            [params setValue:limit forKey:@"limit"];
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SIM_JOBS_PAGINATION];
            [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:(NSMutableDictionary *)@{@"jobId": jobFetched.jobID},K_RESOURCE_PARAMS,params,K_ATTRIBUTE_PARAMS, nil] handler:^(NGAPIResponseModal *responseData) {
                
                XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS,@"Error in Getting Similar jobs API");
                
                NSArray *jobsArr = [responseData.parsedResponseData objectForKey:@"Sim Jobs"];
                XCTAssertNotNil(jobsArr, @"Not getting the list/data array for Sim Job API");
                
                if(jobsArr.count>limit.intValue)
                    XCTFail(@"Sim jobs count is greater than limit requested");

                [simjobExpectation fulfill];
            }];
            
        }
        else{
            XCTFail(@"Job not found..");
            [simjobExpectation fulfill];
        
        }
        
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}

#pragma mark Login Delegate
-(void)successfullyLoginTest{
    
    [loginExpectation fulfill];
}
- (void)successfullyLogoutTest{
    
    [logoutExpectation fulfill];
}
-(void)errorInLoginTest{
    XCTFail(@"Error In Login");
    
    [loginExpectation fulfill];
}
-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout");
    
    [logoutExpectation fulfill];
}
@end
