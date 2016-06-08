//
//  NGResmanNotificationHelperUnitTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 30/04/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGResmanNotificationHelper.h"

@interface NGResmanNotificationHelperUnitTest : XCTestCase<NGLoginHelperTestDelegate>{
    
    XCTestExpectation *expectation;
}

@end

@implementation NGResmanNotificationHelperUnitTest

- (void)setUp {
    [super setUp];
    
    //make user log out
    if ([[NGHelper sharedInstance] isUserLoggedIn]) {
        [NGUIUtility makeUserLoggedOutOnSessionExpired:NO];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedInstance {
    NGResmanNotificationHelper *instanceOne = [NGResmanNotificationHelper sharedInstance];
    NGResmanNotificationHelper *instanceTwo = [NGResmanNotificationHelper sharedInstance];
    
    //nil check
    XCTAssertNotNil(instanceOne,@"NGResmanNotificationHelper instance is nil");
    
    
    //instances should be of equal reference
    XCTAssertTrue(instanceOne == instanceTwo,@"NGResmanNotificationHelper sharedInstance giving different instances.");
    
    
    //Allocation method should not give nil object
    NGResmanNotificationHelper *allocatedInstance = [[NGResmanNotificationHelper alloc] init];
    XCTAssertNotNil(allocatedInstance,@"NGResmanNotificationHelper alloc-init instance is nil");
    
    
    //Allocated instance and shared instances should not be equal
    XCTAssertTrue(allocatedInstance != instanceOne,@"NGResmanNotificationHelper sharedInstance and alloc giving same.");
}


-(void)testInit{
    NGResmanNotificationHelper *instanceNew = [[NGResmanNotificationHelper alloc] init];
    
    //check for default values
    XCTAssertTrue(NGResmanPageNone == [[instanceNew valueForKey:@"currentPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of currentPage is invalid!");
    
    XCTAssertTrue(NGResmanPageNone == [[instanceNew valueForKey:@"previousPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of previousPage is invalid!");
    
    XCTAssertTrue(NGResmanPageNone == [[instanceNew valueForKey:@"higestVisitedPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of higestVisitedPage is invalid!");
    
    XCTAssertTrue(NO == [[instanceNew valueForKey:@"hasUserComeViaNotification"] boolValue],@"NGResmanNotificationHelper default value of hasUserComeViaNotification is invalid!");
    
    
    XCTAssertTrue(NO == [[instanceNew valueForKey:@"isFresherUser"] boolValue],@"NGResmanNotificationHelper default value of isFresherUser is invalid!");
    
    NSArray *freshScreenArrayOriginal = (NSArray*)[instanceNew valueForKey:@"freshScreenArray"];
    NSArray *freshScreenArrayTest = @[[NSNumber numberWithInteger:NGResmanPageCreateAccount],
                         [NSNumber numberWithInteger:NGResmanPageSelectFresherOrExperience],
                         [NSNumber numberWithInteger:NGResmanPageFresherEducationDetails],
                         [NSNumber numberWithInteger:NGResmanPageFresherKeySkills],
                         [NSNumber numberWithInteger:NGResmanPageFresherPersonalDetailAndRegister]];
    
    for (NSNumber *pageName in freshScreenArrayOriginal) {
        XCTAssertTrue([freshScreenArrayTest containsObject:pageName],@"NGResmanNotificationHelper default value of freshScreenArray is invalid!");
    }
    
    
    NSArray *experienceScreenArrayOriginal = (NSArray*)[instanceNew valueForKey:@"experienceScreenArray"];
    NSArray *experienceScreenArrayTest = @[[NSNumber numberWithInteger:NGResmanPageCreateAccount],
                                           [NSNumber numberWithInteger:NGResmanPageSelectFresherOrExperience],
                                           [NSNumber numberWithInteger:NGResmanPageExperienceBasicDetails],
                                           [NSNumber numberWithInteger:NGResmanPageExperienceProfessionalDetails],
                                           [NSNumber numberWithInteger:NGResmanPageExperienceKeySkills],
                                           [NSNumber numberWithInteger:NGResmanPageExperiencePersonalDetailAndRegister],
                                           ];
    
    for (NSNumber *pageName in experienceScreenArrayOriginal) {
        XCTAssertTrue([experienceScreenArrayTest containsObject:pageName],@"NGResmanNotificationHelper default value of experienceScreenArray is invalid!");
    }
    
    
    instanceNew = nil;
    
}



-(void)testIsUserRegistered{
    
    NGResmanNotificationHelper *instanceNew = [NGResmanNotificationHelper sharedInstance];
    
    //we initially set user status to loggegout
    XCTAssertFalse([[instanceNew valueForKey:@"isUserRegistered"] boolValue] ,@"NGResmanNotificationHelper -->isUserRegistered return value is incorrect!");
}


-(void)testCheckAndManageResmanNotificationForAppState{
        
}
-(void)testProcessNotificationInfo{
    
}

-(void)testLoadPage{
}

-(void)testSaveResmanNotificationInfo{
    
}
-(void)testRetrieveResmanNotificationInfo{
    
}

-(void)testCreateNotificationForIncompleteRegistrationWithLandingPage{
    
}


-(void)testCancelNotificationForIncompleteRegistration{
    
}

-(void)testIsCancellableNotificationId{
    
}

-(void)testCreateNotificationForJobPreferencePage{
    
}

-(void)testSendResmanNotificationGA{
    
}

-(void)testReportUserRegistrationForGA{
}

-(void)testSetJobPreferenceNotification{
}

-(void)testCreateValidDateFromDate{
}

-(void)testCreateNewDateFromDateForHourAndForMinute{
    
}

-(void)testIsDatePassed{
    
}

-(void)stepAwayFromRegister{
    
}

-(void)testIsRegistrationProcessPage{
    
    NSArray *validPageList = @[[NSNumber numberWithInteger:NGResmanPageCreateAccount],
                               [NSNumber numberWithInteger:NGResmanPageSelectFresherOrExperience],
                               [NSNumber numberWithInteger:NGResmanPageExperienceBasicDetails],
                               [NSNumber numberWithInteger:NGResmanPageFresherEducationDetails],
                               [NSNumber numberWithInteger:NGResmanPageExperienceProfessionalDetails],
                               [NSNumber numberWithInteger:NGResmanPageFresherKeySkills],
                               [NSNumber numberWithInteger:NGResmanPageExperienceKeySkills],
                               [NSNumber numberWithInteger:NGResmanPageFresherPersonalDetailAndRegister],
                               [NSNumber numberWithInteger:NGResmanPageExperiencePersonalDetailAndRegister]];
    
    NGResmanNotificationHelper *instanceNew = [NGResmanNotificationHelper sharedInstance];
    
    SEL selector = NSSelectorFromString(@"isRegistrationProcessPage:");
    XCTAssertTrue([instanceNew respondsToSelector:selector],@"NGResmanNotificationHelper -->isRegistrationProcessPage method not found!!!");
    
    for (NSNumber *pageName in validPageList) {
        
        enum NGResmanPage resmanPage = pageName.unsignedIntegerValue;
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [[instanceNew class] instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:instanceNew];
        [invocation setArgument:&resmanPage atIndex:2];
        [invocation invoke];
        BOOL returnValue;
        [invocation getReturnValue:&returnValue];
//        NSLog(@"%s:returnvalue:%d",__PRETTY_FUNCTION__,returnValue);
        XCTAssertTrue(returnValue,@"NGResmanNotificationHelper -->isRegistrationProcessPage found missing page!!!");
        invocation = nil;
    }
    
}

-(void)testSetCurrentPage{
    
    NGResmanNotificationHelper *instanceNew = [NGResmanNotificationHelper sharedInstance];
    
    SEL selector = NSSelectorFromString(@"setCurrentPage:");
    XCTAssertTrue([instanceNew respondsToSelector:selector],@"NGResmanNotificationHelper -->setCurrentPage method not found!!!");
    
    enum NGResmanPage resmanPage = NGResmanPageSelectFresherOrExperience;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [[instanceNew class] instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:instanceNew];
    [invocation setArgument:&resmanPage atIndex:2];
    [invocation invoke];
    invocation = nil;

    XCTAssertTrue(NGResmanPageSelectFresherOrExperience == [[instanceNew valueForKey:@"currentPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of currentPage is invalid!");
    
    XCTAssertTrue(NGResmanPageNone == [[instanceNew valueForKey:@"previousPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of previousPage is invalid!");
    
    XCTAssertTrue(NGResmanPageSelectFresherOrExperience == [[instanceNew valueForKey:@"higestVisitedPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of higestVisitedPage is invalid!");
    
    
    //now check change for highest visited page value
    resmanPage = NGResmanPageCreateAccount;
    invocation = [NSInvocation invocationWithMethodSignature:
                                [[instanceNew class] instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:instanceNew];
    [invocation setArgument:&resmanPage atIndex:2];
    [invocation invoke];
    invocation = nil;
    
    XCTAssertTrue(NGResmanPageCreateAccount == [[instanceNew valueForKey:@"currentPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of currentPage is invalid!");
    
    XCTAssertTrue(NGResmanPageSelectFresherOrExperience == [[instanceNew valueForKey:@"previousPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of previousPage is invalid!");
    
    //highest visited page should be highest rank page in forward direction
    XCTAssertTrue(NGResmanPageSelectFresherOrExperience == [[instanceNew valueForKey:@"higestVisitedPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of higestVisitedPage is invalid!");
}

-(void)testSetHighestVisitedPage{
    NGResmanNotificationHelper *instanceNew = [NGResmanNotificationHelper sharedInstance];
    
    SEL selector = NSSelectorFromString(@"setHighestVisitedPage:");
    XCTAssertTrue([instanceNew respondsToSelector:selector],@"NGResmanNotificationHelper -->setHighestVisitedPage method not found!!!");
    
    enum NGResmanPage resmanPage = NGResmanPageSelectFresherOrExperience;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [[instanceNew class] instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:instanceNew];
    [invocation setArgument:&resmanPage atIndex:2];
    [invocation invoke];
    invocation = nil;
    
    XCTAssertTrue(NGResmanPageSelectFresherOrExperience == [[instanceNew valueForKey:@"higestVisitedPage"] unsignedIntegerValue],@"NGResmanNotificationHelper default value of higestVisitedPage is invalid!");
    
    //    higestVisitedPage = paramPage;
}

-(void)testSetUserAsFresher{
    NGResmanNotificationHelper *instanceNew = [NGResmanNotificationHelper sharedInstance];
    
    [instanceNew setUserAsFresher:YES];
    
    XCTAssertTrue([[instanceNew valueForKey:@"isFresherUser"] boolValue],@"NGResmanNotificationHelper --> Invalid state of isFresherUser.");
}
-(void)testLoadLoginPage{
    [self loginUserForTesting];
    
    NGResmanNotificationHelper *instanceNew = [NGResmanNotificationHelper sharedInstance];
    
    XCTAssertTrue([[instanceNew valueForKey:@"isUserRegistered"] boolValue],@"NGResmanNotificationHelper --> Invalid state of user.");
    
    [self logoutUserForTesting];
}

-(void)loginUserForTesting{
    expectation = [self expectationWithDescription:@"NGResmanNotificationHelperTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}
-(void)logoutUserForTesting{
    expectation = [self expectationWithDescription:@"NGResmanNotificationHelperTest"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
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
