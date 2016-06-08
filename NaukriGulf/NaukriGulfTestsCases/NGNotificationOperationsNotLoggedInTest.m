//
//  NGNotificationOperationsNotLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 15/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define DEFAULT_TEST_DEVICE_TOKEN @"FE66489F304DC75B8D6E8200DFF8A456E8DAEACEC428B427E9518741C92C6660"

@interface NGNotificationOperationsNotLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
     XCTestExpectation *expectation;
}

@end

@implementation NGNotificationOperationsNotLoggedInTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    expectation = [self expectationWithDescription:@"NGNotificationOperationsNotLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1RegisterUserDeviceNotLoggedIn{
   
    expectation = [self expectationWithDescription:@"NGNotificationOperationsNotLoggedInTest"];
    
    NSString *deviceID = [[NSString getUniqueDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"json",@"format",DEFAULT_TEST_DEVICE_TOKEN,@"tokenId",deviceID,@"deviceId",[NSString getAppVersion],@"appVersion", nil];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_INFO_NOTIFICATION];
    [obj getDataWithParams:(NSMutableDictionary*)params handler:^(NGAPIResponseModal *responseData){
        
        XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCESS_WITHOUT_BODY);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}

-(void)test2GetNotificationCountNotLoggedIn{
   
    expectation = [self expectationWithDescription:@"NGNotificationOperationsNotLoggedInTest"];
    
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


-(void)test3ResetNotificationNotLoggedIn{
    
    //    Push type can be anyone of this
    //    KEY_BADGE_TYPE_JA
    //    KEY_BADGE_TYPE_PV
    //    KEY_BADGE_TYPE_PU
    //    KEY_BADGE_TYPE_PROD
    expectation = [self expectationWithDescription:@"NGNotificationOperationsNotLoggedInTest"];
    
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithObjectsAndKeys:DEFAULT_TEST_DEVICE_TOKEN,@"tokenId",KEY_BADGE_TYPE_PROD,@"pushType", nil];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_RESET_NOTIFICATION];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        
        XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCESS_WITHOUT_BODY);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

//-(void)test4DeleteNotificationNotLoggedIn{
//    
//    expectation = [self expectationWithDescription:@"NGNotificationOperationsNotLoggedInTest"];
//    
//    NSMutableDictionary* params= [NSMutableDictionary dictionaryWithObjectsAndKeys:DEFAULT_TEST_DEVICE_TOKEN, @"tokenId", nil];
//    
//    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DELETE_PUSH_COUNT];
//    
//    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
//        
//        XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCCESS);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
//}
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
