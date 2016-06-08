//
//  NGDocumentFetcherTest.m
//  NaukriGulf
//
//  Created by Himanshu on 12/2/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NGDocumentFetcher.h"

@interface NGDocumentFetcherTest : XCTestCase<NGLoginHelperTestDelegate>
{

    XCTestExpectation *expectation;
    NGDocumentFetcher *documentFetchObj;
}
@end

@implementation NGDocumentFetcherTest

- (void)setUp {
    [super setUp];
    expectation = [self expectationWithDescription:@"NGLoginTest"];
    documentFetchObj  = [NGDocumentFetcher sharedInstance];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGLogoutTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}
- (void)testSharedInstance {
    
    NGDocumentFetcher *instanceOne = [NGDocumentFetcher sharedInstance];
    NGDocumentFetcher *instanceTwo = [NGDocumentFetcher sharedInstance];
    
    
    if (!instanceOne) {
        
        XCTFail(@"Instance is nil");
        
    }
    
    // Two instances
    if (instanceOne != instanceTwo) {
        
        XCTFail(@"Instances are not equal");
        
    }
    
    //Alloc
    instanceOne = [[NGDocumentFetcher alloc] init];
    
    if (instanceOne == instanceTwo) {
        
        XCTFail(@"Instances should not be equal but they are equal");
        
    }
    
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
