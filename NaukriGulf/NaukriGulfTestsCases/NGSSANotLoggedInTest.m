//
//  NGSSANotLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 06/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGSSANotLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *expectation;
}

@end

@implementation NGSSANotLoggedInTest

- (void)setUp {
    [super setUp];
  
    expectation = [self expectationWithDescription:@"NGSSANotLoggedInTest"];
    
    [NGLoginHelperTest sharedInstance].delegate = self;
    
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1SSANotLoggedIn {
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"Experience":@99,
                                                                                      @"Keywords":@"dummyvar",
                                                                                      @"Limit":@15,
                                                                                      @"Location":@"",
                                                                                      @"Offset":@0
                                                                                      }];
    
    [self performSSAWithRequestParams:paramsDict];
}
- (void)test2SSANotLoggedInWithRefineFilterApplied {
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"Experience":@99,
                                                                                      @"Offset":@0,
                                                                                      @"Keywords":@"sales and marketing",
                                                                                      @"Limit":@15,
                                                                                      @"Location":@"Dubai, Jeddah, Other, Oman, Qatar, OtherIsThired",
                                                                                      @"ClusterCTC":@[@30],
                                                                                      @"ClusterGender":@[@"nm"],
                                                                                      @"ClusterInd":@[@20],
                                                                                      @"CompanyType":@[@1],
                                                                                      @"Experience":@3,
                                                                                      @"Freshness":@[@30,@60],
                                                                                      @"JobTitles":@[@10083]
                                                                                      }];
    
    [self performSSAWithRequestParams:paramsDict];
}

- (void)performSSAWithRequestParams:(NSMutableDictionary*)requestParamDic{
   
    expectation = [self expectationWithDescription:@"NGSSANotLoggedInTest"];
    
    NSMutableDictionary *paramsDictPassed = requestParamDic;
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_SSA];
    
    NSString *emailId = [[NGLoginHelperTest sharedInstance] defaultTestUserId];
    NSInteger expParamOfSearch = [[paramsDictPassed objectForKey:@"Experience"] integerValue];
    NSString  *strExpParamOfSearch = expParamOfSearch<0 || expParamOfSearch==Const_Any_Exp_Tag?@"":[NSString stringWithFormat:@"%ld",(long)expParamOfSearch];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[paramsDictPassed objectForKey:@"Keywords"],@"keyword",[paramsDictPassed objectForKey:@"Location"],@"location",strExpParamOfSearch,@"workExpYr",emailId,@"emailId",@"srp_ios",@"ssaloc", nil];
    
    NSArray *nameAPIArr = [NSArray arrayWithObjects:@"titles",@"freshness",@"ctc",@"country",@"gender",@"expRange",@"industry",@"citysrp",@"companyType", nil];
    
    NSArray *nameRequestArr = [NSArray arrayWithObjects:@"JobTitles",@"Freshness",@"ClusterCTC",@"ClusterCountry",@"ClusterGender",@"ClusterExperience",@"ClusterInd",@"ClusterCity",@"CompanyType", nil];
    
    
    for (NSInteger i = 0; i<nameAPIArr.count; i++) {
        NSString *nameAPI = [nameAPIArr fetchObjectAtIndex:i];
        NSString *nameRequest = [nameRequestArr fetchObjectAtIndex:i];
        
        if ([paramsDictPassed objectForKey:nameRequest]) {
            [params setCustomObject:[paramsDictPassed objectForKey:nameRequest] forKey:nameAPI];
        }
    }
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertEqual(responseInfo.responseCode, K_RESPONSE_CREATE_SUCCESS, @"Error in creating SSA Not LoggedIn");
            [expectation fulfill];
        });
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
    XCTFail(@"Error In Logout");
    [expectation fulfill];
}
@end
