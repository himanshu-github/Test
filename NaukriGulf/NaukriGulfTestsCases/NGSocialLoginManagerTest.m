//
//  NGSocialLoginManagerTest.m
//  
//
//  Created by Nveen Bandlamoodi on 11/04/16.
//
//

#import <XCTest/XCTest.h>
#import "NGSocialLoginManager.h"

@interface NGSocialLoginManagerTest : XCTestCase

@end

@implementation NGSocialLoginManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedInstance {
    
    NGSocialLoginManager *instanceOne = [NGSocialLoginManager sharedInstance];
    NGSocialLoginManager *instanceTwo = [NGSocialLoginManager sharedInstance];
    
    //single instance not nil
    XCTAssertNotNil(instanceOne, @"Instance is nil");
    
    //two instaces should be same
    XCTAssertEqual(instanceOne, instanceTwo, @"Instances are not equal");
    
    //Alloc
    instanceOne = [[NGSocialLoginManager alloc] init];
    
    //alloc instance not nil
    XCTAssertNotEqual(instanceOne, instanceTwo, @"Instances should not be equal but they are equal");
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
