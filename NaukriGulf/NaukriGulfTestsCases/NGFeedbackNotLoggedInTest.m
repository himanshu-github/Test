//
//  NGFeedbackNotLoggedInTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGFeedbackNotLoggedInTest : XCTestCase<NGLoginHelperTestDelegate>{
    XCTestExpectation *expectation;
}

@end

@implementation NGFeedbackNotLoggedInTest

- (void)setUp {
    
    [super setUp];
    expectation = [self expectationWithDescription:@"NGFeedbackNotLoggedInTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

-(void)testFeedbackNotLoggedIn{
   
    expectation = [self expectationWithDescription:@"NGFeedbackNotLoggedInTest"];
    
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
    
    //how to get user name from profile fetched
    [params setValue:@"TestUser_Xcode" forKey:@"name"];
    [params setValue:[[NGLoginHelperTest sharedInstance] defaultTestUserId] forKey:@"email"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_FEEDBACK];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCESS_WITHOUT_BODY, "Feedback not submitted for Feedback API");
            [expectation fulfill];
        
        });
    }];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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
