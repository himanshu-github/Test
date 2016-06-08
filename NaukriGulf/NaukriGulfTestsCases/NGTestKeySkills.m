//
//  NGTestKeySkills.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/2/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGTestKeySkills : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;
    NSMutableArray *keySkills;
 
}

@end

@implementation NGTestKeySkills

- (void)setUp {
    [super setUp];
    keySkills = [[NSMutableArray alloc] initWithObjects:@"bb",@"CA", @"f&b",nil];
    expectation = [self expectationWithDescription:@"NGTestKeySkills"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGTestKeySkills"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
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


- (void)testAddKeySkill {

    expectation = [self expectationWithDescription:@"NGTestKeySkills"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *otherParamDict = [NSMutableDictionary dictionary];
    [otherParamDict setObject:@"0" forKey:@"resId"];

    [params setObject:otherParamDict forKey:@"otherparamskey"];
    
    
    NSMutableDictionary *keySkillDict = [[NSMutableDictionary alloc] init];
    [keySkillDict setObject:[NSString getStringsFromArray:keySkills] forKey:@"EN"];
    [keySkillDict setObject:[NSString getStringsFromArray:keySkills] forKey:@"default"];
    [params setObject:keySkillDict forKey:@"keySkills"];
    
     [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Add key skill Api Response");
         [keySkills removeLastObject];
         [keySkills addObject:@"c++"];
         [self editKeySkill];

    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}


-(void) editKeySkill {
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *otherParamDict = [NSMutableDictionary dictionary];
    [otherParamDict setObject:@"0" forKey:@"resId"];
    
    [params setObject:otherParamDict forKey:@"otherparamskey"];
    
    
    NSMutableDictionary *keySkillDict = [[NSMutableDictionary alloc] init];
    [keySkillDict setObject:[NSString getStringsFromArray:keySkills] forKey:@"EN"];
    [keySkillDict setObject:[NSString getStringsFromArray:keySkills] forKey:@"default"];
    [params setObject:keySkillDict forKey:@"keySkills"];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess, @"Problem with Add key skill Api Response");
        [expectation fulfill];
    
    }];
}

@end
