//
//  NGNotificationOperationsLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 15/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define DEFAULT_TEST_DEVICE_TOKEN @"FE66489F304DC75B8D6E8200DFF8A456E8DAEACEC428B427E9518741C92C6660"

@interface NGNotificationOperationsLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
   XCTestExpectation *expectation;
}

@end

@implementation NGNotificationOperationsLoggedInTest

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGNotificationOperationsLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGNotificationOperationsLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)test1RegisterUserDeviceLoggedIn{
   
    expectation = [self expectationWithDescription:@"NGNotificationOperationsLoggedInTest"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"json",@"format",DEFAULT_TEST_DEVICE_TOKEN,@"tokenId",[NSNumber numberWithBool:1],@"loginStatus",[NSString getAppVersion],@"appVersion" ,nil];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_INFO_NOTIFICATION];
    [obj getDataWithParams:(NSMutableDictionary*)params handler:^(NGAPIResponseModal *responseData){
        XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCESS_WITHOUT_BODY);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}

-(void)test2GetNotificationCountLoggedIn{
    
    expectation = [self expectationWithDescription:@"NGNotificationOperationsLoggedInTest"];
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    [params setValue:DEFAULT_TEST_DEVICE_TOKEN forKey:@"tokenId"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_GET_NOTIFICATION];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        NSArray *pushArray = responseData.parsedResponseData;
        XCTAssertNotNil(pushArray,@"Get Notification API not working!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
}

-(void)test3ResetNotificationLoggedIn{

//    Push type can be anyone of this
//    KEY_BADGE_TYPE_JA
//    KEY_BADGE_TYPE_PV
//    KEY_BADGE_TYPE_PU
//    KEY_BADGE_TYPE_PROD

    expectation = [self expectationWithDescription:@"NGNotificationOperationsLoggedInTest"];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithObjectsAndKeys:DEFAULT_TEST_DEVICE_TOKEN,@"tokenId",KEY_BADGE_TYPE_PU,@"pushType", nil];

    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_RESET_NOTIFICATION];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        
        XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCESS_WITHOUT_BODY);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

//-(void)test4DeleteNotificationLoggedIn{
//
//        NSLog(@"%i",[NGHelper sharedInstance].isUserLoggedIn);
//        
//    expectation = [self expectationWithDescription:@"NGNotificationOperationsLoggedInTest"];
//    NSMutableDictionary* params= [NSMutableDictionary dictionaryWithObjectsAndKeys:DEFAULT_TEST_DEVICE_TOKEN, @"deviceId", nil];
//    
//    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DELETE_PUSH_COUNT];
//    
//    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
//        //TODO:device token showing empty
//        //{"error":{"status":400,"message":"Validation Error","code":[],"validationErrorDetails":[{"deviceId":{"message":"Device Id should not be empty.","code":"Array1"}}]}}
//        XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCESS_WITHOUT_BODY);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
//}
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
