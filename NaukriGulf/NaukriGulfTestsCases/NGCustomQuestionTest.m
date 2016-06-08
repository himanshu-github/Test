//
//  NGCustomQuestionTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 09/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGCustomQuestionTest : XCTestCase<NGLoginHelperTestDelegate>{
   
     XCTestExpectation *expectation;
}


@end

@implementation NGCustomQuestionTest

- (void)setUp {
    [super setUp];
   
    expectation = [self expectationWithDescription:@"NGCustomQuestionTest"];
    
    [NGLoginHelperTest sharedInstance].delegate = self;
    
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
-(void)testCustomQuestion{
    
    expectation = [self expectationWithDescription:@"NGCustomQuestionTest"];
    
    [[NGSearchJobHelperTest sharedInstance] fetchJDWithHandler:^(NGJobDetailModel *jobDetailModel) {
        if (jobDetailModel) {
            NGJobDetails *jobFetched = [jobDetailModel.jobList objectAtIndex:arc4random_uniform((u_int32_t)[jobDetailModel.jobList count])];
            
            NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_CUSTOM_QUESTION];
            [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:(NSMutableDictionary *)@{@"jobId": jobFetched.jobID},K_RESOURCE_PARAMS, nil] handler:^(NGAPIResponseModal *responseData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    if (404 != responseData.responseCode && K_RESPONSE_SUCCESS!=responseData.responseCode) {
                        XCTFail(@"Error in Custom Question API");
                    }
                    [expectation fulfill];
                });
            }];
            
        }else{
         
            XCTFail(@"Error In Job Search API");
            [expectation fulfill];
        }
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
    [expectation fulfill];
}

@end
