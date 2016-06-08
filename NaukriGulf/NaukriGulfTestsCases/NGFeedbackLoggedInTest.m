//
//  NGFeedbackLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGFeedbackLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
   
    XCTestExpectation *expectation;
}

@end

@implementation NGFeedbackLoggedInTest

- (void)setUp {
    expectation = [self expectationWithDescription:@"NGFeedbackLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
   
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGFeedbackLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

-(void)testFeedbackLoggedIn{
   
    expectation = [self expectationWithDescription:@"NGFeedbackLoggedInTest"];
    
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    
    NSString *feedback = @"A feedback send from automatic test cases in order to check whether feedback API is working or not";
    feedback = [NSString stripTags:feedback];
    feedback=[NSString tripWhiteSpace:feedback];
    feedback=[NSString formatSpecialCharacters:feedback];
    feedback = [feedback trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [params setValue:feedback forKey:@"comment"];
    NSString *iosInfo = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion]];
    [params setValue:iosInfo forKey:@"mtype"];
    
    [params setValue:@"iOS App Feedback" forKey:@"subject"];
    
    //get from saved data to check saved data methods
    [params setValue:[[NGSavedData  getUserDetails] valueForKey:@"name"] forKey:@"name"];
    [params setValue:[NGSavedData  getEmailID] forKey:@"email"];

    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_FEEDBACK];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCESS_WITHOUT_BODY, "Feedback not submitted for Feedback API");
            [expectation fulfill];
        
        });
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
